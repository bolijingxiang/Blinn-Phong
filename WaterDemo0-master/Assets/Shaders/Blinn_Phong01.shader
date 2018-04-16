Shader "Custom/Blinn_Phong01" {


	Properties
	{
		_Color("Color",Color) = (1,1,1,1)
		_RampTex("RampTex",2D) = "white"{}
		_SpecuColor("SpecColor",Color) = (1,1,1,1)
		_Gloss("Gloss",Range(0,200)) = 10
	}

		SubShader
	{
		Tags{ "LightMode" = "ForwardBase" }
			Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			float4 _Color;
			uniform sampler2D _RampTex;
			float4 _SpecuColor;
			float _Gloss;
			float4 _RampTex_ST;

			struct v2f
			{
				float4 pos:SV_POSITION;
				float2 uv:TEXCOORD0;
				float3 worldNormal:TEXCOORD1;
				float4 worldPos:TEXCOORD2;
			};


			v2f vert(appdata_full v)
			{
				v2f o;

				o.pos = UnityObjectToClipPos(v.vertex);

				o.uv = TRANSFORM_TEX(v.texcoord, _RampTex);

				o.worldNormal = normalize(mul(v.normal, unity_WorldToObject));

				o.worldPos = mul(unity_ObjectToWorld, v.vertex);

				return o;
			}

			float4 frag(v2f i) :SV_Target
			{
				//float3 tex = tex2D(_RampTex,i.uv);

				float3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

				float3 worldNormal = normalize(i.worldNormal);//在vert中单位向量话没有用，必须在片源里面进行单位向量化，不然数值我也不知道，变成什么样子

				float3 worldViewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
				//vDir = mul(unity_ObjectToWorld,vDir);
				float3 dif = max(0, dot(i.worldNormal, worldLightDir));
				float3 h = normalize(worldLightDir + worldViewDir);
				float3 spec = _SpecuColor * pow(max(0,dot(h, worldNormal)), _Gloss);

				return float4(spec,1);
			}
			ENDCG
		}
	}

}
