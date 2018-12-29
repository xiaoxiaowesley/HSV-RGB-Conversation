Shader "learn/NewSurfaceShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
        _deltaH ("deltaH",Range(-0,360)) = 0.0
        _deltaS ("deltaS",Range(-0,100)) = 0.0
        _deltaV ("deltaV",Range(-0,100)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0
        
        ///
        bool equalf(float a ,float b){
            float precise =0.000001;
            return abs(a - b) < precise;
        }
        float4 HSV2RGB(float3 hsv) {
            float H = hsv[0];
            float S = hsv[1];
            float V = hsv[2];
            
            //h scale from 0 to 6
            //s scale from 0 to  1
            //v scale from 0 to  1
            if(H > 6.0) H = 6.0;
            if(S > 1.0) S = 1.0;
            if(V > 1.0) V = 1.0;
        
            float alpha =V * (1.0-S);
            float beta = V * (1.0-(H-floor(H))*S);
            float gama = V *( 1.0- ( 1.0-( H - floor(H) )   )  *S   );
            
            float r = 0.0;
            float g = 0.0;
            float b = 0.0;
            if (H >= 0.0 && H < 1.0){
                r = V;
                g = gama;
                b = alpha;
            }else if (H >= 1.0 && H < 2.0){
                r = beta;
                g = V;
                b = alpha;
            }else if (H >= 2.0 && H < 3.0){
                r = alpha;
                g = V;
                b = gama;
            }else if (H >= 3.0&& H < 4.0){
                r = alpha;
                g = beta;
                b = V;
            }else if (H >= 4.0 && H < 5.0){
                r = gama;
                g = alpha;
                b = V;
            }else if (H >= 5.0 && H < 6.0){
                r = V;
                g = alpha;
                b = beta;
            }else{
                r = V;
                g = V;
                b = V;
            }
            float4 color;
            color[0] = r;
            color[1] = g;
            color[2] = b;
            color[3] = 1.0;
            return color;
        }
        
        float3 RGB2HSV(float4 color) {
            //rgb scale from 0 to 1
            float r = color[0];
            float g = color[1];
            float b = color[2];
            
            float M = max( max(r,g),b);
            float m = min( min(r,g),b);
            float delta = M - m;
            
            float h = 0.0;
            float s = 0.0;
            float v = 0.0;
            
            //H(Hue) a scale from 0 to 6
            if ( equalf(delta, 0.0)) h = 0.0;
            else if (equalf(M, r)) h = (g - b) / delta;
            else if (equalf(M , g)) h = 2.0 + (b - r) / delta;
            else if (equalf(M , b)) h = 4.0 + (r - g) / delta;
            
            //V(brightness) a scale from 0 to 1
            v = M;
            
            //S(saturation) a scale from 0 to 1
            if ( equalf(v , 0.0)) s = 0.0;
            else s = delta / v;
            
            float3 hsv;
            hsv[0] = h;
            hsv[1] = s;
            hsv[2] = v;
            return hsv;
        }
        float4 deltaHBV(float4 color,float deltaH,float deltaS,float deltaV)
        {
            float3 hsv = RGB2HSV(color);
            hsv[0] = hsv[0] + deltaH;
            hsv[1] = hsv[1] + deltaS;
            hsv[2] = hsv[2] + deltaV;
            float4 newColor = HSV2RGB(hsv);
            return newColor;
        }
        ///
        
        
		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
        fixed _deltaH;
        fixed _deltaS;
        fixed _deltaV;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) ;
            //
            float dh =  6.0 * _deltaH / 360.0;  //0-6
            float ds = _deltaS / 100.0; //0-1
            float dv = _deltaV / 100.0; //0-1
            float4 nc = deltaHBV(c,dh,ds,dv);
            //float4 nc = HSV2RGB((dh,ds,dv));
            //c.r = 83.0/255.0; //nc[0];
            //c.g = 138.0/255.0;//nc[1];
            //c.b = 88.0/255.0;//nc[2];
            
            c.r = nc[0];
            c.g = nc[1];
            c.b = nc[2];
            
            //
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
