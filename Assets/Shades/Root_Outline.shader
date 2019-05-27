// シェーダーの情報
Shader "Unlit/Root_Outline"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Color1("Color1", Color) = (0,0,0,1)
		_Color2("Color2", Color) = (1,0,0,1)
	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" }
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

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					UNITY_TRANSFER_FOG(o, o.vertex);
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					float2 size = (0.8,0.8);
					float2 leftbottom = (0.5,0.5) - size * 0.5;
					float2 uv = step(leftbottom, i.uv);
					uv *= step(leftbottom, 1 - i.uv);
					float4 col = uv.x*uv.y;

					//出力
					return lerp(_Color1,_Color2,col);
				}

				ENDCG
			}

		}
}
