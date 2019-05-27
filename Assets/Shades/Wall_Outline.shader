// シェーダーの情報
Shader "Unlit/Wall_Outline"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Color1 ("Color1", Color) = (0,0,0,1)
		_Color2 ("Color2", Color) = (1,0,0,1)
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
			
				fixed4 _Color1;
				fixed4 _Color2;
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
			

			float rectangle(float2 p, float2 size) {
				return max(abs(p.x) - size.x, abs(p.y) - size.y);
			}

			float square(float2 p) {
				return max(abs(p.x),abs(p.y));
			}

			float circle(float2 p, float radius) {
				return length(p) - radius;
			}

			fixed4 frag (v2f i) : SV_Target
			{	
				//1.真ん中に四角配置
				//2.上端と下端・左端と右端に四角形を伸ばして配置

				//真ん中の四角の座標（中心）
				float2 f_st = frac(i.uv) * 2 - 1;

				//xに伸びる四角の座標（上端と下端）
				float2 f_st_x = ((frac(1 - i.uv.x) * 2 - 1) , (frac(1 - i.uv.x) * 2));
				f_st_x *= ((frac(i.uv.x) * 2 - 1), (frac(i.uv.x) * 2));

				//yに伸びる四角の座標（左端と右端）
				float2 f_st_y = ((frac(1 - i.uv.y) * 2 - 1) , (frac(1 - i.uv.y) * 2));
				f_st_y *= ((frac(i.uv.y) * 2 - 1), (frac(i.uv.y) * 2));

				//四角のサイズ設定（上端と下端・左端と右端は同じじゃないと気持ち悪いので）
				float center_rect = 0.05;
				float edge_rect = -0.1;

				
				//四角を配置
				float ci = rectangle(f_st, center_rect);
				float ci1 = rectangle(f_st_x, edge_rect);
				float ci2 = rectangle(f_st_y, edge_rect);

				//四角をなめらかに
				fixed4 col = smoothstep(0.5, 0.51, ci);
				col *= smoothstep(0.5, 0.51, ci1);
				col *= smoothstep(0.5, 0.51, ci2);

				//出力
				return lerp(_Color1,_Color2,col);

			}

            ENDCG 
		}

	}
}
