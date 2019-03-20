
function equalf(a, b) {
    var precise = 0.000001;
    return abs(a - b) < precise ? true : false;
}
//h element must be a var value scaled from 0 to 6
//s element must be a var value scaled from 0 to 1
//v element must be a var value scaled from 0 to 1
function HSV2RGB(hsv) {
    var H = hsv.h;
    var S = hsv.s;
    var V = hsv.v;

    if (H > 6.0) H = 6.0;
    if (S > 1.0) S = 1.0;
    if (V > 1.0) V = 1.0;

    var alpha = V * (1.0 - S);
    var beta = V * (1.0 - (H - floor(H)) * S);
    var gama = V * (1.0 - (1.0 - (H - floor(H))) * S);

    var r = 0.0;
    var g = 0.0;
    var b = 0.0;
    if (H >= 0.0 && H < 1.0) {
        r = V;
        g = gama;
        b = alpha;
    } else if (H >= 1.0 && H < 2.0) {
        r = beta;
        g = V;
        b = alpha;
    } else if (H >= 2.0 && H < 3.0) {
        r = alpha;
        g = V;
        b = gama;
    } else if (H >= 3.0 && H < 4.0) {
        r = alpha;
        g = beta;
        b = V;
    } else if (H >= 4.0 && H < 5.0) {
        r = gama;
        g = alpha;
        b = V;
    } else if (H >= 5.0 && H < 6.0) {
        r = V;
        g = alpha;
        b = beta;
    } else {
        r = V;
        g = V;
        b = V;
    }
    return {
        r: r,
        g: g,
        b: b
    };
}

//Every element of color must be a var value scaled from 0 to 1
function RGB2HSV(color) {
    //rgb scale from 0 to 1
    var r = color.r;
    var g = color.g;
    var b = color.b;

    var M = Math.max(Math.max(r, g), b);
    var m = Math.min(Math.min(r, g), b);
    var delta = M - m;

    var h = 0.0;
    var s = 0.0;
    var v = 0.0;

    //H(Hue) scale from 0 to 6
    if (equalf(delta, 0.0)) h = 0.0;
    else if (equalf(M, r)) h = (g - b) / delta;
    else if (equalf(M, g)) h = 2.0 + (b - r) / delta;
    else if (equalf(M, b)) h = 4.0 + (r - g) / delta;

    //V(brightness) scale from 0 to 1
    v = M;

    //S(saturation) scale from 0 to 1
    if (equalf(v, 0.0)) s = 0.0;
    else s = delta / v;
    
    if (h<0) {
        h=h+6;
    }
    return {
        h: h,
        s: s,
        v: v
    };
}
