// シェーダーの情報
Shader "Unlit/Outline"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Color ("Main Color", Color) = (1,1,1,1)
		_Color2 ("Sub Color", Color) = (0,0,0,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

		//パス2つ作って2つ枠作ることにしたけど、なんかスマートな方法があるかも…
		//1パス目で外側描画
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
			
				fixed4 _Color;
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
			fixed4 frag (v2f i) : SV_Target
			{
				//fixed2 size = fixed2(0.3,0.3);
				//fixed2 leftbottom = fixed2(0.5,0.5) - size * 0.5;
				//fixed2 uv = step(leftbottom, i.uv);
				//uv *= step(leftbottom, 1-i.uv);
				//return lerp(_Color,_Color2, uv.x*uv.y);

				//fixed2 uv=step(1,1);
				//uv *= step(0.2, i.uv.x);
				//uv *= step(0.2, i.uv.y);
				//uv *= step(0.2, 1-i.uv.x);
				//uv *= step(0.2, 1-i.uv.y);
				//return lerp(_Color,_Color2, 1-uv.x*1-uv.y);
				fixed len = distance(i.uv, fixed2(0.5,0.5));
				return step(0.8, sin(len*4));
			}
            ENDCG 
		}
	}
}
