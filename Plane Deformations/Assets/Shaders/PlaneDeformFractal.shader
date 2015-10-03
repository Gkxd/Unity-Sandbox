Shader "PlaneDeform/Fractal"
{
    Properties
    {
        _MainColor ("Color", Color) = (1, 1, 1, 1)
        _Border ("Border Width", Range(0.01, 0.49)) = 0.1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "PreviewType" = "Plane"}
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

            fixed4 _MainColor;
            float _Border;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
                o.uv = v.uv;
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }
            
            float2 distort(float2 uv) {
                float x = 2 * uv.x - 1;
                float y = 2 * uv.y - 1;
                float r = sqrt(x * x + y * y);
                float a = atan2(y, x);

                float2 distorted;
                distorted.x = cos(a)/r;
                distorted.y = sin(a)/r;
                return distorted;
            }

            float getBrightness(float2 uv) {
                float2 time = float2(_Time.y, _Time.y);
                float2 recursiveDistort = fmod(distort(uv) + time, 1);
                for (int i = 0; i < 4; i++) {
                    if (recursiveDistort.x < _Border || recursiveDistort.x > 1 - _Border|| recursiveDistort.y < _Border || recursiveDistort.y > 1 - _Border) {
                        return 1 - i * 0.15;
                    }
                    else {
                        float scaledX = (recursiveDistort.x - _Border)/(1 - 2*_Border);
                        float scaledY = (recursiveDistort.y - _Border)/(1 - 2*_Border);
                        float2 scaled = float2(scaledX, scaledY);
                        recursiveDistort = fmod(distort(scaled) + time, 1);
                    }
                }
                return 0.4;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float brightness = getBrightness(i.uv);

                float randomArray[8] = {
                    0.0003708,
                    0.0002225,
                   -0.0001491,
                    0.0002141,
                   -0.0002781,
                   -0.0002506,
                    0.0002123,
                   -0.0001882
                };

                for (uint j = 0; j < 10; j++) {
                    float x = fmod(i.uv.x + randomArray[(j * j) % 8], 1);
                    float y = fmod(i.uv.y + randomArray[(3 * j) % 8], 1);
                    
                    brightness += getBrightness(float2(x, y));
                }

                fixed4 col = _MainColor * (brightness / 11);

                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
