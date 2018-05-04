Shader "Custom/ReactionDiffusionSolver3"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
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
				const float W = 1.0 / 1024.0;
				const float H = 1.0 / 1024.0;
				float4 base = tex2D(_MainTex, i.uv);

				float dr = sin(base.b * 10) * -2.0 + 16.0;
				float4 colR = base * 0.2;
				colR += tex2D(_MainTex, i.uv + float2(W, 0.0)) * 0.3;
				colR += tex2D(_MainTex, i.uv + float2(-W, 0.0)) * 0.3;
				colR += tex2D(_MainTex, i.uv + float2(0.0, H)) * 0.3;
				colR += tex2D(_MainTex, i.uv + float2(0.0, -H)) * 0.3;
				colR -= tex2D(_MainTex, i.uv + float2(W * dr, 0.0)) * 0.1;
				colR -= tex2D(_MainTex, i.uv + float2(-W * dr, 0.0)) * 0.1;
				colR -= tex2D(_MainTex, i.uv + float2(0.0, H * dr)) * 0.1;
				colR -= tex2D(_MainTex, i.uv + float2(0.0, -H * dr)) * 0.1;

				float dg = sin(base.r * 3) * -1.0 + 16.0;
				float4 colG = base * 0.2;
				colG += tex2D(_MainTex, i.uv + float2(W, 0.0)) * 0.3;
				colG += tex2D(_MainTex, i.uv + float2(-W, 0.0)) * 0.3;
				colG += tex2D(_MainTex, i.uv + float2(0.0, H)) * 0.3;
				colG += tex2D(_MainTex, i.uv + float2(0.0, -H)) * 0.3;
				colG -= tex2D(_MainTex, i.uv + float2(W * dg, 0.0)) * 0.1;
				colG -= tex2D(_MainTex, i.uv + float2(-W * dg, 0.0)) * 0.1;
				colG -= tex2D(_MainTex, i.uv + float2(0.0, H * dg)) * 0.1;
				colG -= tex2D(_MainTex, i.uv + float2(0.0, -H * dg)) * 0.1;

				float db = sin(base.g * 10) * 2.0 + 8.0;
				float4 colB = base * 0.2;
				colB += tex2D(_MainTex, i.uv + float2(W, 0.0)) * 0.3;
				colB += tex2D(_MainTex, i.uv + float2(-W, 0.0)) * 0.3;
				colB += tex2D(_MainTex, i.uv + float2(0.0, H)) * 0.3;
				colB += tex2D(_MainTex, i.uv + float2(0.0, -H)) * 0.3;
				colB -= tex2D(_MainTex, i.uv + float2(W * db, 0.0)) * 0.1;
				colB -= tex2D(_MainTex, i.uv + float2(-W * db, 0.0)) * 0.1;
				colB -= tex2D(_MainTex, i.uv + float2(0.0, H * db)) * 0.1;
				colB -= tex2D(_MainTex, i.uv + float2(0.0, -H * db)) * 0.1;
				
				return float4(colR.r, colG.g, colB.b, 1.0);
			}
			ENDCG
		}
	}
}
