Shader "Custom/SolverImitFluid"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		Cull Off
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 color_ = tex2D(_MainTex, i.uv);
			fixed4 colR = tex2D(_MainTex, i.uv
				+ float2(sin(color_.g * 10) * 0.001, cos(color_.b * 10) * 0.001)
				+ float2(
					cos(cos(i.uv.y * 7) * 23) * 0.001,
					sin(cos(i.uv.x * 7) * 23) * 0.001
					));
			fixed4 colG = tex2D(_MainTex, i.uv
				+ float2(sin(color_.b * 10) * 0.002, cos(color_.r * 10) * 0.002)
				+ float2(
					sin(sin(i.uv.y * 11) * 11) * 0.001,
					sin(cos(i.uv.x * 11) * 11) * 0.001
					));
			fixed4 colB = tex2D(_MainTex, i.uv
				+ float2(sin(color_.r * 10) * 0.001, cos(color_.g * 10) * 0.001)
				+ float2(
					sin(cos(i.uv.y * 3) * 5) * 0.001,
					sin(sin(i.uv.x * 3) * 5) * 0.001
					));
			colR.r -= 0.007;
			colG.g -= 0.009;
			colB.b -= 0.014;
				// apply fog
				//UNITY_APPLY_FOG(i.fogCoord, col);
				return float4(colR.r, colG.g, colB.b, 1.0);
			}
			ENDCG
		}
	}
}
