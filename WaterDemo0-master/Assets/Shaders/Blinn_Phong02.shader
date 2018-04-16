// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Blinn_Phong02" {
	Properties
	{
		_Color("Color",Color)=(1,1,1,1)
		_Gloss("Gloss",Range(8,200))=20
		_SpecuColor("SpecuColor",Color)=(1,1,1,1)
	}
		SubShader
	{
		Tags{"LightMode"="ForwardBase"}
		Pass
	{
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		#include "Lighting.cginc"

		float4 _Color;
		float _Gloss;
		float4 _SpecuColor;

	struct v2f
	{
		float4 pos:SV_POSITION;
		float3 worldNormal:TEXCOORD0;
		float3 worldPos: TEXCOORD1;
	};

	v2f vert(appdata_tan v)
	{
		v2f o;
		o.pos = UnityObjectToClipPos(v.vertex);
		o.worldNormal = mul(v.normal,unity_WorldToObject);
		o.worldPos = mul(unity_ObjectToWorld,v.vertex);
		return o;
	}

	inline float4 frag(v2f v):SV_Target
	{
		float3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

		float3 worldNormal = normalize(v.worldNormal);

		float3 worldViewDir = normalize(_WorldSpaceCameraPos.xyz-v.worldPos.xyz);//顶点变量位置变化

		float3 dif = _LightColor0 * _Color*max(0,dot(worldLightDir,worldNormal));

		float3 h = normalize(worldLightDir+worldViewDir);

		float3 spec = _LightColor0 * _SpecuColor*pow(max(0,dot(worldNormal,h)),_Gloss);

		return float4(spec,1);

	}
		ENDCG
}
	}
}
