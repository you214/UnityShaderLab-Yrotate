Shader "Unlit/yaxis"
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

            #include "UnityCG.cginc"

            #define PI 3.141592

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 flippedUV = float2(1.0 - i.uv.x, i.uv.y);

                float _BlendStartU =  0.5 + 0.5 * (sin(_Time.y ));
                float _BlendEndU = 0.5 + 0.5 * (-sin(_Time.y ));    

                if (_BlendStartU > 0.5){
                    _BlendEndU = 0.0;
                    _BlendStartU = 0.0;
                }

                float2 pos = float2(frac(i.uv.x - _BlendStartU) * 1/(_BlendEndU - _BlendStartU),
                                    frac(i.uv.y) * 1 );

                float _BlendStartU_flipped = 0.5 + 0.5 * (sin((_Time.y + PI )));
                float _BlendEndU_flipped =  0.5 + 0.5 * (-sin((_Time.y + PI) ));                

                if(_BlendStartU_flipped > _BlendEndU_flipped){
                    _BlendEndU_flipped = 0.5;
                    _BlendStartU_flipped = 0.5;
                }

                float2 pos_flipped = float2(frac(flippedUV.x - _BlendStartU_flipped) * 1/(_BlendEndU_flipped - _BlendStartU_flipped),
                                    frac(flippedUV.y) * 1 );

                fixed4 col = tex2D(_MainTex, pos) + tex2D(_MainTex, pos_flipped);

                return col;
            }
            ENDCG
        }
    }
}
