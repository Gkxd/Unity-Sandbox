Shader "Custom/Texture Scale Angle"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1, 1, 1, 1)
        
        _ScaleAngle ("Scale Angle", Range(0, 6.2831853)) = 0
        _Scale ("Scale", Vector) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "PreviewType"="Plane"}
        LOD 100

        Pass
        {
            Cull Off
            ZWrite Off
            ZTest Off
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

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
            fixed4 _Color;

            float _ScaleAngle;
            float4 _Scale;
            
            v2f vert (appdata v)
            {
                v2f o;

                float sx = _Scale.x;
                float sy = _Scale.y;
                float sinTheta = sin(_ScaleAngle);
                float cosTheta = cos(_ScaleAngle);

                float sincos = sinTheta*cosTheta;
                float sinSq = sinTheta*sinTheta;
                float cosSq = cosTheta*cosTheta;

                float4 row1 = float4(sx*cosSq + sy*sinSq, (sx - sy)*sincos, 0, 0);
                float4 row2 = float4((sx - sy)*sincos, sx*sinSq + sy*cosSq, 0, 0);
                float4 row3 = float4(0, 0, 1, 0);
                float4 row4 = float4(0, 0, 0, 1);

                float4x4 angularShearMatrix = float4x4(row1, row2, row3, row4);

                o.vertex = mul(UNITY_MATRIX_MVP, mul(angularShearMatrix, v.vertex));
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                return tex2D(_MainTex, i.uv) * _Color;
            }
            ENDCG
        }
    }
}
