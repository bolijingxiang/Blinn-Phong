// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Wave" {
	Properties
	{
		_MainTex("MainTex",2D) = "white"{}
		_Bump("BumpMap",2D) = "bump"{}
	}
	SubShader
	{
		Tags{"RenderType"="Transparent""Queue"="Transparent"}
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "Lighting.cginc"  
			#include "AutoLight.cginc" 
					sampler2D _MainTex;
					sampler2D _Bump;
					float4 _MainTex_ST;
					float4 _Bump_ST;

					struct v2f
					{
						float4 pos:POSITION;
						float4 uv:TEXCOORD0;
						float3 lightDir:TEXCOORD1;
						float3 viewDir:TEXCOORD2;
						//float3 nor:Normal;
					};

					v2f vert(appdata_base v)
					{
						v2f o;
						o.pos = UnityObjectToClipPos(v.vertex);
						o.uv = ComputeGrabScreenPos(o.pos);
						//TANGENT_SPACE_ROTATION
						o.lightDir = normalize(mul(unity_ObjectToWorld, ObjSpaceLightDir(v.vertex)));
						o.viewDir = normalize(mul(unity_ObjectToWorld,ObjSpaceViewDir(v.vertex)));
						return o;
					}

					inline float4 frag(v2f i):SV_Target
					{
						float3 tex = tex2Dproj(_MainTex,i.uv);
						float3 nor = normalize(UnpackNormal(tex2Dproj(_Bump,mul(unity_ObjectToWorld,i.uv))));

						float3 diff = _LightColor0.rgb*saturate(dot(i.lightDir,nor));

						tex *= diff;
						return  float4(tex,1);
					}
			ENDCG
		}
	}
}
