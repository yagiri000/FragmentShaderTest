Shader "Custom/SolveWaveSin"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
	}
		SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 100
		Cull Off

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

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				// sample the texture
				float4 col = tex2D(_MainTex, i.uv);
				float vel = col.g * 2.0 - 1.0;
				float height = col.r * 2.0 - 1.0;
				vel += height * -0.8;
				vel = clamp(vel, -1.0, 1.0);
				//vel *= 0.999;
				height += vel * 0.05;
				col.r = (height + 1.0) *0.5;
				col.g = (vel + 1.0) *0.5;

				float4 colGauss = tex2D(_MainTex, i.uv) * 0.0;
				colGauss += tex2D(_MainTex, i.uv + float2(0.001, 0.0)) * 0.25;
				colGauss += tex2D(_MainTex, i.uv + float2(-0.001, 0.0)) * 0.25;
				colGauss += tex2D(_MainTex, i.uv + float2(0.0, 0.001)) * 0.25;
				colGauss += tex2D(_MainTex, i.uv + float2(0.0, -0.001)) * 0.25;
				return col * 0.7 + colGauss * 0.3;
			}
			ENDCG
		}
	}
}
