// シェーダーの情報
Shader "Unlit/Outline"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Color1 ("Color1", Color) = (0,0,0,1)
		_Color2 ("Color2", Color) = (1,0,0,1)
		_Color3 ("Color3", Color) = (0,1,0,1)
		_Color4 ("Color4", Color) = (0,0,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

		//パス2つ作って2つ枠作ることにしたけど、なんかスマートな方法があるかも…
		//1パス目で中側描画
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
			
	
			float rectangle(float2 p, float2 size){
				return max(abs(p.x) - size.x, abs(p.y) - size.y);
			}

			fixed4 frag (v2f i) : SV_Target
			{	
				//1.真ん中に四角配置
				//2.座標0.0と1,0に縦と横に伸ばした四角を変形させて配置
				float2 f_st = frac(i.uv) * 2 - 1;
				float ci = rectangle(f_st, -0.3);
				fixed4 col = smoothstep(0.5, 0.51, ci);
				return lerp(_Color1,_Color2,col);

			}
            ENDCG 
		}

	}
}
