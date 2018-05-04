Shader "Custom/GradTableAdditive"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_GradTex("Texture", 2D) = "white" {}
	}
		SubShader
	{
		Tags { "Queue" = "Transparent" }
		Cull Off
		LOD 100
		ZWrite Off
		Blend One One

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
			sampler2D _GradTex;
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
				fixed4 color_ = tex2D(_MainTex, i.uv);
			color_.a = (color_.r + color_.g + color_.b) * 0.3333;
			fixed4 gradColor = tex2D(_GradTex, float2(color_.a, 0.0));
			gradColor.rgb = gradColor.rgb * 0.9 + color_.rgb * 0.1;
				return gradColor;
			}
			ENDCG
		}
	}
}
