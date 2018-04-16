// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/JianBian" {

	Properties
	{
		_Color("Color",Color)=(1,1,1,1)
		_RampTex("RampTex",2D) = "white"{}
		_SpecuColor("SpecColor",Color) = (1,1,1,1)
		_Gloss("Gloss",Range(0,20)) = 10
	}

		CGINCLUDE
		#include "UnityCG.cginc"
		#include "Lighting.cginc"

		float4 _Color;
		uniform sampler2D _RampTex;
		float4 _SpecuColor;
		float _Gloss;
		float4 _RampTex_ST;

		struct v2f
		{
			float4 pos:POSITION;
			float2 uv:TEXCOORD0;
			float3 worldNormal:TEXCOORD1;
			float4 worldPos:TEXCOORD2;
		};


		v2f vert(appdata_full v)
		{
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex);

			o.uv = TRANSFORM_TEX( v.texcoord, _RampTex);

			//o.worldNormal = normalize(mul(unity_WorldToObject, v.normal));
			o.worldNormal = normalize(mul( v.normal, unity_WorldToObject));

			o.worldPos = mul(unity_ObjectToWorld, v.vertex);

			return o;
		}

		float4 frag(v2f i) :SV_Target
		{
			float3 tex = tex2D(_RampTex,i.uv);
			//float3 lDir = ObjSpaceLightDir(i.worldPos);
			//lDir = mul(unity_ObjectToWorld,lDir);
			float3 lDir = normalize(_WorldSpaceLightPos0.xyz);

			float3 worldNormal = normalize(i.worldNormal);

			float3 vDir = normalize(_WorldSpaceCameraPos.xyz-i.worldPos.xyz);
			
			half3 halfLambert = dot(lDir, worldNormal) / 2 + 0.5;

			float3 dif = _LightColor0* max(0, dot(i.worldNormal, lDir));

			float3 h = normalize(lDir+vDir);

			float3 spec =_SpecuColor * pow(max(0,dot(worldNormal,h)), _Gloss);

			return float4(spec+dif+tex,1);
		}
			ENDCG

		SubShader
		{
			Tags{"LightMode"="ForwardBase"}
			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				ENDCG
		    }
	    }

}
