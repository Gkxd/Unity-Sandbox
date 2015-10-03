Shader "PlaneDeform/Two Planes"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }
            
            float2 distort(float2 uv) {
                float x = 2 * uv.x - 1;
                float y = 2 * uv.y - 1;
                float r = sqrt(x * x + y * y);
                float a = atan2(y, x);

                float2 distorted;
                distorted.x = x/abs(y);
                distorted.y = 1/abs(y);
                return distorted;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                float2 time = float2(_Time.y, _Time.y);
                fixed4 col = tex2D(_MainTex, distort(i.uv) + time);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);				
                return col;
            }
            ENDCG
        }
    }
}
