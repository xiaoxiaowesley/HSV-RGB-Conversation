#include  <math.h>

float max(float a,float b) {
    return a > b ? a : b;
}

float min(float a, float b) {
    return a < b ? a : b;
}

typedef struct
{
    float r;
    float g;
    float b;
    float a;
}vec4;
typedef struct
{
    float x;
    float y;
    float z;
}vec3;


//compare two float value function
int equalf(float a ,float b){
    float precise =0.000001;
    return fabs(a - b) < precise ? 1 : 0;
}

//h 0-6
//s 0-1
//v 0-1
vec4 HSV2RGB(vec3 hsv) {
    
    float H = hsv.x;
    float S = hsv.y;
    float V = hsv.z;
    
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
    vec4 color;
    color.r = r;
    color.g = g;
    color.b = b;
    color.a = 1.0;
    return color;
}
vec3 RGB2HSV(vec4 color) {
    //rgb scale from 0 to 1
    float r = color.r;
    float g = color.g;
    float b = color.b;
    
    float M = max( max(r,g),b);
    float m = min( min(r,g),b);
    float delta = M - m;
    
    float h = 0.0;
    float s = 0.0;
    float v = 0.0;
    
    //H(Hue) scale from 0 to 6
    if ( equalf(delta, 0.0)) h = 0.0;
    else if (equalf(M, r)) h = (g - b) / delta;
    else if (equalf(M , g)) h = 2.0 + (b - r) / delta;
    else if (equalf(M , b)) h = 4.0 + (r - g) / delta;
    
    //V(brightness) scale from 0 to 1
    v = M;
    
    //S(saturation) scale from 0 to 1
    if ( equalf(v , 0.0)) s = 0.0;
    else s = delta / v;
    
    vec3 hsv;
    hsv.x = h;
    hsv.y = s;
    hsv.z = v;
    return hsv;
};


int main(int argc, const char * argv[]) {

    return 0;
}
