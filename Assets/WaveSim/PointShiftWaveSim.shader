Shader "Custom/PointShiftWaveSim"
{
	Properties
	{
		[NoScaleOffset] _MainTex("Texture", 2D) = "white" {}
		_Amp("Amp", float) = 0
		_Dif("Dif", float) = 0
	}
		SubShader
		{
			Pass
		{
			// pass はフォワードレンダリングパイプラインの「ベース」パスで
			// あることを示します。アンビエントと主要ディレクショナルライトの
			// データ設定を行います。ライト方向は _WorldSpaceLightPos0
			// カラーは _LightColor0
			Tags{ "LightMode" = "ForwardBase" }
			Cull Off

			CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#include "UnityCG.cginc" //  UnityObjectToWorldNormal に対し
	#include "UnityLightingCommon.cginc" // _LightColor0 に対し

			struct v2f
		{
			float2 uv : TEXCOORD0;
			fixed4 diff : COLOR0; // 拡散ライティングカラー
			float4 vertex : SV_POSITION;
		};


		float _Amp;
		float _Dif;
		sampler2D _MainTex;
		v2f vert(appdata_base v)
		{
			v2f o;
			o.uv = v.texcoord;
			// ワールド空間で頂点法線を取得
			half3 worldNormal = UnityObjectToWorldNormal(v.normal);

			float dif = 0.005;
			fixed4 col = tex2Dlod(_MainTex, float4(o.uv, 0, 0));
			fixed4 colx = tex2Dlod(_MainTex, float4(o.uv + float2(dif, 0.0), 0, 0));
			fixed4 colx_ = tex2Dlod(_MainTex, float4(o.uv + float2(-dif, 0.0), 0, 0));
			fixed4 coly = tex2Dlod(_MainTex, float4(o.uv + float2(0.0, dif), 0, 0));
			fixed4 coly_ = tex2Dlod(_MainTex, float4(o.uv + float2(0.0, -dif), 0, 0));
			float rate = (col.r - 0.5)*2.0;
			rate = sin(sin(rate * 1.57) * 1.57);

			float4 pos = float4(v.normal.x, v.normal.y, v.normal.z, 0.0) * (rate *_Amp + _Dif) + v.vertex;
			o.vertex = UnityObjectToClipPos(pos);

			// []

			//float dist = sin(rate / (6.28 * 3.0)) * rate;
			worldNormal.x = (col.r - colx.r) * 0.5 + (col.r - colx_.r) * 0.5;
			worldNormal.z = (col.r - coly.r) * 0.5 + (col.r - coly_.r) * 0.5;
			worldNormal.y = 0.3;
			worldNormal.x *= 2.0;
			worldNormal.z *= 2.0;

			worldNormal = normalize(worldNormal);

			// 標準拡散 (Lambert) ライティングを求めるための
			//法線とライト方向間のドット積
			half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
			// ライトカラーの積
			o.diff = nl * _LightColor0;
			return o;
		}


		fixed4 frag(v2f i) : SV_Target
		{
			// テクスチャのサンプリング
			fixed4 col = tex2D(_MainTex, i.uv);
			col = fixed4(0.0, 0.5, 1.0, 0.5);
			// ライティングで乗算します
			col *= i.diff;
			return col;
		}
			ENDCG
		}
		}
}