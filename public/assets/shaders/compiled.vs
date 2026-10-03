{@}AntimatterCopy.fs{@}uniform sampler2D tDiffuse;

varying vec2 vUv;

void main() {
    gl_FragColor = texture2D(tDiffuse, vUv);
}{@}AntimatterCopy.vs{@}varying vec2 vUv;
void main() {
    vUv = uv;
    gl_Position = vec4(position, 1.0);
}{@}AntimatterPass.vs{@}varying vec2 vUv;

void main() {
    vUv = uv;
    gl_Position = vec4(position, 1.0);
}{@}AntimatterPosition.vs{@}uniform sampler2D tPos;
uniform float uDPR;

void main() {
    vec4 decodedPos = texture2D(tPos, position.xy);
    vec3 pos = decodedPos.xyz;

    vec4 mvPosition = modelViewMatrix * vec4(pos, 1.0);
    gl_PointSize = (0.02 * uDPR) * (1000.0 / length(mvPosition.xyz));
    gl_Position = projectionMatrix * mvPosition;
}{@}AntimatterBasicFrag.fs{@}void main() {
    gl_FragColor = vec4(1.0);
}{@}antimatter.glsl{@}vec3 getData(sampler2D tex, vec2 uv) {
    return texture2D(tex, uv).xyz;
}

vec4 getData4(sampler2D tex, vec2 uv) {
    return texture2D(tex, uv);
}

{@}blendmodes.glsl{@}float blendColorDodge(float base, float blend) {
    return (blend == 1.0)?blend:min(base/(1.0-blend), 1.0);
}
vec3 blendColorDodge(vec3 base, vec3 blend) {
    return vec3(blendColorDodge(base.r, blend.r), blendColorDodge(base.g, blend.g), blendColorDodge(base.b, blend.b));
}
vec3 blendColorDodge(vec3 base, vec3 blend, float opacity) {
    return (blendColorDodge(base, blend) * opacity + base * (1.0 - opacity));
}
float blendColorBurn(float base, float blend) {
    return (blend == 0.0)?blend:max((1.0-((1.0-base)/blend)), 0.0);
}
vec3 blendColorBurn(vec3 base, vec3 blend) {
    return vec3(blendColorBurn(base.r, blend.r), blendColorBurn(base.g, blend.g), blendColorBurn(base.b, blend.b));
}
vec3 blendColorBurn(vec3 base, vec3 blend, float opacity) {
    return (blendColorBurn(base, blend) * opacity + base * (1.0 - opacity));
}
float blendVividLight(float base, float blend) {
    return (blend<0.5)?blendColorBurn(base, (2.0*blend)):blendColorDodge(base, (2.0*(blend-0.5)));
}
vec3 blendVividLight(vec3 base, vec3 blend) {
    return vec3(blendVividLight(base.r, blend.r), blendVividLight(base.g, blend.g), blendVividLight(base.b, blend.b));
}
vec3 blendVividLight(vec3 base, vec3 blend, float opacity) {
    return (blendVividLight(base, blend) * opacity + base * (1.0 - opacity));
}
float blendHardMix(float base, float blend) {
    return (blendVividLight(base, blend)<0.5)?0.0:1.0;
}
vec3 blendHardMix(vec3 base, vec3 blend) {
    return vec3(blendHardMix(base.r, blend.r), blendHardMix(base.g, blend.g), blendHardMix(base.b, blend.b));
}
vec3 blendHardMix(vec3 base, vec3 blend, float opacity) {
    return (blendHardMix(base, blend) * opacity + base * (1.0 - opacity));
}
float blendLinearDodge(float base, float blend) {
    return min(base+blend, 1.0);
}
vec3 blendLinearDodge(vec3 base, vec3 blend) {
    return min(base+blend, vec3(1.0));
}
vec3 blendLinearDodge(vec3 base, vec3 blend, float opacity) {
    return (blendLinearDodge(base, blend) * opacity + base * (1.0 - opacity));
}
float blendLinearBurn(float base, float blend) {
    return max(base+blend-1.0, 0.0);
}
vec3 blendLinearBurn(vec3 base, vec3 blend) {
    return max(base+blend-vec3(1.0), vec3(0.0));
}
vec3 blendLinearBurn(vec3 base, vec3 blend, float opacity) {
    return (blendLinearBurn(base, blend) * opacity + base * (1.0 - opacity));
}
float blendLinearLight(float base, float blend) {
    return blend<0.5?blendLinearBurn(base, (2.0*blend)):blendLinearDodge(base, (2.0*(blend-0.5)));
}
vec3 blendLinearLight(vec3 base, vec3 blend) {
    return vec3(blendLinearLight(base.r, blend.r), blendLinearLight(base.g, blend.g), blendLinearLight(base.b, blend.b));
}
vec3 blendLinearLight(vec3 base, vec3 blend, float opacity) {
    return (blendLinearLight(base, blend) * opacity + base * (1.0 - opacity));
}
float blendLighten(float base, float blend) {
    return max(blend, base);
}
vec3 blendLighten(vec3 base, vec3 blend) {
    return vec3(blendLighten(base.r, blend.r), blendLighten(base.g, blend.g), blendLighten(base.b, blend.b));
}
vec3 blendLighten(vec3 base, vec3 blend, float opacity) {
    return (blendLighten(base, blend) * opacity + base * (1.0 - opacity));
}
float blendDarken(float base, float blend) {
    return min(blend, base);
}
vec3 blendDarken(vec3 base, vec3 blend) {
    return vec3(blendDarken(base.r, blend.r), blendDarken(base.g, blend.g), blendDarken(base.b, blend.b));
}
vec3 blendDarken(vec3 base, vec3 blend, float opacity) {
    return (blendDarken(base, blend) * opacity + base * (1.0 - opacity));
}
float blendPinLight(float base, float blend) {
    return (blend<0.5)?blendDarken(base, (2.0*blend)):blendLighten(base, (2.0*(blend-0.5)));
}
vec3 blendPinLight(vec3 base, vec3 blend) {
    return vec3(blendPinLight(base.r, blend.r), blendPinLight(base.g, blend.g), blendPinLight(base.b, blend.b));
}
vec3 blendPinLight(vec3 base, vec3 blend, float opacity) {
    return (blendPinLight(base, blend) * opacity + base * (1.0 - opacity));
}
float blendReflect(float base, float blend) {
    return (blend == 1.0)?blend:min(base*base/(1.0-blend), 1.0);
}
vec3 blendReflect(vec3 base, vec3 blend) {
    return vec3(blendReflect(base.r, blend.r), blendReflect(base.g, blend.g), blendReflect(base.b, blend.b));
}
vec3 blendReflect(vec3 base, vec3 blend, float opacity) {
    return (blendReflect(base, blend) * opacity + base * (1.0 - opacity));
}
vec3 blendGlow(vec3 base, vec3 blend) {
    return blendReflect(blend, base);
}
vec3 blendGlow(vec3 base, vec3 blend, float opacity) {
    return (blendGlow(base, blend) * opacity + base * (1.0 - opacity));
}
float blendOverlay(float base, float blend) {
    return base<0.5?(2.0*base*blend):(1.0-2.0*(1.0-base)*(1.0-blend));
}
vec3 blendOverlay(vec3 base, vec3 blend) {
    return vec3(blendOverlay(base.r, blend.r), blendOverlay(base.g, blend.g), blendOverlay(base.b, blend.b));
}
vec3 blendOverlay(vec3 base, vec3 blend, float opacity) {
    return (blendOverlay(base, blend) * opacity + base * (1.0 - opacity));
}
vec3 blendHardLight(vec3 base, vec3 blend) {
    return blendOverlay(blend, base);
}
vec3 blendHardLight(vec3 base, vec3 blend, float opacity) {
    return (blendHardLight(base, blend) * opacity + base * (1.0 - opacity));
}
vec3 blendPhoenix(vec3 base, vec3 blend) {
    return min(base, blend)-max(base, blend)+vec3(1.0);
}
vec3 blendPhoenix(vec3 base, vec3 blend, float opacity) {
    return (blendPhoenix(base, blend) * opacity + base * (1.0 - opacity));
}
vec3 blendNormal(vec3 base, vec3 blend) {
    return blend;
}
vec3 blendNormal(vec3 base, vec3 blend, float opacity) {
    return (blendNormal(base, blend) * opacity + base * (1.0 - opacity));
}
vec3 blendNegation(vec3 base, vec3 blend) {
    return vec3(1.0)-abs(vec3(1.0)-base-blend);
}
vec3 blendNegation(vec3 base, vec3 blend, float opacity) {
    return (blendNegation(base, blend) * opacity + base * (1.0 - opacity));
}
vec3 blendMultiply(vec3 base, vec3 blend) {
    return base*blend;
}
vec3 blendMultiply(vec3 base, vec3 blend, float opacity) {
    return (blendMultiply(base, blend) * opacity + base * (1.0 - opacity));
}
vec3 blendAverage(vec3 base, vec3 blend) {
    return (base+blend)/2.0;
}
vec3 blendAverage(vec3 base, vec3 blend, float opacity) {
    return (blendAverage(base, blend) * opacity + base * (1.0 - opacity));
}
float blendScreen(float base, float blend) {
    return 1.0-((1.0-base)*(1.0-blend));
}
vec3 blendScreen(vec3 base, vec3 blend) {
    return vec3(blendScreen(base.r, blend.r), blendScreen(base.g, blend.g), blendScreen(base.b, blend.b));
}
vec3 blendScreen(vec3 base, vec3 blend, float opacity) {
    return (blendScreen(base, blend) * opacity + base * (1.0 - opacity));
}
float blendSoftLight(float base, float blend) {
    return (blend<0.5)?(2.0*base*blend+base*base*(1.0-2.0*blend)):(sqrt(base)*(2.0*blend-1.0)+2.0*base*(1.0-blend));
}
vec3 blendSoftLight(vec3 base, vec3 blend) {
    return vec3(blendSoftLight(base.r, blend.r), blendSoftLight(base.g, blend.g), blendSoftLight(base.b, blend.b));
}
vec3 blendSoftLight(vec3 base, vec3 blend, float opacity) {
    return (blendSoftLight(base, blend) * opacity + base * (1.0 - opacity));
}
float blendSubtract(float base, float blend) {
    return max(base+blend-1.0, 0.0);
}
vec3 blendSubtract(vec3 base, vec3 blend) {
    return max(base+blend-vec3(1.0), vec3(0.0));
}
vec3 blendSubtract(vec3 base, vec3 blend, float opacity) {
    return (blendSubtract(base, blend) * opacity + base * (1.0 - opacity));
}
vec3 blendExclusion(vec3 base, vec3 blend) {
    return base+blend-2.0*base*blend;
}
vec3 blendExclusion(vec3 base, vec3 blend, float opacity) {
    return (blendExclusion(base, blend) * opacity + base * (1.0 - opacity));
}
vec3 blendDifference(vec3 base, vec3 blend) {
    return abs(base-blend);
}
vec3 blendDifference(vec3 base, vec3 blend, float opacity) {
    return (blendDifference(base, blend) * opacity + base * (1.0 - opacity));
}
float blendAdd(float base, float blend) {
    return min(base+blend, 1.0);
}
vec3 blendAdd(vec3 base, vec3 blend) {
    return min(base+blend, vec3(1.0));
}
vec3 blendAdd(vec3 base, vec3 blend, float opacity) {
    return (blendAdd(base, blend) * opacity + base * (1.0 - opacity));
}{@}conditionals.glsl{@}vec4 when_eq(vec4 x, vec4 y) {
  return 1.0 - abs(sign(x - y));
}

vec4 when_neq(vec4 x, vec4 y) {
  return abs(sign(x - y));
}

vec4 when_gt(vec4 x, vec4 y) {
  return max(sign(x - y), 0.0);
}

vec4 when_lt(vec4 x, vec4 y) {
  return max(sign(y - x), 0.0);
}

vec4 when_ge(vec4 x, vec4 y) {
  return 1.0 - when_lt(x, y);
}

vec4 when_le(vec4 x, vec4 y) {
  return 1.0 - when_gt(x, y);
}

vec3 when_eq(vec3 x, vec3 y) {
  return 1.0 - abs(sign(x - y));
}

vec3 when_neq(vec3 x, vec3 y) {
  return abs(sign(x - y));
}

vec3 when_gt(vec3 x, vec3 y) {
  return max(sign(x - y), 0.0);
}

vec3 when_lt(vec3 x, vec3 y) {
  return max(sign(y - x), 0.0);
}

vec3 when_ge(vec3 x, vec3 y) {
  return 1.0 - when_lt(x, y);
}

vec3 when_le(vec3 x, vec3 y) {
  return 1.0 - when_gt(x, y);
}

vec2 when_eq(vec2 x, vec2 y) {
  return 1.0 - abs(sign(x - y));
}

vec2 when_neq(vec2 x, vec2 y) {
  return abs(sign(x - y));
}

vec2 when_gt(vec2 x, vec2 y) {
  return max(sign(x - y), 0.0);
}

vec2 when_lt(vec2 x, vec2 y) {
  return max(sign(y - x), 0.0);
}

vec2 when_ge(vec2 x, vec2 y) {
  return 1.0 - when_lt(x, y);
}

vec2 when_le(vec2 x, vec2 y) {
  return 1.0 - when_gt(x, y);
}

float when_eq(float x, float y) {
  return 1.0 - abs(sign(x - y));
}

float when_neq(float x, float y) {
  return abs(sign(x - y));
}

float when_gt(float x, float y) {
  return max(sign(x - y), 0.0);
}

float when_lt(float x, float y) {
  return max(sign(y - x), 0.0);
}

float when_ge(float x, float y) {
  return 1.0 - when_lt(x, y);
}

float when_le(float x, float y) {
  return 1.0 - when_gt(x, y);
}

vec4 and(vec4 a, vec4 b) {
  return a * b;
}

vec4 or(vec4 a, vec4 b) {
  return min(a + b, 1.0);
}

vec4 Not(vec4 a) {
  return 1.0 - a;
}

vec3 and(vec3 a, vec3 b) {
  return a * b;
}

vec3 or(vec3 a, vec3 b) {
  return min(a + b, 1.0);
}

vec3 Not(vec3 a) {
  return 1.0 - a;
}

vec2 and(vec2 a, vec2 b) {
  return a * b;
}

vec2 or(vec2 a, vec2 b) {
  return min(a + b, 1.0);
}


vec2 Not(vec2 a) {
  return 1.0 - a;
}

float and(float a, float b) {
  return a * b;
}

float or(float a, float b) {
  return min(a + b, 1.0);
}

float Not(float a) {
  return 1.0 - a;
}{@}contrast.glsl{@}vec3 adjustContrast(vec3 color, float c, float m) {
	float t = 0.5 - c * 0.5;
	color.rgb = color.rgb * c + t;
	return color * m;
}{@}curl.glsl{@}#test Device.mobile
float sinf2(float x) {
    x*=0.159155;
    x-=floor(x);
    float xx=x*x;
    float y=-6.87897;
    y=y*xx+33.7755;
    y=y*xx-72.5257;
    y=y*xx+80.5874;
    y=y*xx-41.2408;
    y=y*xx+6.28077;
    return x*y;
}

float cosf2(float x) {
    return sinf2(x+1.5708);
}
#endtest

#test !Device.mobile
    #define sinf2 sin
    #define cosf2 cos
#endtest

float potential1(vec3 v) {
    float noise = 0.0;
    noise += sinf2(v.x * 1.8 + v.z * 3.) + sinf2(v.x * 4.8 + v.z * 4.5) + sinf2(v.x * -7.0 + v.z * 1.2) + sinf2(v.x * -5.0 + v.z * 2.13);
    noise += sinf2(v.y * -0.48 + v.z * 5.4) + sinf2(v.y * 2.56 + v.z * 5.4) + sinf2(v.y * 4.16 + v.z * 2.4) + sinf2(v.y * -4.16 + v.z * 1.35);
    return noise;
}

float potential2(vec3 v) {
    float noise = 0.0;
    noise += sinf2(v.y * 1.8 + v.x * 3. - 2.82) + sinf2(v.y * 4.8 + v.x * 4.5 + 74.37) + sinf2(v.y * -7.0 + v.x * 1.2 - 256.72) + sinf2(v.y * -5.0 + v.x * 2.13 - 207.683);
    noise += sinf2(v.z * -0.48 + v.x * 5.4 -125.796) + sinf2(v.z * 2.56 + v.x * 5.4 + 17.692) + sinf2(v.z * 4.16 + v.x * 2.4 + 150.512) + sinf2(v.z * -4.16 + v.x * 1.35 - 222.137);
    return noise;
}

float potential3(vec3 v) {
    float noise = 0.0;
    noise += sinf2(v.z * 1.8 + v.y * 3. - 194.58) + sinf2(v.z * 4.8 + v.y * 4.5 - 83.13) + sinf2(v.z * -7.0 + v.y * 1.2 -845.2) + sinf2(v.z * -5.0 + v.y * 2.13 - 762.185);
    noise += sinf2(v.x * -0.48 + v.y * 5.4 - 707.916) + sinf2(v.x * 2.56 + v.y * 5.4 + -482.348) + sinf2(v.x * 4.16 + v.y * 2.4 + 9.872) + sinf2(v.x * -4.16 + v.y * 1.35 - 476.747);
    return noise;
}

vec3 snoiseVec3( vec3 x ) {
    float s  = potential1(x);
    float s1 = potential2(x);
    float s2 = potential3(x);
    return vec3( s , s1 , s2 );
}

//Analitic derivatives of the potentials for the curl noise, based on: http://weber.itn.liu.se/~stegu/TNM084-2019/bridson-siggraph2007-curlnoise.pdf

float dP3dY(vec3 v) {
    float noise = 0.0;
    noise += 3. * cosf2(v.z * 1.8 + v.y * 3. - 194.58) + 4.5 * cosf2(v.z * 4.8 + v.y * 4.5 - 83.13) + 1.2 * cosf2(v.z * -7.0 + v.y * 1.2 -845.2) + 2.13 * cosf2(v.z * -5.0 + v.y * 2.13 - 762.185);
    noise += 5.4 * cosf2(v.x * -0.48 + v.y * 5.4 - 707.916) + 5.4 * cosf2(v.x * 2.56 + v.y * 5.4 + -482.348) + 2.4 * cosf2(v.x * 4.16 + v.y * 2.4 + 9.872) + 1.35 * cosf2(v.x * -4.16 + v.y * 1.35 - 476.747);
    return noise;
}

float dP2dZ(vec3 v) {
    return -0.48 * cosf2(v.z * -0.48 + v.x * 5.4 -125.796) + 2.56 * cosf2(v.z * 2.56 + v.x * 5.4 + 17.692) + 4.16 * cosf2(v.z * 4.16 + v.x * 2.4 + 150.512) -4.16 * cosf2(v.z * -4.16 + v.x * 1.35 - 222.137);
}

float dP1dZ(vec3 v) {
    float noise = 0.0;
    noise += 3. * cosf2(v.x * 1.8 + v.z * 3.) + 4.5 * cosf2(v.x * 4.8 + v.z * 4.5) + 1.2 * cosf2(v.x * -7.0 + v.z * 1.2) + 2.13 * cosf2(v.x * -5.0 + v.z * 2.13);
    noise += 5.4 * cosf2(v.y * -0.48 + v.z * 5.4) + 5.4 * cosf2(v.y * 2.56 + v.z * 5.4) + 2.4 * cosf2(v.y * 4.16 + v.z * 2.4) + 1.35 * cosf2(v.y * -4.16 + v.z * 1.35);
    return noise;
}

float dP3dX(vec3 v) {
    return -0.48 * cosf2(v.x * -0.48 + v.y * 5.4 - 707.916) + 2.56 * cosf2(v.x * 2.56 + v.y * 5.4 + -482.348) + 4.16 * cosf2(v.x * 4.16 + v.y * 2.4 + 9.872) -4.16 * cosf2(v.x * -4.16 + v.y * 1.35 - 476.747);
}

float dP2dX(vec3 v) {
    float noise = 0.0;
    noise += 3. * cosf2(v.y * 1.8 + v.x * 3. - 2.82) + 4.5 * cosf2(v.y * 4.8 + v.x * 4.5 + 74.37) + 1.2 * cosf2(v.y * -7.0 + v.x * 1.2 - 256.72) + 2.13 * cosf2(v.y * -5.0 + v.x * 2.13 - 207.683);
    noise += 5.4 * cosf2(v.z * -0.48 + v.x * 5.4 -125.796) + 5.4 * cosf2(v.z * 2.56 + v.x * 5.4 + 17.692) + 2.4 * cosf2(v.z * 4.16 + v.x * 2.4 + 150.512) + 1.35 * cosf2(v.z * -4.16 + v.x * 1.35 - 222.137);
    return noise;
}

float dP1dY(vec3 v) {
    return -0.48 * cosf2(v.y * -0.48 + v.z * 5.4) + 2.56 * cosf2(v.y * 2.56 + v.z * 5.4) +  4.16 * cosf2(v.y * 4.16 + v.z * 2.4) -4.16 * cosf2(v.y * -4.16 + v.z * 1.35);
}


vec3 curlNoise( vec3 p ) {

    //A sinf2 or cosf2 call is a trigonometric function, these functions are expensive in the GPU
    //the partial derivatives with approximations require to calculate the snoiseVec3 function 4 times.
    //The previous function evaluate the potentials that include 8 trigonometric functions each.
    //
    //This means that the potentials are evaluated 12 times (4 calls to snoiseVec3 that make 3 potential calls).
    //The whole process call 12 * 8 trigonometric functions, a total of 96 times.


    /*
    const float e = 1e-1;
    vec3 dx = vec3( e   , 0.0 , 0.0 );
    vec3 dy = vec3( 0.0 , e   , 0.0 );
    vec3 dz = vec3( 0.0 , 0.0 , e   );
    vec3 p0 = snoiseVec3(p);
    vec3 p_x1 = snoiseVec3( p + dx );
    vec3 p_y1 = snoiseVec3( p + dy );
    vec3 p_z1 = snoiseVec3( p + dz );
    float x = p_y1.z - p0.z - p_z1.y + p0.y;
    float y = p_z1.x - p0.x - p_x1.z + p0.z;
    float z = p_x1.y - p0.y - p_y1.x + p0.x;
    return normalize( vec3( x , y , z ));
    */


    //The noise that is used to define the potentials is based on analitic functions that are easy to derivate,
    //meaning that the analitic solution would provide a much faster approach with the same visual results.
    //
    //Usinf2g the analitic derivatives the algorithm does not require to evaluate snoiseVec3, instead it uses the
    //analitic partial derivatives from each potential on the corresponding axis, providing a total of
    //36 calls to trigonometric functions, making the analytic evaluation almost 3 times faster than the aproximation method.


    float x = dP3dY(p) - dP2dZ(p);
    float y = dP1dZ(p) - dP3dX(p);
    float z = dP2dX(p) - dP1dY(p);


    return normalize( vec3( x , y , z ));



}{@}depthvalue.fs{@}float getDepthValue(sampler2D tDepth, vec2 uv, float n, float f) {
    vec4 depth = texture2D(tDepth, uv);
    return (2.0 * n) / (f + n - depth.x * (f - n));
}

vec3 worldPosFromDepth(sampler2D tDepth) {
    float depth = texture2D(tDepth, vUv).r;
    float z = depth * 2.0 - 1.0;

    vec4 clipSpacePosition = vec4(vUv * 2.0 - 1.0, z, 1.0);
    vec4 viewSpacePosition = inverse(projectionMatrix) * clipSpacePosition;

    // Perspective division
    viewSpacePosition /= viewSpacePosition.w;

    vec4 worldSpacePosition = inverse(viewMatrix) * viewSpacePosition;

    return worldSpacePosition.xyz;
}
{@}eases.glsl{@}#ifndef PI
#define PI 3.141592653589793
#endif

#ifndef HALF_PI
#define HALF_PI 1.5707963267948966
#endif

float backInOut(float t) {
  float f = t < 0.5
    ? 2.0 * t
    : 1.0 - (2.0 * t - 1.0);

  float g = pow(f, 3.0) - f * sin(f * PI);

  return t < 0.5
    ? 0.5 * g
    : 0.5 * (1.0 - g) + 0.5;
}

float backIn(float t) {
  return pow(t, 3.0) - t * sin(t * PI);
}

float backOut(float t) {
  float f = 1.0 - t;
  return 1.0 - (pow(f, 3.0) - f * sin(f * PI));
}

float bounceOut(float t) {
  const float a = 4.0 / 11.0;
  const float b = 8.0 / 11.0;
  const float c = 9.0 / 10.0;

  const float ca = 4356.0 / 361.0;
  const float cb = 35442.0 / 1805.0;
  const float cc = 16061.0 / 1805.0;

  float t2 = t * t;

  return t < a
    ? 7.5625 * t2
    : t < b
      ? 9.075 * t2 - 9.9 * t + 3.4
      : t < c
        ? ca * t2 - cb * t + cc
        : 10.8 * t * t - 20.52 * t + 10.72;
}

float bounceIn(float t) {
  return 1.0 - bounceOut(1.0 - t);
}

float bounceInOut(float t) {
  return t < 0.5
    ? 0.5 * (1.0 - bounceOut(1.0 - t * 2.0))
    : 0.5 * bounceOut(t * 2.0 - 1.0) + 0.5;
}

float circularInOut(float t) {
  return t < 0.5
    ? 0.5 * (1.0 - sqrt(1.0 - 4.0 * t * t))
    : 0.5 * (sqrt((3.0 - 2.0 * t) * (2.0 * t - 1.0)) + 1.0);
}

float circularIn(float t) {
  return 1.0 - sqrt(1.0 - t * t);
}

float circularOut(float t) {
  return sqrt((2.0 - t) * t);
}

float cubicInOut(float t) {
  return t < 0.5
    ? 4.0 * t * t * t
    : 0.5 * -pow(2.0 - 2.0 * t, 3.0) + 1.0;
}

float cubicIn(float t) {
  return t * t * t;
}

float cubicOut(float t) {
  float f = t - 1.0;
  return f * f * f + 1.0;
}

float elasticInOut(float t) {
  return t < 0.5
    ? 0.5 * sin(+13.0 * HALF_PI * 2.0 * t) * pow(2.0, 10.0 * (2.0 * t - 1.0))
    : 0.5 * sin(-13.0 * HALF_PI * ((2.0 * t - 1.0) + 1.0)) * pow(2.0, -10.0 * (2.0 * t - 1.0)) + 1.0;
}

float elasticIn(float t) {
  return sin(13.0 * t * HALF_PI) * pow(2.0, 10.0 * (t - 1.0));
}

float elasticOut(float t) {
  return sin(-13.0 * (t + 1.0) * HALF_PI) * pow(2.0, -10.0 * t) + 1.0;
}

float expoInOut(float t) {
  return t == 0.0 || t == 1.0
    ? t
    : t < 0.5
      ? +0.5 * pow(2.0, (20.0 * t) - 10.0)
      : -0.5 * pow(2.0, 10.0 - (t * 20.0)) + 1.0;
}

float expoIn(float t) {
  return t == 0.0 ? t : pow(2.0, 10.0 * (t - 1.0));
}

float expoOut(float t) {
  return t == 1.0 ? t : 1.0 - pow(2.0, -10.0 * t);
}

float linear(float t) {
  return t;
}

float quadraticInOut(float t) {
  float p = 2.0 * t * t;
  return t < 0.5 ? p : -p + (4.0 * t) - 1.0;
}

float quadraticIn(float t) {
  return t * t;
}

float quadraticOut(float t) {
  return -t * (t - 2.0);
}

float quarticInOut(float t) {
  return t < 0.5
    ? +8.0 * pow(t, 4.0)
    : -8.0 * pow(1.0 - t, 4.0) + 1.0;
}

float quarticIn(float t) {
  return pow(t, 4.0);
}

float quarticOut(float t) {
  return pow(1.0 - t, 3.0) * (t - 1.0) + 1.0;
}

float qinticInOut(float t) {
  return t < 0.5
    ? +16.0 * pow(t, 5.0)
    : -0.5 * pow(2.0 * t - 2.0, 5.0) + 1.0;
}

float qinticIn(float t) {
  return pow(t, 5.0);
}

float qinticOut(float t) {
  return 1.0 - (pow(1.0 - t, 5.0));
}

float sineInOut(float t) {
  return -0.5 * (cos(PI * t) - 1.0);
}

float sineIn(float t) {
  return sin((t - 1.0) * HALF_PI) + 1.0;
}

float sineOut(float t) {
  return sin(t * HALF_PI);
}
{@}ColorMaterial.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform vec3 color;
uniform float alpha;

#!VARYINGS

#!SHADER: ColorMaterial.vs
void main() {
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: ColorMaterial.fs
void main() {
    gl_FragColor = vec4(color, alpha);
}{@}DebugCamera.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform vec3 uColor;

#!VARYINGS
varying vec3 vColor;

#!SHADER: DebugCamera.vs
void main() {
    vColor = mix(uColor, vec3(1.0, 0.0, 0.0), step(position.z, -0.1));
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: DebugCamera.fs
void main() {
    gl_FragColor = vec4(vColor, 1.0);
}{@}OcclusionMaterial.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform vec3 bbMin;
uniform vec3 bbMax;

#!VARYINGS

#!SHADER: Vertex.vs
void main() {
    vec3 pos = position;
    pos *= bbMax - bbMin;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment.fs
void main() {
    gl_FragColor = vec4(1.0);
}{@}ScreenQuad.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;

#!VARYINGS

#!SHADER: ScreenQuad.vs
void main() {
    gl_Position = vec4(position, 1.0);
}

#!SHADER: ScreenQuad.fs
void main() {
    gl_FragColor = texture2D(tMap, gl_FragCoord.xy / resolution);
    gl_FragColor.a = 1.0;
}{@}ScreenQuadVR.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform float uEye;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex

vec2 scaleUV(vec2 uv, vec2 scale, vec2 origin) {
    vec2 st = uv - origin;
    st /= scale;
    return st + origin;
}

void main() {
    vUv = scaleUV(uv, vec2(2.0, 1.0), vec2(0.0)) - vec2(uEye, 0.0);
    gl_Position = vec4(position, 1.0);
}

#!SHADER: Fragment
void main() {
    gl_FragColor = texture2D(tMap, vUv);
}{@}TestMaterial.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform float alpha;

#!VARYINGS
varying vec3 vNormal;

#!SHADER: TestMaterial.vs
void main() {
    vec3 pos = position;
    vNormal = normalMatrix * normal;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: TestMaterial.fs
void main() {
    gl_FragColor = vec4(vNormal, 1.0);
}{@}TextureMaterial.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;

#!VARYINGS
varying vec2 vUv;

#!SHADER: TextureMaterial.vs
void main() {
    vUv = uv;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: TextureMaterial.fs
void main() {
    gl_FragColor = texture2D(tMap, vUv);
    gl_FragColor.rgb /= gl_FragColor.a;
}{@}BlitPass.fs{@}void main() {
    gl_FragColor = texture2D(tDiffuse, vUv);
    gl_FragColor.a = 1.0;
}{@}NukePass.vs{@}varying vec2 vUv;

void main() {
    vUv = uv;
    gl_Position = vec4(position, 1.0);
}{@}ShadowDepth.glsl{@}#!ATTRIBUTES

#!UNIFORMS

#!VARYINGS

#!SHADER: ShadowDepth.vs
void main() {
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: ShadowDepth.fs
void main() {
    gl_FragColor = vec4(vec3(gl_FragCoord.x), 1.0);
}{@}instance.vs{@}vec3 transformNormal(vec3 n, vec4 orientation) {
    vec3 nn = n + 2.0 * cross(orientation.xyz, cross(orientation.xyz, n) + orientation.w * n);
    return nn;
}

vec3 transformPosition(vec3 position, vec3 offset, vec3 scale, vec4 orientation) {
    vec3 _pos = position;
    _pos *= scale;

    _pos = _pos + 2.0 * cross(orientation.xyz, cross(orientation.xyz, _pos) + orientation.w * _pos);
    _pos += offset;
    return _pos;
}

vec3 transformPosition(vec3 position, vec3 offset, vec4 orientation) {
    vec3 _pos = position;

    _pos = _pos + 2.0 * cross(orientation.xyz, cross(orientation.xyz, _pos) + orientation.w * _pos);
    _pos += offset;
    return _pos;
}

vec3 transformPosition(vec3 position, vec3 offset, float scale, vec4 orientation) {
    return transformPosition(position, offset, vec3(scale), orientation);
}

vec3 transformPosition(vec3 position, vec3 offset) {
    return position + offset;
}

vec3 transformPosition(vec3 position, vec3 offset, float scale) {
    vec3 pos = position * scale;
    return pos + offset;
}

vec3 transformPosition(vec3 position, vec3 offset, vec3 scale) {
    vec3 pos = position * scale;
    return pos + offset;
}{@}lights.fs{@}vec3 worldLight(vec3 pos, vec3 vpos) {
    vec4 mvPos = modelViewMatrix * vec4(vpos, 1.0);
    vec4 worldPosition = viewMatrix * vec4(pos, 1.0);
    return worldPosition.xyz - mvPos.xyz;
}{@}lights.vs{@}vec3 worldLight(vec3 pos) {
    vec4 mvPos = modelViewMatrix * vec4(position, 1.0);
    vec4 worldPosition = viewMatrix * vec4(pos, 1.0);
    return worldPosition.xyz - mvPos.xyz;
}

vec3 worldLight(vec3 lightPos, vec3 localPos) {
    vec4 mvPos = modelViewMatrix * vec4(localPos, 1.0);
    vec4 worldPosition = viewMatrix * vec4(lightPos, 1.0);
    return worldPosition.xyz - mvPos.xyz;
}{@}shadows.fs{@}#define PI2 6.2831853072
#define PI 3.141592653589793

#define MAX_PCSS_SAMPLES 17
vec2 poissonDisk[MAX_PCSS_SAMPLES];

struct PCSShadowConfig {
    int sampleCount;
    int ringCount;
    float lightWorldSize;
    float lightFrustumWidth;
    float nearPlane;
};

PCSShadowConfig defaultPCSSShadowConfig() {
    PCSShadowConfig config;
    config.sampleCount = 10;
    config.ringCount = 11;
    config.lightWorldSize = 0.3;
    config.lightFrustumWidth = 6.75;
    config.nearPlane = 6.5;
    return config;
}

bool frustumTest(vec3 coords) {
    return coords.x >= 0.0 && coords.x <= 1.0 && coords.y >= 0.0 && coords.y <= 1.0 && coords.z <= 1.0;
}

float rand(float n){return fract(sin(n) * 43758.5453123);}
highp float rand( const in vec2 uv ) {
    const highp float a = 12.9898, b = 78.233, c = 43758.5453;
    highp float dt = dot( uv.xy, vec2( a, b ) ), sn = mod( dt, PI );
    return fract( sin( sn ) * c );
}

void initPoissonSamples(const in vec2 randomSeed, PCSShadowConfig config) {
    float angleStep = PI2 * float(config.ringCount) / float(config.sampleCount);
    float invSampleCount = 1.0 / float(config.sampleCount);
    float angle = rand(randomSeed) * PI2;
    float radius = invSampleCount;
    float radiusStep = radius;
    
    for(int i = 0; i < MAX_PCSS_SAMPLES; i ++ ) {
        if( i > config.sampleCount ) {
            break;
        }
        poissonDisk[i] = vec2(cos(angle), sin(angle)) * pow(radius, 0.75);
        radius += radiusStep;
        angle += angleStep;
    }
}

float penumbraSize(const in float zReceiver, const in float zBlocker) {
    return (zReceiver - zBlocker) / zBlocker;
}

float findBlocker(sampler2D shadowMap, const in vec2 uv, const in float zReceiver, PCSShadowConfig config) {
    // This uses similar triangles to compute what
    // area of the shadow map we should search
    float lightSizeUV = config.lightWorldSize / config.lightFrustumWidth;
    float searchRadius = lightSizeUV * (zReceiver - config.nearPlane) / zReceiver;
    float blockerDepthSum = 0.0;
    int numBlockers = 0;
    
    for(int i = 0; i < MAX_PCSS_SAMPLES; i ++ ) {
        if( i > config.sampleCount ) {
            break;
        }
        float shadowMapDepth = texture2D(shadowMap, uv + poissonDisk[i] * searchRadius).r;
        if (shadowMapDepth < zReceiver) {
            blockerDepthSum += shadowMapDepth;
            numBlockers ++ ;
        }
    }
    
    if (numBlockers == 0)return -1.0;
    
    return blockerDepthSum / float(numBlockers);
}

float pcfFilter(sampler2D shadowMap, vec2 uv, float zReceiver, float filterRadius, PCSShadowConfig config) {
    float sum = 0.0;
    float depth;
    int numSamples = config.sampleCount;
    for(int i = 0; i < MAX_PCSS_SAMPLES; i ++ ) {
        if( i > numSamples ) {
            break;
        }
        depth = texture2D(shadowMap, uv + poissonDisk[i] * filterRadius).r;
        if (zReceiver <= depth) sum += 1.0;
    }
    for(int i = 0; i < MAX_PCSS_SAMPLES; i ++ ) {
        if( i > numSamples ) {
            break;
        }
        depth = texture2D(shadowMap, uv + -poissonDisk[i].yx * filterRadius).r;
        if (zReceiver <= depth) sum += 1.0;
    }
    return sum / (2.0 * float(numSamples));
}

float PCSS(sampler2D shadowMap, vec3 coords, PCSShadowConfig config) {
    vec2 uv = coords.xy;
    float zReceiver = coords.z; // Assumed to be eye-space z in this code
    
    initPoissonSamples(uv, config);
    
    float avgBlockerDepth = findBlocker(shadowMap, uv, zReceiver, config);
    if (avgBlockerDepth == -1.0)return 1.0; 

    float penumbraRatio = penumbraSize(zReceiver, avgBlockerDepth);
    float lightSizeUV = config.lightWorldSize / config.lightFrustumWidth;
    float filterRadius = penumbraRatio * lightSizeUV * config.nearPlane / zReceiver;    

    return pcfFilter(shadowMap, uv, zReceiver, filterRadius, config);
}

float shadowLookupPCSS(sampler2D map, vec3 coords, float size, float compare, vec3 wpos, PCSShadowConfig config) {
    float shadow = 1.0;
    bool frustumTest = frustumTest(coords);
    if (frustumTest) {
        shadow = PCSS(map, coords, config);
    }
    return clamp(shadow, 0.0, 1.0);
}

float shadowCompare(sampler2D map, vec2 coords, float compare) {
    return step(compare, texture2D(map, coords).r);
}

float shadowLerp(sampler2D map, vec2 coords, float compare, float size) {
    const vec2 offset = vec2(0.0, 1.0);

    vec2 texelSize = vec2(1.0) / size;
    vec2 centroidUV = floor(coords * size + 0.5) / size;

    float lb = shadowCompare(map, centroidUV + texelSize * offset.xx, compare);
    float lt = shadowCompare(map, centroidUV + texelSize * offset.xy, compare);
    float rb = shadowCompare(map, centroidUV + texelSize * offset.yx, compare);
    float rt = shadowCompare(map, centroidUV + texelSize * offset.yy, compare);

    vec2 f = fract( coords * size + 0.5 );

    float a = mix( lb, lt, f.y );
    float b = mix( rb, rt, f.y );
    float c = mix( a, b, f.x );

    return c;
}

float srange(float oldValue, float oldMin, float oldMax, float newMin, float newMax) {
    float oldRange = oldMax - oldMin;
    float newRange = newMax - newMin;
    return (((oldValue - oldMin) * newRange) / oldRange) + newMin;
}

float shadowrandom(vec3 vin) {
    vec3 v = vin * 0.1;
    float t = v.z * 0.3;
    v.y *= 0.8;
    float noise = 0.0;
    float s = 0.5;
    noise += srange(sin(v.x * 0.9 / s + t * 10.0) + sin(v.x * 2.4 / s + t * 15.0) + sin(v.x * -3.5 / s + t * 4.0) + sin(v.x * -2.5 / s + t * 7.1), -1.0, 1.0, -0.3, 0.3);
    noise += srange(sin(v.y * -0.3 / s + t * 18.0) + sin(v.y * 1.6 / s + t * 18.0) + sin(v.y * 2.6 / s + t * 8.0) + sin(v.y * -2.6 / s + t * 4.5), -1.0, 1.0, -0.3, 0.3);
    return noise;
}

float shadowLookup(sampler2D map, vec3 coords, float size, float compare, vec3 wpos) {
    float shadow = 1.0;

    #if defined(SHADOW_MAPS)
    bool frustumTest = coords.x >= 0.0 && coords.x <= 1.0 && coords.y >= 0.0 && coords.y <= 1.0 && coords.z <= 1.0;
    if (frustumTest) {
        
        vec2 texelSize = vec2(1.0) / size;

        float dx0 = -texelSize.x;
        float dy0 = -texelSize.y;
        float dx1 = +texelSize.x;
        float dy1 = +texelSize.y;

        float rnoise = shadowrandom(wpos) * 0.00015;
        dx0 += rnoise;
        dy0 -= rnoise;
        dx1 += rnoise;
        dy1 -= rnoise;

        #if defined(SHADOWS_MED)
        shadow += shadowCompare(map, coords.xy + vec2(0.0, dy0), compare);
        //        shadow += shadowCompare(map, coords.xy + vec2(dx1, dy0), compare);
        shadow += shadowCompare(map, coords.xy + vec2(dx0, 0.0), compare);
        shadow += shadowCompare(map, coords.xy, compare);
        shadow += shadowCompare(map, coords.xy + vec2(dx1, 0.0), compare);
        //        shadow += shadowCompare(map, coords.xy + vec2(dx0, dy1), compare);
        shadow += shadowCompare(map, coords.xy + vec2(0.0, dy1), compare);
        shadow /= 5.0;

        #elif defined(SHADOWS_HIGH)
        shadow = shadowLerp(map, coords.xy + vec2(dx0, dy0), compare, size);
        shadow += shadowLerp(map, coords.xy + vec2(0.0, dy0), compare, size);
        shadow += shadowLerp(map, coords.xy + vec2(dx1, dy0), compare, size);
        shadow += shadowLerp(map, coords.xy + vec2(dx0, 0.0), compare, size);
        shadow += shadowLerp(map, coords.xy, compare, size);
        shadow += shadowLerp(map, coords.xy + vec2(dx1, 0.0), compare, size);
        shadow += shadowLerp(map, coords.xy + vec2(dx0, dy1), compare, size);
        shadow += shadowLerp(map, coords.xy + vec2(0.0, dy1), compare, size);
        shadow += shadowLerp(map, coords.xy + vec2(dx1, dy1), compare, size);
        shadow /= 9.0;

        #else
        shadow = shadowCompare(map, coords.xy, compare);
        #endif
    }

        #endif

    return clamp(shadow, 0.0, 1.0);
}

#test !!window.Metal
vec3 transformShadowLight(vec3 pos, vec3 vpos, mat4 mvMatrix, mat4 viewMatrix) {
    vec4 mvPos = mvMatrix * vec4(vpos, 1.0);
    vec4 worldPosition = viewMatrix * vec4(pos, 1.0);
    return normalize(worldPosition.xyz - mvPos.xyz);
}

float getShadow(vec3 pos, vec3 normal, float bias, Uniforms uniforms, GlobalUniforms globalUniforms, sampler2D shadowMap) {
    float shadow = 1.0;
    #if defined(SHADOW_MAPS)

    vec4 shadowMapCoords;
    vec3 coords;
    float lookup;

    for (int i = 0; i < SHADOW_COUNT; i++) {
        shadowMapCoords = uniforms.shadowMatrix[i] * vec4(pos, 1.0);
        coords = (shadowMapCoords.xyz / shadowMapCoords.w) * vec3(0.5) + vec3(0.5);
        lookup = shadowLookup(shadowMap, coords, uniforms.shadowSize[i], coords.z - bias, pos);
        lookup += mix(1.0 - step(0.002, dot(transformShadowLight(uniforms.shadowLightPos[i], pos, uniforms.modelViewMatrix, globalUniforms.viewMatrix), normal)), 0.0, step(999.0, normal.x));
        shadow *= clamp(lookup, 0.0, 1.0);
    }

    #endif
    return shadow;
}

float getShadow(vec3 pos, vec3 normal, Uniforms uniforms, GlobalUniforms globalUniforms, sampler2D shadowMap) {
    return getShadow(pos, normal, 0.0, uniforms, globalUniforms, shadowMap);
}

float getShadow(vec3 pos, float bias, Uniforms uniforms, GlobalUniforms globalUniforms, sampler2D shadowMap) {
    return getShadow(pos, vec3(99999.0), bias, uniforms, globalUniforms, shadowMap);
}

float getShadow(vec3 pos, Uniforms uniforms, GlobalUniforms globalUniforms, sampler2D shadowMap) {
    return getShadow(pos, vec3(99999.0), 0.0, uniforms, globalUniforms, shadowMap);
}

float getShadow(vec3 pos, vec3 normal) {
    return 1.0;
}

float getShadow(vec3 pos, float bias) {
    return 1.0;
}

float getShadow(vec3 pos) {
    return 1.0;
}

float getShadowPCSS(vec3 pos, vec3 normal, Uniforms uniforms, GlobalUniforms globalUniforms, sampler2D shadowMap, PCSShadowConfig config) {
    float shadow = 1.0;
    #if defined(SHADOW_MAPS)

    vec4 shadowMapCoords;
    vec3 coords;
    float lookup;

    for (int i = 0; i < SHADOW_COUNT; i++) {
        shadowMapCoords = uniforms.shadowMatrix[i] * vec4(pos, 1.0);
        coords = (shadowMapCoords.xyz / shadowMapCoords.w) * vec3(0.5) + vec3(0.5);
        lookup = shadowLookupPCSS(shadowMap, coords, uniforms.shadowSize[i], coords.z - bias, pos);
        lookup += mix(1.0 - step(0.002, dot(transformShadowLight(uniforms.shadowLightPos[i], pos, uniforms.modelViewMatrix, globalUniforms.viewMatrix), normal)), 0.0, step(999.0, normal.x));
        shadow *= clamp(lookup, 0.0, 1.0);
    }

    #endif
    return shadow;
}

float getShadowPCSS(vec3 pos, vec3 normal, Uniforms uniforms, GlobalUniforms globalUniforms, sampler2D shadowMap) {
    PCSShadowConfig config = defaultPCSSShadowConfig();
    return getShadowPCSS(pos, normal, bias, config);
}

#endtest

#test !window.Metal
vec3 transformShadowLight(vec3 pos, vec3 vpos) {
    vec4 mvPos = modelViewMatrix * vec4(vpos, 1.0);
    vec4 worldPosition = viewMatrix * vec4(pos, 1.0);
    return normalize(worldPosition.xyz - mvPos.xyz);
}

float getShadow(vec3 pos, vec3 normal, float bias) {

    float shadow = 1.0;
    #if defined(SHADOW_MAPS)

    vec4 shadowMapCoords;
    vec3 coords;
    float lookup;

    #pragma unroll_loop
    for (int i = 0; i < SHADOW_COUNT; i++) {
        shadowMapCoords = shadowMatrix[i] * vec4(pos, 1.0);
        coords = (shadowMapCoords.xyz / shadowMapCoords.w) * vec3(0.5) + vec3(0.5);
        lookup = shadowLookup(shadowMap[i], coords, shadowSize[i], coords.z - bias, pos);        
        lookup += mix(1.0 - step(0.002, dot(transformShadowLight(shadowLightPos[i], pos), normal)), 0.0, step(999.0, normal.x));
        shadow *= clamp(lookup, 0.0, 1.0);
    }
    #endif
    return shadow;
}

float getShadow(vec3 pos, vec3 normal) {
    return getShadow(pos, normal, 0.0);
}

float getShadow(vec3 pos, float bias) {
    return getShadow(pos, vec3(99999.0), bias);
}

float getShadow(vec3 pos) {
    return getShadow(pos, vec3(99999.0), 0.0);
}

float getShadowPCSS(vec3 pos, vec3 normal, float bias, PCSShadowConfig config) {    
    float shadow = 1.0;
    #if defined(SHADOW_MAPS)

    vec4 shadowMapCoords;
    vec3 coords;
    float lookup;

    #pragma unroll_loop
    for (int i = 0; i < SHADOW_COUNT; i++) {
        shadowMapCoords = shadowMatrix[i] * vec4(pos, 1.0);
        coords = (shadowMapCoords.xyz / shadowMapCoords.w) * vec3(0.5) + vec3(0.5);
        lookup = shadowLookupPCSS(shadowMap[i], coords, shadowSize[i], coords.z - bias, pos, config);
        lookup += mix(1.0 - step(0.002, dot(transformShadowLight(shadowLightPos[i], pos), normal)), 0.0, step(999.0, normal.x));
        shadow *= clamp(lookup, 0.0, 1.0);
    }
    #endif
    
    return shadow;
}

float getShadowPCSS(vec3 pos, vec3 normal, float bias) {
    PCSShadowConfig config = defaultPCSSShadowConfig();
    return getShadowPCSS(pos, normal, bias, config);
}
#endtest{@}fresnel.glsl{@}float getFresnel(vec3 normal, vec3 viewDir, float power) {
    float d = dot(normalize(normal), normalize(viewDir));
    return 1.0 - pow(abs(d), power);
}

float getFresnel(float inIOR, float outIOR, vec3 normal, vec3 viewDir) {
    float ro = (inIOR - outIOR) / (inIOR + outIOR);
    float d = dot(normalize(normal), normalize(viewDir));
    return ro + (1. - ro) * pow((1. - d), 5.);
}


//viewDir = -vec3(modelViewMatrix * vec4(position, 1.0));{@}FXAA.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMask;

#!VARYINGS
varying vec2 v_rgbNW;
varying vec2 v_rgbNE;
varying vec2 v_rgbSW;
varying vec2 v_rgbSE;
varying vec2 v_rgbM;

#!SHADER: FXAA.vs

varying vec2 vUv;

void main() {
    vUv = uv;

    vec2 fragCoord = uv * resolution;
    vec2 inverseVP = 1.0 / resolution.xy;
    v_rgbNW = (fragCoord + vec2(-1.0, -1.0)) * inverseVP;
    v_rgbNE = (fragCoord + vec2(1.0, -1.0)) * inverseVP;
    v_rgbSW = (fragCoord + vec2(-1.0, 1.0)) * inverseVP;
    v_rgbSE = (fragCoord + vec2(1.0, 1.0)) * inverseVP;
    v_rgbM = vec2(fragCoord * inverseVP);

    gl_Position = vec4(position, 1.0);
}

#!SHADER: FXAA.fs

#require(conditionals.glsl)

#ifndef FXAA_REDUCE_MIN
    #define FXAA_REDUCE_MIN   (1.0/ 128.0)
#endif
#ifndef FXAA_REDUCE_MUL
    #define FXAA_REDUCE_MUL   (1.0 / 8.0)
#endif
#ifndef FXAA_SPAN_MAX
    #define FXAA_SPAN_MAX     8.0
#endif

vec4 fxaa(sampler2D tex, vec2 fragCoord, vec2 resolution,
            vec2 v_rgbNW, vec2 v_rgbNE,
            vec2 v_rgbSW, vec2 v_rgbSE,
            vec2 v_rgbM) {
    vec4 color;
    mediump vec2 inverseVP = vec2(1.0 / resolution.x, 1.0 / resolution.y);
    vec3 rgbNW = texture2D(tex, v_rgbNW).xyz;
    vec3 rgbNE = texture2D(tex, v_rgbNE).xyz;
    vec3 rgbSW = texture2D(tex, v_rgbSW).xyz;
    vec3 rgbSE = texture2D(tex, v_rgbSE).xyz;
    vec4 texColor = texture2D(tex, v_rgbM);
    vec3 rgbM  = texColor.xyz;
    vec3 luma = vec3(0.299, 0.587, 0.114);
    float lumaNW = dot(rgbNW, luma);
    float lumaNE = dot(rgbNE, luma);
    float lumaSW = dot(rgbSW, luma);
    float lumaSE = dot(rgbSE, luma);
    float lumaM  = dot(rgbM,  luma);
    float lumaMin = min(lumaM, min(min(lumaNW, lumaNE), min(lumaSW, lumaSE)));
    float lumaMax = max(lumaM, max(max(lumaNW, lumaNE), max(lumaSW, lumaSE)));

    mediump vec2 dir;
    dir.x = -((lumaNW + lumaNE) - (lumaSW + lumaSE));
    dir.y =  ((lumaNW + lumaSW) - (lumaNE + lumaSE));

    float dirReduce = max((lumaNW + lumaNE + lumaSW + lumaSE) *
                          (0.25 * FXAA_REDUCE_MUL), FXAA_REDUCE_MIN);

    float rcpDirMin = 1.0 / (min(abs(dir.x), abs(dir.y)) + dirReduce);
    dir = min(vec2(FXAA_SPAN_MAX, FXAA_SPAN_MAX),
              max(vec2(-FXAA_SPAN_MAX, -FXAA_SPAN_MAX),
              dir * rcpDirMin)) * inverseVP;

    vec3 rgbA = 0.5 * (
        texture2D(tex, fragCoord * inverseVP + dir * (1.0 / 3.0 - 0.5)).xyz +
        texture2D(tex, fragCoord * inverseVP + dir * (2.0 / 3.0 - 0.5)).xyz);
    vec3 rgbB = rgbA * 0.5 + 0.25 * (
        texture2D(tex, fragCoord * inverseVP + dir * -0.5).xyz +
        texture2D(tex, fragCoord * inverseVP + dir * 0.5).xyz);

    float lumaB = dot(rgbB, luma);

    color = vec4(rgbB, texColor.a);
    color = mix(color, vec4(rgbA, texColor.a), when_lt(lumaB, lumaMin));
    color = mix(color, vec4(rgbA, texColor.a), when_gt(lumaB, lumaMax));

    return color;
}

void main() {
    vec2 fragCoord = vUv * resolution;
    float mask = texture2D(tMask, vUv).r;
    if (mask < 0.5) {
        gl_FragColor = fxaa(tDiffuse, fragCoord, resolution, v_rgbNW, v_rgbNE, v_rgbSW, v_rgbSE, v_rgbM);
    } else {
        gl_FragColor = texture2D(tDiffuse, vUv);
    }
    gl_FragColor.a = 1.0;
}
{@}gaussianblur.fs{@}vec4 blur13(sampler2D image, vec2 uv, vec2 resolution, vec2 direction) {
  vec4 color = vec4(0.0);
  vec2 off1 = vec2(1.411764705882353) * direction;
  vec2 off2 = vec2(3.2941176470588234) * direction;
  vec2 off3 = vec2(5.176470588235294) * direction;
  color += texture2D(image, uv) * 0.1964825501511404;
  color += texture2D(image, uv + (off1 / resolution)) * 0.2969069646728344;
  color += texture2D(image, uv - (off1 / resolution)) * 0.2969069646728344;
  color += texture2D(image, uv + (off2 / resolution)) * 0.09447039785044732;
  color += texture2D(image, uv - (off2 / resolution)) * 0.09447039785044732;
  color += texture2D(image, uv + (off3 / resolution)) * 0.010381362401148057;
  color += texture2D(image, uv - (off3 / resolution)) * 0.010381362401148057;
  return color;
}

vec4 blur5(sampler2D image, vec2 uv, vec2 resolution, vec2 direction) {
  vec4 color = vec4(0.0);
  vec2 off1 = vec2(1.3333333333333333) * direction;
  color += texture2D(image, uv) * 0.29411764705882354;
  color += texture2D(image, uv + (off1 / resolution)) * 0.35294117647058826;
  color += texture2D(image, uv - (off1 / resolution)) * 0.35294117647058826;
  return color;
}

vec4 blur9(sampler2D image, vec2 uv, vec2 resolution, vec2 direction) {
  vec4 color = vec4(0.0);
  vec2 off1 = vec2(1.3846153846) * direction;
  vec2 off2 = vec2(3.2307692308) * direction;
  color += texture2D(image, uv) * 0.2270270270;
  color += texture2D(image, uv + (off1 / resolution)) * 0.3162162162;
  color += texture2D(image, uv - (off1 / resolution)) * 0.3162162162;
  color += texture2D(image, uv + (off2 / resolution)) * 0.0702702703;
  color += texture2D(image, uv - (off2 / resolution)) * 0.0702702703;
  return color;
}

vec4 gaussianblur(sampler2D image, vec2 uv, float steps, vec2 resolution, vec2 direction) {

  vec4 blend = vec4(0.);
  float sum = 1.;
  float m = 1.;
  float n = steps;

  for (float i = 0.; i < 100.; i += 1.) {
      if(i >= 2. * steps) break;
      float k = i;
      float j = i - 0.5 * steps;
      blend += m * texture2D(image, uv + j * direction / resolution);
      m *= (n - k) / (k + 1.);
      sum += m;
  }

  return blend / sum;

}{@}glscreenprojection.glsl{@}vec2 frag_coord(vec4 glPos) {
    return ((glPos.xyz / glPos.w) * 0.5 + 0.5).xy;
}

vec2 getProjection(vec3 pos, mat4 projMatrix) {
    vec4 mvpPos = projMatrix * vec4(pos, 1.0);
    return frag_coord(mvpPos);
}

void applyNormal(inout vec3 pos, mat4 projNormalMatrix) {
    vec3 transformed = vec3(projNormalMatrix * vec4(pos, 0.0));
    pos = transformed;
}{@}DefaultText.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform vec3 uColor;
uniform float uAlpha;
uniform vec2 uMouse;

#!VARYINGS

varying vec2 vUv;
varying vec3 vWorldPos;

#!SHADER: DefaultText.vs

void main() {
    vUv = uv;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
    vWorldPos = vec3(modelMatrix * vec4(position, 1.0));
}

#!SHADER: DefaultText.fs

#require(msdf.glsl)

void main() {
    float transition = smoothstep(0.3, 0.8, uAlpha);
    float gridV = mix(50.0, 500.0, transition);
    vec2 gridSize = vec2(gridV*3.0, floor(gridV/(resolution.x/resolution.y)));
    vec2 uv = floor(vUv * gridSize) / gridSize;
    uv += (1.0-transition) * (1.0/gridV) * vec2(0.2, 0.5);
    uv = mix(uv, vUv,transition);

    float alpha = msdf(tMap, uv);
    alpha *= uAlpha;

    vec3 color = uColor;
    color = mix(color, vec3(0.5, 0.5, 1.0), 0.1 + sin(time - vWorldPos.x * 0.01 + vWorldPos.y * 0.005 + alpha * 10.0) * 0.1);

    alpha *= 0.9 + sin(time*40.0) * 0.1 * smoothstep(0.2, 0.15, abs(uAlpha-0.5));

    gl_FragColor = vec4(color, alpha);

}
{@}msdf.glsl{@}float msdf(vec3 tex, vec2 uv) {
    // TODO: fallback for fwidth for webgl1 (need to enable ext)
    float signedDist = max(min(tex.r, tex.g), min(max(tex.r, tex.g), tex.b)) - 0.5;
    float d = fwidth(signedDist);
    float alpha = smoothstep(-d, d, signedDist);
    if (alpha < 0.01) discard;
    return alpha;
}

float msdf(sampler2D tMap, vec2 uv) {
    vec3 tex = texture2D(tMap, uv).rgb;
    return msdf( tex, uv );
}

float strokemsdf(sampler2D tMap, vec2 uv, float stroke, float padding) {
    vec3 tex = texture2D(tMap, uv).rgb;
    float signedDist = max(min(tex.r, tex.g), min(max(tex.r, tex.g), tex.b)) - 0.5;
    float t = stroke;
    float alpha = smoothstep(-t, -t + padding, signedDist) * smoothstep(t, t - padding, signedDist);
    return alpha;
}{@}GLUIBatch.glsl{@}#!ATTRIBUTES
attribute vec3 offset;
attribute vec2 scale;
attribute float rotation;
//attributes

#!UNIFORMS
uniform sampler2D tMap;
uniform vec3 uColor;
uniform float uAlpha;

#!VARYINGS
varying vec2 vUv;
//varyings

#!SHADER: Vertex

mat4 rotationMatrix(vec3 axis, float angle) {
    axis = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    float oc = 1.0 - c;

    return mat4(oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,  0.0,
    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,  0.0,
    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c,           0.0,
    0.0,                                0.0,                                0.0,                                1.0);
}

void main() {
    vUv = uv;
    //vdefines

    vec3 pos = vec3(rotationMatrix(vec3(0.0, 0.0, 1.0), rotation) * vec4(position, 1.0));
    pos.xy *= scale;
    pos.xyz += offset;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment
void main() {
    gl_FragColor = vec4(1.0);
}{@}GLUIBatchText.glsl{@}#!ATTRIBUTES
attribute vec3 offset;
attribute vec2 scale;
attribute float rotation;
//attributes

#!UNIFORMS
uniform sampler2D tMap;
uniform vec3 uColor;
uniform float uAlpha;

#!VARYINGS
varying vec2 vUv;
//varyings

#!SHADER: Vertex

mat4 lrotationMatrix(vec3 axis, float angle) {
    axis = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    float oc = 1.0 - c;

    return mat4(oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,  0.0,
    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,  0.0,
    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c,           0.0,
    0.0,                                0.0,                                0.0,                                1.0);
}

void main() {
    vUv = uv;
    //vdefines

    vec3 pos = vec3(lrotationMatrix(vec3(0.0, 0.0, 1.0), rotation) * vec4(position, 1.0));

    //custommain

    pos.xy *= scale;
    pos += offset;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment

#require(msdf.glsl)

void main() {
    float alpha = msdf(tMap, vUv);

    gl_FragColor.rgb = v_uColor;
    gl_FragColor.a = alpha * v_uAlpha;
}
{@}GLUIColor.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform vec3 uColor;
uniform float uAlpha;

#!VARYINGS
varying vec2 vUv;

#!SHADER: GLUIColor.vs
void main() {
    vUv = uv;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: GLUIColor.fs
void main() {
    vec2 uv = vUv;
    vec3 uvColor = vec3(uv, 1.0);
    gl_FragColor = vec4(mix(uColor, uvColor, 0.0), uAlpha);
}{@}GLUIObject.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform float uAlpha;

#!VARYINGS
varying vec2 vUv;
varying vec3 vWorldPos;

#!SHADER: GLUIObject.vs
void main() {
    vUv = uv;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
    vWorldPos = vec3(modelMatrix * vec4(position, 1.0));
}

#!SHADER: GLUIObject.fs

#require(transformUV.glsl)

void main() {
    // float transition = smoothstep(0.0, 0.8, uAlpha);
    // float gridV = mix(20.0, 100.0, transition);
    // vec2 gridSize = vec2(gridV, floor(gridV/(resolution.x/resolution.y)));
    // vec2 uv = floor(vUv * gridSize) / gridSize;
    // uv += (1.0-transition) * (1.0/gridV) * 0.4;
    // uv = mix(uv, vUv,transition);

    vec4 color = texture2D(tMap, vUv);
    color.a *= 0.8 + sin(time * 2.0 + vUv.y * 2.0 - vWorldPos.x * 0.02) * 0.2;
    color.a *= uAlpha;
    gl_FragColor = color;
}{@}gluimask.fs{@}uniform vec4 uMaskValues;

#require(range.glsl)

vec2 getMaskUV() {
    vec2 ores = gl_FragCoord.xy / resolution;
    vec2 uv;
    uv.x = range(ores.x, uMaskValues.x, uMaskValues.z, 0.0, 1.0);
    uv.y = 1.0 - range(1.0 - ores.y, uMaskValues.y, uMaskValues.w, 0.0, 1.0);
    return uv;
}{@}LightVolume.glsl{@}#!ATTRIBUTES
attribute vec3 offset;
attribute vec4 attribs;

#!UNIFORMS
uniform sampler2D tMap;
uniform sampler2D tMask;

uniform float uScale;
uniform float uSeparation;
uniform float uAlpha;
uniform float uMaskScale;
uniform float uRotateSpeed;
uniform float uRotateTexture;
uniform float uNoiseScale;
uniform float uNoiseSpeed;
uniform float uNoiseRange;
uniform float uOffset;
uniform float uScrollX;
uniform float uScrollY;
uniform float uHueShift;
uniform vec3 uColor;

#!VARYINGS
varying vec2 vUv;
varying vec3 vPos;
varying vec4 vAttribs;
varying float vOffset;

#!SHADER: LightVolume.vs

#require(instance.vs)
#require(rotation.glsl)

void main() {
    vec3 pos = transformPosition(position, offset * uSeparation, uScale);
    pos = vec3(vec4(pos, 1.0) * rotationMatrix(vec3(0.0, 0.0, 1.0), radians(360.0 * 0.1 * offset.z * uOffset)));

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);

    vUv = uv;
    vPos = pos;
    vAttribs = attribs;
    vOffset = offset.z * 10.0;
}

#!SHADER: LightVolume.fs

#require(rgb2hsv.fs)
#require(range.glsl)
#require(transformUV.glsl)
#require(simplenoise.glsl)

void main() {
    vec3 color = rgb2hsv(uColor);
    color += vOffset * uHueShift * 0.01;
    color = hsv2rgb(color);

    vec2 auv = vUv;
    if (uRotateTexture > 0.0) {
        auv = rotateUV(vUv, time * uRotateTexture * 0.1);
    }

    float alpha = texture2D(tMap, auv).r;

    vec2 uv = scaleUV(vUv, vec2(uMaskScale));

    if (uNoiseSpeed > 0.0) {
        float noise = cnoise(vPos * uNoiseScale + (time * uNoiseSpeed));
        uv += noise * uNoiseRange * 0.1;
        uv = scaleUV(uv, vec2(range(noise, -1.0, 0.0, 0.96, 1.02)));
        uv.x += sin(time * 0.04) * 0.3;
    }

    if (uRotateSpeed > 0.0) {
        uv = rotateUV(uv, uRotateSpeed * time * range(vAttribs.x, 0.0, 1.0, 0.5, 1.5));
        uv.x += time * uScrollX * 0.1 * range(vAttribs.y, 0.0, 1.0, 0.5, 1.5);
        uv.y += time * uScrollY * 0.1 * range(vAttribs.z, 0.0, 1.0, 0.5, 1.5);
    }

    float mask = texture2D(tMask, uv).r;
    alpha *= mask;

    #drawbuffer Color gl_FragColor = vec4(color, alpha * uAlpha);
    #drawbuffer VolumetricLight gl_FragColor = vec4(color, alpha * uAlpha);
}
{@}luma.fs{@}float luma(vec3 color) {
  return dot(color, vec3(0.299, 0.587, 0.114));
}

float luma(vec4 color) {
  return dot(color.rgb, vec3(0.299, 0.587, 0.114));
}{@}matcap.vs{@}vec2 reflectMatcap(vec3 position, mat4 modelMatrix, vec3 normal) {
    vec3 worldNormal = mat3(modelMatrix[0].xyz, modelMatrix[1].xyz, modelMatrix[2].xyz) * normal;
    vec3 worldPos = (modelMatrix * vec4(position, 1.0)).xyz;
    vec3 viewDir = normalize(cameraPosition - worldPos);
    vec3 x = normalize(vec3(viewDir.z, 0.0, - viewDir.x));
    vec3 y = cross(viewDir, x);
    vec2 uv = vec2(dot(x, worldNormal), dot(y, worldNormal)) * 0.495 + 0.5; // 0.495 to remove artifacts caused by undersized matcap disks
    return uv;
}

vec2 reflectMatcap(vec3 worldPos, vec3 worldNormal) {
    vec3 viewDir = normalize(cameraPosition - worldPos);
    vec3 x = normalize(vec3(viewDir.z, 0.0, - viewDir.x));
    vec3 y = cross(viewDir, x);
    vec2 uv = vec2(dot(x, worldNormal), dot(y, worldNormal)) * 0.495 + 0.5; // 0.495 to remove artifacts caused by undersized matcap disks
    return uv;
}
{@}BasicMirror.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMirrorReflection;
uniform mat4 uMirrorMatrix;

#!VARYINGS
varying vec4 vMirrorCoord;

#!SHADER: BasicMirror.vs
void main() {
    vec4 worldPos = modelMatrix * vec4(position, 1.0);
    vMirrorCoord = uMirrorMatrix * worldPos;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: BasicMirror.fs
void main() {
    gl_FragColor.rgb = vec3(texture2D(tMirrorReflection, vMirrorCoord.xy / vMirrorCoord.w));
    gl_FragColor.a = 1.0;
}{@}normalmap.glsl{@}vec3 unpackNormal( vec3 eye_pos, vec3 surf_norm, sampler2D normal_map, float intensity, float scale, vec2 uv ) {
    vec3 q0 = dFdx( eye_pos.xyz );
    vec3 q1 = dFdy( eye_pos.xyz );
    vec2 st0 = dFdx( uv.st );
    vec2 st1 = dFdy( uv.st );

    vec3 N = normalize(surf_norm);

    vec3 q1perp = cross( q1, N );
    vec3 q0perp = cross( N, q0 );

    vec3 T = q1perp * st0.x + q0perp * st1.x;
    vec3 B = q1perp * st0.y + q0perp * st1.y;

    float det = max( dot( T, T ), dot( B, B ) );
    float scalefactor = ( det == 0.0 ) ? 0.0 : inversesqrt( det );

    vec3 mapN = texture2D( normal_map, uv * scale ).xyz * 2.0 - 1.0;
    mapN.xy *= intensity;
    
    return normalize( T * ( mapN.x * scalefactor ) + B * ( mapN.y * scalefactor ) + N * mapN.z );
}

//mvPosition.xyz, normalMatrix * normal, normalMap, intensity, scale, uv{@}PBR.glsl{@}#!ATTRIBUTES

#!UNIFORMS

#!VARYINGS

#!SHADER: Vertex

#require(pbr.vs)

void main() {
    vec3 pos = position;
    setupPBR(pos);

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment

#require(pbr.fs)

void main() {
    gl_FragColor = getPBR();
}
{@}pbr.fs{@}uniform sampler2D tBaseColor;
uniform sampler2D tMRO;
uniform sampler2D tNormal;
uniform sampler2D tLUT;

uniform sampler2D tEnvDiffuse;
uniform sampler2D tEnvSpecular;
uniform vec2 uEnvOffset;

uniform sampler2D tLightmap;
uniform float uUseLightmap;
uniform float uLightmapIntensity;
uniform float uUseLinearOutput;

uniform vec3 uTint;
uniform vec2 uTiling;
uniform vec2 uOffset;
uniform vec4 uMRON;
uniform vec3 uEnv;

uniform float uHDR;

varying vec2 vUv;
varying vec2 vUv2;
varying vec3 vV;
varying vec3 vWorldNormal;

vec3 unpackNormalPBR( vec3 eye_pos, vec3 surf_norm, sampler2D normal_map, float intensity, float scale, vec2 uv ) {
    vec3 q0 = dFdx( eye_pos.xyz );
    vec3 q1 = dFdy( eye_pos.xyz );
    vec2 st0 = dFdx( uv.st );
    vec2 st1 = dFdy( uv.st );

    vec3 N = normalize(surf_norm);

    vec3 q1perp = cross( q1, N );
    vec3 q0perp = cross( N, q0 );

    vec3 T = q1perp * st0.x + q0perp * st1.x;
    vec3 B = q1perp * st0.y + q0perp * st1.y;

    float det = max( dot( T, T ), dot( B, B ) );
    float scalefactor = ( det == 0.0 ) ? 0.0 : inversesqrt( det );

    vec3 mapN = texture2D( normal_map, uv * scale ).xyz * 2.0 - 1.0;
    mapN.xy *= intensity;

    return normalize( T * ( mapN.x * scalefactor ) + B * ( mapN.y * scalefactor ) + N * mapN.z );
}

const vec2 INV_ATAN = vec2(0.1591, 0.3183);
const float LN2 = 0.6931472;
const float ENV_LODS = 7.0;
const float PI = 3.14159;

struct PBRConfig {
    float reflection;
    float clearcoat;
    vec3 color;
    vec3 lightColor;
    vec3 envReflection;
    bool overrideMRO;
    vec3 mro;
};

vec3 fresnelSphericalGaussianRoughness(float cosTheta, vec3 F0, float roughness) {
    return F0 + (max(vec3(1.0 - roughness), F0) - F0) * pow(2.0, (-5.55473 * cosTheta - 6.98316) * cosTheta);
}

vec2 sampleSphericalMap(vec3 v) {
    vec3 normalizedV = normalize(v);
    vec2 uv = vec2(0.5 + atan(normalizedV.z, normalizedV.x) / (2.0 * PI), 0.5 + asin(normalizedV.y) / PI);
    return uv;
}

vec4 SRGBtoLinear(vec4 srgb) {
    vec3 linOut = pow(srgb.xyz, vec3(2.2));
    return vec4(linOut, srgb.w);
}

vec3 linearToSRGB(vec3 color) {
    return pow(color, vec3(0.4545454545454545));
}

vec4 linearToSRGB(vec4 color) {
    return vec4(pow(color.rgb, vec3(0.4545454545454545)), 1.0);
}

vec4 RGBMToLinear(vec4 value) {
    float maxRange = 6.0;
    return vec4(value.xyz * value.w * maxRange, 1.0);
}

vec4 autoToLinear(vec4 texel, float uHDR) {
    vec4 color = RGBMToLinear(texel);
    if (uHDR < 0.001) { color = SRGBtoLinear(texel); }
    return color;
}

vec3 uncharted2Tonemap(vec3 x) {
    float A = 0.15;
    float B = 0.50;
    float C = 0.10;
    float D = 0.20;
    float E = 0.02;
    float F = 0.30;
    return ((x * (A * x + C * B) + D * E) / (x * (A * x + B) + D * F)) - E / F;
}

vec3 uncharted2(vec3 color) {
    const float W = 11.2;
    float exposureBias = 2.0;
    vec3 curr = uncharted2Tonemap(exposureBias * color);
    vec3 whiteScale = 1.0 / uncharted2Tonemap(vec3(W));
    return curr * whiteScale;
}

vec4 getIBLContribution(float NdV, vec4 baseColor, vec4 MRO, vec3 R, vec3 V, vec3 N, sampler2D tLUT, sampler2D tEnvDiffuse, sampler2D tEnvSpecular, PBRConfig config) {
    float metallic = clamp(MRO.x + uMRON.x - 1.0, 0.0, 1.0);
    float roughness = clamp(MRO.y + uMRON.y - 1.0, 0.0, 1.0);
    float ao = mix(1.0, MRO.z, uMRON.z);

    if (config.overrideMRO) {
        metallic = config.mro.x;
        roughness = config.mro.y;
        ao *= config.mro.z;
    }

    vec2 lutUV = vec2(NdV, roughness);
    vec2 diffuseUV = sampleSphericalMap(N);

    vec3 brdf = SRGBtoLinear(texture2D(tLUT, lutUV)).rgb;
    vec3 diffuse = autoToLinear( texture2D(tEnvDiffuse, diffuseUV + uEnvOffset ), uHDR).rgb;

    vec3 lightmap = vec3(1.0);

    if (uUseLightmap > 0.0) {
        lightmap = texture2D(tLightmap, vUv2).rgb;
        lightmap.rgb = pow(lightmap.rgb, vec3(2.2)) * uLightmapIntensity;
        diffuse.rgb *= lightmap.rgb;
    }

    diffuse *= baseColor.rgb;

    float level = floor(roughness * ENV_LODS);
    vec2 specUV = sampleSphericalMap(R);

    specUV.y /= 2.0;
    specUV /= pow(2.0, level);
    specUV.y += 1.0 - exp(-LN2 * level);

    vec3 specular = autoToLinear(texture2D(tEnvSpecular, specUV + uEnvOffset), uHDR).rgb;

    // fake stronger specular highlight
    specular += pow(specular, vec3(2.2)) * uEnv.y;

    if (uUseLightmap > 0.0) {
        specular *= lightmap;
    }

    vec3 F0 = vec3(0.04);
    F0 = mix(F0, baseColor.rgb, metallic);

    vec3 F = fresnelSphericalGaussianRoughness(NdV, F0, roughness);

    vec3 diffuseContrib = 1.0 - F;
    specular = specular.rgb * (F * brdf.x + brdf.y);

    diffuseContrib *= 1.0 - metallic;

    float alpha = baseColor.a;

    return vec4((diffuseContrib * diffuse + specular + (config.envReflection*0.01)) * ao * uEnv.x, alpha);
}

vec3 getNormal() {
    vec3 N = vWorldNormal;
    vec3 V = normalize(vV);
    return unpackNormalPBR(V, N, tNormal, uMRON.w, 1.0, vUv).xyz;
}

vec4 getPBR(vec3 baseColor, PBRConfig config) {
    vec3 N = vWorldNormal;
    vec3 V = normalize(vV);
    vec3 worldNormal = getNormal();
    vec3 R = reflect(V, worldNormal);
    float NdV = abs(dot(worldNormal, V));
    vec4 baseColor4 = SRGBtoLinear(vec4(baseColor, 1.0));

    vec4 MRO = texture2D(tMRO, vUv);
    vec4 color = getIBLContribution(NdV, baseColor4, MRO, R, V, worldNormal, tLUT, tEnvDiffuse, tEnvSpecular, config);

    if (uUseLinearOutput < 0.5) {
        color.rgb = uncharted2(color.rgb);
        color = linearToSRGB(color);
    }

    return color;
}

vec4 getPBR(vec3 baseColor) {
    PBRConfig config;
    return getPBR(baseColor, config);
}

vec4 getPBR() {
    vec4 baseColor = texture2D(tBaseColor, vUv);
    vec4 color = getPBR(baseColor.rgb * uTint);
    color.a *= baseColor.a;
    return color;
}
{@}pbr.vs{@}attribute vec2 uv2;

uniform sampler2D tBaseColor;
uniform vec2 uTiling;
uniform vec2 uOffset;

varying vec2 vUv;
varying vec2 vUv2;
varying vec3 vNormal;
varying vec3 vWorldNormal;
varying vec3 vV;

void setupPBR(vec3 p0) { //inlinemain
    vUv = uv * uTiling + uOffset;
    vUv2 = uv2;
    vec4 worldPos = modelMatrix * vec4(p0, 1.0);
    vV = worldPos.xyz - cameraPosition;
    vNormal = normalMatrix * normal;
    vWorldNormal = mat3(modelMatrix[0].xyz, modelMatrix[1].xyz, modelMatrix[2].xyz) * normal;
}

void setupPBR(vec3 p0, vec3 n) {
    vUv = uv * uTiling + uOffset;
    vUv2 = uv2;
    vec4 worldPos = modelMatrix * vec4(p0, 1.0);
    vV = worldPos.xyz - cameraPosition;
    vNormal = normalMatrix * n;
    vWorldNormal = mat3(modelMatrix[0].xyz, modelMatrix[1].xyz, modelMatrix[2].xyz) * n;
}
{@}radialblur.fs{@}vec3 radialBlur( sampler2D map, vec2 uv, float size, vec2 resolution, float quality ) {
    vec3 color = vec3(0.);

    const float pi2 = 3.141596 * 2.0;
    const float direction = 8.0;

    vec2 radius = size / resolution;
    float test = 1.0;

    for ( float d = 0.0; d < pi2 ; d += pi2 / direction ) {
        vec2 t = radius * vec2( cos(d), sin(d));
        for ( float i = 1.0; i <= 100.0; i += 1.0 ) {
            if (i >= quality) break;
            color += texture2D( map, uv + t * i / quality ).rgb ;
        }
    }

    return color / ( quality * direction);
}

vec3 radialBlur( sampler2D map, vec2 uv, float size, float quality ) {
    vec3 color = vec3(0.);

    const float pi2 = 3.141596 * 2.0;
    const float direction = 8.0;

    vec2 radius = size / vec2(1024.0);
    float test = 1.0;
    float samples = 0.0;

    for ( float d = 0.0; d < pi2 ; d += pi2 / direction ) {
        vec2 t = radius * vec2( cos(d), sin(d));
        for ( float i = 1.0; i <= 100.0; i += 1.0 ) {
            if (i >= quality) break;
            color += texture2D( map, uv + t * i / quality ).rgb ;
            samples += 1.0;
        }
    }

    return color / samples;
}
{@}range.glsl{@}

float range(float oldValue, float oldMin, float oldMax, float newMin, float newMax) {
    vec3 sub = vec3(oldValue, newMax, oldMax) - vec3(oldMin, newMin, oldMin);
    return sub.x * sub.y / sub.z + newMin;
}

vec2 range(vec2 oldValue, vec2 oldMin, vec2 oldMax, vec2 newMin, vec2 newMax) {
    vec2 oldRange = oldMax - oldMin;
    vec2 newRange = newMax - newMin;
    vec2 val = oldValue - oldMin;
    return val * newRange / oldRange + newMin;
}

vec3 range(vec3 oldValue, vec3 oldMin, vec3 oldMax, vec3 newMin, vec3 newMax) {
    vec3 oldRange = oldMax - oldMin;
    vec3 newRange = newMax - newMin;
    vec3 val = oldValue - oldMin;
    return val * newRange / oldRange + newMin;
}

float crange(float oldValue, float oldMin, float oldMax, float newMin, float newMax) {
    return clamp(range(oldValue, oldMin, oldMax, newMin, newMax), min(newMin, newMax), max(newMin, newMax));
}

vec2 crange(vec2 oldValue, vec2 oldMin, vec2 oldMax, vec2 newMin, vec2 newMax) {
    return clamp(range(oldValue, oldMin, oldMax, newMin, newMax), min(newMin, newMax), max(newMin, newMax));
}

vec3 crange(vec3 oldValue, vec3 oldMin, vec3 oldMax, vec3 newMin, vec3 newMax) {
    return clamp(range(oldValue, oldMin, oldMax, newMin, newMax), min(newMin, newMax), max(newMin, newMax));
}

float rangeTransition(float t, float x, float padding) {
    float transition = crange(t, 0.0, 1.0, -padding, 1.0 + padding);
    return crange(x, transition - padding, transition + padding, 1.0, 0.0);
}
{@}refl.fs{@}vec3 reflection(vec3 worldPosition, vec3 normal) {
    vec3 cameraToVertex = normalize(worldPosition - cameraPosition);
    
    return reflect(cameraToVertex, normal);
}

vec3 refraction(vec3 worldPosition, vec3 normal, float rRatio) {
    vec3 cameraToVertex = normalize(worldPosition - cameraPosition);
    
    return refract(cameraToVertex, normal, rRatio);
}

vec4 envColor(samplerCube map, vec3 vec) {
    float flipNormal = 1.0;
    return textureCube(map, flipNormal * vec3(-1.0 * vec.x, vec.yz));
}

vec4 envColorEqui(sampler2D map, vec3 direction) {
    vec2 uv;
    uv.y = asin( clamp( direction.y, - 1.0, 1.0 ) ) * 0.31830988618 + 0.5;
    uv.x = atan( direction.z, direction.x ) * 0.15915494 + 0.5;
    return texture2D(map, uv);
}

vec4 envColorEquiRGB(sampler2D map, vec3 direction, float angle, float amount) {
    vec2 uv;
    uv.y = asin( clamp( direction.y, - 1.0, 1.0 ) ) * 0.31830988618 + 0.5;
    uv.x = atan( direction.z, direction.x ) * 0.15915494 + 0.5;

    vec2 offset = vec2(cos(angle), sin(angle)) * amount * 0.01;
    vec4 r = texture2D(map, uv + offset);
    vec4 g = texture2D(map, uv);
    vec4 b = texture2D(map, uv - offset);
    return vec4(r.r, g.g, b.b, g.a);
}{@}refl.vs{@}vec3 inverseTransformDirection(in vec3 normal, in mat4 matrix) {
    return normalize((matrix * vec4(normal, 0.0) * matrix).xyz);
}

vec3 transformDirection( in vec3 dir, in mat4 matrix ) {
    return normalize( ( matrix * vec4( dir, 0.0 ) ).xyz );
}

vec3 reflection(vec4 worldPosition) {
    vec3 transformedNormal = normalMatrix * normal;
    vec3 cameraToVertex = normalize(worldPosition.xyz - cameraPosition);
    vec3 worldNormal = inverseTransformDirection(transformedNormal, viewMatrix);
    
    return reflect(cameraToVertex, worldNormal);
}

vec3 refraction(vec4 worldPosition, float refractionRatio) {
    vec3 transformedNormal = normalMatrix * normal;
    vec3 cameraToVertex = normalize(worldPosition.xyz - cameraPosition);
    vec3 worldNormal = inverseTransformDirection(transformedNormal, viewMatrix);
    
    return refract(cameraToVertex, worldNormal, refractionRatio);
}{@}rgb2hsv.fs{@}vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
    
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}{@}rgbshift.fs{@}vec4 getRGB(sampler2D tDiffuse, vec2 uv, float angle, float amount) {
    vec2 offset = vec2(cos(angle), sin(angle)) * amount;
    vec4 r = texture2D(tDiffuse, uv + offset);
    vec4 g = texture2D(tDiffuse, uv);
    vec4 b = texture2D(tDiffuse, uv - offset);
    return vec4(r.r, g.g, b.b, g.a);
}{@}rotation.glsl{@}mat4 rotationMatrix(vec3 axis, float angle) {
    axis = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    float oc = 1.0 - c;

    return mat4(oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,  0.0,
                oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,  0.0,
                oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c,           0.0,
                0.0,                                0.0,                                0.0,                                1.0);
}


mat2 rotationMatrix(float angle) {
  float s = sin(angle);
  float c = cos(angle);
  return mat2(c, -s, s, c);
}{@}simplenoise.glsl{@}float getNoise(vec2 uv, float time) {
    float x = uv.x * uv.y * time * 1000.0;
    x = mod(x, 13.0) * mod(x, 123.0);
    float dx = mod(x, 0.01);
    float amount = clamp(0.1 + dx * 100.0, 0.0, 1.0);
    return amount;
}

#test Device.mobile
float sinf(float x) {
    x*=0.159155;
    x-=floor(x);
    float xx=x*x;
    float y=-6.87897;
    y=y*xx+33.7755;
    y=y*xx-72.5257;
    y=y*xx+80.5874;
    y=y*xx-41.2408;
    y=y*xx+6.28077;
    return x*y;
}
#endtest

#test !Device.mobile
    #define sinf sin
#endtest

highp float getRandom(vec2 co) {
    highp float a = 12.9898;
    highp float b = 78.233;
    highp float c = 43758.5453;
    highp float dt = dot(co.xy, vec2(a, b));
    highp float sn = mod(dt, 3.14);
    return fract(sin(sn) * c);
}

float cnoise(vec3 v) {
    float t = v.z * 0.3;
    v.y *= 0.8;
    float noise = 0.0;
    float s = 0.5;
    noise += (sinf(v.x * 0.9 / s + t * 10.0) + sinf(v.x * 2.4 / s + t * 15.0) + sinf(v.x * -3.5 / s + t * 4.0) + sinf(v.x * -2.5 / s + t * 7.1)) * 0.3;
    noise += (sinf(v.y * -0.3 / s + t * 18.0) + sinf(v.y * 1.6 / s + t * 18.0) + sinf(v.y * 2.6 / s + t * 8.0) + sinf(v.y * -2.6 / s + t * 4.5)) * 0.3;
    return noise;
}

float cnoise(vec2 v) {
    float t = v.x * 0.3;
    v.y *= 0.8;
    float noise = 0.0;
    float s = 0.5;
    noise += (sinf(v.x * 0.9 / s + t * 10.0) + sinf(v.x * 2.4 / s + t * 15.0) + sinf(v.x * -3.5 / s + t * 4.0) + sinf(v.x * -2.5 / s + t * 7.1)) * 0.3;
    noise += (sinf(v.y * -0.3 / s + t * 18.0) + sinf(v.y * 1.6 / s + t * 18.0) + sinf(v.y * 2.6 / s + t * 8.0) + sinf(v.y * -2.6 / s + t * 4.5)) * 0.3;
    return noise;
}

float fbm(vec3 x, int octaves) {
    float v = 0.0;
    float a = 0.5;
    vec3 shift = vec3(100);

    for (int i = 0; i < 10; ++i) {
        if (i >= octaves){ break; }

        v += a * cnoise(x);
        x = x * 2.0 + shift;
        a *= 0.5;
    }

    return v;
}

float fbm(vec2 x, int octaves) {
    float v = 0.0;
    float a = 0.5;
    vec2 shift = vec2(100);
    mat2 rot = mat2(cos(0.5), sin(0.5), -sin(0.5), cos(0.50));

    for (int i = 0; i < 10; ++i) {
        if (i >= octaves){ break; }

        v += a * cnoise(x);
        x = rot * x * 2.0 + shift;
        a *= 0.5;
    }

    return v;
}
{@}skinning.glsl{@}attribute vec4 skinIndex;
attribute vec4 skinWeight;

uniform sampler2D boneTexture;
uniform float boneTextureSize;

mat4 getBoneMatrix(const in float i) {
    float j = i * 4.0;
    float x = mod(j, boneTextureSize);
    float y = floor(j / boneTextureSize);

    float dx = 1.0 / boneTextureSize;
    float dy = 1.0 / boneTextureSize;

    y = dy * (y + 0.5);

    vec4 v1 = texture2D(boneTexture, vec2(dx * (x + 0.5), y));
    vec4 v2 = texture2D(boneTexture, vec2(dx * (x + 1.5), y));
    vec4 v3 = texture2D(boneTexture, vec2(dx * (x + 2.5), y));
    vec4 v4 = texture2D(boneTexture, vec2(dx * (x + 3.5), y));

    return mat4(v1, v2, v3, v4);
}

void applySkin(inout vec3 pos, inout vec3 normal) {
    mat4 boneMatX = getBoneMatrix(skinIndex.x);
    mat4 boneMatY = getBoneMatrix(skinIndex.y);
    mat4 boneMatZ = getBoneMatrix(skinIndex.z);
    mat4 boneMatW = getBoneMatrix(skinIndex.w);

    mat4 skinMatrix = mat4(0.0);
    skinMatrix += skinWeight.x * boneMatX;
    skinMatrix += skinWeight.y * boneMatY;
    skinMatrix += skinWeight.z * boneMatZ;
    skinMatrix += skinWeight.w * boneMatW;
    normal = vec4(skinMatrix * vec4(normal, 0.0)).xyz;

    vec4 bindPos = vec4(pos, 1.0);
    vec4 transformed = vec4(0.0);
    
    transformed += boneMatX * bindPos * skinWeight.x;
    transformed += boneMatY * bindPos * skinWeight.y;
    transformed += boneMatZ * bindPos * skinWeight.z;
    transformed += boneMatW * bindPos * skinWeight.w;

    pos = transformed.xyz;
}

void applySkin(inout vec3 pos) {
    vec3 normal = vec3(0.0, 1.0, 0.0);
    applySkin(pos, normal);
}{@}transformUV.glsl{@}vec2 translateUV(vec2 uv, vec2 translate) {
    return uv - translate;
}

vec2 rotateUV(vec2 uv, float r, vec2 origin) {
    float c = cos(r);
    float s = sin(r);
    mat2 m = mat2(c, -s,
                  s, c);
    vec2 st = uv - origin;
    st = m * st;
    return st + origin;
}

vec2 scaleUV(vec2 uv, vec2 scale, vec2 origin) {
    vec2 st = uv - origin;
    st /= scale;
    return st + origin;
}

vec2 rotateUV(vec2 uv, float r) {
    return rotateUV(uv, r, vec2(0.5));
}

vec2 scaleUV(vec2 uv, vec2 scale) {
    return scaleUV(uv, scale, vec2(0.5));
}

vec2 skewUV(vec2 st, vec2 skew) {
    return st + st.gr * skew;
}

vec2 transformUV(vec2 uv, float a[9]) {

    // Array consists of the following
    // 0 translate.x
    // 1 translate.y
    // 2 skew.x
    // 3 skew.y
    // 4 rotate
    // 5 scale.x
    // 6 scale.y
    // 7 origin.x
    // 8 origin.y

    vec2 st = uv;

    //Translate
    st -= vec2(a[0], a[1]);

    //Skew
    st = st + st.gr * vec2(a[2], a[3]);

    //Rotate
    st = rotateUV(st, a[4], vec2(a[7], a[8]));

    //Scale
    st = scaleUV(st, vec2(a[5], a[6]), vec2(a[7], a[8]));

    return st;
}{@}LightBlur.fs{@}uniform vec2 uDir;

#require(gaussianblur.fs)

void main() {
    gl_FragColor = blur9(tDiffuse, vUv, resolution, uDir);
}{@}VolumetricLight.fs{@}uniform vec2 lightPos;
uniform float fExposure;
uniform float fDecay;
uniform float fDensity;
uniform float fWeight;
uniform float fClamp;

const int iSamples = 20;

void main() {
    vec2 deltaTextCoord = vUv - lightPos;
    deltaTextCoord *= 1.0  / float(iSamples) * fDensity;
    vec2 coord = vUv;

    float illuminationDecay = 1.0;
    vec4 color = vec4(0.0);

    for (int i = 0; i < iSamples; i++) {
        coord -= deltaTextCoord;
        vec4 texel = texture2D(tDiffuse, coord);
        texel *= illuminationDecay * fWeight;

        color += texel;
        illuminationDecay *= fDecay;
    }

    color *= fExposure;
    color = clamp(color, 0.0, fClamp);
    gl_FragColor = color;
}{@}waternormals.fs{@}vec4 getWaterNoise(sampler2D tNormal, vec2 uv, float speed, float scale){
    float time = time * 0.2 * speed;
    vec2 uv0 = (uv/103.0)+vec2(time/17.0, time/29.0);
    vec2 uv1 = uv/107.0-vec2(time/-19.0, time/31.0);
    vec2 uv2 = uv/vec2(897.0, 983.0)+vec2(time/101.0, time/97.0);
    vec2 uv3 = uv/vec2(991.0, 877.0)-vec2(time/109.0, time/-113.0);
    vec4 noise = (texture2D(tNormal, uv0 * scale)) +
    (texture2D(tNormal, uv1 * scale)) +
    (texture2D(tNormal, uv2 * scale)) +
    (texture2D(tNormal, uv3 * scale));
    return noise*0.5-1.0;
}

vec3 getWaterNormal(sampler2D tNormal, vec2 uv, float speed, float scale) {
    vec4 noise = getWaterNoise(tNormal, uv, speed, scale);
    vec3 surfaceNormal = normalize(noise.xzy * vec3(2.0, 1.0, 2.0));
    return surfaceNormal;
}
{@}VRInputControllerBeam.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform vec3 uColor;

#!VARYINGS
varying vec2 vUv;

#!SHADER: VRInputControllerBeam.vs
void main() {
    vUv = uv;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: VRInputControllerBeam.fs

#require(range.glsl)

void main() {
    vec4 vColor = vec4( uColor, length( vUv.y ));
    gl_FragColor = vColor;
}{@}VRInputControllerBody.glsl{@}#!ATTRIBUTES

#!UNIFORMS

#!VARYINGS

#!SHADER: VRInputControllerBody.vs
void main() {
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: VRInputControllerBody.fs
void main() {
    gl_FragColor = vec4(1.0);
}{@}VRInputControllerPoint.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform vec3 uColor;
uniform vec3 uBorderColor;
uniform float uAlpha;

#!VARYINGS
varying vec2 vUv;

#!SHADER: VRInputControllerPoint.vs
void main() {
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
    vUv = uv;
}

#!SHADER: VRInputControllerPoint.fs

const float borderWidth = 0.08;

void main() {
    vec2 uv = vUv * (2. + borderWidth * 4.) - (1. + borderWidth * 2.); // -1.0 ... 1.0
    float r = length(uv);

    // border
    float dist = abs(r-(1. - borderWidth));
    float delta = fwidth(dist);
    float alpha = 1.0 - smoothstep(-delta, delta, dist - borderWidth);
    vec4 border = vec4(uBorderColor, alpha);

    // fill
    dist = r-(1. - borderWidth);
    delta = fwidth(dist);
    float limit = borderWidth * 0.5;
    alpha = 1.0 - smoothstep(-delta, delta, dist - limit);
    vec4 fill = vec4(uColor, alpha);

    alpha = border.a + fill.a * (1. - border.a);

    gl_FragColor = vec4((border.rgb * border.a + fill.rgb * fill.a * (1. - border.a)) / alpha, uAlpha * alpha);
}{@}AboutComposite.fs{@}void main() {
    gl_FragColor = texture2D(tDiffuse, vUv);
}{@}AboutLogoShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform sampler2D tVideo;
uniform sampler2D tNormal;
uniform sampler2D tRefraction;
uniform float uAlpha;
uniform float uNormalScale;
uniform float uScrollDelta;
uniform float uVisible;
uniform float uNormalStrength;

#!VARYINGS
varying vec2 vUv;
varying vec3 vPos;
varying vec3 vWorldPos;
varying vec3 vNormal;
varying vec3 vViewDir;
varying vec2 vMUV;
varying vec3 vCameraPos;

#!SHADER: Vertex
#require(matcap.vs)

void main() {
    vUv = uv;
    vec3 pos = position;

    //pos.x -= cos(pos.y * 8.0) * 0.02 * uScrollDelta;
    //pos.z -= sin(pos.y * 8.0) * 0.02 * uScrollDelta;

    vPos = pos;
    vWorldPos = vec3(modelMatrix * vec4(pos, 1.0));
    vNormal = normalMatrix * normal;
    vCameraPos = cameraPosition;
    vViewDir = -vec3(modelViewMatrix * vec4(pos, 1.0));
    vMUV = reflectMatcap(vWorldPos, vNormal);
    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment

#require(range.glsl)
#require(simplenoise.glsl)
#require(fresnel.glsl)
#require(rgbshift.fs)
#require(radialblur.fs)
#require(normalmap.glsl)
#require(transformUV.glsl)
#require(blendmodes.glsl)
#require(rgb2hsv.fs)

vec3 rainbowColor(float t) {
    t = mod(t, 1.0); // Wraps the t value between 0.0 and 1.0
    if (t < 0.03) return mix(vec3(0.5, 0.0, 0.5), vec3(0.5, 0.0, 1.0), t / 0.03); // violet to blue
    else if (t < 0.06) return mix(vec3(0.5, 0.0, 1.0), vec3(0.0, 0.0, 1.0), (t - 0.03) / 0.03); // blue to darker blue
    else if (t < 0.09) return mix(vec3(0.0, 0.0, 1.0), vec3(0.0, 1.0, 1.0), (t - 0.06) / 0.03); // darker blue to cyan
    else if (t < 0.12) return mix(vec3(0.0, 1.0, 1.0), vec3(0.0, 1.0, 0.0), (t - 0.09) / 0.03); // cyan to green
    else if (t < 0.18) return mix(vec3(0.0, 1.0, 0.0), vec3(1.0, 1.0, 0.0), (t - 0.12) / 0.06); // green to yellow
    else if (t < 0.24) return mix(vec3(1.0, 1.0, 0.0), vec3(1.0, 0.5, 0.0), (t - 0.18) / 0.06); // yellow to orange
    else return mix(vec3(1.0, 0.5, 0.0), vec3(1.0, 0.0, 0.0), (t - 0.24) / 0.06); // orange to red
}

void main() {
    vec2 uv = vUv;



    vec2 screenuv = gl_FragCoord.xy / resolution;

    uv = scaleUV(uv, vec2(1.8));
    //uv += cnoise(screenuv*0.5 + time * 0.03 - vWorldPos.y * 0.3) * 0.1;
    vec2 normalUV = scaleUV(screenuv, vec2(5.0)) - vNormal.xy * 0.3 - vViewDir.xy * 0.2;
    //normalUV.y -= uScroll * 0.25;
    vec3 normal = crange(texture2D(tNormal, normalUV).rgb, vec3(0.0), vec3(1.0), vec3(-1.0), vec3(1.0));

    uv = rotateUV(uv, 1.0 + sin(time * 0.5) * 0.5);
    uv += normal.xy * 0.02 * uNormalStrength;
    uv += vViewDir.xy * 0.025 * uNormalStrength;
    

    vec4 color = getRGB(tMap, uv, 0.2, 0.001) * 0.6;
    //color *= smoothstep(0.0, 0.1, vUv.x);
    //color *= smoothstep(0.75, 0.65, vUv.x);
    //color *= smoothstep(0.75, 0.65, vUv.x);

    float center = smoothstep(0.35, 0.25, length(vPos));

    float f = getFresnel(vNormal + normal * 0.05, vViewDir, 1.8);    
    screenuv -= vNormal.xy * 0.1;
    screenuv += normal.xy * 0.01;

    vec3 video = texture2D(tVideo, scaleUV(screenuv, vec2(0.8))).rgb;
    color.rgb += blendSoftLight(color.rgb, video, 0.8);//rainbowColor(f);

    color.rgb *= smoothstep(0.0, 0.1, vUv.y);
    color.rgb *= smoothstep(0.0, 0.1, vUv.x);
    //color.rgb *= smoothstep(0.75, 0.65, vUv.y);

    vec2 refractionuv = gl_FragCoord.xy / resolution;
    refractionuv += vNormal.xy * 0.25 * uNormalStrength;
    refractionuv += normal.xy * 0.06 * uNormalStrength;
    //refractionuv = rotateUV(refractionuv, vNormal.y * 1.0);

    vec3 refractionTex = radialBlur(tRefraction, refractionuv, 8.0, 8.0).rgb;
    color.rgb += refractionTex * 0.6;//blendOverlay(color.rgb, refractionTex, refractionTex.r * 10.0);//radialBlur(tRefraction, screenuv, 5.0, 5.0) * 0.8;

    color += texture2D(tMap, vMUV);
    color.rgb = blendOverlay(color.rgb, rainbowColor(f * 0.3), 0.1);
    color.rgb += rainbowColor(f * 0.2) * 0.05;
    color *= 1.0 + f * .6;
    color.rgb += pow(f, 2.0) * 0.8 * mix(video, vec3(1.0), 0.6);

    color.rgb = blendSoftLight(color.rgb, vec3(1.0), smoothstep(0.2, 0.0, f) * mix(0.0, 1.0, abs(sin(time * 0.4 - f*2.0 - vViewDir.x * 2.0)))*2.0);

    vec3 hueShift = rgb2hsv(color.rgb);
    hueShift.x += sin(time * 0.5 + normal.x * 3.0 + vNormal.x * 0.5) * 0.1;
    hueShift.y *= 0.7;
    color.rgb = hsv2rgb(hueShift);

    color.rgb = pow(color.rgb*1.0, vec3(1.5));
    color.a *= uAlpha;
    
    #drawbuffer Color gl_FragColor = color;
    #drawbuffer Refraction gl_FragColor = vec4(0.0);
}{@}ChatBGShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform vec3 uColor;
uniform float uAlpha;
uniform float uScroll;
uniform float uScrollDelta;
uniform float uBottom;
uniform float uDisabled;
uniform float uHeight;
uniform float uActive;

#!VARYINGS
varying vec2 vUv;
varying vec3 vPos;
varying vec3 vWorldPos;

#!SHADER: Vertex

void main() {
    vUv = uv;
    vPos = position;
    vWorldPos = vec3(modelMatrix * vec4(position, 1.0));
    
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: Fragment

#require(transformUV.glsl)
#require(simplenoise.glsl)
#require(range.glsl)
#require(rgb2hsv.fs)

float innerRoundedRectangle(vec2 p, vec2 size, float radius, float stepper) {
    vec2 q = abs(p) - size + radius;
    return step(stepper, length(max(q, 0.0)) - radius);
}

void main() {
    vec2 uv = vUv;
    vec4 color = vec4(0.0);

    //float innerClip = step(0.4, abs(uv.x-0.5));
    //innerClip = max(innerClip, step(0.3, abs(uv.y-0.5)));
    
    vec2 innerUV = uv;
    innerUV.y += smoothstep(1.5, 0.0, abs(uv.x-mix(0.35, 0.5, uActive))) * 0.03 * uScrollDelta;

    //innerUV += cnoise(uv*2.0+time*0.2) * 0.01;
    vec2 innerScale = vec2(mix(0.4, 0.75, uActive), uHeight);
    vec2 innerOffset = vec2(mix(0.7, 1.05, uActive), 1.0 + uScrollDelta * 0.03);
    float innerClip = innerRoundedRectangle(scaleUV(innerUV, vec2(0.5, 0.5), innerOffset), innerScale, innerScale.y, 0.0);
    float innerClip2 = innerRoundedRectangle(scaleUV(innerUV, vec2(0.5, 0.5), innerOffset), innerScale, innerScale.y, 0.01);

    vec2 bgUV = scaleUV(innerUV, vec2(mix(0.65, 1.0, uActive), 0.4), vec2(0.1, mix(0.42, 0.57, uBottom) + uScrollDelta * 0.015));

    vec3 rainbow = vec3(0.65, 1.0, 0.9);
    rainbow = rgb2hsv(rainbow);
    rainbow.x += cnoise(-bgUV*0.5-bgUV.y*0.5-time*0.05-uScroll*0.3+length(bgUV-0.2)*0.2) * 0.2;
    rainbow = hsv2rgb(rainbow);

    color = mix(color, vec4(rainbow, 0.5), smoothstep(0.65, abs(uScrollDelta * 0.02) - 0.2, length(bgUV-0.5)));
    color = mix(color, vec4(rainbow, 0.8), smoothstep(0.25, 0.0, length(bgUV-0.5)));
    color = mix(color, vec4(rainbow, 0.2 + abs(uScrollDelta * 0.08) + uActive * 0.4), 1.0-innerClip2);

    vec4 inner = vec4(uColor, 0.7);
    vec2 barUV = innerUV;
    barUV.y -= uScroll * 0.2 + time * 0.1;
    float bars = sin(barUV.x * 1000.0) * cnoise(barUV*30.0 + time * 0.2 + abs(barUV.y-0.5) * 4.0);
    color += vec4(mix(rainbow, vec3(1.0), 0.5), step(0.9, bars)) * mix(abs(uScrollDelta) * 0.03 + 0.2, 0.3, uActive) * innerClip2 * smoothstep(0.5, 0.2, length(bgUV-0.5));

    color = mix(color, inner, 1.0-innerClip);
    color.a *= mix(1.0, 0.0, uDisabled);

    gl_FragColor = color;
    gl_FragColor.a *= uAlpha;
}{@}CleanRoomComposite.fs{@}uniform sampler2D tDiffuse;
uniform float uRGBStrength;
uniform float uVolumetricStrength;
uniform vec2 uContrast;
uniform sampler2D tVolumetricBlur;

varying vec2 vUv;

#require(UnrealBloom.fs)
#require(rgbshift.fs)
#require(contrast.glsl)
#require(simplenoise.glsl)

void main() {
    vec3 color = texture2D(tDiffuse, vUv).rgb;//getRGB(tDiffuse, vUv, 0.3, 0.002 * uRGBStrength).rgb;
    color = adjustContrast(color, uContrast.x, uContrast.y);
    // color += pow(getUnrealBloom(vUv), vec3(1.5)) * 0.4;
    //color += (-0.5 + getNoise(vUv, time)) * 0.1;
    color += texture2D(tVolumetricBlur, vUv).rgb * uVolumetricStrength;
    //color = texture2D(tVolumetricBlur, vUv).rgb;

    gl_FragColor = vec4(color, 1.0);
}{@}CleanRoomGlass.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tRefraction;
uniform sampler2D tEnv;
uniform sampler2D tInner;
uniform float uFresnelPow;
uniform float uDistortStrength;
uniform float uRefractionRatio;

#!VARYINGS
varying vec3 vWorldPos;
varying vec3 vNormal;
varying vec3 vViewDir;
varying vec3 vReflection;
varying vec3 vRefraction;
varying vec3 vPos;

#!SHADER: Vertex

#require(refl.vs)

void main() {
    vec4 worldPos = modelMatrix * vec4(position, 1.0);

    vReflection = reflection(worldPos);
    vRefraction = refraction(worldPos, uRefractionRatio);

    vPos = position;
    vWorldPos = worldPos.xyz;
    vNormal = normalMatrix * normal;
    vViewDir = -vec3(modelViewMatrix * vec4(position, 1.0));
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: Fragment

#require(range.glsl)
#require(simplenoise.glsl)
#require(fresnel.glsl)
#require(eases.glsl)
#require(refl.fs)
#require(rgbshift.fs)

vec3 rainbowColor(float t) {
    t = mod(t, 1.0); // Wraps the t value between 0.0 and 1.0
    if (t < 0.03) return mix(vec3(0.5, 0.0, 0.5), vec3(0.5, 0.0, 1.0), t / 0.03); // violet to blue
    else if (t < 0.06) return mix(vec3(0.5, 0.0, 1.0), vec3(0.0, 0.0, 1.0), (t - 0.03) / 0.03); // blue to darker blue
    else if (t < 0.09) return mix(vec3(0.0, 0.0, 1.0), vec3(0.0, 1.0, 1.0), (t - 0.06) / 0.03); // darker blue to cyan
    else if (t < 0.12) return mix(vec3(0.0, 1.0, 1.0), vec3(0.0, 1.0, 0.0), (t - 0.09) / 0.03); // cyan to green
    else if (t < 0.18) return mix(vec3(0.0, 1.0, 0.0), vec3(1.0, 1.0, 0.0), (t - 0.12) / 0.06); // green to yellow
    else if (t < 0.24) return mix(vec3(1.0, 1.0, 0.0), vec3(1.0, 0.5, 0.0), (t - 0.18) / 0.06); // yellow to orange
    else return mix(vec3(1.0, 0.5, 0.0), vec3(1.0, 0.0, 0.0), (t - 0.24) / 0.06); // orange to red
}

void main() {
    float f = getFresnel(vNormal, vViewDir, uFresnelPow);
    vec3 r = rainbowColor(f * 4.0);
    if (r.r > 0.99) r *= 0.0;

    vec2 uv = gl_FragCoord.xy / resolution;
    uv += 0.1 * vNormal.xy * f * uDistortStrength;

    gl_FragColor = getRGB(tRefraction, uv, 0.3, 0.002);
    gl_FragColor.rgb += r;
    // gl_FragColor = envColorEqui(tEnv, vReflection);
    gl_FragColor += envColorEquiRGB(tEnv, vRefraction, 0.2, 1.0);
    gl_FragColor.rgb += cnoise(vViewDir + 2.0) * 0.1;
    gl_FragColor.rgb += texture2D(tInner, gl_FragCoord.xy / resolution).r;
    gl_FragColor.rgb += quarticIn(crange(abs(vPos.x), 0.5, 0.3, 1.0, 0.0) * crange(abs(vPos.z), 0.5, 0.3, 1.0, 0.0)) * 0.05;

    gl_FragColor.rgb = pow(gl_FragColor.rgb, vec3(1.5));

    if (vNormal.y > 0.8) gl_FragColor.rgb *= 1.8;

    // gl_FragColor = vec4(vec3(f), 1.0);
}{@}FloorShader.glsl{@}#!ATTRIBUTES
attribute vec2 uv2;

#!UNIFORMS
uniform sampler2D tLightmap;
uniform sampler2D tMirrorReflection;
uniform mat4 uMirrorMatrix;
uniform float uMirrorStrength;
uniform float uDistortStrength;
uniform sampler2D tLightReflection;
uniform vec2 uRUVOffset;
uniform float uRUVScale;

#!VARYINGS
varying vec2 vUv2;
varying vec4 vMirrorCoord;
varying vec3 vWorldPos;

#!SHADER: Vertex

#require(fbr.vs)

void main() {
    vec4 worldPos = modelMatrix * vec4(position, 1.0);
    vMirrorCoord = uMirrorMatrix * worldPos;
    vWorldPos = worldPos.xyz;

    setupFBR(position);
    vUv2 = uv2;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: Fragment

#require(fbr.fs)
#require(radialblur.fs)
#require(luma.fs)
#require(simplenoise.glsl)
#require(range.glsl)
#require(transformUV.glsl)

void main() {
    gl_FragColor = vec4(getFBR(vec3(1.0)), 1.0);
    gl_FragColor.rgb *= crange(getNoise(vUv, time), 0.0, 1.0, 0.5, 1.0);

    vec3 mro = texture2D(tMRO, vUv).rgb;
    vec3 normal = texture2D(tNormal, vUv).rgb;

    vec2 mirrorUV = vMirrorCoord.xy / vMirrorCoord.w;
    mirrorUV += crange(normal.xy, vec2(0.0), vec2(1.0), vec2(-1.0), vec2(1.0)) * uDistortStrength;

    float strength = crange(mro.y, 0.6, 0.7, 0.0, 1.0);
    vec3 reflectionColor = radialBlur(tMirrorReflection, mirrorUV, 15.0 * strength, 5.0) * uMirrorStrength;
    gl_FragColor.rgb += reflectionColor;

    vec3 lightmap = texture2D(tLightmap, vUv2).rgb;
    float lighting = lightmap.g;
    float ao = lightmap.r;
    gl_FragColor.rgb *= ao;
    gl_FragColor.rgb += lighting * 0.15;

    vec3 viewDir = normalize(vWorldPos - cameraPosition);
    vec3 viewProjection = viewDir - dot(viewDir, vNormal) * vNormal;
    float maxViewSkew = radians(30.0);
    vec2 viewSkew;
    viewSkew.x = clamp(viewProjection.x / maxViewSkew, -1.0, 1.0);
    viewSkew.y = -clamp(viewProjection.y / maxViewSkew, -1.0, 1.0);

    vec2 ruv = scaleUV(vUv, vec2(0.2 * uRUVScale));
    ruv += uRUVOffset + (viewSkew*0.2);

    gl_FragColor.rgb += texture2D(tLightReflection, ruv).rgb * 0.5 * crange(strength, 0.0, 1.0, 0.5, 1.0);

    // gl_FragColor = texture2D(tLightReflection, ruv);
}{@}GlassInner.glsl{@}#!ATTRIBUTES

#!UNIFORMS

#!VARYINGS
varying vec3 vNormal;
varying vec3 vViewDir;
varying vec3 vPos;

#!SHADER: Vertex
void main() {
    vNormal = normal;
    vViewDir = -vec3(modelViewMatrix * vec4(position, 1.0));
    vPos = position;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: Fragment

#require(range.glsl)
#require(simplenoise.glsl)
#require(eases.glsl)

void main() {
    gl_FragColor = mix(vec4(0.0), vec4(1.4), vNormal.y) * crange(cnoise(vViewDir*0.2 + 0.5), -1.0, 1.0, 0.0, 1.0);
    gl_FragColor.rgb += cnoise(vViewDir) * 0.05;
    gl_FragColor.rgb += quarticIn(crange(abs(vPos.x), 0.5, 0.3, 1.0, 0.0) * crange(abs(vPos.z), 0.5, 0.3, 1.0, 0.0)) * 0.1;
}{@}GlassReflection.glsl{@}#!ATTRIBUTES

#!UNIFORMS

#!VARYINGS

#!SHADER: Vertex
void main() {
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: Fragment
void main() {
    gl_FragColor = vec4(vec3(1.0), 0.1);
}{@}LabLogoShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform float uAlpha;

#!VARYINGS
varying vec2 vUv;
varying vec3 vPos;
varying vec3 vWorldPos;

#!SHADER: Vertex

void main() {
    vUv = uv;
    vPos = position;
    vWorldPos = vec3(modelMatrix * vec4(position, 1.0));
    
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: Fragment

#require(range.glsl)
#require(transformUV.glsl)

void main() {
    vec2 uv = vUv;
    vec4 color = texture2D(tMap, uv);

    color.a *= 0.7 + sin(-time + length(uv-0.5) * 10.0) * 0.3;

    color.a = mix(color.a, 1.0, smoothstep(0.8, 1.0, uAlpha));
    
    gl_FragColor = color;
    gl_FragColor.a *= uAlpha;
}{@}RoomPBR.glsl{@}#!ATTRIBUTES

#!UNIFORMS

#!VARYINGS

#!SHADER: Vertex

#require(pbr.vs)

void main() {
    vec3 pos = position;
    setupPBR(pos);

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment

#require(pbr.fs)

void main() {
    gl_FragColor = getPBR();
}
{@}WallShader.glsl{@}#!ATTRIBUTES
attribute vec2 uv2;

#!UNIFORMS
uniform sampler2D tLightmap;
uniform sampler2D tLightReflection;
uniform vec2 uRUVOffset;
uniform float uRUVScale;

#!VARYINGS
varying vec2 vUv;
varying vec2 vUv2;
varying vec3 vONormal;
varying vec3 vWorldPos;

#!SHADER: Vertex

#require(fbr.vs)

void main() {
    vWorldPos = vec3(modelMatrix * vec4(position, 1.0));
    vUv2 = uv2;
    vUv = uv;
    vONormal = normal;
    setupFBR(position);
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: Fragment

#require(fbr.fs)
#require(simplenoise.glsl)
#require(range.glsl)
#require(transformUV.glsl)

vec3 calculateFixedReflection(vec3 surfacePosition, vec3 lightPosition, vec3 surfaceNormal) {
    // Calculate the vector from the surface to the light source
    vec3 toLight = normalize(lightPosition - surfacePosition);

    // Reflect this vector around the surface normal
    vec3 reflected = reflect(-toLight, surfaceNormal);

    // Return the reflected vector, which will remain constant as long as the light position
    // and surface normal don't change, even if the camera moves
    return reflected;
}

void main() {
    vec3 viewDir = normalize(vWorldPos - cameraPosition);
    vec3 viewProjection = viewDir - dot(viewDir, vNormal) * vNormal;
    float maxViewSkew = radians(30.0);
    vec2 viewSkew;
    viewSkew.y = clamp(viewProjection.y / maxViewSkew, -1.0, 1.0);
    
    vec2 ruvscale = vec2(0.2 * uRUVScale);
    ruvscale.y += crange(viewSkew.y, -1.0, 1.0, 0.0, 1.0);
    vec2 ruv = scaleUV(vUv, ruvscale);
    ruv += uRUVOffset;

    vec3 mro = texture2D(tMRO, vUv).rgb;
    vec3 color = getFBR(vec3(1.0));

    vec3 lightmap = texture2D(tLightmap, vUv2).rgb;
    float lighting = lightmap.g;
    float ao = lightmap.r * 2.2;
    color *= ao;
    color += lighting * 0.25 * crange(mro.y, 0.6, 0.7, 0.8, 1.0);

    //gl_FragColor.rgb *= crange(getNoise(vUv, time), 0.0, 1.0, 0.5, 1.0);
    
    if (vONormal.z > 0.9) {
        color += texture2D(tLightReflection, ruv).rgb * crange(mro.y, 0.6, 0.7, 0.5, 1.0) * 0.025;
    }

    color *= 0.7;


    gl_FragColor = vec4(color, 1.0);
}{@}WaterCeilingShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform sampler2D tVideo;
uniform float uAlpha;

#!VARYINGS
varying vec2 vUv;
varying vec3 vPos;
varying vec3 vWorldPos;

#!SHADER: Vertex

void main() {
    vUv = uv;
    vPos = position;
    vWorldPos = vec3(modelMatrix * vec4(position, 1.0));
    
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: Fragment

#require(range.glsl)
#require(simplenoise.glsl)
#require(transformUV.glsl)
#require(blendmodes.glsl)
#require(rgb2hsv.fs)
#require(luma.fs)

void main() {
    vec2 uv = scaleUV(vUv, vec2(0.1));
    //uv += cnoise(uv * 5.0 + time * 0.1 ) * 0.02;
    //uv += cnoise(uv * 1.0 - time * 0.1 ) * 0.04;
    vec4 color = texture2D(tMap, uv);

    vec3 hsl = rgb2hsv(color.rgb);
    hsl.x -= length(vUv-0.5) * 0.2;
    hsl.y *= 0.5;
    //hsl.z = pow(hsl.z, 1.5);

    color.rgb = hsv2rgb(hsl);

    color.rgb *= smoothstep(0.45, 0.0, length(vUv-0.5));
    vec3 video = texture2D(tVideo, scaleUV(vUv, vec2(0.4))).rgb;
    color.rgb = blendOverlay(color.rgb, video, 0.3);

    color.rgb = pow(color.rgb, vec3(2.2));
    //color.rgb *= 1.0 + cnoise(uv*0.5 + length(vUv-0.5) * 5.0 - time * 0.3) * 0.8;


    //if (rgb2hsv(color.rgb).z > 0.5 + sin(time - length(vWorldPos) * 5.0) * 0.1) discard;

    color.a *= uAlpha;
    
    #drawbuffer Color gl_FragColor = color;
    #drawbuffer CleanroomVolumetricLight gl_FragColor = mix(color, vec4(0.0), 1.0 - smoothstep(0.2, 0.5, luma(color.rgb)));
}{@}WaterParticles.glsl{@}#!ATTRIBUTES
attribute vec4 random;

#!UNIFORMS
uniform sampler2D tPos;
uniform sampler2D tPointColor;
uniform sampler2D tMap;
uniform float DPR;


#!VARYINGS
varying vec3 vLightColor;
varying vec3 vPos;
varying vec4 vRandom;
varying float vScale;
varying float vDist;
varying float vRipple;
varying vec3 vWorldPos;
varying vec2 vUv;

#!SHADER: Vertex

const float PI = 3.1415926535897932384626433832795;

#require(range.glsl)
#require(lighting.vs)
#require(simplenoise.glsl)

void main() {
    vec4 decodedPos = texture2D(tPos, position.xy);
    vec3 pos = decodedPos.xyz;

    pos += cnoise(pos*0.05+time*0.1) * 0.2;

    // pos.x += 1.0;
    // pos.z -= 0.5;

    // float offset = (1.0 - uScroll) * pow(random.x, 100.0) * 50.0;
    // offset *= (0.8 + sin(pos.y * 0.2 + time * 0.02 + uScroll + random.z * 2.0) * 0.2);
    // pos.y += offset;

    // float radius = mix(0.5, 3.0, pow(random.w, 2.0));

    // pos.x -= cos(pos.y * 0.5) * 12.0 * step(0.98, random.y);
    // pos.z -= sin(pos.y * 0.5) * 12.0 * step(0.98, random.y);
    // pos.y -= pow(uScroll, 2.0) * 30.0 * pow(random.w, 40.0);

    vec3 worldPos = vec3(modelMatrix * vec4(pos, 1.0));
    vWorldPos = worldPos;

    float dist = length(worldPos - cameraPosition);
    vDist = dist;
    vUv = uv;

    vRipple = 0.0;
    vPos = pos;
    vRandom = random;

    vScale = smoothstep(3.0, 15.0, dist);
    vScale *= 1.0 + (0.5 + sin(time * 3.0 + vRandom.x * 20.0) * 0.5) * 0.3;
    vScale *= mix(0.1, 1.5, random.z);
    vScale *= mix(1.0, 3.0, vRipple);

    vec4 mvPosition = modelViewMatrix * vec4(pos, 1.0);
    gl_PointSize = (0.08) * DPR * 2.0 * vScale * (1000.0 / length(mvPosition.xyz));
    gl_Position = projectionMatrix * mvPosition;
}

#!SHADER: Fragment

#require(range.glsl)
#require(transformUV.glsl)
#require(simplenoise.glsl)
#require(rgb2hsv.fs)
#require(blendmodes.glsl)
#require(shadows.fs)

void main() {
    vec2 uv = vec2(gl_PointCoord.x, 1.0 - gl_PointCoord.y);
    if (length(uv-0.5) > 0.5) discard;
    if (vScale < 0.1) discard;

    vec2 matcapUV = rotateUV(uv, sin(time * 0.5 + vRandom.z * 20.0) * 0.5 + 1.0);
    vec3 color = texture2D(tMap, matcapUV).rgb;
    color *= 1.0 + vRipple * 0.5;
    color = pow(color, vec3(3.0));

    color *= 0.5;
    //color *= smoothstep(0.5, 0.0, length(uv-0.5));
    //color += vRipple * 0.01;

    float sparkle = 0.5 + sin(time * 2.0 + vRandom.y * 20.0);
    color *= mix(sparkle, 1.0, 0.6);
    color = min(vec3(0.9), color);
    //float noise = cnoise(vWorldPos*0.5-time*0.2+length(vWorldPos) * 0.05);

    gl_FragColor = vec4(color, 1.0);
}{@}PhysicalShader.glsl{@}#!ATTRIBUTES
attribute vec2 uv2;
attribute vec3 vdata;
attribute float side;

#!UNIFORMS
uniform sampler2D tVideo;

uniform sampler2D tBaseColor;
uniform sampler2D tMRO;
uniform sampler2D tNormal;
uniform sampler2D tLUT;
uniform sampler2D tFluid;
uniform sampler2D tFluidMask;

uniform sampler2D tEnvDiffuse;
uniform sampler2D tEnvSpecular;

uniform sampler2D tLightmap;
uniform float uUseLightmap;
uniform float uLightmapIntensity;
uniform float uTime;

uniform vec4 uParams;
uniform vec3 uFogColor;

uniform vec3 uTint;
uniform vec2 uTiling;
uniform vec2 uOffset;
uniform vec4 uMRON;
uniform vec2 uEnv;

uniform float uHDR;
uniform float uLightmapAsDiffuse;
uniform float uHold;

uniform float uVisible;
uniform float uRotation;

uniform float uScroll;

uniform vec2 uUVScale;

#!VARYINGS
varying vec2 vUv;
varying vec2 vUv2;
varying vec3 vN;
varying vec3 vV;
varying vec3 vWorldNormal;
varying vec3 vColor;
varying float vFog;
varying float vAngle;
varying float vSide;
varying float vAO;
varying vec3 vFluid;
varying float vFluidMask;
varying float vVisible;

#!SHADER: Vertex
#require(rotation.glsl)

const float LOG2 = 1.442695;

void main() {
    // vec3 ndc = offset.xyz / gl_Position.w; //perspective divide/normalize
    // vec2 viewportCoord = ndc.xy * 0.5 + 0.5; //ndc is -1 to 1 in GL. scale for 0 to 1
    // vec2 viewportPixelCoord = viewportCoord * resolution;

    // vec2 fluidUv = offset.xy * 0.1 + vec2(0.4, 0.5);
    // vec2 fluidUv = offset.xy * 0.1 + vec2(0.4, 0.5);
    // vec2 fluidUv = viewportPixelCoord;
    vUv = position.xy * 0.01 + offset.xy * 0.1 + vec2(0.4, 0.5);

    vec4 screenUv = projectionMatrix * modelViewMatrix * vec4(offset, 1.0);
    screenUv /= screenUv.w;

    // vec3 fluidVel = texture2D(tFluid, fluidUv).rgb;
    // float fluidMag = length(fluidVel);
    vec2 fluidUv = offset.xy * 0.1 + vec2(0.4, 0.5);
    vec3 fluidVel = texture2D(tFluid, screenUv.xy * 0.5 + 0.5).rgb;
    float fluidMask = texture2D(tFluidMask, screenUv.xy * 0.5 + 0.5).r;
    fluidMask = 1.0 - pow(1.0 - fluidMask, 20.2);
    vColor = vec3(fluidMask);

    vFluid = fluidVel;
    vFluidMask = fluidMask;

    vec4 color = texture2D(tVideo, offset.xy * 0.1 + vec2(0.4, 0.5));
    vec3 pos = position;

    float layFlat = 1.0;
    // layFlat = clamp(sin(pow(length(offset), 1.0) * -0.15 + time * 0.2 - 5.0) * 3.0, 0.0, 1.0);
    layFlat = 0.0;
    
    float strength = length(offset) * mix(0.1, 0.2, uHold) + 0.5;

    vec3 axis = cross(normalize(offset), vec3(0.0, 0.0, 1.0));
    float angle = (sin(length(offset * 1.4) - uTime) * 0.5 + 0.5) * 3.14159 + 3.14159;
    angle *= 2.0;

    angle = mix(angle, 0.0, layFlat);
    angle += fluidMask * 3.14 * mix(0.5, 0.2, uHold) * 1.5;
    angle -= fluidVel.x * 0.005 * 3.14 * mix(0.3, 0.7, uHold);
    angle -= fluidVel.y * 0.005 * 3.14 * mix(0.3, 0.7, uHold);


    vVisible = (1.0-uVisible) * length(offset);
    angle += vVisible * - 15.0;

    mat4 m = rotationMatrix(axis, angle);

    float mask = 0.0;


    vec3 off = offset;
    pos -= offset;
    pos *= mix(0.95, 1.0, layFlat);
    pos = (m * vec4(pos.xyz, 1.0)).xyz;
    off.z += (angle * 0.2) * strength - 1.0 * (1.0 - layFlat);
    off.z *= 3.0 * (1.0 - clamp(length(offset * 0.2), 0.0, 1.0));
    pos += off;

    //pos.y += uScroll * angle * 0.1 - 0.5;

    vec3 n = (m * vec4(mix(normal.xyz, normalize(position), 0.1), 0.0)).xyz;
    n = mix(normal, n, strength);
    n = mix(n, vec3(0.0, 0.0, 1.0), layFlat - fluidMask);

    vAO = 1.0 - (dot(normalize(vec3(0.2, 0.0, -1.0)), n) * 0.5 + 0.5);
    vAO = abs(vAO);
    vAO = pow(vAO, 5.0);
    vAO = 1.0 - clamp(vAO, 0.0, 1.0);
    vAO = mix(1.0, vAO, smoothstep(0.0, 0.2, pos.z));

    vec4 worldPos = modelMatrix * vec4(pos, 1.0);
    vec4 modelViewPos = viewMatrix * worldPos;
    gl_Position = projectionMatrix * modelViewPos;

    vec3 worldNormal = mat3(modelMatrix[0].xyz, modelMatrix[1].xyz, modelMatrix[2].xyz) * n;

    vN = n;
    vWorldNormal = worldNormal;
    vV = worldPos.xyz - cameraPosition;
    
    // vUv *= 1.2;
    // vUv = uv;
    vUv2 = uv2;

    vAngle = angle;

    
    float fogDistance = -modelViewPos.z;
    float fogFactor = 0.0021;
    float fogAmount = 1. - exp2(-fogFactor * fogFactor * fogDistance * fogDistance * LOG2);
    fogAmount = clamp(fogAmount, 0., 1.);
    vFog = fogAmount;

    vSide = side;
}

#!SHADER: Fragment
#require(normalmap.glsl)
#require(transformUV.glsl)
#require(blendmodes.glsl)
#require(rgbshift.fs)

const vec2 INV_ATAN = vec2(0.1591, 0.3183);
const float LN2 = 0.6931472;
const float ENV_LODS = 7.0;

vec3 unreal(vec3 x) {
  return x / (x + 0.155) * 1.019;
}

vec3 fresnelSphericalGaussianRoughness(float cosTheta, vec3 F0, float roughness) {
	return F0 + (max(vec3(1.0 - roughness), F0) - F0) * pow(2.0, (-5.55473 * cosTheta - 6.98316) * cosTheta);
}

vec2 sampleSphericalMap(vec3 v)
{
    vec2 uv = vec2(atan(v.z, v.x), asin(v.y));
    uv *= INV_ATAN;
    uv += 0.5;

    // match default C4D baked HDRI
    uv.x = fract(uv.x + 0.25 + uParams.y + 0.8 - 0.1);

    return uv;
}

vec4 SRGBtoLinear(vec4 srgb) {
    vec3 linOut = pow(srgb.xyz, vec3(2.2));
    return vec4(linOut, srgb.w);
}

vec3 linearToSRGB(vec3 color) {
    return pow(color, vec3(0.4545454545454545));
}

vec4 RGBMToLinear(vec4 value) {
    float maxRange = 6.0;
    return vec4(value.xyz * value.w * maxRange, 1.0);
}

vec4 autoToLinear(vec4 texel, float uHDR) {
    vec4 color = RGBMToLinear(texel);
    if (uHDR == 0.0) { color = SRGBtoLinear(texel); }
    return color;
}

vec4 getIBLContribution(float NdV, vec4 baseColor, vec4 MRO, vec3 R, vec3 V, vec3 N, sampler2D tLUT, sampler2D tEnvDiffuse, sampler2D tEnvSpecular) {
    float metallic = clamp(MRO.x + uMRON.x - 1.0, 0.0, 1.0);
    float roughness = clamp(MRO.y + uMRON.y - 1.0, 0.0, 1.0);
    float ao = mix(1.0, MRO.z, uMRON.z);

    vec2 lutUV = vec2(NdV, roughness);
    vec2 diffuseUV = sampleSphericalMap(N);

    vec3 brdf = SRGBtoLinear(texture2D(tLUT, lutUV)).rgb;
    vec3 diffuse = autoToLinear( texture2D(tEnvDiffuse, diffuseUV ), uHDR).rgb;

    vec3 lightmap = vec3(1.0);

    if (uUseLightmap > 0.0) {
        lightmap = texture2D(tLightmap, vUv2).rgb;
        lightmap.rgb = pow(lightmap.rgb, vec3(2.2));
        diffuse.rgb *= lightmap.rgb;
    }

    diffuse *= baseColor.rgb;

    float level = floor(roughness * ENV_LODS);
    vec2 specUV = sampleSphericalMap(R);

    specUV.y /= 2.0;
    specUV /= pow(2.0, level);
    specUV.y += 1.0 - exp(-LN2 * level);

    vec3 specular = autoToLinear(texture2D(tEnvSpecular, specUV), uHDR).rgb;

    // fake stronger specular highlight
    specular += pow(specular, vec3(2.2)) * uEnv.y;

    if (uUseLightmap > 0.0) {
        specular *= lightmap;
    }

    vec3 F0 = vec3(0.01);
    F0 = mix(F0, baseColor.rgb, metallic);

    vec3 F = fresnelSphericalGaussianRoughness(NdV, F0, roughness);

    vec3 diffuseContrib = 1.0 - F;
    specular = specular.rgb * (F);

    diffuseContrib *= 1.0 - metallic;

    float alpha = baseColor.a;

    return vec4((diffuseContrib * diffuse + specular) * ao * uEnv.x, alpha);
}

void main() {
    vec2 uv = vUv;
    vec3 N = vWorldNormal;
    vec3 V = normalize(vV);
    vec3 worldNormal = unpackNormal(V, N, tNormal, uMRON.w, 1.0, uv).xyz;
    vec3 R = reflect(V, worldNormal);
    float NdV = abs(dot(worldNormal, V));

    vec4 MRO = texture2D(tMRO, uv);
    MRO.r = mix(0.8, 0.6, uHold);
    vec4 baseColor = texture2D(tBaseColor, uv);

    vec2 videoUV = scaleUV(uv, uParams.xy, uParams.zw);
    //videoUV.x += 0.2;
    videoUV.xy += vFluid.xy * 0.005 * vFluidMask;
    videoUV = scaleUV(videoUV, vec2(1.1 + sin(time) * 0.1));

    vec3 videoColor = texture2D(tVideo, videoUV).rgb;

    //videoColor *= mix(1.0, 0.7, smoothstep(0.5, 0.1, length(scaleUV(videoUV, vec2(1.0, 1.5))-0.5)));

    baseColor.rgb = videoColor * 1.0;
    baseColor = SRGBtoLinear(baseColor);

    baseColor += vFluid.x * 0.001;
    
    vec4 color = getIBLContribution(NdV, baseColor, MRO, R, V, worldNormal, tLUT, tEnvDiffuse, tEnvSpecular);
    color.rgb = pow(color.rgb, vec3(0.45454545));
    // color.rgb = mix(color.rgb, uFogColor, vFog);

    vec4 outputColor = color;
    outputColor.rgb += vColor * color.rgb * mix(0.1, 0.2, uHold);
    outputColor.a = 1.0;


    //outputColor.rgb = blendSoftLight(outputColor.rgb, videoColor, 0.5);
    //outputColor.rgb = blendOverlay(outputColor.rgb, videoColor, 0.8);
    //outputColor.rgb = blendAdd(outputColor.rgb, videoColor, mix(0.2, 0.2, uHold));
    //outputColor.rgb = mix(outputColor.rgb, pow(outputColor.rgb, vec3(1.1)), uHold);

    //outputColor.rgb = pow(vec3(0.05) + outputColor.rgb * 0.5, vec3(1.2));

    outputColor.rgb *= (1.0-vVisible);
    outputColor.rgb = pow(outputColor.rgb*1.2, vec3(1.5));

    #drawbuffer Color gl_FragColor = outputColor;
    #drawbuffer Refraction gl_FragColor = outputColor;
}{@}LogoParticleShader.glsl{@}#!ATTRIBUTES
attribute vec4 random;

#!UNIFORMS
uniform sampler2D tPos;
uniform sampler2D tLightTexture;
uniform sampler2D tPointColor;
uniform sampler2D tMap;
uniform sampler2D tVideo;
uniform vec3 uLightPos;
uniform vec3 uTint;
uniform float DPR;
uniform float uScroll;

#!VARYINGS
varying vec3 vLightColor;
varying vec3 vPos;
varying vec4 vRandom;
varying float vScale;
varying float vDist;
varying float vRipple;
varying vec3 vWorldPos;
varying vec2 vUv;

#!SHADER: Vertex

const float PI = 3.1415926535897932384626433832795;

#require(range.glsl)
#require(lighting.vs)
#require(simplenoise.glsl)

void main() {
    vec4 decodedPos = texture2D(tPos, position.xy);
    vec3 pos = decodedPos.xyz;

    vec3 basePos = pos;

    // pos.x += 1.0;
    // pos.z -= 0.5;

    float offset = pow((1.0 - uScroll), 2.5) * pow(random.x, 20.0) * 6.0;
    offset *= (0.8 + sin(pos.y * 0.2 + time * 0.02 + uScroll + random.z * 2.0) * 0.2);
    pos.y += offset;
    pos.y += pow((1.0 - uScroll), 3.0) * pow(random.w, 1.0);
    pos.y += pow((1.0 - uScroll), 5.0) * 4.0;
    pos.y -= 0.12;

    // float radius = mix(0.5, 3.0, pow(random.w, 2.0));

    pos.x -= cos(pos.y * 2.0) * 0.05 * step(0.7, random.y);
    pos.z -= sin(pos.y * 2.0) * 0.05 * step(0.7, random.y);
    // pos.y -= pow(uScroll, 2.0) * 30.0 * pow(random.w, 40.0);


    pos = mix(pos, basePos, pow(random.z, 200.0));
    pos.y += pow((1.0 - uScroll), 3.0) * 0.1;

    //pos.y += pow(random.x, 2.0) * 10.0 * uScroll;

    //pos += cnoise(pos*5.0+time*0.2) * 0.005;

    vec3 worldPos = vec3(modelMatrix * vec4(pos, 1.0));
    vWorldPos = worldPos;

    float dist = length(worldPos - cameraPosition);
    vDist = dist;
    vUv = uv;

    vRipple = 0.0;
    vPos = pos;
    vRandom = random;

    vScale = smoothstep(3.0, 15.0, dist);
    vScale *= 1.0 + (0.5 + sin(time * 5.0 + vRandom.x * 20.0) * 0.5) * 0.5;
    vScale *= mix(0.1, 2.0, random.z);
    vScale *= mix(1.0, 3.0, vRipple);

    vec4 mvPosition = modelViewMatrix * vec4(pos, 1.0);
    gl_PointSize = (0.035) * DPR * 2.0 * vScale * (1000.0 / length(mvPosition.xyz));
    gl_Position = projectionMatrix * mvPosition;
}

#!SHADER: Fragment

#require(range.glsl)
#require(transformUV.glsl)
#require(simplenoise.glsl)
#require(rgb2hsv.fs)
#require(blendmodes.glsl)
#require(shadows.fs)

void main() {
    vec2 uv = vec2(gl_PointCoord.x, 1.0 - gl_PointCoord.y);
    if (length(uv-0.5) > 0.5) discard;
    if (vScale < 0.1) discard;
    if (length(vWorldPos - vec3(-2.0, 6.0, -2.0)) > 5.0) discard;

    vec3 color = vec3(0.01);

    vec2 screenuv = gl_FragCoord.xy / resolution;

    color += texture2D(tVideo, scaleUV(screenuv, vec2(0.5)) - vWorldPos.zz * 0.3).rgb * 0.5;

    vec3 sparkle = vec3(0.4 + sin(time * 4.0 + vRandom.y * 20.0));
    color *= 0.5 + sparkle * pow(vRandom.z, 20.0) * 1.5;
    //color = min(vec3(0.9), color);

    float noise = cnoise(vWorldPos*0.5-time*0.2+length(vWorldPos) * 0.05);

    // Bubble Texture
    vec2 matcapUV = rotateUV(uv, sin(time * 1.0 + vRandom.z * 20.0) * 0.5 + 1.0);
    vec3 matcap = texture2D(tMap, matcapUV).rgb * 2.0;
    // matcap = mix(matcap, vec3(1.0), 0.5 + sin(time + vRandom.x * 20.0) * 0.4);
    color = blendSoftLight(color, matcap, 0.2);
    color = blendOverlay(color, matcap, 0.1);
    color = rgb2hsv(color);
    color.x += noise * 0.05;
    color = hsv2rgb(color);

    gl_FragColor = vec4(color, 1.0);
}{@}sdfs.glsl{@}vec3 applyQuaternion(vec3 vec, vec4 quat) {
    return vec + 2.0 * cross(quat.xyz, cross(quat.xyz, vec) + quat.w * vec);
}

// Total training time taken: 55.728095 seconds
// Total Loss:  6.774403300369158e-05
float logo_sdf(vec3 p) {
    // Mirror and flip
    p.z = sqrt(p.z * p.z + 0.0215) - sqrt(0.012); // first number is "clip width", second is "seam width"
    p = applyQuaternion(p, vec4(0.5));
  if (length(p) > .8) return length(p)-.7;
  vec4 x=vec4(p,1),
    f00=sin(x*mat4(-.91,-4.0,-.9,-1.09,.49,4.33,-2.8,-.61,-3.86,-1.09,-1.97,.33,-3.62,2.82,-3.46,1.44)),
    f01=sin(x*mat4(1.44,1.65,-5.59,.06,-.49,-5.06,-.79,.42,2.16,.94,8.4,1.65,.88,-6.19,5.45,.51)),
    f02=sin(x*mat4(3.74,1.67,-2.29,-.34,3.25,-2.21,-.4,-.2,-1.51,7.37,-5.42,.19,.34,-1.96,3.46,.5)),
    f10=sin(mat4(.57,-1.33,-.77,-.16,.77,-.88,-.08,.72,.19,-.25,.87,-.38,-.33,.9,.35,.19)*f00+mat4(-.45,-.8,.4,.4,.24,-.58,.17,-.6,-.49,-.03,-.14,.29,.34,.19,.49,.4)*f01+mat4(.72,-.24,.85,.75,.75,1.01,.59,-.53,.09,.09,.49,.69,-.77,.64,.48,-.24)*f02+vec4(1.16,.88,1.41,1.26)),
    f11=sin(mat4(.09,.83,.54,.11,-1.23,-.25,-.52,.63,-.23,-.1,.34,-1.04,-.42,-.4,-.14,.21)*f00+mat4(-.05,.04,.6,-.69,1.06,.4,.68,.01,.25,.28,.04,.06,-.18,-1.16,-.6,.08)*f01+mat4(.02,-.7,.04,.93,.68,.98,.58,-.44,-.44,-1.15,.0,-.68,.87,.95,-.33,.51)*f02+vec4(2.05,.9,-.97,1.33)),
    f12=sin(mat4(-.55,-1.13,.68,.38,.85,.51,-.67,-.45,.06,.29,-1.2,-.21,-.61,.3,.08,-.1)*f00+mat4(-1.13,.32,.06,.15,-.82,.31,-.65,1.67,-.34,-.1,-.12,.37,-.67,-.52,-.67,-.73)*f01+mat4(-.16,-.3,.36,-.54,-.3,-.51,1.23,.45,-1.53,-.52,-.47,-1.08,-.19,.43,-.87,-.55)*f02+vec4(-.04,-.88,-.67,1.62));
  return dot(vec4(.05,.04,.09,.07),f10)+dot(vec4(.07,.08,-.08,.07),f11)+dot(vec4(-.03,-.08,.07,.04),f12)+.01;
}

vec3 logo_norm(vec3 p) {
    mat3 k = mat3(p,p,p)-mat3(0.001);
    return normalize(logo_sdf(p) - vec3(logo_sdf(k[0]),logo_sdf(k[1]),logo_sdf(k[2])));
}
{@}HomeBGShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform float uAlpha;

#!VARYINGS
varying vec2 vUv;
varying vec3 vPos;
varying vec3 vWorldPos;

#!SHADER: Vertex

void main() {
    vUv = uv;
    vPos = position;
    vWorldPos = vec3(modelMatrix * vec4(position, 1.0));
    
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: Fragment

void main() {
    vec2 uv = vUv;
    uv *= 0.5;
    vec4 color = texture2D(tMap, uv);

    color.rgb *= smoothstep(30.0, 0.0, abs(vWorldPos.y-5.0)) * 0.1;
    
    gl_FragColor = color;
    gl_FragColor.a *= uAlpha;
}{@}HomeColumnShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform sampler2D tVideo;
uniform sampler2D tRefraction;
uniform float uAlpha;
uniform float uVisible;
uniform float uOffset;
uniform float uDirection;

#!VARYINGS
varying vec2 vUv;
varying vec3 vPos;
varying vec3 vWorldPos;
varying vec3 vCameraPosition;
varying vec3 vNormal;
varying vec3 vViewDir;
varying float vTop;

#!SHADER: Vertex


void main() {
    vUv = uv;
    vec3 pos = position;

    vTop = smoothstep(9.8, 9.8-2.0*smoothstep(0.8, 1.0, uVisible), pos.y);

    pos.y -= pow((1.0-uVisible), 1.15) * 20.0;

    float radius = mix(1.9, 4.0, smoothstep(10.0, -10.0, pos.y));
    pos.x += cos(-pos.y * 0.32 * uDirection + uOffset) * radius;
    pos.z += sin(-pos.y * 0.32 * uDirection + uOffset) * radius;


    pos.x += cos(-pos.y * 10.0 * uDirection) * 0.1 * pow((1.0-uVisible), 1.25);
    pos.z += sin(-pos.y * 10.0 * uDirection) * 0.1 * pow((1.0-uVisible), 1.25);

    vWorldPos = vec3(modelMatrix * vec4(pos, 1.0));
    vCameraPosition = cameraPosition;
    vPos = pos;
    
    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment

#require(rgbshift.fs)
#require(blendmodes.glsl)
#require(transformUV.glsl)
#require(fresnel.glsl)

void main() {
    vec2 uv = vUv;
    vec2 screenuv = gl_FragCoord.xy / resolution;
    //uv.y += time * 0.1;
    uv.y *= 1.2;
    uv.y += uVisible;

    vec2 texUV = uv;
    texUV.y += time * 0.1 - cameraPosition.y * 0.03;

    vec4 color = texture2D(tRefraction, screenuv);
    vec3 video = texture2D(tVideo, screenuv).rgb;

    float highlight = smoothstep(0.03, 0.0, abs(0.97-uVisible)) * smoothstep(0.8, 1.0, vUv.y); 

    color.rgb += getRGB(tMap, texUV, 0.2, 0.00001).rgb * 0.5;
    color.rgb = pow(color.rgb * mix(0.8, 1.5, highlight), vec3(1.2));
    color.rgb = blendSoftLight(color.rgb, video, 0.7);
    //color.rgb = blendSoftLight(color.rgb, texture2D(tRefraction, screenuv).rgb, 1.0);
    color.rgb += pow(highlight, 2.0) * 0.5 * video;
    color.rgb *= mix(1.0, 1.5, highlight);

    color.a = mix(vTop, 1.0, highlight*0.3);
    color.rgb = pow(0.1 + color.rgb * mix(1.5, 2.5, highlight) * 1.5, vec3(1.5));

    color.a *= uAlpha;

    
    gl_FragColor = color;
    //gl_FragColor.a *= uAlpha;
}{@}HomeComposite.fs{@}uniform sampler2D tDiffuse;
uniform float uRGBStrength;
uniform float uVolumetricStrength;
uniform vec2 uContrast;
uniform sampler2D tVolumetricBlur;

varying vec2 vUv;

#require(rgbshift.fs)
#require(contrast.glsl)
#require(simplenoise.glsl)

void main() {
    vec3 color = texture2D(tDiffuse, vUv).rgb;//getRGB(tDiffuse, vUv, 0.3, 0.000 * uRGBStrength).rgb;
    color = adjustContrast(color, uContrast.x, uContrast.y);
    color += texture2D(tVolumetricBlur, vUv).rgb * uVolumetricStrength;
    gl_FragColor = vec4(color, 1.0);
}{@}HomeLogoShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform sampler2D tVideo;
uniform sampler2D tNormal;
uniform sampler2D tRefraction;
uniform float uAlpha;
uniform float uNormalScale;
uniform float uScrollDelta;
uniform float uVisible;
uniform float uScroll;
uniform float uFooter;
uniform float uPhone;

#!VARYINGS
varying vec2 vUv;
varying vec3 vPos;
varying vec3 vWorldPos;
varying vec3 vNormal;
varying vec3 vViewDir;
varying vec2 vMUV;
varying vec3 vCameraPos;

#!SHADER: Vertex
#require(matcap.vs)

void main() {
    vUv = uv;
    vec3 pos = position;

    pos.x += cos(pos.y * 6.0 + uScrollDelta * 2.0) * 0.005 * uScrollDelta;
    pos.z += sin(pos.y * 6.0 + uScrollDelta * 2.0) * 0.005 * uScrollDelta;

    vPos = pos;
    vWorldPos = vec3(modelMatrix * vec4(pos, 1.0));
    vNormal = normalMatrix * normal;
    vCameraPos = cameraPosition;
    vViewDir = -vec3(modelViewMatrix * vec4(pos, 1.0));
    vMUV = reflectMatcap(vWorldPos, vNormal);
    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment

#require(range.glsl)
#require(simplenoise.glsl)
#require(fresnel.glsl)
#require(rgbshift.fs)
#require(radialblur.fs)
#require(normalmap.glsl)
#require(transformUV.glsl)
#require(blendmodes.glsl)
#require(rgb2hsv.fs)

vec3 rainbowColor(float t) {
    t = mod(t, 1.0); // Wraps the t value between 0.0 and 1.0
    if (t < 0.03) return mix(vec3(0.5, 0.0, 0.5), vec3(0.5, 0.0, 1.0), t / 0.03); // violet to blue
    else if (t < 0.06) return mix(vec3(0.5, 0.0, 1.0), vec3(0.0, 0.0, 1.0), (t - 0.03) / 0.03); // blue to darker blue
    else if (t < 0.09) return mix(vec3(0.0, 0.0, 1.0), vec3(0.0, 1.0, 1.0), (t - 0.06) / 0.03); // darker blue to cyan
    else if (t < 0.12) return mix(vec3(0.0, 1.0, 1.0), vec3(0.0, 1.0, 0.0), (t - 0.09) / 0.03); // cyan to green
    else if (t < 0.18) return mix(vec3(0.0, 1.0, 0.0), vec3(1.0, 1.0, 0.0), (t - 0.12) / 0.06); // green to yellow
    else if (t < 0.24) return mix(vec3(1.0, 1.0, 0.0), vec3(1.0, 0.5, 0.0), (t - 0.18) / 0.06); // yellow to orange
    else return mix(vec3(1.0, 0.5, 0.0), vec3(1.0, 0.0, 0.0), (t - 0.24) / 0.06); // orange to red
}

void main() {
    vec2 uv = vUv;
    vec2 screenuv = gl_FragCoord.xy / resolution;

    vec2 normalUV = scaleUV(mix(screenuv, vUv, 0.5), vec2(0.5)) - vNormal.xy * 0.05 - vViewDir.xy * 0.001;
    //normalUV.y += vCameraPos.y * 0.015;
    normalUV -= time*0.01;
    vec3 normal = crange(texture2D(tNormal, normalUV).rgb, vec3(0.0), vec3(1.0), vec3(-1.0), vec3(1.0));
    uv = rotateUV(uv, vCameraPos.y * 0.2 - 1.5 - time * 0.2);
    uv += normal.xy * 0.02;

    float center = smoothstep(0.4, 0.25, length(vPos));
    float highlight = smoothstep(0.03, 0.0, abs(0.97-uVisible + vPos.y * 0.01));
    
    // Base Color
    vec3 color = texture2D(tRefraction, screenuv - vNormal.xy * 0.05 - normal.xy * 0.005).rgb;

    vec2 baseUv = scaleUV(uv, vec2(2.0)) - vViewDir.xy * 0.05 - vNormal.xy * 0.2;
    color += getRGB(tMap, baseUv, 0.2, 0.002).rgb * smoothstep(0.5, 0.4, abs(0.5-uv.x));

    color *= smoothstep(0.0, 0.1, vUv.x);
    color *= smoothstep(0.75, 0.65, vUv.x);

    // Video Add
    vec3 video = texture2D(tVideo, scaleUV(screenuv, vec2(0.5)) - normal.xy * 0.02).rgb;
    color = blendAdd(color, video, 0.1);
    color = blendSoftLight(color, video, 0.2);

    // Refraction

    // Stylizations
    float f = getFresnel(vNormal, vViewDir, 1.5 + sin(time * 0.1) * 0.3);
    //f += normal.x * 0.1;
    vec3 r = rainbowColor(f*3.0);
    if (r.r > 0.99) r *= 0.0;

    r = rgb2hsv(r);
    r.x += 0.5;
    r = hsv2rgb(r);

    color += r * f * mix(0.8, 2.0, highlight) * mix(0.0, 1.0, uVisible) * 0.4;
    //color *= 1.0 + f * 1.0;
    //color += pow(f, 2.0) * mix(0.4, 0.5, uFooter) * video;
    //color += f * mix(0.2, 0.5, uFooter);
    color += pow(f, 2.0) * mix(0.55, 1.0, uFooter) * mix(video, vec3(1.0), 0.5);
    color += highlight * 0.15;
    //color *= 1.0 + highlight * 5.0 + mix(-0.5, 2.0, center);

    vec3 hueShift = rgb2hsv(color);
    hueShift.y *= 0.9;
    color = hsv2rgb(hueShift);

    color *= mix(0.5, 1.0, uVisible);
    color = pow(color * mix(1.5, 2.5, highlight), vec3(1.8));

    //color *= highlight;
    
    gl_FragColor = vec4(color, uAlpha);
}{@}HomeVideoShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform float uAlpha;

#!VARYINGS
varying vec2 vUv;
varying vec3 vPos;
varying vec3 vWorldPos;

#!SHADER: Vertex

void main() {
    vUv = uv;
    vec3 pos = position;

    pos.z -= (-0.5 + smoothstep(1.0, 0.0, abs(uv.x-0.5))) * 20.0;

    vWorldPos = vec3(modelMatrix * vec4(pos, 1.0));
    
    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);

    vPos = pos;
}

#!SHADER: Fragment

void main() {
    vec2 uv = vUv;
    vec4 color = texture2D(tMap, uv);

    //color.rgb *= smoothstep(0.5, 0.49, abs(uv.x-0.5));
    //color.rgb *= smoothstep(0.5, 0.47, abs(uv.y-0.5));
    color.rgb *= smoothstep(0.5, 0.05, length(uv-0.5));

    color *= uAlpha;

    #drawbuffer Color gl_FragColor = color;
    #drawbuffer HomeRefraction gl_FragColor = color;
    #drawbuffer HomeVolumetricLight gl_FragColor = color;
}{@}JellyShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform sampler2D tMatcap;
uniform sampler2D tVideo;
uniform sampler2D tRefraction;
uniform vec2 uReflection;
uniform float uScroll;
uniform float uDirection;
uniform vec2 uMouse;

#!VARYINGS
varying vec3 vCameraPos;
varying vec3 vViewDir;
varying vec4 vWorldPos;
varying float vDist;
varying float vMouse;

#!SHADER: Vertex

#require(fbr.vs)
#require(simplenoise.glsl)

void main() {
    vec3 pos = position;

    pos.y += cnoise(pos * vec3(0.1, 0.5, 0.1) * 0.8 + time * 0.5 * 0.35) * 0.6;

    pos.x += sin(pos.y + time * 0.1 + uScroll) * 0.1;
    pos.z += cos(pos.y + time * 0.1 + uScroll) * 0.1;

    pos.x += sin(pos.y * 0.04 + time * 0.2) * 1.0;
    pos.z += cos(pos.y * 0.04 + time * 0.2) * 1.0;

    // pos.x += sin(pos.y * 0.04 + time * 0.1) * 5.0;
    // pos.z += cos(pos.y * 0.04 + time * 0.1) * 5.0;
    vWorldPos = modelMatrix * vec4(pos, 1.0);

    vMouse = smoothstep(2.0, 1.0, length(pos.xy-uMouse));

    setupFBR(pos);
    vNormal = normalMatrix * normal;
    vCameraPos = cameraPosition;
    vDist = length(vWorldPos.xyz - cameraPosition);
    vViewDir = -vec3(modelViewMatrix * vec4(pos, 1.0));
    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment

#require(fbr.fs)
#require(rgb2hsv.fs)
#require(transformUV.glsl)
#require(blendmodes.glsl)
#require(fresnel.glsl)

vec3 rainbowColor(float t) {
    t = mod(t, 1.0); // Wraps the t value between 0.0 and 1.0
    if (t < 0.03) return mix(vec3(0.5, 0.0, 0.5), vec3(0.5, 0.0, 1.0), t / 0.03); // violet to blue
    else if (t < 0.06) return mix(vec3(0.5, 0.0, 1.0), vec3(0.0, 0.0, 1.0), (t - 0.03) / 0.03); // blue to darker blue
    else if (t < 0.09) return mix(vec3(0.0, 0.0, 1.0), vec3(0.0, 1.0, 1.0), (t - 0.06) / 0.03); // darker blue to cyan
    else if (t < 0.12) return mix(vec3(0.0, 1.0, 1.0), vec3(0.0, 1.0, 0.0), (t - 0.09) / 0.03); // cyan to green
    else if (t < 0.18) return mix(vec3(0.0, 1.0, 0.0), vec3(1.0, 1.0, 0.0), (t - 0.12) / 0.06); // green to yellow
    else if (t < 0.24) return mix(vec3(1.0, 1.0, 0.0), vec3(1.0, 0.5, 0.0), (t - 0.18) / 0.06); // yellow to orange
    else return mix(vec3(1.0, 0.5, 0.0), vec3(1.0, 0.0, 0.0), (t - 0.24) / 0.06); // orange to red
}

void main() {
    vec3 baseColor = texture2D(tMap, vUv).rgb;
    vec3 color = getFBR(baseColor, vUv);
    vec3 normal = unpackNormalFBR(vEyePos, vWorldNormal, tNormal, uNormalStrength, 1.0, vUv);
    //normal.y -= vWorldPos.y * 0.01;

    vec2 screenuv = gl_FragCoord.xy / resolution;
        screenuv.y = mix(1.0-screenuv.y, screenuv.y, uDirection);
    screenuv.x = mix(1.0-screenuv.x, screenuv.x, uDirection);

    screenuv += normal.xy * 0.01 * uReflection.x;


    float f = pow(getFresnel(vNormal + normal * 0.02, vViewDir, 1.0), 5.0);
    
    color += f * texture2D(tVideo, vUv + normal.xy * 0.1).rgb * 0.9;
    color += texture2D(tRefraction, screenuv).rgb * uReflection.y;
    color = blendSoftLight(color, vec3(1.0), 1.0);
    color = pow(color * 1.5, vec3(1.8));

    color = mix(color, vec3(1.0), vMouse);

    gl_FragColor = vec4(color, 1.0);
}{@}ParticleTestShader.glsl{@}#!ATTRIBUTES
attribute vec4 random;

#!UNIFORMS
uniform sampler2D tPos;
uniform sampler2D tLightTexture;
uniform sampler2D tPointColor;
uniform sampler2D tMap;
uniform sampler2D tVideo;
uniform vec3 uLightPos;
uniform vec3 uTint;
uniform vec3 uLogoPos;
uniform float DPR;
uniform float uScroll;
uniform float uVisible;
uniform float uPulse;
uniform float uSizeBias;

#!VARYINGS
varying vec3 vLightColor;
varying vec3 vPos;
varying vec4 vRandom;
varying float vScale;
varying float vDist;
varying float vRipple;
varying float vRippleDist;
varying vec3 vWorldPos;
varying vec2 vUv;

#!SHADER: Vertex

const float PI = 3.1415926535897932384626433832795;

#require(range.glsl)
#require(lighting.vs)
#require(simplenoise.glsl)

void main() {
    vec4 decodedPos = texture2D(tPos, position.xy);
    vec3 pos = decodedPos.xyz;
    
    float funnel = smoothstep(8.0, 5.0, length(pos.xz));
    //funnel *= smoothstep(4.0, 5.0, length(pos.xz - 2.0));
    float scrollMove = smoothstep(0.9, 0.0, uScroll) * mix(2.0, mix(27.0, -10.0, (1.0-uVisible)), pow(random.y, mix(40.0, 2.0, funnel)));

    pos.y += (1.0-uVisible) * 10.0 * random.w;
    pos.y += scrollMove;
    pos.y += sin(time + random.x * 20.0) * 0.5 * pow(random.w, 30.0);
    pos.y -= smoothstep(0.8, 1.0, uScroll) * 2.0 * pow(funnel, 5.0);

    pos.x += cos(scrollMove * 0.4) * 1.0;
    pos.z += sin(scrollMove * 0.4) * 1.0;

    vec3 worldPos = vec3(modelMatrix * vec4(pos, 1.0));
    vWorldPos = worldPos;

    pos.x += cos(uLogoPos.y * 0.1 + time * 0.1) * smoothstep(5.0, 3.0, length(worldPos - uLogoPos)) * 4.0 * random.w;
    pos.z += sin(uLogoPos.y * 0.1 + time * 0.1) * smoothstep(5.0, 3.0, length(worldPos - uLogoPos)) * 4.0 * random.w;

    float dist = length(worldPos - cameraPosition);
    vDist = dist;
    vUv = uv;

    vec3 ripplePos = vWorldPos;
    ripplePos += cnoise(ripplePos * 0.15 + time * 0.1) * 1.5;
    float rippleDist = length(ripplePos - uLogoPos);
    vRippleDist = rippleDist;
    float ripple = (0.5 + sin(-time * 0.8 + rippleDist * 0.2 - 1.0) * 0.5);
    //ripple += smoothstep(1.0, 0.0, uPulse);
    ripple = pow(ripple, mix(100.0, 200.0, smoothstep(5.0, 25.0, rippleDist)));
    ripple *= smoothstep(25.0, 15.0, rippleDist);
    ripple = pow(ripple, 2.0);
    vRipple = ripple;
    pos.y += ripple * 0.2 * pow(random.w, 4.0);

    vec3 video = texture2D(tVideo, vec2(0.4) + position.xy * 0.2).rgb;
    vec3 viewDir = normalize(cameraPosition - pos);
    vec3 ray = vec3(0.0, 0.0, 0.0) - pos;
    vec3 rayDir = normalize(ray);
    float u = 0.5 + atan(rayDir.z, rayDir.x) / (2.0 * PI);
    float v = 0.5 - asin(rayDir.y) / PI;
    float intensity = smoothstep(5.0, 2.0, length(ray));
    vLightColor = texture2D(tPointColor, position.xy).rgb;
    vLightColor *= 1.4;//mix(1.0, 3.0, smoothstep(0.5, 0.0, vLightColor.g));
    //vLightColor += ;

    //vLightColor += video * smoothstep(10.0, 2.0, length(vWorldPos-vec3(0.0, mix(30.0, 6.0, uScroll), -5.0))) * 0.2;
    vLightColor = mix(vLightColor, video * mix(0.8, 3.0, pow(random.y, 10.0)), ripple * (0.2 + pow(random.z, 5.0)));
    vLightColor = mix(vLightColor, video, smoothstep(10.0, -10.0, vRippleDist) * 0.2);

    vPos = pos;
    vRandom = random;

    vScale = smoothstep(8.0, 15.0, dist);
    vScale *= 1.0 + (0.5 + sin(time * 5.0 + vRandom.x * 20.0) * 0.5) * 0.2;
    vScale += 1.0 * ripple;
    vScale *= mix(1.0, 3.0, pow(random.x, 50.0));

    vScale *= smoothstep(4.0, 5.0, rippleDist);

    vec4 mvPosition = modelViewMatrix * vec4(pos, 1.0);
    gl_PointSize = (0.06) * DPR * 2.0 * vScale * (1000.0 / length(mvPosition.xyz)) * uSizeBias;
    gl_Position = projectionMatrix * mvPosition;
}

#!SHADER: Fragment

#require(range.glsl)
#require(transformUV.glsl)
#require(simplenoise.glsl)
#require(rgb2hsv.fs)
#require(blendmodes.glsl)
#require(shadows.fs)

void main() {
    vec2 uv = vec2(gl_PointCoord.x, 1.0 - gl_PointCoord.y);
    if (length(uv-0.5) > 0.5) discard;
    if (vScale < 0.1) discard;
    if (length(vPos.xz) < 2.5) discard;

    vec3 color = vLightColor;
    color *= 1.0 + vRipple * 0.1;
    //color += vRipple * 0.01;

    vec3 sparkle = vec3(0.4 + sin(time * 3.0 + vRandom.y * 20.0));
    color += sparkle * pow(vRandom.z, 400.0) * vRipple * 0.5;

    vec2 vuv = (uv - vec2(0.5)) / uSizeBias + vec2(0.5);
    vec3 video = texture2D(tVideo, vuv).rgb;
    //video = min(vec3(0.8), video);
    //color = blendSoftLight(color, video, smoothstep(50.0, 0.0, length(vWorldPos-vec3(0.0, 6.0, 0.0))) * 0.8);
    color = blendOverlay(color, video, smoothstep(50.0, 0.0, length(vWorldPos-vec3(0.0, 6.0, 0.0))) * 0.8);
    color = blendOverlay(color, video, 0.4);

    //color = min(vec3(0.9), color);

    float noise = cnoise(vWorldPos*0.05-time*0.2+length(vWorldPos) * 0.05);

    color = rgb2hsv(color);
    color.x += vRipple * 0.05 * vRandom.y - noise * 0.05;
    color.y *= 1.2;
    color.z *= 1.0 + noise * 0.2;
    color = hsv2rgb(color);

    //color *= 1.0 + smoothstep(8.0, 3.0, vRippleDist) * pow((0.5 + sin(time * 5.0 + vRandom.y * 20.0) * 0.5), 5.0) * 5.0;
    //color = min(vec3(0.8), color);

    // Bubble Texture
    vec2 matcapUV = rotateUV(uv, sin(time * 1.0 + vRandom.z * 20.0) * 0.5 + 1.0);
    vec3 matcap = texture2D(tMap, matcapUV).rgb * 2.0;
    //matcap = mix(matcap, vec3(1.0), 0.3 + sin(time + vRandom.x * 20.0) * 0.3);
    color = blendSoftLight(color, matcap, 0.4);
    //color = blendOverlay(color, matcap, 0.2);



    #drawbuffer Color gl_FragColor = vec4(color, 1.0);
    #drawbuffer HomeRefraction gl_FragColor = vec4(color, 1.0);
    // gl_FragColor.rgb *= crange(getShadow(vPos, 0.01), 0.0, 1.0, 0.3, 1.0);
}{@}TriangleParticleShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS

#!VARYINGS

#!SHADER: Vertex
void main() {
    vec3 pos = position;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment
void main() {
    gl_FragColor = vec4(1.0);
}{@}LoaderBGShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform vec3 uColor;
uniform float uAlpha;
uniform float uVisible;
uniform float uScrollDelta;
uniform float uBottom;
uniform float uProgress;
uniform float uHeight;
uniform float uMobile;
uniform float uBars;

#!VARYINGS
varying vec2 vUv;
varying vec3 vPos;
varying vec3 vWorldPos;

#!SHADER: Vertex

void main() {
    vUv = uv;
    vPos = position;
    vWorldPos = vec3(modelMatrix * vec4(position, 1.0));
    
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: Fragment

#require(transformUV.glsl)
#require(simplenoise.glsl)
#require(range.glsl)
#require(rgb2hsv.fs)

// float waveform(vec2 uv, float t) {
//     vec2 waveformUV = uv;
//     // return smoothstep(0.0 + smoothstep(0.6, 0.0, abs(uv.x-0.5)) * 0.08, 0.0, abs(waveformUV.y-0.5)) * 0.5;
// }

const float PI = 3.141592653589793;

float drawLine(vec2 uv, float offset) {
    vec2 circleUv = uv - 0.5;
    // radius of circle
    float r = 0.2; 
    
    // thickness of circle
    float t = 0.0015; 
    
    // half angle
    float a = (35.0 + 17.0*cos(-3.0*t + offset));

    // vector from the circle origin to the middle of the arc
    vec2 up = vec2(cos(1.0*t + offset), sin(-1.0*t + offset));
        
    // cos(angle/2.0), where `angle` is the full arc length
    float c = cos(a*3.1416/180.0); 
    // in particular:
    // c =  1.0 gives a 0 degree arc, 
    // c =  0.0 gives a 180 degree arc, 
    // c = -1.0 gives a 360 degree arc

    c = -0.4;
    
    // smoothing perpendicular to the arc
    float d1 = abs(length(circleUv) - r) - t;
    float w1 = 2.0*fwidth(d1); // proportional to how much `d1` change between pixels
    float s1 = smoothstep(w1/2.0, -w1/2.0, d1); 

    // smoothing along the arc
    float d2 = dot(up, normalize(circleUv)) - c;
    float w2 = 2.0*fwidth(d2); // proportional to how much `d2` changes between pixels
    float s2 = smoothstep(w2/2.0, -w2/2.0, d2); 

    // mix perpendicular and parallel smoothing
    float s = s1*(1.0 - s2);
    return s;
}

void main() {

    float t = time * 0.1 + uProgress * 4.0 + 1.6;
    vec2 uv = scaleUV(vUv, vec2(1.0, resolution.x/resolution.y));
    uv = scaleUV(uv, vec2(mix(0.9, 1.5, uMobile) + (1.0-uVisible) * 0.2));
    uv = rotateUV(uv, uVisible * 3.0);

    vec2 gradientUv = uv;
    gradientUv += cnoise(uv*2.0 - t * 0.1 + length(uv-0.5) * 2.0) * 0.01;
    vec4 color = vec4(vec3(0.0), 1.0);

    vec2 barUV = scaleUV(vUv, vec2(1.0, 1.0));
    barUV = scaleUV(barUV, vec2(1.0 + sin(t * 0.5 - length(barUV-0.5)*30.0) * mix(0.1, 0.4, smoothstep(0.3, 0.1, length(uv-0.5)))));
    barUV = rotateUV(barUV, radians(mix(0.0, 90.0, uMobile)));

    //barUV.x += (1.0/uBars) * 0.5;
    float bars = fract(barUV.x * uBars);
    bars *= (0.5 + sin(t + bars * 10.0 - length(uv-0.5) * 30.0 + t * 1.0) * 0.5);
    
    vec3 rainbow = vec3(0.5, 0.8, 1.0);
    rainbow = rgb2hsv(rainbow);
    rainbow.x += (0.5-bars) * 0.12 + 0.05 + sin(t * 1.0 - bars * 2.0) * 0.05;
    rainbow.x -= length(uv-0.5) * 0.2;
    rainbow.y *= 0.9;
    rainbow = hsv2rgb(rainbow);

    rainbow *= step(0.85, bars) * smoothstep(0.5, 0.3, length(uv-0.5));
    rainbow = mix(rainbow, vec3(1.0), step(0.98, bars) - step(0.9, bars));
    //rainbow *= step(0.92, bars);

    color.rgb += rainbow * step(0.02*uProgress, length(uv-0.5)) * step(0.08, length(uv-0.5)) * (1.0-step(0.4, length(uv-0.5))) * 0.9; 

    // Gradient Corners
    vec3 gradient = vec3(0.5, 0.4, 1.0);
    gradient = rgb2hsv(gradient);
    gradient.x += cnoise(vUv*2.5 - t * 0.04) * 0.05 + 0.87;
    gradient.y *= 0.9;
    gradient = hsv2rgb(gradient);
    //float gNoise = (0.5 + cnoise(uv*2.0 + t * 0.2) * 0.5);
    color.rgb += gradient * step(0.08, length(uv-0.5)) * smoothstep(0.09, 0.08, length(uv-0.5)) * (0.5 + sin(t * 4.0) * 0.3) * 0.5;
    //color.rgb += gradient * 0.5 * smoothstep(0.2, 0.7, length(uv-0.5));

    color.rgb += drawLine(scaleUV(uv, vec2(0.4)), 0.0) * gradient * 0.5;//
    color.rgb += drawLine(scaleUV(uv, vec2(0.4)), 2.0) * gradient * 0.5;///
    color.rgb += drawLine(scaleUV(uv, vec2(0.4)), 4.0) * gradient * 0.5;//
    color.rgb += step(0.2, bars) * 0.06 * smoothstep(0.5, 0.0, length(uv-0.5)) * step(0.08, length(uv-0.5));

    color.rgb *= smoothstep(0.0, 0.4, uProgress);
    color.rgb *= uVisible;
    color.rgb -= getNoise(uv, t) * 0.2;
    color.rgb += 0.03;

    color.rgb *= smoothstep(0.4, 0.0, length(vUv-0.5));

    gl_FragColor = color;
    gl_FragColor.a *= uAlpha;
}{@}LoaderBGShader2.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform vec3 uColor;
uniform float uAlpha;
uniform float uVisible;
uniform float uScrollDelta;
uniform float uBottom;
uniform float uProgress;
uniform float uHeight;
uniform float uMobile;

#!VARYINGS
varying vec2 vUv;
varying vec3 vPos;
varying vec3 vWorldPos;

#!SHADER: Vertex

void main() {
    vUv = uv;
    vPos = position;
    vWorldPos = vec3(modelMatrix * vec4(position, 1.0));
    
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: Fragment

#require(transformUV.glsl)
#require(simplenoise.glsl)
#require(range.glsl)
#require(rgb2hsv.fs)


void main() {
    vec2 uv = scaleUV(vUv, vec2(1.0, resolution.x/resolution.y));
    uv = scaleUV(uv, vec2(mix(0.8, 1.5, uMobile) - (1.0-uVisible) * 0.2));
    uv = scaleUV(uv, vec2(1.0 + sin(time * 4.0 - length(uv-0.5) * 20.0) * 0.05));


    vec3 color = vec3(0.0);
    float len = length(uv-0.5);

    float wave = 0.5 + sin(time * 2.0 - length(uv-0.5) * 20.0) * 0.5;


    float lines = step(0.9, fract(uv.x * resolution.x * 0.025));
    lines *= (0.5 + sin(time + fract(uv.y * resolution.y * 0.025 + time * 2.0 + cnoise(uv - time * 0.5 + len * 50.0)) * 10.0) * 0.5);

    color += wave * lines * step(0.1, len);
    color += smoothstep(0.105, 0.1, len) * 0.5;



    color *= step(0.1, len) * smoothstep(0.7, 0.0, len);



    gl_FragColor = vec4(color, uAlpha);
}{@}LoaderBGShader3.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform vec3 uColor;
uniform float uAlpha;
uniform float uVisible;
uniform float uScrollDelta;
uniform float uBottom;
uniform float uProgress;
uniform float uHeight;
uniform float uMobile;

#!VARYINGS
varying vec2 vUv;
varying vec3 vPos;
varying vec3 vWorldPos;

#!SHADER: Vertex

void main() {
    vUv = uv;
    vPos = position;
    vWorldPos = vec3(modelMatrix * vec4(position, 1.0));
    
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: Fragment

#require(transformUV.glsl)
#require(simplenoise.glsl)
#require(range.glsl)
#require(rgb2hsv.fs)

// float waveform(vec2 uv, float time) {
//     vec2 waveformUV = uv;
//     // return smoothstep(0.0 + smoothstep(0.6, 0.0, abs(uv.x-0.5)) * 0.08, 0.0, abs(waveformUV.y-0.5)) * 0.5;
// }

const float PI = 3.141592653589793;

float drawLine(vec2 uv, float offset) {
    vec2 circleUv = uv - 0.5;
    float r = 0.2; 
    float t = 0.003; 
    float a = (35.0 + 17.0*cos(-3.0*time + offset));
    vec2 up = vec2(cos(-3.0*time + offset), sin(-3.0*time + offset));
    float c = cos(time - radians(81.0 + time * 1.0)); 
    
    float d1 = abs(length(circleUv) - r) - t;
    float w1 = 2.0*fwidth(d1); // proportional to how much `d1` change between pixels
    float s1 = smoothstep(w1/2.0, -w1/2.0, d1); 

    float d2 = dot(up, normalize(circleUv)) - c;
    float w2 = 2.0*fwidth(d2); // proportional to how much `d2` changes between pixels
    float s2 = smoothstep(w2/2.0, -w2/2.0, d2); 

    float s = s1*(1.0 - s2);
    return s;
}

void main() {
    vec2 uv = scaleUV(vUv, vec2(1.0, resolution.x/resolution.y));
    uv = scaleUV(uv, vec2(mix(0.8, 1.5, uMobile) - (1.0-uVisible) * 0.2));
    uv = scaleUV(uv, vec2(1.0 + sin(time * 3.0 - length(uv-0.5) * 20.0) * 0.06));

    //uv = rotateUV(uv, uVisible * 3.0);

    // Gradient Corners
    vec3 gradient = vec3(0.5, 0.4, 1.0);
    gradient = rgb2hsv(gradient);
    gradient.x += cnoise(vUv*3.0 + length(uv-0.5) * 30.0 - time * 0.2) * 0.1 + 0.8;
    gradient.y *= 0.8;
    gradient = hsv2rgb(gradient);

    vec3 color = vec3(0.0);

    color += drawLine(scaleUV(uv, vec2(0.4)), 0.0) * gradient * 0.5;//
    color += drawLine(scaleUV(uv, vec2(0.4)), 2.0) * gradient * 0.5;///
    color += drawLine(scaleUV(uv, vec2(0.4)), 4.0) * gradient * 0.5;//

    float len = length(uv-0.5);
    float wave = 0.5 + sin(time * 1.0 - length(uv-0.5) * 20.0) * 0.5;
    float lines = step(0.85, fract(uv.x * resolution.x * 0.02));
    lines *= (0.5 + sin(time + fract(uv.y * resolution.y * 0.005 + time * 1.0 + cnoise(uv - time * 0.5 + len * 50.0) * 0.05) * 10.0) * 0.5);
    color += wave * lines * step(0.1, len) * gradient * smoothstep(0.7, 0.1, len);

    color.rgb *= smoothstep(0.0, 0.4, uProgress);
    color.rgb *= uVisible;
    color.rgb -= getNoise(uv, time) * 0.2;

    color.rgb += 0.05;

    gl_FragColor = vec4(color, uAlpha);
}{@}LoaderBGShader4.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform vec3 uColor;
uniform float uAlpha;
uniform float uVisible;
uniform float uScrollDelta;
uniform float uBottom;
uniform float uProgress;
uniform float uHeight;
uniform float uMobile;

#!VARYINGS
varying vec2 vUv;
varying vec3 vPos;
varying vec3 vWorldPos;

#!SHADER: Vertex

void main() {
    vUv = uv;
    vPos = position;
    vWorldPos = vec3(modelMatrix * vec4(position, 1.0));
    
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: Fragment

#require(transformUV.glsl)
#require(simplenoise.glsl)
#require(range.glsl)
#require(rgb2hsv.fs)
#require(blendmodes.glsl)

const float PI = 3.141592653589793;

float drawLine(vec2 uv, float offset) {
    vec2 circleUv = uv - 0.5;
    float r = 0.2; 
    float t = 0.003; 
    float a = (35.0 + 17.0*cos(-3.0*time + offset));
    vec2 up = vec2(cos(-3.0*time + offset), sin(-3.0*time + offset));
    float c = cos(time - radians(81.0 + time * 1.0)); 
    
    float d1 = abs(length(circleUv) - r) - t;
    float w1 = 2.0*fwidth(d1); // proportional to how much `d1` change between pixels
    float s1 = smoothstep(w1/2.0, -w1/2.0, d1); 

    float d2 = dot(up, normalize(circleUv)) - c;
    float w2 = 2.0*fwidth(d2); // proportional to how much `d2` changes between pixels
    float s2 = smoothstep(w2/2.0, -w2/2.0, d2); 

    float s = s1*(1.0 - s2);
    return s;
}

float waveform(vec2 uv, float time) {
    vec2 waveformUV = uv;
    waveformUV.y += sin(waveformUV.x * 10.0 + time * 4.0 + (1.0-uVisible) * 2.0) * mix(0.012, 0.022, smoothstep(0.5, 0.0, vUv.y));// * smoothstep(0.7, 0.0, abs(waveformUV.x-0.5));
    float wave = smoothstep(0.0 + smoothstep(0.6, 0.2, abs(uv.x-0.5)) * 0.03, 0.0, abs(waveformUV.y-0.5)) * 0.5;
    return wave;
}

void main() {
    vec3 color = vec3(0.0);

    vec2 uv = rotateUV(vUv, radians(90.0));
    uv.x += (0.63 - 0.3 * (1.0-uVisible));

    float t = time * 0.5;
    color += waveform(uv, t);
    color += waveform(uv, t + sin(t * 2.0 + uv.x * 1.0) * 0.3);
    color += waveform(uv, t + cos(t * 2.0 + uv.x * 1.0) * 0.3);

    // vec2 lineUV = vUv;
    // lineUV.y += 0.02 * (1.0-pow(uVisible, 5.0));
    // color += drawLine(scaleUV(lineUV, vec2(0.4)), 0.0) * 0.4 * pow(uVisible, 20.0);//
    // color += drawLine(scaleUV(lineUV, vec2(0.4)), 2.0) * 0.4 * pow(uVisible, 20.0);///
    // color += drawLine(scaleUV(lineUV, vec2(0.4)), 4.0) * 0.4 * pow(uVisible, 20.0);//

    color.rgb -= getNoise(uv, time) * 0.5;
    color.rgb += 0.1;
    vec3 gradient = vec3(0.1, 1.0, 1.0);

    gradient = rgb2hsv(gradient);
    gradient.x += color.r * 0.45 - 0.15;
    gradient = hsv2rgb(gradient);

    color.rgb = blendOverlay(color.rgb, gradient, 0.8);




    //color.rgb *= smoothstep(-0.5, 0.4, vUv.y * uAlpha);

    //color = mix(color, vec3(0.0, 1.0, 1.0), pow(color.r, 5.0));

    gl_FragColor = vec4(color, uAlpha);
}{@}NavAudioShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform vec3 uColor;
uniform float uScroll;
uniform float uAmplitude;
uniform float uAlpha;
uniform float uHover;

#!VARYINGS
varying vec2 vUv;
varying vec3 vPos;
varying vec3 vWorldPos;

#!SHADER: Vertex

void main() {
    vUv = uv;
    vPos = position;
    vWorldPos = vec3(modelMatrix * vec4(position, 1.0));
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: Fragment

#require(simplenoise.glsl)
#require(range.glsl)
#require(rgb2hsv.fs)


float waveform(vec2 uv, float time) {
    vec2 waveformUV = uv;
    waveformUV.y += sin(waveformUV.x * 6.0 + time * 4.0) * mix(0.06, 0.09, uHover) * uAmplitude - 0.03;// * smoothstep(0.7, 0.0, abs(waveformUV.x-0.5));

    float wave = smoothstep(0.0 + smoothstep(0.6, 0.2, abs(uv.x-0.5)) * 0.05, 0.0, abs(waveformUV.y-0.5)) * mix(0.5, 0.7, uHover);

    wave = mix(wave, smoothstep(0.01, 0.0, abs(waveformUV.y-0.5)), 1.0-uAmplitude);

    return wave;//* smoothstep(0.0, 1.0, uv.x);
    //return step(0.25, mod(waveformUV.y, 0.3));
}

void main() {
    vec2 uv = vUv;

    vec3 color = uColor;

    vec3 rainbow = vec3(0.7, 0.8, 1.0);
    rainbow = rgb2hsv(rainbow);
    rainbow.x += sin(uv.x * 5.0 + time * 3.0) * 0.08;
    rainbow = hsv2rgb(rainbow);

    float alpha = 0.0;
    float t = time * 0.5 + uScroll * 0.3;
    alpha += waveform(uv, t);
    alpha += waveform(uv, t + sin(t * 2.0 + uv.x * 1.0) * 0.4);
    alpha += waveform(uv, t + cos(t * 2.0 + uv.x * 1.0) * 0.4);
    //alpha += waveform(uv, time + 2.0);
    // alpha = 0.5 + sin(uv.x * 5.0 + time * 10.0) * 0.5;
    // alpha *= 0.5 + cos(abs(uv.y-0.5) * 20.0 + time * 10.0) * 0.5;

    alpha *= uAlpha;

    color = mix(color, rainbow, smoothstep(1.0, -1.0, abs(alpha-0.5)));

    gl_FragColor = vec4(color, alpha);
}{@}NavBGShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform vec3 uColor;
uniform float uAlpha;
uniform float uScroll;
uniform float uScrollDelta;
uniform float uBottom;
uniform float uDisabled;
uniform float uHeight;
uniform vec3 uUIColor;
uniform float uUIBlend;

#!VARYINGS
varying vec2 vUv;
varying vec3 vPos;
varying vec3 vWorldPos;

#!SHADER: Vertex

void main() {
    vUv = uv;
    vPos = position;
    vWorldPos = vec3(modelMatrix * vec4(position, 1.0));
    
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: Fragment

#require(transformUV.glsl)
#require(simplenoise.glsl)
#require(range.glsl)
#require(rgb2hsv.fs)

float innerRoundedRectangle(vec2 p, vec2 size, float radius, float stepper) {
    vec2 q = abs(p) - size + radius;
    return step(stepper, length(max(q, 0.0)) - radius);
}

void main() {
    vec2 uv = vUv;
    vec4 color = vec4(0.0);

    //float innerClip = step(0.4, abs(uv.x-0.5));
    //innerClip = max(innerClip, step(0.3, abs(uv.y-0.5)));
    
    vec2 innerUV = uv;
    innerUV.y += smoothstep(1.1, 0.0, abs(uv.x-0.5)) * 0.03 * uScrollDelta;

    //innerUV += cnoise(uv*2.0+time*0.2) * 0.01;
    vec2 innerScale = vec2(0.7, uHeight);
    vec2 innerOffset = vec2(1.0, 1.0 + uScrollDelta * 0.03);
    float innerClip = innerRoundedRectangle(scaleUV(innerUV, vec2(0.5, 0.5), innerOffset), innerScale, innerScale.y, 0.0);
    float innerClip2 = innerRoundedRectangle(scaleUV(innerUV, vec2(0.5, 0.5), innerOffset), innerScale, innerScale.y, 0.01);

    vec2 bgUV = scaleUV(innerUV, vec2(1.0, 0.4), vec2(1.0, mix(0.45, 0.57, uBottom) + uScrollDelta * 0.025));

    vec3 rainbow = vec3(0.65, 1.0, 0.9);
    rainbow = rgb2hsv(rainbow);
    rainbow.x += cnoise(-bgUV*0.5-bgUV.y*0.5-time*0.05-uScroll*0.3+length(bgUV-0.2)*0.2) * 0.2;
    rainbow = hsv2rgb(rainbow);

    rainbow = mix(rainbow, mix(uUIColor * 1.2, vec3(1.0), 0.2), uUIBlend * 0.8);

    color = mix(color, vec4(rainbow, 0.5), smoothstep(0.65, abs(uScrollDelta * 0.02) - 0.2, length(bgUV-0.5)));
    color = mix(color, vec4(rainbow, 0.8), smoothstep(0.25, 0.0, length(bgUV-0.5)));
    color = mix(color, vec4(rainbow, 0.3 + abs(uScrollDelta * 0.08)), 1.0-innerClip2);

    vec4 inner = vec4(uColor, 0.7);
    vec2 barUV = scaleUV(vUv, vec2(1.0, 1.0));
    barUV.y -= uScroll * 0.2 - time * 0.02;
    float bars = sin(barUV.x * 500.0) * cnoise(barUV*30.0 + time * 0.2 + abs(barUV.y-0.5) * 4.0);
    color += vec4(mix(rainbow, vec3(1.0), 0.5), step(0.9, bars)) * (abs(uScrollDelta) * 0.05 + 0.2) * innerClip2 * smoothstep(0.7, 0.2, length(bgUV-0.5));

    color = mix(color, inner, 1.0-innerClip);
    color.a *= mix(1.0, 0.1, uDisabled);

    gl_FragColor = color;
    gl_FragColor.a *= uAlpha;
}{@}FloatingParticles.glsl{@}#!ATTRIBUTES
attribute vec4 random;

#!UNIFORMS
uniform sampler2D tPos;
uniform sampler2D tPointColor;
uniform float DPR;


#!VARYINGS
varying vec3 vLightColor;
varying vec3 vPos;
varying vec4 vRandom;
varying float vScale;
varying float vDist;
varying float vRipple;
varying vec3 vWorldPos;
varying vec2 vUv;

#!SHADER: Vertex

const float PI = 3.1415926535897932384626433832795;

#require(range.glsl)
#require(lighting.vs)
#require(simplenoise.glsl)

void main() {
    vec4 decodedPos = texture2D(tPos, position.xy);
    vec3 pos = decodedPos.xyz;

    pos += cnoise(pos*0.1+time*0.2) * 0.2;

    // pos.x += 1.0;
    // pos.z -= 0.5;

    // float offset = (1.0 - uScroll) * pow(random.x, 100.0) * 50.0;
    // offset *= (0.8 + sin(pos.y * 0.2 + time * 0.02 + uScroll + random.z * 2.0) * 0.2);
    // pos.y += offset;

    // float radius = mix(0.5, 3.0, pow(random.w, 2.0));

    // pos.x -= cos(pos.y * 0.5) * 12.0 * step(0.98, random.y);
    // pos.z -= sin(pos.y * 0.5) * 12.0 * step(0.98, random.y);
    // pos.y -= pow(uScroll, 2.0) * 30.0 * pow(random.w, 40.0);

    vec3 worldPos = vec3(modelMatrix * vec4(pos, 1.0));
    vWorldPos = worldPos;

    float dist = length(worldPos - cameraPosition);
    vDist = dist;
    vUv = uv;

    vRipple = 0.0;
    vPos = pos;
    vRandom = random;

    vScale = smoothstep(3.0, 15.0, dist);
    vScale *= 1.0 + (0.5 + sin(time * 5.0 + vRandom.x * 20.0) * 0.5) * 0.5;
    vScale *= mix(0.1, 1.5, random.z);
    vScale *= mix(1.0, 3.0, vRipple);

    vec4 mvPosition = modelViewMatrix * vec4(pos, 1.0);
    gl_PointSize = (0.02) * DPR * 2.0 * vScale * (1000.0 / length(mvPosition.xyz));
    gl_Position = projectionMatrix * mvPosition;
}

#!SHADER: Fragment

#require(range.glsl)
#require(transformUV.glsl)
#require(simplenoise.glsl)
#require(rgb2hsv.fs)
#require(blendmodes.glsl)
#require(shadows.fs)

void main() {
    vec2 uv = vec2(gl_PointCoord.x, 1.0 - gl_PointCoord.y);
    if (length(uv-0.5) > 0.5) discard;
    if (vScale < 0.1) discard;

    vec3 color = vec3(0.3);
    color *= 1.0 + vRipple * 0.5;
    color *= smoothstep(0.5, 0.2, length(uv-0.5));
    //color += vRipple * 0.01;

    vec3 sparkle = vec3(0.4 + sin(time * 2.0 + vRandom.y * 20.0));
    color *= sparkle * vRandom.z;
    color = min(vec3(0.9), color);

    float noise = cnoise(vWorldPos*0.5-time*0.2+length(vWorldPos) * 0.05);

    gl_FragColor = vec4(color, 1.0);
}{@}TreeFBR.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tBaseColor;
uniform sampler2D tVideo;
uniform float uWobble;
uniform float uScroll;

#!VARYINGS
varying vec3 vWorldPos;

#!SHADER: Vertex

#require(fbr.vs)

void main() {
    vec3 pos = position;
    setupFBR(position);
    vWorldPos = vec3(modelMatrix * vec4(pos, 1.0));

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
    
}

#!SHADER: Fragment

#require(fbr.fs)
#require(rgb2hsv.fs)
#require(transformUV.glsl)
#require(blendmodes.glsl)

void main() {
    vec3 baseColor = texture2D(tBaseColor, vUv).rgb;

    vec3 color = getFBR(baseColor, vUv);
    vec3 video = texture2D(tVideo, (vWorldPos.xz * 0.025) + vec2(0.5)).rgb;

    color = rgb2hsv(color);
    video = rgb2hsv(video);
    //color.x *= 0.1;
    //color.x = color.x * 0.05 + video.x;
    //color.y = video.y * 0.8;

    color.x = 0.0;
    color.y = 0.0;
    //color.z *= mix(1.0, video.z, smoothstep(30.0, 0.0, length(vWorldPos)) * 0.1);
    float saturation = color.y;
    color = hsv2rgb(color);
    video = hsv2rgb(video);


    video *= smoothstep(16.0, 5.0, vWorldPos.y);

    color = blendOverlay(color, video, 0.5);
    color = blendSoftLight(color, video, 0.5);
    color = blendAdd(color, baseColor, 0.1);

    color = pow(color*1.0, vec3(1.0));
    color *= smoothstep(13.0, 4.0, length(vWorldPos-vec3(-3.0, 15.0 - uScroll * 20.0, 0.0)));
    color *= smoothstep(25.0, 10.0, length(vWorldPos-vec3(-3.0, -2.0, 0.0)));
    color *= 1.25;




    gl_FragColor = vec4(color, 1.0);
}{@}TreeParticleShader.glsl{@}#!ATTRIBUTES
attribute vec4 random;

#!UNIFORMS
uniform sampler2D tPos;
uniform sampler2D tLightTexture;
uniform sampler2D tPointColor;
uniform sampler2D tMap;
uniform vec3 uLightPos;
uniform vec3 uTint;
uniform float DPR;
uniform float uScroll;

#!VARYINGS
varying vec3 vLightColor;
varying vec3 vPos;
varying vec4 vRandom;
varying float vScale;
varying float vDist;
varying float vRipple;
varying vec3 vWorldPos;
varying vec2 vUv;

#!SHADER: Vertex

const float PI = 3.1415926535897932384626433832795;

#require(range.glsl)
#require(lighting.vs)
#require(simplenoise.glsl)

void main() {
    vec4 decodedPos = texture2D(tPos, position.xy);
    vec3 pos = decodedPos.xyz;

    // pos.x += 1.0;
    // pos.z -= 0.5;

    // float offset = (1.0 - uScroll) * pow(random.x, 100.0) * 50.0;
    // offset *= (0.8 + sin(pos.y * 0.2 + time * 0.02 + uScroll + random.z * 2.0) * 0.2);
    // pos.y += offset;

    // float radius = mix(0.5, 3.0, pow(random.w, 2.0));
    // //pos.x += cos(pos.y * 0.6) * offset * radius * random.w;
    // //pos.z += sin(pos.y * 0.6) * offset * radius * random.w;

    // pos.x -= cos(pos.y * 0.5) * 12.0 * step(0.98, random.y);
    // pos.z -= sin(pos.y * 0.5) * 12.0 * step(0.98, random.y);

    // pos.y -= pow(uScroll, 2.0) * 30.0 * pow(random.w, 40.0);


    vec3 worldPos = vec3(modelMatrix * vec4(pos, 1.0));
    vWorldPos = worldPos;

    float dist = length(worldPos - cameraPosition);
    vDist = dist;
    vUv = uv;

    vRipple = 0.0;//0.5 + sin(length(vWorldPos.xz) * 2.0) * 0.5;

    vec3 viewDir = normalize(cameraPosition - pos);
    vec3 ray = vec3(0.0, 0.0, 0.0) - pos;
    vec3 rayDir = normalize(ray);
    float u = 0.5 + atan(rayDir.z, rayDir.x) / (2.0 * PI);
    float v = 0.5 - asin(rayDir.y) / PI;
    float intensity = smoothstep(5.0, 2.0, length(ray));
    vLightColor = texture2D(tPointColor, position.xy).rgb;
    //vLightColor += ;

    vPos = pos;
    vRandom = random;

    vScale = smoothstep(3.0, 15.0, dist);
    vScale *= 1.0 + (0.5 + sin(time * 5.0 + vRandom.x * 20.0) * 0.5) * 0.5;
    vScale *= mix(0.5, 1.5, random.z);
    vScale *= mix(1.0, 3.0, vRipple);

    vec4 mvPosition = modelViewMatrix * vec4(pos, 1.0);
    gl_PointSize = (0.05) * DPR * 2.0 * vScale * (1000.0 / length(mvPosition.xyz));
    gl_Position = projectionMatrix * mvPosition;
}

#!SHADER: Fragment

#require(range.glsl)
#require(transformUV.glsl)
#require(simplenoise.glsl)
#require(rgb2hsv.fs)
#require(blendmodes.glsl)
#require(shadows.fs)

void main() {
    vec2 uv = vec2(gl_PointCoord.x, 1.0 - gl_PointCoord.y);
    if (length(uv-0.5) > 0.5) discard;
    if (vScale < 0.1) discard;

    vec3 color = vLightColor;
    color *= 1.0 + vRipple * 0.5;
    //color += vRipple * 0.01;

    vec3 sparkle = vec3(0.4 + sin(time * 3.0 + vRandom.y * 20.0));
    color += sparkle * pow(vRandom.z, 200.0) * vRipple * 0.5;
    color = min(vec3(0.9), color);

    float noise = cnoise(vWorldPos*0.5-time*0.2+length(vWorldPos) * 0.05);

    // Bubble Texture
    vec2 matcapUV = rotateUV(uv, sin(time * 1.0 + vRandom.z * 20.0) * 0.5 + 1.0);
    vec3 matcap = texture2D(tMap, matcapUV).rgb * 2.0;
    // matcap = mix(matcap, vec3(1.0), 0.5 + sin(time + vRandom.x * 20.0) * 0.4);
    color = blendSoftLight(color, matcap, 0.5);
    color = blendOverlay(color, matcap, 0.1);

    color = rgb2hsv(color);
    color.x += noise * 0.05;
    color = hsv2rgb(color);

    #drawbuffer Color gl_FragColor = vec4(color, 1.0);
    #drawbuffer WorkRefraction gl_FragColor = vec4(color, 1.0);
    // gl_FragColor.rgb *= crange(getShadow(vPos, 0.01), 0.0, 1.0, 0.3, 1.0);
}{@}TreeSceneComposite.fs{@}uniform sampler2D tDiffuse;
uniform float uRGBStrength;
uniform vec2 uContrast;

varying vec2 vUv;

#require(UnrealBloom.fs)
#require(rgbshift.fs)
#require(contrast.glsl)
#require(simplenoise.glsl)

void main() {
    vec3 color = getRGB(tDiffuse, vUv, 0.3, -0.0002).rgb;
    color = adjustContrast(color, uContrast.x, uContrast.y);
    // color += pow(getUnrealBloom(vUv), vec3(1.1)) * 0.4;

    gl_FragColor = vec4(color, 1.0);
}{@}TreeWaterShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tWaterNormal;
uniform sampler2D tVideo;
uniform float uSpeed; 
uniform float uScale;
uniform float uWaterUVStrength;
uniform float uMouseUVStrength;
uniform float uBrightness;
uniform sampler2D tMirrorReflection;
uniform mat4 uMirrorMatrix;

#!VARYINGS
varying vec3 vNormal;
varying vec2 vUv;
varying vec4 vMirrorCoord;

#!SHADER: Vertex

#require(fbr.vs)

void main() {
    vUv = uv;
    vec3 pos = position;
    vec4 worldPos = modelMatrix * vec4(pos, 1.0);
    setupFBR(pos);
    vMirrorCoord = uMirrorMatrix * worldPos;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment

#require(waternormals.fs)
#require(fbr.fs)
#require(transformUV.glsl)

void main() {
    vec2 uv = vMirrorCoord.xy / vMirrorCoord.w;

    vec3 normal = getWaterNormal(tWaterNormal, vUv, uSpeed*0.05, uScale * 0.8);
    uv -= normal.xy * 0.015 * uWaterUVStrength;
    uv.y -= 0.04;

    vec3 baseColor = texture2D(tMirrorReflection, uv).rgb * uBrightness;
    vec3 color = getFBR(baseColor, vec2(1.0), normal);

    color = mix(color, baseColor * 0.8, 0.2);
    color *= 0.9;
    //color += 


    // vec3 video = texture2D(tVideo, scaleUV(vUv, vec2(20.0))).rgb;
    // color *= video;



    gl_FragColor = vec4(color, 1.0);
}{@}TubeOrbShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform float uAlpha;

#!VARYINGS
varying vec2 vUv;
varying vec3 vPos;
varying vec3 vWorldPos;

#!SHADER: Vertex

void main() {
    vUv = uv;
    vPos = position;
    vWorldPos = vec3(modelMatrix * vec4(position, 1.0));
    
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: Fragment

void main() {
    vec2 uv = vUv;
    vec4 color = texture2D(tMap, uv);
    
    gl_FragColor = vec4(1.0);//color;
    //gl_FragColor.a *= uAlpha;
}{@}TubeShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tColor;
uniform sampler2D tRefraction;

#!VARYINGS
varying vec2 vUv;
varying vec2 vUv2;
varying float vLife;
varying float vLength;
varying vec3 vPos;
varying vec3 vWorldPos;

#!SHADER: Vertex

#require(fbr.vs)

void main() {
    setupFBR(pos);
    vPos = pos;
    vWorldNormal = mat3(modelMatrix[0].xyz, modelMatrix[1].xyz, modelMatrix[2].xyz) * transformedNormal;
    vWorldPos = vec3(modelMatrix * vec4(pos, 1.0));
}

#!SHADER: Fragment

#require(fbr.fs)
#require(range.glsl)
#require(blendmodes.glsl)
#require(rgb2hsv.fs)

void main() {
    vec3 myColor = texture2D(tColor, vUv2).rgb;
    vec3 color = getFBR(vec3(0.2), vUv * 5.0);
    //color = mix(vec3(1.0), color, step(vUv.x, 0.99));

    float b = crange(vLife, 0.1, 0.2, 0.0, 1.0);
    float tb = rangeTransition(b, vLength, 0.01);
    if (tb < 0.5) discard;

    vec2 ruv = gl_FragCoord.xy / resolution;
    ruv += vNormal.xy * 0.1;
    color += texture2D(tRefraction, ruv).rgb;

    color = blendOverlay(color, myColor, 1.0);
    color = mix(myColor, color, 1.0-(step(vUv.x, 0.98) - step(vUv.x, 0.9)));

    color = rgb2hsv(color);
    color.x -= vLength * 0.2 + sin(time * 0.2 + length(vWorldPos) * 0.1) * 0.1;
    color.y *= 0.7;
    color = hsv2rgb(color);

    color += sin(-time * 6.0 + vLength * 4.0 + length(vWorldPos)) * 0.1;
    color *= smoothstep(0.0, 0.3, vLife);
    color = pow(color, vec3(mix(1.0, 2.0, vLength)));


    #drawbuffer Color gl_FragColor = vec4(color, 1.0);
    #drawbuffer HomeRefraction gl_FragColor = vec4(color, 1.0);
    #drawbuffer HomeVolumetricLight gl_FragColor = vec4(color * 0.35, 1.0);
}{@}GlobalComposite.fs{@}uniform sampler2D tDiffuse;
uniform float uRGBStrength;
uniform float uVolumetricStrength;
uniform vec2 uContrast;
uniform float uScroll;
uniform float uContact;
uniform float uScrollDelta;
uniform vec2 uMouse;
uniform vec3 uFrostCorner;
uniform sampler2D tFluid;
uniform sampler2D tFluidMask;
uniform sampler2D tNormal; //repeat
uniform float uNormalScale;
uniform float uVisible;
uniform float uChatOpen;
uniform sampler2D tLightStreak;
uniform vec2 uGradient;
uniform float uMobile;
uniform vec3 uUIColor;
uniform float uUIBlend;
uniform float uSyncTouch;


varying vec2 vUv;

#require(rgbshift.fs)
#require(contrast.glsl)
#require(simplenoise.glsl)
#require(UnrealBloom.fs)
#require(transformUV.glsl)
#require(rgb2hsv.fs)
#require(normalmap.glsl)
#require(range.glsl)
#require(blendmodes.glsl)

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}
                        

void main() {
    vec2 squareUV = scaleUV(vUv, vec2(1.4, resolution.x/resolution.y));
    vec2 uv = scaleUV(vUv, vec2(1.0 + uContact*mix(0.01, 0.06, uMobile) + uContact*0.1*smoothstep(1.0, 0.1, length(squareUV-0.5))));

    vec2 fluid = texture2D(tFluid, uv).xy;
    float fluidMask = smoothstep(0.0, 1.0, texture2D(tFluidMask, uv).r);
    float fluidPush = pow(abs(fluid.x)*0.01, 2.0);
    float fluidPushY = pow(abs(fluid.x)*0.01, 2.0);
    float fluidEdge = fluidPush * smoothstep(0.7, 0.0, abs(fluidMask-0.5));

    // Frosted Effects
    float normalScale = uNormalScale * 1.0 * mix(0.15, 0.2, uMobile);
    normalScale *= crange(resolution.x, 1000.0, 5000.0, 1.0, 0.35);
    normalScale *= 1.0 - (1.0-uContact) * 0.06;
    vec2 normalUV = scaleUV(squareUV, vec2(normalScale));

    vec3 normal = crange(texture2D(tNormal, normalUV).rgb, vec3(0.0), vec3(1.0), vec3(-1.0), vec3(1.0));
    float frost = smoothstep(0.3, 0.0, length(vUv-vec2(1.0)));
    frost += smoothstep(0.4, 0.0, length(vUv-vec2(0.0))) * uChatOpen * 0.4;
    frost = mix(frost * 0.08, 0.14 + fluidEdge * 2.2, pow(uContact, 3.0));
    frost *= 1.0 + sin(time - length(squareUV-0.5) * 30.0 + uScroll * 5.0) * 0.9;
    uv += normal.xy * frost * 0.5;
    uv += uContact * fluidEdge * 0.05;

    // Pixel Sort Effects
    //uv.x -= mod(uv.x, resolution.x/200000.0) * pow((1.0-uVisible), 5.0) * random(uv) * 100.0;
    vec3 color = getRGB(tDiffuse, uv, radians(120.0), fluidEdge * 0.01 * uContact + 0.00 * uRGBStrength + 0.0001 * uScrollDelta - 0.0005 * uContact).rgb;
    color = adjustContrast(color, uContrast.x, uContrast.y);
    color *= mix(1.0, 0.3, pow(uContact, 3.0));

    // Corner Glows
    vec3 gradient = vec3(0.5, 0.5, 1.0);
    gradient = rgb2hsv(gradient);
    gradient.x += cnoise(squareUV*0.65 - time * 0.04 + uContact * 0.2) * 0.065 + 0.88;
    gradient = hsv2rgb(gradient);
    gradient = mix(gradient, uUIColor, uUIBlend * 0.75);

    // Glows
    color += pow(getUnrealBloom(uv), vec3(1.8)) * mix(1.0, 1.1, fluidEdge);
    color += pow(texture2D(tLightStreak, uv).rgb, vec3(1.25));

    // Contact Stylization
    color = pow(color, vec3(1.0 + uContact * 0.3));
    //color = blendOverlay(color, vec3(1.0), (normal.y + normal.x) * smoothstep(0.5, -0.05, abs(uContact-0.5)));

    // Gradient Corners
    vec2 noiseUV = rotateUV(squareUV, radians(15.0));
    float gNoise = (0.5 + cnoise(noiseUV*mix(1.1, 0.6, uMobile) + time * 0.03 + uScroll * 0.08 + uContact * 0.2) * 0.5);
    vec2 gradientUV = squareUV;
    float cornerNoise = 0.7 * mix(1.6, 1.5, uMobile) * smoothstep(uGradient.x, uGradient.y * 0.9, length(gradientUV-0.5));;
    color = blendAdd(color, gradient, 0.05 + pow(cornerNoise * gNoise, 2.0));

    // Work Stuff
    vec3 cornerColor = mix(vec3(0.15, 0.11, 0.25), mix(uUIColor, vec3(0.1), 0.8), uUIBlend * 0.9);
    vec2 cornerUV = scaleUV(squareUV, vec2(1000.0/resolution.x));
    cornerUV = scaleUV(squareUV, vec2(1.0, 1.3), vec2(0.0));
    cornerUV += fluidEdge * 0.2;
    float cornerBlend = smoothstep(0.65*uChatOpen, 0.2*uChatOpen, length(cornerUV-vec2(0.0, (1.0-uChatOpen) * 0.5))) * uChatOpen * 0.95 + (0.5 + sin(time * 2.0) * 0.5) * 0.05;
    color = mix(color, cornerColor * 1.1, cornerBlend);
    color *= smoothstep(0.0, 0.5, uVisible);

    color = blendOverlay(color, vec3(getNoise(vUv, time)), mix(0.15, 0.15, uMobile));
    color = pow(color, vec3(1.0 + smoothstep(1.0, 0.2, uVisible) * 0.4));

    vec3 colorTouch = mix(vec3(1.0), gradient, smoothstep(0.0, 1.0, fluidPush) * 0.5);
    float colorPush = fluidPush + fluidPushY;
    color = blendSoftLight(color, colorTouch, colorPush * 0.6 * smoothstep(0.0, 0.0001, uSyncTouch));
    //color = blendOverlay(color, colorTouch, colorPush * 0.5 * smoothstep(0.0, 0.0001, uSyncTouch));

    color = max(vec3(0.0), min(vec3(1.0), color));
    gl_FragColor = vec4(color, 1.0);
}{@}ChainShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tBaseColor;
uniform sampler2D tRefraction;
uniform vec2 uReflection;
uniform float uScroll;

#!VARYINGS
varying vec3 vCameraPos;
varying vec4 vWorldPos;
varying float vDist;

#!SHADER: Vertex

#require(fbr.vs)

void main() {
    vec3 pos = position;
    pos.y -= 17.0 * uScroll;
    pos.x -= cos(-pos.y * 0.4) * 1.1;
    pos.z -= sin(-pos.y * 0.4) * 1.1;

    setupFBR(pos);
    vNormal = normalMatrix * normal;
    vCameraPos = cameraPosition;
    vWorldPos = modelMatrix * vec4(pos, 1.0);
    vDist = length(vWorldPos.xyz - cameraPosition);

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment

#require(fbr.fs)
#require(rgb2hsv.fs)
#require(transformUV.glsl)

void main() {
    vec3 baseColor = texture2D(tBaseColor, vUv).rgb;
    vec3 color = getFBR(baseColor, vUv);

    vec3 normal = unpackNormalFBR(vEyePos, vWorldNormal, tNormal, uNormalStrength, 1.0, vUv);

    normal.y -= vWorldPos.y * 0.05;

    vec2 screenuv = gl_FragCoord.xy / resolution;
    screenuv += normal.xy * 0.1 * uReflection.x;

    color += texture2D(tRefraction, screenuv).rgb * uReflection.y;

    color *= mix(0.4, 1.2, smoothstep(18.0, 4.0, vDist));

    color = pow(color, vec3(1.5));

    #drawbuffer Color gl_FragColor = vec4(color, 1.0);
    #drawbuffer WorkRefraction gl_FragColor = vec4(color, 1.0);
}{@}FlowerParticleShader.glsl{@}#!ATTRIBUTES
attribute vec4 random;

#!UNIFORMS
uniform sampler2D tPos;
uniform sampler2D tLightTexture;
uniform sampler2D tPointColor;
uniform sampler2D tMap;
uniform vec3 uLightPos;
uniform vec3 uTint;
uniform float DPR;
uniform float uScroll;
uniform float uSizeBias;
uniform float uAnimate;
uniform float uRotate;
uniform float uSparkle;

#!VARYINGS
varying vec3 vLightColor;
varying vec3 vPos;
varying vec4 vRandom;
varying float vScale;
varying float vDist;
varying float vRipple;
varying vec3 vWorldPos;
varying vec2 vUv;
varying float vOffset;
varying float vFlowers;
varying vec3 vCameraPos;

#!SHADER: Vertex

const float PI = 3.1415926535897932384626433832795;

#require(range.glsl)
#require(lighting.vs)
#require(simplenoise.glsl)

void main() {
    vec4 decodedPos = texture2D(tPos, position.xy);
    vec3 pos = decodedPos.xyz;

    vCameraPos = cameraPosition;


    //vFlowers = pos.z > 0.5 ? 1.0 : 0.0;

    if (pos.x < 0.0) {
        pos.z = -pos.z;
        pos.y -= 5.0;
    }

    pos.x += 1.0;
    pos.z -= 0.5;

    float offset = smoothstep(0.4, 0.0, uScroll) * pow(random.x, 30.0) * 10.0;
    offset *= (0.8 + sin(pos.y * 0.2 + time * 0.02 + uScroll + random.z * 2.0) * 0.2);
    pos.y += offset;

    // Top Spiral
    pos.x -= cos(uScroll * 5.0 + length(pos.xz) * 1.0 + pos.y * 0.5 + uRotate * 2.0) * 0.5 * smoothstep(0.0, 0.5, abs(uScroll-0.5));
    pos.z -= sin(uScroll * 5.0 + length(pos.xz) * 1.0 + pos.y * 0.5 + uRotate * 2.0) * 0.5 * smoothstep(0.0, 0.5, abs(uScroll-0.5));

    // RotateTransition
    float radius = 3.0;
    //pos.x -= (cos(uRotate) * radius) - radius * 2.0;
    //pos.z -= (sin(uRotate) * radius) - radius * 2.0;

    // Outer Spiral
    radius = mix(0.5, 3.0, pow(random.w, 2.0));
    pos.x -= cos(pos.y * 0.5 + sin(time * 0.05 + random.w * 5.0 * 0.1 - uRotate * 0.2)) * 25.0 * step(0.95, random.y);
    pos.z -= sin(pos.y * 0.5 + sin(time * 0.05 + random.w * 5.0 * 0.1 - uRotate * 0.2)) * 25.0 * step(0.95, random.y);

    if (pos.x < 0.0) {
        pos.x -= cos(-decodedPos.y * 0.06) * 3.0 - 3.5;
        pos.z -= sin(-decodedPos.y * 0.06) * 3.0 - 2.0;
    } else {
        pos.x -= cos(-decodedPos.y * 0.06 + 3.0) * 3.0 + 3.5;
        pos.z -= sin(-decodedPos.y * 0.06 + 3.0) * 3.0 + 1.0;
    }

    // Bottom Spiral
    pos.y -= pow(uScroll, 4.0) * 20.0 * pow(random.w, 15.0);
    pos.x -= cos(pos.y * 1.0) * 0.2 * pow(random.w, 4.0) * pow(uScroll, 3.5);
    pos.z -= sin(pos.y * 1.0) * 0.2 * pow(random.w, 4.0) * pow(uScroll, 3.5);

    pos.xz = mix(pos.xz, vec2(0.0), pow(smoothstep(5.0, -45.0, pos.y), 3.0));

    vOffset = length(pos-decodedPos.xyz);


    vec3 worldPos = vec3(modelMatrix * vec4(pos, 1.0));
    vWorldPos = worldPos;

    float dist = length(worldPos - cameraPosition);
    vDist = dist;
    vUv = uv;

    vRipple = 0.0;//0.5 + sin(length(vWorldPos.xz) * 2.0) * 0.5;

    vec3 viewDir = normalize(cameraPosition - pos);
    vec3 ray = vec3(0.0, 0.0, 0.0) - pos;
    vec3 rayDir = normalize(ray);
    float u = 0.5 + atan(rayDir.z, rayDir.x) / (2.0 * PI);
    float v = 0.5 - asin(rayDir.y) / PI;
    float intensity = smoothstep(5.0, 2.0, length(ray));
    vLightColor = texture2D(tPointColor, position.xy).rgb;
    //vLightColor += ;

    vPos = pos;
    vRandom = random;

    vScale = smoothstep(3.0, 15.0, dist);
    vScale *= 1.0 + (0.5 + sin(time * 5.0 + random.y * 20.0) * 0.5) * 0.3;
    vScale *= mix(0.5, 1.5, random.z);
    vScale *= mix(1.0, 3.0, vRipple);

    vec4 mvPosition = modelViewMatrix * vec4(pos, 1.0);
    gl_PointSize = (0.0275) * DPR * 2.0 * vScale * (1000.0 / length(mvPosition.xyz)) * uSizeBias;
    gl_Position = projectionMatrix * mvPosition;
}

#!SHADER: Fragment

#require(range.glsl)
#require(transformUV.glsl)
#require(simplenoise.glsl)
#require(rgb2hsv.fs)
#require(blendmodes.glsl)
#require(shadows.fs)

void main() {
    vec2 uv = vec2(gl_PointCoord.x, 1.0 - gl_PointCoord.y);
    if (length(uv-0.5) > 0.5) discard;
    if (vScale < 0.1) discard;

    vec3 color = vLightColor;
    //color *= 1.0 + vRipple * 0.5;
    //color += vRipple * 0.01;

    vec3 sparkle = vec3(0.4 + sin(time * 3.0 + vRandom.y * 20.0));
    //color += sparkle * pow(vRandom.z, 200.0) * vRipple * 0.5;
    //color = min(vec3(0.9), color);

    float noise = cnoise(vWorldPos*0.5+time*0.15+vWorldPos.y*0.3);

    // Bubble Texture
    vec2 matcapUV = rotateUV(uv, sin(time * 1.0 + vRandom.z * 20.0) * 0.5 + 1.0);
    vec3 matcap = texture2D(tMap, matcapUV).rgb * 1.3;
    //matcap = mix(matcap, vec3(1.0), 0.5 + sin(time + vRandom.x * 20.0) * 0.4);
    color = blendSoftLight(color, matcap, 0.8);
    color = blendOverlay(color, matcap, 0.1);

    color = rgb2hsv(color);
    color.x = mix(color.x, (0.6 + smoothstep(0.8, 1.0, color.x)), vFlowers);
    color.x += noise * 0.03 - 0.03;
    color.x += vCameraPos.y * 0.02 - 0.0;
    color.y *= mix(0.5, 0.8, vRandom.w);
    color = hsv2rgb(color);

    color = mix(color, sparkle, smoothstep(2.0, 0.2, uSparkle) * pow(vRandom.x, 10.0) * 0.5);

    
    color *= mix(0.6, 1.0, smoothstep(15.0, 6.0, vDist));
    //color = mix(color, vec3(1.0, 0.0, 0.0), smoothstep(0.0001, 0.0, vOffset));

    color = pow(color * 1.2, vec3(1.4));
    //color = mix(color, vec3(1.0), vFlowers);


    #drawbuffer Color gl_FragColor = vec4(color, 1.0);
    #drawbuffer WorkRefraction gl_FragColor = vec4(color, 1.0);
    // gl_FragColor.rgb *= crange(getShadow(vPos, 0.01), 0.0, 1.0, 0.3, 1.0);
}{@}LogoShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform float uAlpha;

#!VARYINGS
varying vec2 vUv;
varying vec3 vWorldPos;

#!SHADER: Vertex
void main() {
    vUv = uv;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
    vWorldPos = vec3(modelMatrix * vec4(position, 1.0));
}

#!SHADER: Fragment

#require(transformUV.glsl)

void main() {
    if (vUv.x < 0.1 || vUv.x > 0.9) discard;

    vec4 color = texture2D(tMap, vUv);
    color.a *= 0.8 + sin(time * 2.0 + vUv.y * 2.0 - vWorldPos.x * 0.02) * 0.2;
    color.a *= uAlpha;
    gl_FragColor = color;
}{@}SpineShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tBaseColor;
uniform sampler2D tRefraction;
uniform vec2 uReflection;

#!VARYINGS
varying vec3 vCameraPos;
varying vec4 vWorldPos;

#!SHADER: Vertex

#require(fbr.vs)

void main() {
    vec3 pos = position;
    setupFBR(position);
    vNormal = normalMatrix * normal;
    vCameraPos = cameraPosition;
    vWorldPos = modelMatrix * vec4(position, 1.0);

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment

#require(fbr.fs)
#require(rgb2hsv.fs)
#require(transformUV.glsl)

void main() {
    vec2 uv = vUv;
    uv.x += vWorldPos.x * 0.2;

    vec3 baseColor = texture2D(tBaseColor, uv).rgb;
    vec3 color = getFBR(baseColor, uv);

    vec3 normal = unpackNormalFBR(vEyePos, vWorldNormal, tNormal, uNormalStrength, 1.0, vUv);

    normal.y -= vWorldPos.y * 0.02;

    vec2 screenuv = gl_FragCoord.xy / resolution;
    screenuv += normal.xy * 0.1 * uReflection.x;

    color += texture2D(tRefraction, screenuv).rgb * uReflection.y;

    #drawbuffer Color gl_FragColor = vec4(color, 1.0);
    #drawbuffer WorkRefraction gl_FragColor = vec4(color, 1.0);
}{@}WorkComposite.fs{@}uniform sampler2D tDiffuse;
uniform sampler2D tDetail;
uniform float uRGBStrength;
uniform float uTransition;
uniform vec2 uContrast;

varying vec2 vUv;

#require(UnrealBloom.fs)
#require(rgbshift.fs)
#require(contrast.glsl)
#require(simplenoise.glsl)
#require(transformUV.glsl)

float random (in vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

float noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

#define OCTAVES 6
float fbm (in vec2 st) {
    // Initial values
    float value = 0.0;
    float amplitude = .5;
    float frequency = 0.;
    //
    // Loop of octaves
    for (int i = 0; i < OCTAVES; i++) {
        value += amplitude * noise(st);
        st *= 2.;
        amplitude *= .5;
    }
    return value;
}

void main() {
    
    if (uTransition > 0.001 && uTransition < 0.999) {
        vec2 uv = gl_FragCoord.xy / resolution;
        vec2 squareuv = (uv - vec2(0.5)) * (resolution.x > resolution.y
            ? vec2(resolution.x / resolution.y, 1.)
            : vec2(1., resolution.y / resolution.x)) + vec2(0.5);

        float trans = uTransition * 1.5; //trans = 0.3;
        vec2 dir = normalize(uv - vec2(0.5));
        float noise = fbm(dir);
        squareuv += smoothstep(0.2, 0.4, trans) * noise * dir * 0.2;
        float d = smoothstep(trans + 0.25, trans - 0.25, distance(squareuv, vec2(0.5)));

        d *= smoothstep(0.0, 0.5, uTransition);

        vec2 fromuv = (uv - vec2(0.5)) / (1. + d) + vec2(0.5);
        //fromuv = scaleUV(fromuv, vec2(1.0 + uTransition * 0.5));
        vec2 touv = (uv - vec2(0.5)) / (2. - d) + vec2(0.5);

        fromuv = scaleUV(fromuv, vec2(1.0 + uTransition * 0.1));

        vec3 from = getRGB(tDiffuse, fromuv, 0.2, 0.005 * uTransition).rgb;
        vec3 to = getRGB(tDetail, touv, 0.2, 0.001 * (1.0 - uTransition)).rgb;


        from *= smoothstep(1.0, 0.5, uTransition);
        to *= smoothstep(0.2, 0.6, uTransition);

        vec3 color;

        // color = vec3(d);
        // color = vec3(noise);

        from *= mix(1.0, 2.0, d);
        to *= mix(2.0, 1.0, d);

        color = mix(from, to, d);
        gl_FragColor = vec4(color, 1.0);
    } else {
        if (uTransition > 0.999) {
            gl_FragColor = texture2D(tDetail, vUv);    
        } else {
            gl_FragColor = texture2D(tDiffuse, vUv);
        }
    }


    // vec3 color = texture2D(tDiffuse, vUv).rgb;//getRGB(tDiffuse, vUv, 0.3, 0.000 * uRGBStrength).rgb;
    // color = adjustContrast(color, uContrast.x, uContrast.y);
    // color += pow(getUnrealBloom(vUv), vec3(2.0));
    // color += (-0.5 + getNoise(vUv, time)) * 0.05;
}{@}WorkItemShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform sampler2D tVideo;
uniform sampler2D tRefraction;
uniform sampler2D tEnv;
uniform sampler2D tNormal;
uniform float uFresnelPow;
uniform float uDistortStrength;
uniform float uRefractionRatio;
uniform vec3 uColor;
uniform float uHover;
uniform vec2 uMouse;
uniform float uVideoBlend;
uniform vec2 uScale;
uniform float uPhone;

#!VARYINGS
varying vec2 vUv;
varying float vBackface;
varying float vSide;
varying vec3 vWorldPos;
varying vec3 vNormal;
varying vec3 vViewDir;
varying vec3 vReflection;
varying vec3 vRefraction;
varying vec3 vPos;
varying float vDist;
#!SHADER: Vertex

#require(refl.vs)

void main() {
    vec3 pos = position;

    pos.z += sin(time * 0.5 + abs(0.5-pos.x) * 3.0) * 0.1 + uHover * 0.2;
    pos.y -= pos.x * mix(0.08, 0.14, uPhone);
    pos.x -= vec2(uMouse-0.5).x * 0.03;
    
    //pos.z += sin(time * 1.0 + uv.x * 10.0) * 0.5;

    vec4 worldPos = modelMatrix * vec4(pos, 1.0);

    vUv = uv;

    vUv.y += pos.x * mix(0.08, 0.2, uPhone) * 0.2;
    vReflection = reflection(worldPos);
    vRefraction = refraction(worldPos, uRefractionRatio);

    vPos = pos;
    vWorldPos = worldPos.xyz;
    vNormal = normalMatrix * normal;
    vViewDir = -vec3(modelViewMatrix * vec4(pos, 1.0));
    vDist = vWorldPos.x - cameraPosition.x;

    if (normal.z < 0.0) {
        vUv.x = 1.0 - vUv.x;
        vBackface = 1.0;
    }
    vSide = abs(normal.x);
    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment

#require(radialblur.fs)
#require(range.glsl)
#require(simplenoise.glsl)
#require(fresnel.glsl)
#require(eases.glsl)
#require(refl.fs)
#require(rgbshift.fs)
#require(transformUV.glsl)
#require(normalmap.glsl)
#require(blendmodes.glsl)

vec3 rainbowColor(float t) {
    t = mod(t, 1.0); // Wraps the t value between 0.0 and 1.0
    if (t < 0.03) return mix(vec3(0.5, 0.0, 0.5), vec3(0.5, 0.0, 1.0), t / 0.03); // violet to blue
    else if (t < 0.06) return mix(vec3(0.5, 0.0, 1.0), vec3(0.0, 0.0, 1.0), (t - 0.03) / 0.03); // blue to darker blue
    else if (t < 0.09) return mix(vec3(0.0, 0.0, 1.0), vec3(0.0, 1.0, 1.0), (t - 0.06) / 0.03); // darker blue to cyan
    else if (t < 0.12) return mix(vec3(0.0, 1.0, 1.0), vec3(0.0, 1.0, 0.0), (t - 0.09) / 0.03); // cyan to green
    else if (t < 0.18) return mix(vec3(0.0, 1.0, 0.0), vec3(1.0, 1.0, 0.0), (t - 0.12) / 0.06); // green to yellow
    else if (t < 0.24) return mix(vec3(1.0, 1.0, 0.0), vec3(1.0, 0.5, 0.0), (t - 0.18) / 0.06); // yellow to orange
    else return mix(vec3(1.0, 0.5, 0.0), vec3(1.0, 0.0, 0.0), (t - 0.24) / 0.06); // orange to red
}

void main() {
    vec2 normalUV = scaleUV(vUv, vec2(0.5)) + vNormal.xy * 0.02;
    normalUV += cnoise(vUv*1.0 + time * 0.06) * 0.01;
    //normalUV.y -= uScroll * 0.25;
    vec3 normal = crange(texture2D(tNormal, normalUV).rgb, vec3(0.0), vec3(1.0), vec3(-1.0), vec3(1.0));
    //uv += normal.xy * 0.02;

    float f = getFresnel(vNormal, vViewDir, uFresnelPow);
    vec3 r = rainbowColor(f * 0.5);
    if (r.r > 0.99) r *= 0.0;
    
    vec2 ruv = gl_FragCoord.xy / resolution;
    ruv -= 0.05 * vNormal.xy;// * f * uDistortStrength;
    ruv -= normal.xy * (uHover * 0.03 + 0.02 + sin(time * 2.0 + vUv.x * 5.0) * 0.005);
    ruv = scaleUV(ruv, vec2(1.1 + uHover*0.05));
    ruv += (uMouse-0.5) * 0.02;
    vec3 refraction = pow(radialBlur(tRefraction, ruv, 5.0, 5.0).rgb, vec3(1.5));

    float edges = smoothstep(0.5, 6.0, abs(vViewDir.x-0.5));
    float fadeVideo = smoothstep(3.0, 1.0, abs(vWorldPos.y-cameraPosition.y));
    vec2 videoUV = scaleUV(vUv, vec2(0.65, 0.52));
    videoUV += vec2(0.3, -0.5);
    videoUV.x += edges * 0.5;

    videoUV -= 0.5;
    videoUV *= 0.8;
    videoUV += 0.5;
    videoUV = mix(videoUV, scaleUV(gl_FragCoord.xy / resolution, vec2(0.6)), 0.3);

    //videoUV += vec2(uMouse.x, 1.0-uMouse.y) * 0.1;
    //videoUV = scaleUV(videoUV, vec2(1.05));
    videoUV = scaleUV(videoUV, uScale);


    vec2 imageUV = videoUV - normal.xy * 0.05 * (1.0-uVideoBlend);
    vec3 image = getRGB(tMap, scaleUV(imageUV, vec2(1.0 + (1.0-uVideoBlend) * 0.1)), 0.0, 0.005 * edges).rgb * 0.7;
    //image *= mix(1.0, 0.2, edges);
    
    vec3 video = getRGB(tVideo, scaleUV(videoUV, vec2(1.0 + (1.0-uVideoBlend) * 0.1)), 0.0, 0.005 * edges).rgb;
    video = mix(image, video, uVideoBlend);
    video *= smoothstep(0.7, 0.0, abs(videoUV.x-0.5)) * smoothstep(0.5, 0.4, abs(videoUV.y-0.5));
    video *= mix(0.2, 1.0, fadeVideo);

    vec4 color = vec4(vec3(0.0), 1.0);
    //color.rgb += r * mix(0.025, 0.25, vSide);
    color += envColorEquiRGB(tEnv, vRefraction, 0.2, 0.05) * 0.08;
    color.rgb += pow(min(vec3(0.5), video), vec3(1.0)) * 0.45;
    color.rgb += 0.01 * vUv.x + 0.01 * vUv.y;
    color.rgb *= 1.0 + 1.0 * pow(vSide, 3.0);

    vec4 refractionOut = color;

    if (vBackface < 0.5) {
        refractionOut = vec4(0.0);
    } else {
        //color.rgb = blendSoftLight(color.rgb, uColor, 0.4);
    }
    //color.rgb = min(vec3(0.5), color.rgb);

    color.rgb += refraction * mix(1.1, 0.3, smoothstep(0.65, 0.0, length(vUv-0.5))) * mix(1.0, 0.7, uHover);
    color.rgb = blendSoftLight(color.rgb, video, smoothstep(0.7, 0.0, length(vUv-0.5)) * 1.0);
    color.rgb *= 1.0 + sin(time * 2.0 + vUv.x * 5.0) * 0.15;
    //color.rgb = max(vec3(0.07), color.rgb);
    vec2 offset = mix(vec2(0.5, 0.5), vec2(uMouse.x, 1.0-uMouse.y), uHover);
    color.rgb = blendAdd(color.rgb, uColor, mix(0.0, 0.3 + uHover * 0.2, smoothstep(0.7, -0.1, length(vUv-offset))));

    color.rgb *= 1.0 + vSide * uHover * 0.2 + 0.3 * smoothstep(0.5, 0.0, abs(uHover-0.5));
    

    //color.rgb += uHover * 0.01 + uHover * pow(vSide, 10.0) * 0.5;

    #drawbuffer Color gl_FragColor = color;
    #drawbuffer WorkRefraction gl_FragColor = refractionOut;
}{@}WorkItemUIShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform float uAlpha;
uniform vec3 uColor;
uniform float uHover;
uniform float uCamDistance;

#!VARYINGS
varying vec2 vUv;
varying vec3 vPos;
varying vec3 vWorldPos;
varying vec3 vCameraPos;
varying vec3 vViewDir;

#!SHADER: Vertex

void main() {
    vUv = uv;
    vec3 pos = position;

    pos.z += 0.1 + smoothstep(1.0, 0.0, abs(vUv.x-0.5)) * 0.3 + uHover * 0.2;

    pos.y -= (-0.5 + vUv.x) * 0.42;
    vPos = pos;
    vWorldPos = vec3(modelMatrix * vec4(pos, 1.0));
    vCameraPos = cameraPosition;
        vViewDir = -vec3(modelViewMatrix * vec4(pos, 1.0));

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment

#require(transformUV.glsl)
#require(range.glsl)
#require(rgbshift.fs)
#require(rgb2hsv.fs)


void main() {
    vec2 uv = scaleUV(vUv, vec2(0.42, 1.0));
    uv = scaleUV(uv, vec2(1.15));

    //uv += fract(uv.y * 20.0) * smoothstep(1.0, 0.0, length(vWorldPos-vCameraPos));
    //uv.x += length(vWorldPos.x-vCameraPos.x);

    uv.y -= (-0.5 + uv.x) * 0.15;
    uv.x -= (0.5 - vViewDir.x) * 0.1;
    uv.y += 0.02;

    float edges = smoothstep(0.9 + uHover * 1.0, 7.0, abs(vViewDir.x-0.5));
    uv.x += fract(uv.x * 15.0) * edges;
    uv.y -= uv.y * vViewDir.x * 0.15 * edges;

    vec3 color = getRGB(tMap, uv, radians(180.0), 0.001 - edges * 0.15).rgb;
    color *= smoothstep(0.5, 0.4, abs(uv.x-0.5));
    color *= smoothstep(0.5, 0.4, abs(uv.y-0.5));


    vec3 base = rgb2hsv(uColor);

    vec3 color2 = rgb2hsv(color);
    color2.x = color2.x * 0.1 + base.x - 0.25;
    color2.y *= base.y;
    color2 = hsv2rgb(color2);
    

    color = mix(color, color2, 0.05);

    vec2 lineUV = vUv;
    lineUV.y -= (-0.5 + uv.x) * 0.05;
    lineUV.x -= (0.5 - vViewDir.x) * 0.05;

    //color *= smoothstep(0.15, 0.3, abs(edges-0.5));

    // float lines = smoothstep(0.01, 0.0, abs(fract(lineUV.y*7.0)-0.5));
    // lines *= pow(0.5 + sin(lineUV.y * 10.0 + vViewDir.x * 2.0 - time * 2.0) * 0.5, 4.0);
    // lines *= smoothstep(0.5, 0.4, abs(lineUV.x - 0.5));
    // lines *= smoothstep(0.5, 0.0, abs(lineUV.y - 0.5));
    // color += vec3(lines) * 0.4;

    // color *= 0.2;

    color *= crange(uCamDistance, 5.0, 6.0, 1.0, 0.0);
    
    gl_FragColor = vec4(color * mix(0.65, 0.9, uHover), 1.0);
}{@}WorkTubeShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform float uAlpha;

#!VARYINGS
varying vec2 vUv;
varying vec3 vPos;
varying vec3 vWorldPos;

#!SHADER: Vertex

void main() {
    vUv = uv;

    vec3 pos = position;

    pos.x += cos(pos.y * 0.6) * 2.0;
    pos.z += sin(pos.y * 0.6) * 2.0;

    vPos = pos;
    vWorldPos = vec3(modelMatrix * vec4(pos, 1.0));
    
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: Fragment

#require(simplenoise.glsl)
#require(range.glsl)

void main() {
    vec2 uv = vUv;
    //vec4 color = texture2D(tMap, uv);

    float noise = fract(vWorldPos.y * 0.2 + time * 0.3);
    noise = smoothstep(0.5, 0.0, abs(noise-0.5));
    vec3 color = vec3(pow(noise, 5.0));
    
    gl_FragColor = vec4(color, 1.0);
}{@}WorkDetailComposite.fs{@}uniform sampler2D tDiffuse;
uniform float uRGBStrength;

varying vec2 vUv;

#require(rgbshift.fs)

void main() {
    gl_FragColor = getRGB(tDiffuse, vUv, 0.3, 0.002 * uRGBStrength);
}{@}WorkDetailCube.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tRefraction;
uniform sampler2D tPrevFrame;
uniform sampler2D tEnv;
uniform sampler2D tNormal; //repeat
uniform float uFresnelPow; //js {value: 1}
uniform float uDistortStrength; //js {value: 1}
uniform float uRefractionRatio; //js {value: 1}
uniform float uNormalScale; //js {value: 1}
uniform float uSideReflection; //js {value: 0.2}
uniform float uParticleDarken; //js {value: 0.3}
uniform vec3 uColor; //js {value: new Color('#ff0000') }
uniform sampler2D tFluid;
uniform sampler2D tFluidMask;

#!VARYINGS
varying vec2 vUv;
varying float vSide;
varying vec3 vWorldPos;
varying vec3 vNormal;
varying vec3 vViewDir;
varying vec3 vReflection;
varying vec3 vRefraction;
varying vec3 vPos;
varying vec2 vMUV;
varying vec3 vONormal;

#!SHADER: Vertex

#require(refl.vs)
#require(matcap.vs)

void main() {
    vec4 worldPos = modelMatrix * vec4(position, 1.0);

    vUv = uv;
    vReflection = reflection(worldPos);
    vRefraction = refraction(worldPos * 10.0, uRefractionRatio);
    vONormal = normal;

    vPos = position;
    vWorldPos = worldPos.xyz;
    vNormal = normalMatrix * normal;
    vViewDir = -vec3(modelViewMatrix * vec4(position, 1.0));
    vMUV = reflectMatcap(position, modelMatrix, normal);

    vSide = clamp(abs(normal.x) + abs(normal.y), 0.0, 1.0);
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: Fragment

#require(radialblur.fs)
#require(range.glsl)
#require(simplenoise.glsl)
#require(fresnel.glsl)
#require(eases.glsl)
#require(refl.fs)
#require(rgbshift.fs)
#require(normalmap.glsl)
#require(matcap.vs)
#require(blendmodes.glsl)
#require(transformUV.glsl)

vec3 rainbowColor(float t) {
    t = mod(t, 1.0); // Wraps the t value between 0.0 and 1.0
    if (t < 0.03) return mix(vec3(0.5, 0.0, 0.5), vec3(0.5, 0.0, 1.0), t / 0.03); // violet to blue
    else if (t < 0.06) return mix(vec3(0.5, 0.0, 1.0), vec3(0.0, 0.0, 1.0), (t - 0.03) / 0.03); // blue to darker blue
    else if (t < 0.09) return mix(vec3(0.0, 0.0, 1.0), vec3(0.0, 1.0, 1.0), (t - 0.06) / 0.03); // darker blue to cyan
    else if (t < 0.12) return mix(vec3(0.0, 1.0, 1.0), vec3(0.0, 1.0, 0.0), (t - 0.09) / 0.03); // cyan to green
    else if (t < 0.18) return mix(vec3(0.0, 1.0, 0.0), vec3(1.0, 1.0, 0.0), (t - 0.12) / 0.06); // green to yellow
    else if (t < 0.24) return mix(vec3(1.0, 1.0, 0.0), vec3(1.0, 0.5, 0.0), (t - 0.18) / 0.06); // yellow to orange
    else return mix(vec3(1.0, 0.5, 0.0), vec3(1.0, 0.0, 0.0), (t - 0.24) / 0.06); // orange to red
}

void main() {
    vec2 screenUV = gl_FragCoord.xy / resolution.xy;
    vec2 fluid = texture2D(tFluid, screenUV).xy;
    float fluidMask = smoothstep(0.0, 1.0, texture2D(tFluidMask, screenUV).r);
    float fluidEdge = pow(abs(fluid.x)*0.01, 2.0);

    float normalScale = mix(1.0, 1.0, vSide) * uNormalScale * 1.0;
    vec2 normalUV = vUv * normalScale;
    //normalUV += fluidEdge * 0.5;
    vec3 normal = crange(texture2D(tNormal, vUv * normalScale).rgb, vec3(0.0), vec3(1.0), vec3(-1.0), vec3(1.0));

    vec2 ruv = gl_FragCoord.xy / resolution;

    float frostedStrength = smoothstep(-0.2, 0.6, length(screenUV-0.5));
    frostedStrength *= 2.0 + cnoise(screenUV * 0.8 + time * 0.5) * 1.0;

    ruv += 0.04 * normal.xy * uDistortStrength * smoothstep(0.2, 0.0, fluidEdge) * frostedStrength;
    vec3 refraction = texture2D(tRefraction, ruv).rgb * uParticleDarken;

    vec4 color = vec4(vec3(0.0), 1.0);
    color.rgb += refraction * 0.7;
    //color += envColorEquiRGB(tEnv, vRefraction, 0.2, 0.5) * 0.1;
    // color.rgb += vSide * 0.01;
    // color.rgb += (1.0 - vSide) * 0.05;

    vec2 squareUV = scaleUV(screenUV, vec2(1.0, resolution.x/resolution.y));
    squareUV = scaleUV(squareUV, vec2(1.2, 0.7));
    color.rgb *= mix(mix(0.3, 1.0, smoothstep(0.2, 0.45, length(squareUV-0.5))), 1.0, smoothstep(0.0, 0.2, fluidEdge));

    if (vSide > 0.5) {
        vec2 ruv2 = gl_FragCoord.xy / resolution;

        if (vONormal.x < 0.0) ruv2.x = crange(vPos.z, 0.5, -0.5, 0.5, 0.0);
        else if (vONormal.x > 0.0) ruv2.x = crange(vPos.z, 0.5, -0.5, 0.5, 1.0);
        else if (vONormal.y > 0.0) ruv2.y = crange(vPos.z, 0.5, -0.5, 0.5, 1.0);
        else if (vONormal.y < 0.0) ruv2.y = crange(vPos.z, 0.5, -0.5, 0.5, 0.0);
        // ruv2 += 0.1 * normal.xy * uDistortStrength;
        ruv2 += 0.1 * normal.xy * uDistortStrength * (1.0-fluidEdge);
        ruv2 += fluidEdge * 0.1;
       color.rgb = mix(color.rgb, texture2D(tPrevFrame, ruv2).rgb, 0.4 * (1.0-fluidMask));
    }

    color.rgb *= clamp(crange(vPos.x, 0.45, 0.5, 1.0, 0.0) * crange(vPos.x, -0.45, -0.5, 1.0, 0.0) + 
                (crange(vPos.y, 0.45, 0.5, 1.0, 0.0) * crange(vPos.y, -0.45, -0.5, 1.0, 0.0)), 0.5, 1.0);

    color.rgb *= 1.0 + fluidEdge * 0.2;

    //color.rgb = blendOverlay(color.rgb, uColor, mix(0.6, 0.2, fluidEdge));

    gl_FragColor = color;
}{@}WorkDetailParticleShader.glsl{@}#!ATTRIBUTES
varying vec4 random;

#!UNIFORMS
uniform sampler2D tPos;
uniform sampler2D tMap;
uniform sampler2D tVideo;
uniform float DPR;
uniform float uSize;
uniform float uSizeBias;

#!VARYINGS
varying vec3 vPos;
varying vec4 vRandom;

#!SHADER: Vertex

#require(range.glsl)

void main() {
    vec4 decodedPos = texture2D(tPos, position.xy);
    vec3 pos = decodedPos.xyz;

    vPos = vec3(modelMatrix * vec4(pos, 1.0));
    vRandom = random;

    vec4 mvPosition = modelViewMatrix * vec4(pos, 1.0);
    gl_PointSize = (0.03 * DPR) * uSize * crange(random.x, 0.0, 1.0, 0.5, 1.5) * (1000.0 / length(mvPosition.xyz)) * uSizeBias;
    gl_Position = projectionMatrix * mvPosition;
}

#!SHADER: Fragment

#require(range.glsl)
#require(transformUV.glsl)
#require(blendmodes.glsl)
#require(rgb2hsv.fs)

void main() {
    vec2 uv = vec2(gl_PointCoord.x, 1.0 - gl_PointCoord.y);
    if (length(uv-0.5) > 0.5) discard;

    vec2 uv2;
    uv2.x = crange(vPos.x, -7.0, 7.0, 0.0, 1.0);
    uv2.y = crange(vPos.y, -5.0, 5.0, 0.0, 1.0);

    //uv2.xy += vRandom.xx * 10.0;

    //uv2.x += crange(gl_PointCoord.x, 0.0, 1.0, -0.02, 0.02);
    //uv2.y += crange(gl_PointCoord.y, 0.0, 1.0, 0.02, -0.02);
    
    vec3 color = texture2D(tVideo, uv2).rgb;

    // Bubble Texture
    vec2 matcapUV = rotateUV(uv, sin(time * 1.0 + vRandom.z * 20.0) * 0.5 + 1.0);
    vec3 matcap = texture2D(tMap, matcapUV).rgb * 1.2;
    //matcap = mix(matcap, vec3(1.0), 0.5 + sin(time + vRandom.x * 20.0) * 0.4);
    color = blendSoftLight(color, matcap, 0.8);
    color = blendOverlay(color, matcap, 0.2);
    color += 0.05;

    color = rgb2hsv(color);
    color.y *= 1.4;
    color = hsv2rgb(color);


    //color *= mix(0.0, 1.0, vRandom.w);
    color *= smoothstep(-10.0, 10.0, vPos.z);

    gl_FragColor = vec4(color, 1.0);
}{@}WorkPanelShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform float uAlpha;
uniform sampler2D tFluid;
uniform sampler2D tFluidMask;

#!VARYINGS
varying vec2 vUv;
varying vec3 vPos;
varying vec3 vWorldPos;

#!SHADER: Vertex

void main() {
    vUv = uv;
    vPos = position;
    vWorldPos = vec3(modelMatrix * vec4(position, 1.0));
    
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: Fragment

#require(blendmodes.glsl)
#require(transformUV.glsl)

float roundedBox(vec2 p, vec2 c, float r) {
  return length(max(abs(p-c),0.0))-r;
}

void main() {
    vec2 screenUV = gl_FragCoord.xy / resolution.xy;
    vec2 fluid = texture2D(tFluid, screenUV).xy;
    float fluidMask = smoothstep(0.0, 1.0, texture2D(tFluidMask, screenUV).r);
    float fluidEdge = pow(abs(fluid.x)*0.01, 2.0);

    vec2 uv = vUv;
    
    float rounded = roundedBox(uv, scaleUV(uv, vec2(0.55, 0.6)), 0.505);
    if (rounded > 0.0) discard;

    uv += fluidEdge * 0.1;
    

    vec3 color = texture2D(tMap, uv).rgb * 0.8;
    color *= mix(1.0, 1.6, smoothstep(0.2, 1.0, length(uv-0.5)));

    //color = blendOverlay(color, vec3(0.25), smoothstep(0.0, 2.0, border) + step(0.95, border));
    float alpha = uAlpha;

    alpha *= smoothstep(0.5, 0.0, fluidEdge);

    gl_FragColor = vec4(color * 0.8, alpha * 0.9);
}{@}AntimatterSpawn.fs{@}uniform float uMaxCount;
uniform float uSetup;
uniform float decay;
uniform vec2 decayRandom;
uniform sampler2D tLife;
uniform sampler2D tAttribs;
uniform float HZ;

#require(range.glsl)

void main() {
    vec2 uv = vUv;
    #test !window.Metal
    uv = gl_FragCoord.xy / fSize;
    #endtest

    vec4 data = texture2D(tInput, uv);

    if (vUv.x + vUv.y * fSize > uMaxCount) {
        gl_FragColor = vec4(9999.0);
        return;
    }

    vec4 life = texture2D(tLife, uv);
    vec4 random = texture2D(tAttribs, uv);
    if (life.x > 0.5) {
        data.xyz = life.yzw;
        data.x -= 999.0;
    } else {
        if (data.x < -500.0) {
            data.x = 1.0;
        } else {
            data.x -= 0.005 * decay * crange(random.w, 0.0, 1.0, decayRandom.x, decayRandom.y) * HZ;
        }
    }

    if (uSetup > 0.5) {
        data = vec4(0.0);
    }

    gl_FragColor = data;
}{@}Cube2Equi.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform samplerCube tCube;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
void main() {
    vUv = vec2( 1.- uv.x, uv.y );
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: Fragment

#define M_PI 3.1415926535897932384626433832795

void main() {
    vec2 uv = vUv;
    float longitude = uv.x * 2. * M_PI - M_PI + M_PI / 2.;
    float latitude = uv.y * M_PI;

    vec3 dir = vec3(
        - sin( longitude ) * sin( latitude ),
        cos( latitude ),
        - cos( longitude ) * sin( latitude )
    );

    normalize(dir);
    gl_FragColor = textureCube(tCube, dir);
}{@}fbr.fs{@}uniform sampler2D tMRO;
uniform sampler2D tMatcap;
uniform sampler2D tNormal;
uniform vec4 uLight;
uniform vec3 uColor;
uniform float uNormalStrength;

varying vec3 vNormal;
varying vec3 vWorldNormal;
varying vec3 vPos;
varying vec3 vEyePos;
varying vec2 vUv;
varying vec3 vMPos;

const float PI = 3.14159265359;
const float PI2 = 6.28318530718;
const float RECIPROCAL_PI = 0.31830988618;
const float RECIPROCAL_PI2 = 0.15915494;
const float LOG2 = 1.442695;
const float EPSILON = 1e-6;
const float LN2 = 0.6931472;

#require(matcap.vs)

float prange(float oldValue, float oldMin, float oldMax, float newMin, float newMax) {
    float oldRange = oldMax - oldMin;
    float newRange = newMax - newMin;
    return (((oldValue - oldMin) * newRange) / oldRange) + newMin;
}

float pcrange(float oldValue, float oldMin, float oldMax, float newMin, float newMax) {
    return clamp(prange(oldValue, oldMin, oldMax, newMin, newMax), min(newMax, newMin), max(newMin, newMax));
}

vec3 unpackNormalFBR( vec3 eye_pos, vec3 surf_norm, sampler2D normal_map, float intensity, float scale, vec2 uv ) {
    vec3 q0 = dFdx( eye_pos.xyz );
    vec3 q1 = dFdy( eye_pos.xyz );
    vec2 st0 = dFdx( uv.st );
    vec2 st1 = dFdy( uv.st );

    vec3 N = normalize(surf_norm);

    vec3 q1perp = cross( q1, N );
    vec3 q0perp = cross( N, q0 );

    vec3 T = q1perp * st0.x + q0perp * st1.x;
    vec3 B = q1perp * st0.y + q0perp * st1.y;

    float det = max( dot( T, T ), dot( B, B ) );
    float scalefactor = ( det == 0.0 ) ? 0.0 : inversesqrt( det );

    vec3 mapN = texture2D( normal_map, uv * scale ).xyz * 2.0 - 1.0;
    mapN.xy *= intensity;

    return normalize( T * ( mapN.x * scalefactor ) + B * ( mapN.y * scalefactor ) + N * mapN.z );
}

float geometricOcclusion(float NdL, float NdV, float roughness) {
    float r = roughness;
    float attenuationL = 2.0 * NdL / (NdL + sqrt(r * r + (1.0 - r * r) * (NdL * NdL)));
    float attenuationV = 2.0 * NdV / (NdV + sqrt(r * r + (1.0 - r * r) * (NdV * NdV)));
    return attenuationL * attenuationV;
}

float microfacetDistribution(float roughness, float NdH) {
    float roughnessSq = roughness * roughness;
    float f = (NdH * roughnessSq - NdH) * NdH + 1.0;
    return roughnessSq / (PI * f * f);
}

vec3 getFBR(vec3 baseColor, vec2 uv, vec3 normal) {
    vec3 mro = texture2D(tMRO, uv).rgb;
    float roughness = mro.g;

    vec2 aUV = reflectMatcap(vMPos, normal);
    vec2 bUV = ((aUV - 0.5) * 0.5 - vec2(0.1)) + 0.5;
    vec2 mUV = mix(aUV, bUV, roughness);

    vec3 V = normalize(cameraPosition - vMPos);
    vec3 L = normalize(uLight.xyz);
    vec3 H = normalize((L + V) / 2.); // the halfway vector is the sum of L and H divided by the sum of their lengths

    float NdL = pcrange(clamp(dot(normal, L), 0.001, 1.0), 0.0, 1.0, 0.4, 1.0);
    float NdV = pcrange(clamp(abs(dot(normal, V)), 0.001, 1.0), 0.0, 1.0, 0.4, 1.0);
    float NdH = clamp(dot(normal, H), 0.0, 1.0);
    float VdH = clamp(dot(V, H), 0.0, 1.0);

    float G = geometricOcclusion(NdL, NdV, roughness);
    float D = microfacetDistribution(roughness, NdH);

    vec3 specContrib = G * D / (4.0 * NdL * NdV) * uColor;
    vec3 color = NdL * specContrib * uLight.w;

    return ((baseColor * texture2D(tMatcap, mUV).rgb) + color) * mro.b;
}

vec3 getFBR(vec3 baseColor, vec2 uv, vec2 normalUV) {
    vec3 normal = unpackNormalFBR(vEyePos, vWorldNormal, tNormal, uNormalStrength, 1.0, normalUV);
    return getFBR(baseColor, uv, normal);
}

vec3 getFBR(vec3 baseColor, vec2 uv) {
    return getFBR(baseColor, uv, uv);
}

vec3 getFBR(vec3 baseColor) {
    return getFBR(baseColor, vUv, vUv);
}

vec3 getFBR() {
    float roughness = texture2D(tMRO, vUv).g;

    vec3 normal = unpackNormalFBR(vEyePos, vWorldNormal, tNormal, 1.0, 1.0, vUv);
    vec2 aUV = reflectMatcap(vMPos, normal);
    vec2 bUV = ((aUV - 0.5) * 0.5 - vec2(0.1)) + 0.5;
    vec2 mUV = mix(aUV, bUV, roughness);

    return texture2D(tMatcap, mUV).rgb;
}

vec3 getFBRSimplified() {
    vec2 mUV = reflectMatcap(vMPos, vWorldNormal);
    return texture2D(tMatcap, mUV).rgb;
}
{@}fbr.vs{@}varying vec3 vNormal;
varying vec3 vWorldNormal;
varying vec3 vPos;
varying vec3 vEyePos;
varying vec2 vUv;
varying vec3 vMPos;

void setupFBR(vec3 p0) { //inlinemain
    vNormal = normalMatrix * normal;
    vWorldNormal = mat3(modelMatrix[0].xyz, modelMatrix[1].xyz, modelMatrix[2].xyz) * normal;
    vUv = uv;
    vPos = p0;
    vec4 mPos = modelMatrix * vec4(p0, 1.0);
    vMPos = mPos.xyz / mPos.w;
    vEyePos = vec3(modelViewMatrix * vec4(p0, 1.0));
}{@}advectionManualFilteringShader.fs{@}varying vec2 vUv;
uniform sampler2D uVelocity;
uniform sampler2D uSource;
uniform vec2 texelSize;
uniform vec2 dyeTexelSize;
uniform float dt;
uniform float dissipation;
vec4 bilerp (sampler2D sam, vec2 uv, vec2 tsize) {
    vec2 st = uv / tsize - 0.5;
    vec2 iuv = floor(st);
    vec2 fuv = fract(st);
    vec4 a = texture2D(sam, (iuv + vec2(0.5, 0.5)) * tsize);
    vec4 b = texture2D(sam, (iuv + vec2(1.5, 0.5)) * tsize);
    vec4 c = texture2D(sam, (iuv + vec2(0.5, 1.5)) * tsize);
    vec4 d = texture2D(sam, (iuv + vec2(1.5, 1.5)) * tsize);
    return mix(mix(a, b, fuv.x), mix(c, d, fuv.x), fuv.y);
}
void main () {
    vec2 coord = vUv - dt * bilerp(uVelocity, vUv, texelSize).xy * texelSize;
    gl_FragColor = dissipation * bilerp(uSource, coord, dyeTexelSize);
    gl_FragColor.a = 1.0;
}{@}advectionShader.fs{@}varying vec2 vUv;
uniform sampler2D uVelocity;
uniform sampler2D uSource;
uniform vec2 texelSize;
uniform float dt;
uniform float dissipation;
void main () {
    vec2 coord = vUv - dt * texture2D(uVelocity, vUv).xy * texelSize;
    gl_FragColor = dissipation * texture2D(uSource, coord);
    gl_FragColor.a = 1.0;
}{@}backgroundShader.fs{@}varying vec2 vUv;
uniform sampler2D uTexture;
uniform float aspectRatio;
#define SCALE 25.0
void main () {
    vec2 uv = floor(vUv * SCALE * vec2(aspectRatio, 1.0));
    float v = mod(uv.x + uv.y, 2.0);
    v = v * 0.1 + 0.8;
    gl_FragColor = vec4(vec3(v), 1.0);
}{@}clearShader.fs{@}varying vec2 vUv;
uniform sampler2D uTexture;
uniform float value;
void main () {
    gl_FragColor = value * texture2D(uTexture, vUv);
}{@}colorShader.fs{@}uniform vec4 color;
void main () {
    gl_FragColor = color;
}{@}curlShader.fs{@}varying highp vec2 vUv;
varying highp vec2 vL;
varying highp vec2 vR;
varying highp vec2 vT;
varying highp vec2 vB;
uniform sampler2D uVelocity;
void main () {
    float L = texture2D(uVelocity, vL).y;
    float R = texture2D(uVelocity, vR).y;
    float T = texture2D(uVelocity, vT).x;
    float B = texture2D(uVelocity, vB).x;
    float vorticity = R - L - T + B;
    gl_FragColor = vec4(0.5 * vorticity, 0.0, 0.0, 1.0);
}{@}displayShader.fs{@}varying vec2 vUv;
uniform sampler2D uTexture;
void main () {
    vec3 C = texture2D(uTexture, vUv).rgb;
    float a = max(C.r, max(C.g, C.b));
    gl_FragColor = vec4(C, a);
}{@}divergenceShader.fs{@}varying highp vec2 vUv;
varying highp vec2 vL;
varying highp vec2 vR;
varying highp vec2 vT;
varying highp vec2 vB;
uniform sampler2D uVelocity;
void main () {
    float L = texture2D(uVelocity, vL).x;
    float R = texture2D(uVelocity, vR).x;
    float T = texture2D(uVelocity, vT).y;
    float B = texture2D(uVelocity, vB).y;
    vec2 C = texture2D(uVelocity, vUv).xy;
   if (vL.x < 0.0) { L = -C.x; }
   if (vR.x > 1.0) { R = -C.x; }
   if (vT.y > 1.0) { T = -C.y; }
   if (vB.y < 0.0) { B = -C.y; }
    float div = 0.5 * (R - L + T - B);
    gl_FragColor = vec4(div, 0.0, 0.0, 1.0);
}{@}fluidBase.vs{@}varying vec2 vUv;
varying vec2 vL;
varying vec2 vR;
varying vec2 vT;
varying vec2 vB;
uniform vec2 texelSize;

void main () {
    vUv = uv;
    vL = vUv - vec2(texelSize.x, 0.0);
    vR = vUv + vec2(texelSize.x, 0.0);
    vT = vUv + vec2(0.0, texelSize.y);
    vB = vUv - vec2(0.0, texelSize.y);
    gl_Position = vec4(position, 1.0);
}{@}gradientSubtractShader.fs{@}varying highp vec2 vUv;
varying highp vec2 vL;
varying highp vec2 vR;
varying highp vec2 vT;
varying highp vec2 vB;
uniform sampler2D uPressure;
uniform sampler2D uVelocity;
vec2 boundary (vec2 uv) {
    return uv;
    // uv = min(max(uv, 0.0), 1.0);
    // return uv;
}
void main () {
    float L = texture2D(uPressure, boundary(vL)).x;
    float R = texture2D(uPressure, boundary(vR)).x;
    float T = texture2D(uPressure, boundary(vT)).x;
    float B = texture2D(uPressure, boundary(vB)).x;
    vec2 velocity = texture2D(uVelocity, vUv).xy;
    velocity.xy -= vec2(R - L, T - B);
    gl_FragColor = vec4(velocity, 0.0, 1.0);
}{@}pressureShader.fs{@}varying highp vec2 vUv;
varying highp vec2 vL;
varying highp vec2 vR;
varying highp vec2 vT;
varying highp vec2 vB;
uniform sampler2D uPressure;
uniform sampler2D uDivergence;
vec2 boundary (vec2 uv) {
    return uv;
    // uncomment if you use wrap or repeat texture mode
    // uv = min(max(uv, 0.0), 1.0);
    // return uv;
}
void main () {
    float L = texture2D(uPressure, boundary(vL)).x;
    float R = texture2D(uPressure, boundary(vR)).x;
    float T = texture2D(uPressure, boundary(vT)).x;
    float B = texture2D(uPressure, boundary(vB)).x;
    float C = texture2D(uPressure, vUv).x;
    float divergence = texture2D(uDivergence, vUv).x;
    float pressure = (L + R + B + T - divergence) * 0.25;
    gl_FragColor = vec4(pressure, 0.0, 0.0, 1.0);
}{@}splatShader.fs{@}varying vec2 vUv;
uniform sampler2D uTarget;
uniform float aspectRatio;
uniform vec3 color;
uniform vec3 bgColor;
uniform vec2 point;
uniform vec2 prevPoint;
uniform float radius;
uniform float canRender;
uniform float uAdd;

float blendScreen(float base, float blend) {
    return 1.0-((1.0-base)*(1.0-blend));
}

vec3 blendScreen(vec3 base, vec3 blend) {
    return vec3(blendScreen(base.r, blend.r), blendScreen(base.g, blend.g), blendScreen(base.b, blend.b));
}

float l(vec2 uv, vec2 point1, vec2 point2) {
    vec2 pa = uv - point1, ba = point2 - point1;
    pa.x *= aspectRatio;
    ba.x *= aspectRatio;
    float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
    return length(pa - ba * h);
}

float cubicOut(float t) {
    float f = t - 1.0;
    return f * f * f + 1.0;
}

void main () {
    vec3 splat = (1.0 - cubicOut(clamp(l(vUv, prevPoint.xy, point.xy) / radius, 0.0, 1.0))) * color;
    vec3 base = texture2D(uTarget, vUv).xyz;
    base *= canRender;

    vec3 outColor = mix(blendScreen(base, splat), base + splat, uAdd);
    gl_FragColor = vec4(outColor, 1.0);
}{@}vorticityShader.fs{@}varying vec2 vUv;
varying vec2 vL;
varying vec2 vR;
varying vec2 vT;
varying vec2 vB;
uniform sampler2D uVelocity;
uniform sampler2D uCurl;
uniform float curl;
uniform float dt;
void main () {
    float L = texture2D(uCurl, vL).x;
    float R = texture2D(uCurl, vR).x;
    float T = texture2D(uCurl, vT).x;
    float B = texture2D(uCurl, vB).x;
    float C = texture2D(uCurl, vUv).x;
    vec2 force = 0.5 * vec2(abs(T) - abs(B), abs(R) - abs(L));
    force /= length(force) + 0.0001;
    force *= curl * C;
    force.y *= -1.0;
//    force.y += 400.3;
    vec2 vel = texture2D(uVelocity, vUv).xy;
    gl_FragColor = vec4(vel + force * dt, 0.0, 1.0);
}{@}FXScrollTransition.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap1;
uniform sampler2D tMap2;
uniform sampler2D tNormal;
uniform float uTransition;
uniform float uAngle;
uniform float uVelocity;
uniform float uAngleVelocity;
uniform float uRatio;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
void main() {
    vUv = uv;

    gl_Position = vec4(position, 1.0);
}

#!SHADER: Fragment
#require(range.glsl)
#require(transformUV.glsl)

float aastep(float threshold, float value) {
    float signedDist = threshold - value;
    float d = fwidth(signedDist);
    return 1.0 - smoothstep(-d, d, signedDist);
}

float aastep(float threshold, float value, float padding) {
    return smoothstep(threshold - padding, threshold + padding, value);
}

vec2 aastep(vec2 threshold, vec2 value) {
    return vec2(
        aastep(threshold.x, value.x),
        aastep(threshold.y, value.y)
    );
}

void main() {
    vec2 uv = vUv;

    vec2 squareUV = scaleUV(vUv, vec2(1.0, resolution.x/resolution.y));
    vec2 normalUV = scaleUV(squareUV, vec2(0.3));
    normalUV.y -= uTransition * 1.0;
    vec3 normal = crange(texture2D(tNormal, normalUV).rgb, vec3(0.0), vec3(1.0), vec3(-1.0), vec3(1.0));

    float inclination = -0.2 * uAngle * uRatio;
    float inclination2 = -0.1 * uAngle * uRatio;

    float offset = 0.2;
    float transition = crange(uv.y + (uv.x * inclination) + 0.1, 0.0, 1.0, uTransition+offset, uTransition-offset);

    
    float fade = aastep(uv.y + (uv.x * inclination), crange(uTransition+0.01, 0.0, 1.0, inclination, 1.0), 0.15);

    uv += normal.xy * 0.025 * smoothstep(0.5, 0.0, abs(transition-0.5)) * smoothstep(0.5, -0.2, abs(fade-0.5));

    vec3 color1 = texture2D(tMap1, uv).rgb;
    vec3 color2 = texture2D(tMap2, uv).rgb;


    float cut = aastep(uv.y + (uv.x * inclination), crange(uTransition, 0.0, 1.0, inclination, 1.0));
    vec3 color = mix(color1, color2, cut);

    gl_FragColor.rgb = color;
    gl_FragColor.a = 1.0;
}
{@}Blit.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
void main() {
    gl_Position = vec4(position, 1.0);
    vUv = uv;
}

    #!SHADER: Fragment
void main() {
    #drawbuffer Color gl_FragColor = texture2D(tMap, vUv);
    #drawbuffer BloomMask gl_FragColor = vec4(1.0);
}
{@}BloomLuminosityPass.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tDiffuse;
uniform vec3 defaultColor;
uniform float defaultOpacity;
uniform float luminosityThreshold;
uniform float smoothWidth;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex.vs
void main() {
    vUv = uv;
    gl_Position = vec4(position, 1.0);
}

    #!SHADER: Fragment.fs

    #require(luma.fs)

void main() {
    vec4 texel = texture2D(tDiffuse, vUv);
    float v = luma(texel.xyz);
    vec4 outputColor = vec4(defaultColor.rgb, defaultOpacity);
    float alpha = smoothstep(luminosityThreshold, luminosityThreshold + smoothWidth, v);
    gl_FragColor = mix(outputColor, texel, alpha);
}
{@}DownSample.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform vec2 uResolution;
uniform float uRadius;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
void main() {
    gl_Position = vec4(position, 1.0);
    vUv = uv;
}

    #!SHADER: Fragment
void main() {

    vec2 c = vUv;
    vec2 pxSize = 1.0 / uResolution;
    vec2 halfPixel = 0.5 / uResolution;
    vec3 sum = vec3(0.0);

    vec3 weights = vec3(0.03125, 0.0625, 0.125);

    vec2 br = vUv - halfPixel;
    vec2 bl = vUv + vec2(halfPixel.x, -halfPixel.y);
    vec2 tr = vUv + halfPixel;
    vec2 tl = vUv + vec2(-halfPixel.x, halfPixel.y);

    vec3 A = texture2D(tMap, vUv + vec2(-1.0, -1.0) * pxSize).xyz * weights.x;
    vec3 B = texture2D(tMap, vUv + vec2(0.0, -1.0) * pxSize).xyz * weights.y;
    vec3 C = texture2D(tMap, vUv + vec2(1.0, -1.0) * pxSize).xyz * weights.x;

    vec3 D = texture2D(tMap, br).xyz * weights.z;
    vec3 E = texture2D(tMap, bl).xyz * weights.z;
    vec3 F = texture2D(tMap, vUv + vec2(-1.0, 0.0) * pxSize).xyz * weights.y;

    vec3 G = texture2D(tMap, vUv).xyz * weights.z;

    vec3 H = texture2D(tMap, vUv + vec2(1.0, 0.0) * pxSize).xyz * weights.y;
    vec3 I = texture2D(tMap, tl).xyz * weights.z;
    vec3 J = texture2D(tMap, tr).xyz * weights.z;

    vec3 K = texture2D(tMap, vUv + vec2(-1.0, 1.0) * pxSize).xyz * weights.x;
    vec3 L = texture2D(tMap, vUv + vec2(0.0, 1.0) * pxSize).xyz * weights.y;
    vec3 M = texture2D(tMap, vUv + vec2(1.0, 1.0) * pxSize).xyz * weights.x;

    sum = A + B + C + D + E + F + G + H + I + J + K + L + M;

    gl_FragColor = vec4(sum, 1.0);
}
{@}HydraBloom.glsl{@}uniform sampler2D tHydraBloom;

vec3 getHydraBloom(vec2 uv) {
    return texture2D(tHydraBloom, uv).rgb;
}
{@}HydraBloomPass.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tDiffuse;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
void main() {
    gl_Position = vec4(position, 1.0);
    vUv = uv;
}

    #!SHADER: Fragment
    #require(HydraBloom.glsl)
    #require(blendmodes.glsl)
void main() {

    vec3 color = texture2D(tDiffuse, vUv).xyz;
    vec3 bloom = getHydraBloom(vUv);

    gl_FragColor = vec4(blendScreen(color, bloom), 1.0);
}
{@}UpSample.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform sampler2D tNext;
uniform vec2 uResolution;
uniform float uRadius;
uniform float uIntensity;
uniform vec3 uTint;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
void main() {
    gl_Position = vec4(position, 1.0);
    vUv = uv;
}

    #!SHADER: Fragment
void main() {
    vec2 c = vUv;
    vec2 texelSize = (1.0 / uResolution) * uRadius;
    vec3 sum = vec3(0.0);

    sum += texture2D(tMap, vUv - texelSize).xyz * 0.0625;
    sum += texture2D(tMap, vUv + vec2(0.0, -texelSize.y)).xyz * 0.125;
    sum += texture2D(tMap, vUv + vec2(texelSize.x, -texelSize.y)).xyz * 0.0625;

    sum += texture2D(tMap, vUv - vec2(texelSize.x, 0.0)).xyz * 0.125;
    sum += texture2D(tMap, vUv).xyz * 0.25;
    sum += texture2D(tMap, vUv + vec2(texelSize.x, 0.0)).xyz * 0.125;

    sum += texture2D(tMap, vUv + texelSize).xyz * 0.0625;
    sum += texture2D(tMap, vUv + vec2(0.0, texelSize.y)).xyz * 0.125;
    sum += texture2D(tMap, vUv + vec2(-texelSize.x, texelSize.y)).xyz * 0.0625;

    vec3 next = texture2D(tNext, vUv).xyz;
    next += min(vec3(1.0), sum * uIntensity) * uTint;

    gl_FragColor = vec4(next, 1.0);
}
{@}CompositeStreak.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tHigh;
uniform sampler2D tDown;
uniform sampler2D tPrefiltered;

uniform vec3 uStreakColor;
uniform float uStreakIntensity;
uniform float uGlowIntensity;
uniform bool uDebugHalo;
uniform float uFlareIntensity;
uniform float uAspectCorrection;
uniform float uHaloChroma;
uniform float uHaloScale;
uniform float uRotateStreak;
uniform float uHaloSoftness;
uniform float uHaloRotateSrc;
uniform float uHaloConstant;
uniform vec3 uHaloColor;
uniform vec4 uHaloRing;


#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
void main() {
    vUv = uv;
    gl_Position = vec4(position, 1.0);
}

#!SHADER: Fragment

#require(transformUV.glsl)

#define PI 3.1415926

float createRingSDF(vec2 uv, vec2 center, float scale, float innerRadius, float outerRadius, float smoothness) {
    // Scale the UV coordinates
    vec2 scaledUV = (uv - center) * scale;

    // Calculate the distance from the center
    float dist = distance(vec2(0.0), scaledUV);

    // Apply smoothstep for the outer and inner edges of the ring
    float outerEdge = smoothstep(outerRadius - smoothness, outerRadius, dist);
    float innerEdge = smoothstep(innerRadius, innerRadius + smoothness, dist);

    // Create the ring by subtracting the inner edge from the outer edge
    return outerEdge - innerEdge;
}

vec2 getSpriteUVForAtlasIndex(vec2 uv, float index, vec2 atlasSize, vec2 spriteSize) {
    vec2 spriteIndex = vec2(mod(index, atlasSize.x), floor(index / atlasSize.x));
    vec2 spriteUV = uv * spriteSize + spriteIndex * spriteSize;
    return spriteUV;
}

void main() {

    vec2 uv = vUv;

    //rotate the uv but compensate for aspect ratio
    uv = rotateUV(uv, uRotateStreak);

    vec3 c3 = (texture2D(tHigh, uv).rgb) * uStreakIntensity * uStreakColor;
    
    vec3 down = texture2D(tDown, uv).rgb * uStreakColor * uGlowIntensity;

    vec2 haloUV = uv;
    haloUV = rotateUV(haloUV, -(uRotateStreak + uHaloRotateSrc));
    haloUV.x -= 0.5;
    haloUV.x *= mix( 1.0, resolution.x / resolution.y, uAspectCorrection);
    haloUV.x += 0.5;

    vec2 haloVec = normalize( vec2(0.5) - haloUV ) * uHaloScale;

    vec2 aspectUV = vUv;
    aspectUV.x -= 0.5;
    aspectUV.x *= mix( 1.0, resolution.x / resolution.y, uAspectCorrection);
    aspectUV.x += 0.5;

    vec2 haloWarpUV = aspectUV + haloVec;
    haloWarpUV.x = 1.0 - haloWarpUV.x;

    haloWarpUV = scaleUV( haloWarpUV, vec2(1.0 + uHaloSoftness) );

    float haloMask = createRingSDF(aspectUV, vec2(0.5), uHaloRing.x, uHaloRing.y, uHaloRing.z, uHaloRing.w);

    vec2 haloWarpUVR = haloWarpUV + vec2(uHaloChroma, uHaloChroma);
    vec2 haloWarpUVG = haloWarpUV;
    vec2 haloWarpUVB = haloWarpUV - vec2(uHaloChroma, uHaloChroma);

    float haloR = texture2D(tPrefiltered, haloWarpUVR).r * haloMask;
    float haloG = texture2D(tPrefiltered, haloWarpUVG).g * haloMask;
    float haloB = texture2D(tPrefiltered, haloWarpUVB).b * haloMask;

    vec3 halo = vec3(haloR, haloG, haloB) * uHaloColor * uFlareIntensity;

    vec3 streaks = c3 + down;

    vec3 col = streaks + halo;

    float debugHalo = float(uDebugHalo);
    col = mix(col, vec3(haloMask), debugHalo);

    float constantHaloMaskR = createRingSDF(aspectUV, vec2(0.5), uHaloRing.x * 1.05, uHaloRing.y, uHaloRing.z, uHaloRing.w);
    float constantHaloMaskG = createRingSDF(aspectUV, vec2(0.5), uHaloRing.x, uHaloRing.y, uHaloRing.z, uHaloRing.w);
    float constantHaloMaskB = createRingSDF(aspectUV, vec2(0.5), uHaloRing.x * 0.98, uHaloRing.y, uHaloRing.z, uHaloRing.w);

    vec3 constantMask = vec3(constantHaloMaskR, constantHaloMaskG, constantHaloMaskB) * uHaloConstant;
    constantMask *= vec3(1.0) - halo;

    gl_FragColor = vec4( col + constantMask, 1.0 );
    
}{@}HydraLensStreakPass.fs{@}{@}LensFlareDown.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform vec2 uResolution;
uniform float uStretch;

#!VARYINGS
varying vec2 vUv;

#!SHADER: LensFlareDown.vs
void main() {
    vUv = uv;
    gl_Position = vec4(position, 1.0);
}


#!SHADER: LensFlareDown.fs
#require(transformUV.glsl)
void main() {

    vec2 uv = vUv;

    float dx = 1. / uResolution.x;

    float stretch = uStretch;

    float u0 = uv.x - ((dx * 5.) * stretch);
    float u1 = uv.x - ((dx * 3.) * stretch);
    float u2 = uv.x - ((dx * 1.) * stretch);
    float u3 = uv.x + ((dx * 1.) * stretch);
    float u4 = uv.x + ((dx * 3.) * stretch);
    float u5 = uv.x + ((dx * 5.) * stretch);

    vec3 c0 = texture2D(tMap, vec2(u0, uv.y)).rgb;
    vec3 c1 = texture2D(tMap, vec2(u1, uv.y)).rgb;
    vec3 c2 = texture2D(tMap, vec2(u2, uv.y)).rgb;
    vec3 c3 = texture2D(tMap, vec2(u3, uv.y)).rgb;
    vec3 c4 = texture2D(tMap, vec2(u4, uv.y)).rgb;
    vec3 c5 = texture2D(tMap, vec2(u5, uv.y)).rgb;

    vec3 col =  vec3((c0 + c1 * 2. + c2 * 3. + c3 * 3. + c4 * 2. + c5) / 12.);

    gl_FragColor = vec4( col.rgb, 1.0 );
}{@}LensFlarePrefilter.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform float uThreshold;
uniform float uRotate;

#!VARYINGS
varying vec2 vUv;

#!SHADER: LensFlarePrefilter.vs
void main() {
    vUv = uv;
    gl_Position = vec4(position, 1.0);
}


#!SHADER: LensFlarePrefilter.fs

#require(transformUV.glsl)
#require(luma.fs)

void main() {

    vec2 uv = vUv;

    uv = rotateUV(uv, -uRotate);

    vec4 c = texture2D(tMap, vec2(uv.x, uv.y));

    // threshold the brightness

    float brightness = luma(c.rgb);
    if (brightness < uThreshold) {
        c = vec4(0.);
    }

    gl_FragColor = vec4(c.rgb, 1.0);
}{@}LensFlareUp.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tHigh;
uniform sampler2D tScene;
uniform float uStretch;
uniform float uSoftenEdge;
uniform vec2 uResolution;

#!VARYINGS
varying vec2 vUv;

#!SHADER: LensFlareUp.vs
void main() {
    vUv = uv;
    gl_Position = vec4(position, 1.0);
}

#!SHADER: LensFlareUp.fs
void main() {

    vec2 uv = vUv;

    float dx = 1. / uResolution.x;

    float u0 = uv.x - dx;
    float u1 = uv.x;
    float u2 = uv.x + dx;

    // sample horizontally
    vec3 c0 = texture2D(tScene, vec2(u0, uv.y)).rgb / 4.;
    vec3 c1 = texture2D(tScene, vec2(u1, uv.y)).rgb / 2.;
    vec3 c2 = texture2D(tScene, vec2(u2, uv.y)).rgb / 4.;

    vec3 c3 = texture2D(tHigh, uv).rgb;

    vec3 cStretch = c0 + c1 + c2;

    // sample vertically
    vec3 c4 = texture2D(tScene, vec2(uv.x, uv.y - (dx * 0.75))).rgb / 4.;
    vec3 c5 = texture2D(tScene, vec2(uv.x, uv.y + (dx * 0.75))).rgb / 4.;

    cStretch += (c4 + c5) * uSoftenEdge;

    vec4 col = vec4(cStretch, 1.);

    gl_FragColor = col;

}{@}AreaLights.glsl{@}mat3 transposeMat3(  mat3 m ) {
	mat3 tmp;
	tmp[ 0 ] = vec3( m[ 0 ].x, m[ 1 ].x, m[ 2 ].x );
	tmp[ 1 ] = vec3( m[ 0 ].y, m[ 1 ].y, m[ 2 ].y );
	tmp[ 2 ] = vec3( m[ 0 ].z, m[ 1 ].z, m[ 2 ].z );
	return tmp;
}

// Real-Time Polygonal-Light Shading with Linearly Transformed Cosines
// by Eric Heitz, Jonathan Dupuy, Stephen Hill and David Neubelt
// code: https://github.com/selfshadow/ltc_code/
vec2 LTC_Uv(  vec3 N,  vec3 V,  float roughness ) {
	float LUT_SIZE  = 64.0;
	float LUT_SCALE = ( LUT_SIZE - 1.0 ) / LUT_SIZE;
	float LUT_BIAS  = 0.5 / LUT_SIZE;
	float dotNV = clamp( dot( N, V ), 0.0, 1.0 );
	// texture parameterized by sqrt( GGX alpha ) and sqrt( 1 - cos( theta ) )
	vec2 uv = vec2( roughness, sqrt( 1.0 - dotNV ) );
	uv = uv * LUT_SCALE + LUT_BIAS;
	return uv;
}

float LTC_ClippedSphereFormFactor(  vec3 f ) {
	// Real-Time Area Lighting: a Journey from Research to Production (p.102)
	// An approximation of the form factor of a horizon-clipped rectangle.
	float l = length( f );
	return max( ( l * l + f.z ) / ( l + 1.0 ), 0.0 );
}

vec3 LTC_EdgeVectorFormFactor(  vec3 v1,  vec3 v2 ) {
	float x = dot( v1, v2 );
	float y = abs( x );
	// rational polynomial approximation to theta / sin( theta ) / 2PI
	float a = 0.8543985 + ( 0.4965155 + 0.0145206 * y ) * y;
	float b = 3.4175940 + ( 4.1616724 + y ) * y;
	float v = a / b;
	float theta_sintheta = ( x > 0.0 ) ? v : 0.5 * inversesqrt( max( 1.0 - x * x, 1e-7 ) ) - v;
	return cross( v1, v2 ) * theta_sintheta;
}

vec3 LTC_Evaluate(  vec3 N,  vec3 V,  vec3 P,  mat3 mInv,  vec3 rectCoords[ 4 ] ) {
	// bail if point is on back side of plane of light
	// assumes ccw winding order of light vertices
	vec3 v1 = rectCoords[ 1 ] - rectCoords[ 0 ];
	vec3 v2 = rectCoords[ 3 ] - rectCoords[ 0 ];
	vec3 lightNormal = cross( v1, v2 );
	if( dot( lightNormal, P - rectCoords[ 0 ] ) < 0.0 ) return vec3( 0.0 );
	// construct orthonormal basis around N
	vec3 T1, T2;
	T1 = normalize( V - N * dot( V, N ) );
	T2 = - cross( N, T1 ); // negated from paper; possibly due to a different handedness of world coordinate system
	// compute transform
	mat3 mat = mInv * transposeMat3( mat3( T1, T2, N ) );
	// transform rect
	vec3 coords[ 4 ];
	coords[ 0 ] = mat * ( rectCoords[ 0 ] - P );
	coords[ 1 ] = mat * ( rectCoords[ 1 ] - P );
	coords[ 2 ] = mat * ( rectCoords[ 2 ] - P );
	coords[ 3 ] = mat * ( rectCoords[ 3 ] - P );
	// project rect onto sphere
	coords[ 0 ] = normalize( coords[ 0 ] );
	coords[ 1 ] = normalize( coords[ 1 ] );
	coords[ 2 ] = normalize( coords[ 2 ] );
	coords[ 3 ] = normalize( coords[ 3 ] );
	// calculate vector form factor
	vec3 vectorFormFactor = vec3( 0.0 );
	vectorFormFactor += LTC_EdgeVectorFormFactor( coords[ 0 ], coords[ 1 ] );
	vectorFormFactor += LTC_EdgeVectorFormFactor( coords[ 1 ], coords[ 2 ] );
	vectorFormFactor += LTC_EdgeVectorFormFactor( coords[ 2 ], coords[ 3 ] );
	vectorFormFactor += LTC_EdgeVectorFormFactor( coords[ 3 ], coords[ 0 ] );
	// adjust for horizon clipping
	float result = LTC_ClippedSphereFormFactor( vectorFormFactor );

	return vec3( result );
}{@}Lighting.glsl{@}#!ATTRIBUTES

#!UNIFORMS
struct LightConfig {
    vec3 normal;
    bool phong;
    bool areaToPoint;
    float phongAttenuation;
    float phongShininess;
    vec3 phongColor;
    vec3 lightColor;
    bool overrideColor;
};

uniform sampler2D tLTC1;
uniform sampler2D tLTC2;

#!VARYINGS
varying vec3 vPos;
varying vec3 vWorldPos;
varying vec3 vNormal;
varying vec3 vViewDir;

#!SHADER: lighting.vs

void setupLight(vec3 p0, vec3 p1) { //inlinemain
    vPos = p0;
    vNormal = normalize(normalMatrix * p1);
    vWorldPos = vec3(modelMatrix * vec4(p0, 1.0));
    vViewDir = -vec3(modelViewMatrix * vec4(p0, 1.0));
}

#test !window.Metal
void setupLight(vec3 p0) {
    setupLight(p0, normal);
}
#endtest

#!SHADER: lighting.fs

#require(LightingCommon.glsl)

void setupLight() {

}
vec3 getCombinedColor(LightConfig config, vec3 vPos, vec3 vWorldPos, vec3 vViewDir, mat4 modelViewMatrix, mat4 viewMatrix, sampler2D tLTC1, sampler2D tLTC2) {
    vec3 color = vec3(0.0);

    #pragma unroll_loop
    for (int i = 0; i < NUM_LIGHTS; i++) {
        vec3 lColor = config.overrideColor ? config.lightColor : lightColor[i].rgb;
        vec3 lPos = lightPos[i].rgb;
        vec4 lData = lightData[i];
        vec4 lData2 = lightData2[i];
        vec4 lData3 = lightData3[i];
        vec4 lProps = lightProperties[i];

        if (lProps.w < 1.0) continue;

        if (lProps.w < 1.1) {
            color += lightDirectional(config, lColor, lPos, lData, lData2, lData3, lProps, vPos, vWorldPos, vViewDir, modelViewMatrix, viewMatrix);
        } else if (lProps.w < 2.1) {
            color += lightPoint(config, lColor, lPos, lData, lData2, lData3, lProps, vPos, vWorldPos, vViewDir, modelViewMatrix, viewMatrix);
        } else if (lProps.w < 3.1) {
            color += lightCone(config, lColor, lPos, lData, lData2, lData3, lProps, vPos, vWorldPos, vViewDir, modelViewMatrix, viewMatrix);
        } else if (lProps.w < 4.1) {
            color += lightArea(config, lColor, lPos, lData, lData2, lData3, lProps, vPos, vWorldPos, vViewDir, modelViewMatrix, viewMatrix, tLTC1, tLTC2);
        }
    }

    return lclamp(color);
}

vec3 getCombinedColor(LightConfig config) {
    #test !window.Metal
    return getCombinedColor(config, vPos, vWorldPos, vViewDir, modelViewMatrix, viewMatrix, tLTC1, tLTC2);
    #endtest
    return vec3(0.0);
}

vec3 getCombinedColor() {
    LightConfig config;
    config.normal = vNormal;
    return getCombinedColor(config);
}

vec3 getCombinedColor(vec3 normal) {
    LightConfig config;
    config.normal = normal;
    return getCombinedColor(config);
}

vec3 getCombinedColor(vec3 normal, vec3 vPos, vec3 vWorldPos, vec3 vViewDir, mat4 modelViewMatrix, mat4 viewMatrix, sampler2D tLTC1, sampler2D tLTC2) {
    LightConfig config;
    config.normal = normal;
    return getCombinedColor(config, vPos, vWorldPos, vViewDir, modelViewMatrix, viewMatrix, tLTC1, tLTC2);
}

vec3 getPointLightColor(LightConfig config, vec3 vPos, vec3 vWorldPos, vec3 vViewDir, mat4 modelViewMatrix, mat4 viewMatrix) {
    vec3 color = vec3(0.0);

    #pragma unroll_loop
    for (int i = 0; i < NUM_LIGHTS; i++) {
        vec3 lColor = config.overrideColor ? config.lightColor : lightColor[i].rgb;
        vec3 lPos = lightPos[i].rgb;
        vec4 lData = lightData[i];
        vec4 lData2 = lightData2[i];
        vec4 lData3 = lightData3[i];
        vec4 lProps = lightProperties[i];

        if (lProps.w > 1.9 && lProps.w < 2.1) {
            color += lightPoint(config, lColor, lPos, lData, lData2, lData3, lProps, vPos, vWorldPos, vViewDir, modelViewMatrix, viewMatrix);
        }
    }

    return lclamp(color);
}

vec3 getPointLightColor(LightConfig config) {
    #test !window.Metal
    return getPointLightColor(config, vPos, vWorldPos, vViewDir, modelViewMatrix, viewMatrix);
    #endtest
    return vec3(0.0);
}

vec3 getPointLightColor() {
    LightConfig config;
    config.normal = vNormal;
    return getPointLightColor(config);
}

vec3 getPointLightColor(vec3 normal) {
    LightConfig config;
    config.normal = normal;
    return getPointLightColor(config);
}

vec3 getPointLightColor(vec3 normal, vec3 vPos, vec3 vWorldPos, vec3 vViewDir, mat4 modelViewMatrix, mat4 viewMatrix) {
    LightConfig config;
    config.normal = normal;
    return getPointLightColor(config, vPos, vWorldPos, vViewDir, modelViewMatrix, viewMatrix);
}

vec3 getAreaLightColor(float roughness, LightConfig config, vec3 vPos, vec3 vWorldPos, vec3 vViewDir, mat4 modelViewMatrix, mat4 viewMatrix, sampler2D tLTC1, sampler2D tLTC2) {
    vec3 color = vec3(0.0);

    #test Lighting.fallbackAreaToPointTest()
    config.areaToPoint = true;
    #endtest

    #pragma unroll_loop
    for (int i = 0; i < NUM_LIGHTS; i++) {
        vec3 lColor = config.overrideColor ? config.lightColor : lightColor[i].rgb;
        vec3 lPos = lightPos[i].rgb;
        vec4 lData = lightData[i];
        vec4 lData2 = lightData2[i];
        vec4 lData3 = lightData3[i];
        vec4 lProps = lightProperties[i];

        lData.w *= roughness;

        if (lProps.w > 3.9 && lProps.w < 4.1) {
            if (config.areaToPoint) {
                color += lightPoint(config, lColor, lPos, lData, lData2, lData3, lProps, vPos, vWorldPos, vViewDir, modelViewMatrix, viewMatrix);
            } else {
                color += lightArea(config, lColor, lPos, lData, lData2, lData3, lProps, vPos, vWorldPos, vViewDir, modelViewMatrix, viewMatrix, tLTC1, tLTC2);
            }
        }
    }

    return lclamp(color);
}

vec3 getAreaLightColor(float roughness, LightConfig config) {
    #test !window.Metal
    return getAreaLightColor(roughness, config, vPos, vWorldPos, vViewDir, modelViewMatrix, viewMatrix, tLTC1, tLTC2);
    #endtest
    return vec3(0.0);
}


vec3 getAreaLightColor(float roughness) {
    LightConfig config;
    config.normal = vNormal;
    return getAreaLightColor(roughness, config);
}

vec3 getAreaLightColor() {
    LightConfig config;
    config.normal = vNormal;
    return getAreaLightColor(1.0, config);
}

vec3 getAreaLightColor(LightConfig config) {
    return getAreaLightColor(1.0, config);
}

vec3 getAreaLightColor(vec3 normal) {
    LightConfig config;
    config.normal = normal;
    return getAreaLightColor(1.0, config);
}

vec3 getAreaLightColor(vec3 normal, vec3 vPos, vec3 vWorldPos, vec3 vViewDir, mat4 modelViewMatrix, mat4 viewMatrix, sampler2D tLTC1, sampler2D tLTC2) {
    LightConfig config;
    config.normal = normal;
    return getAreaLightColor(1.0, config, vPos, vWorldPos, vViewDir, modelViewMatrix, viewMatrix, tLTC1, tLTC2);
}


vec3 getSpotLightColor(LightConfig config, vec3 vPos, vec3 vWorldPos, vec3 vViewDir, mat4 modelViewMatrix, mat4 viewMatrix) {
    vec3 color = vec3(0.0);

    #pragma unroll_loop
    for (int i = 0; i < NUM_LIGHTS; i++) {
        vec3 lColor = config.overrideColor ? config.lightColor : lightColor[i].rgb;
        vec3 lPos = lightPos[i].rgb;
        vec4 lData = lightData[i];
        vec4 lData2 = lightData2[i];
        vec4 lData3 = lightData3[i];
        vec4 lProps = lightProperties[i];

        if (lProps.w > 2.9 && lProps.w < 3.1) {
            color += lightCone(config, lColor, lPos, lData, lData2, lData3, lProps, vPos, vWorldPos, vViewDir, modelViewMatrix, viewMatrix);
        }
    }

    return lclamp(color);
}

vec3 getSpotLightColor(LightConfig config) {
    #test !window.Metal
    return getSpotLightColor(config, vPos, vWorldPos, vViewDir, modelViewMatrix, viewMatrix);
    #endtest
    return vec3(0.0);
}

vec3 getSpotLightColor() {
    LightConfig config;
    config.normal = vNormal;
    return getSpotLightColor(config);
}

vec3 getSpotLightColor(vec3 normal) {
    LightConfig config;
    config.normal = normal;
    return getSpotLightColor(config);
}

vec3 getSpotLightColor(vec3 normal, vec3 vPos, vec3 vWorldPos, vec3 vViewDir, mat4 modelViewMatrix, mat4 viewMatrix) {
    LightConfig config;
    config.normal = normal;
    return getSpotLightColor(config, vPos, vWorldPos, vViewDir, modelViewMatrix, viewMatrix);
}


vec3 getDirectionalLightColor(LightConfig config, vec3 vPos, vec3 vWorldPos, vec3 vViewDir, mat4 modelViewMatrix, mat4 viewMatrix) {
    vec3 color = vec3(0.0);

    #pragma unroll_loop
    for (int i = 0; i < NUM_LIGHTS; i++) {
        vec3 lColor = config.overrideColor ? config.lightColor : lightColor[i].rgb;
        vec3 lPos = lightPos[i].rgb;
        vec4 lData = lightData[i];
        vec4 lData2 = lightData2[i];
        vec4 lData3 = lightData3[i];
        vec4 lProps = lightProperties[i];

        if (lProps.w > 0.9 && lProps.w < 1.1) {
            color += lightDirectional(config, lColor, lPos, lData, lData2, lData3, lProps, vPos, vWorldPos, vViewDir, modelViewMatrix, viewMatrix);
        }
    }

    return lclamp(color);
}

vec3 getDirectionalLightColor(LightConfig config) {
    #test !window.Metal
    return getDirectionalLightColor(config, vPos, vWorldPos, vViewDir, modelViewMatrix, viewMatrix);
    #endtest
    return vec3(0.0);
}

vec3 getDirectionalLightColor(vec3 normal) {
    LightConfig config;
    config.normal = normal;
    return getDirectionalLightColor(config);
}

vec3 getDirectionalLightColor() {
    LightConfig config;
    config.normal = vNormal;
    return getDirectionalLightColor(config);
}

vec3 getDirectionalLightColor(vec3 normal, vec3 vPos, vec3 vWorldPos, vec3 vViewDir, mat4 modelViewMatrix, mat4 viewMatrix) {
    LightConfig config;
    config.normal = vNormal;
    return getDirectionalLightColor(config, vPos, vWorldPos, vViewDir, modelViewMatrix, viewMatrix);
}

vec3 getStandardColor(LightConfig config, vec3 vPos, vec3 vWorldPos, vec3 vViewDir, mat4 modelViewMatrix, mat4 viewMatrix) {
    vec3 color = vec3(0.0);

    #pragma unroll_loop
    for (int i = 0; i < NUM_LIGHTS; i++) {
        vec3 lColor = config.overrideColor ? config.lightColor : lightColor[i].rgb;
        vec3 lPos = lightPos[i].rgb;
        vec4 lData = lightData[i];
        vec4 lData2 = lightData2[i];
        vec4 lData3 = lightData3[i];
        vec4 lProps = lightProperties[i];

        if (lProps.w < 1.0) continue;

        if (lProps.w < 1.1) {
            color += lightDirectional(config, lColor, lPos, lData, lData2, lData3, lProps, vPos, vWorldPos, vViewDir, modelViewMatrix, viewMatrix);
        } else if (lProps.w < 2.1) {
            color += lightPoint(config, lColor, lPos, lData, lData2, lData3, lProps, vPos, vWorldPos, vViewDir, modelViewMatrix, viewMatrix);
        }
    }

    return lclamp(color);
}

vec3 getStandardColor(LightConfig config) {
    #test !window.Metal
    return getStandardColor(config, vPos, vWorldPos, vViewDir, modelViewMatrix, viewMatrix);
    #endtest
    return vec3(0.0);
}

vec3 getStandardColor() {
    LightConfig config;
    config.normal = vNormal;
    return getStandardColor(config);
}

vec3 getStandardColor(vec3 normal) {
    LightConfig config;
    config.normal = normal;
    return getStandardColor(config);
}

vec3 getStandardColor(vec3 normal, vec3 vPos, vec3 vWorldPos, vec3 vViewDir, mat4 modelViewMatrix, mat4 viewMatrix) {
    LightConfig config;
    config.normal = normal;
    return getStandardColor(config, vPos, vWorldPos, vViewDir, modelViewMatrix, viewMatrix);
}{@}LightingCommon.glsl{@}#require(AreaLights.glsl)

vec3 lworldLight(vec3 lightPos, vec3 localPos, mat4 modelViewMatrix, mat4 viewMatrix) {
    vec4 mvPos = modelViewMatrix * vec4(localPos, 1.0);
    vec4 worldPosition = viewMatrix * vec4(lightPos, 1.0);
    return worldPosition.xyz - mvPos.xyz;
}

float lrange(float oldValue, float oldMin, float oldMax, float newMin, float newMax) {
    vec3 sub = vec3(oldValue, newMax, oldMax) - vec3(oldMin, newMin, oldMin);
    return sub.x * sub.y / sub.z + newMin;
}

vec3 lclamp(vec3 v) {
    return clamp(v, vec3(0.0), vec3(1.0));
}

float lcrange(float oldValue, float oldMin, float oldMax, float newMin, float newMax) {
    return clamp(lrange(oldValue, oldMin, oldMax, newMin, newMax), min(newMax, newMin), max(newMin, newMax));
}

#require(Phong.glsl)

vec3 lightDirectional(LightConfig config, vec3 lColor, vec3 lPos, vec4 lData, vec4 lData2, vec4 lData3, vec4 lProps, vec3 vPos, vec3 vWorldPos, vec3 vViewDir, mat4 modelViewMatrix, mat4 viewMatrix) {
    vec3 lDir = lworldLight(lPos, vPos, modelViewMatrix, viewMatrix);
    float volume = dot(normalize(lDir), config.normal);

    return lColor * lcrange(volume, 0.0, 1.0, lProps.z, 1.0);
}

vec3 lightPoint(LightConfig config, vec3 lColor, vec3 lPos, vec4 lData, vec4 lData2, vec4 lData3, vec4 lProps, vec3 vPos, vec3 vWorldPos, vec3 vViewDir, mat4 modelViewMatrix, mat4 viewMatrix) {
    float dist = length(vWorldPos - lPos);
    if (dist > lProps.y) return vec3(0.0);

    vec3 color = vec3(0.0);

    vec3 lDir = lworldLight(lPos, vPos, modelViewMatrix, viewMatrix);
    float falloff = pow(lcrange(dist, 0.0, lProps.y, 1.0, 0.0), 2.0);

    if (config.phong) {
        color += falloff * phong(lProps.x, lColor, config.phongColor, config.phongShininess, config.phongAttenuation, config.normal, normalize(lDir), vViewDir, lProps.z);
    } else {
        float volume = dot(normalize(lDir), config.normal);
        volume = lcrange(volume, 0.0, 1.0, lProps.z, 1.0);
        color += lColor * volume * lProps.x * falloff;
    }

    return color;
}

vec3 lightCone(LightConfig config, vec3 lColor, vec3 lPos, vec4 lData, vec4 lData2, vec4 lData3, vec4 lProps, vec3 vPos, vec3 vWorldPos, vec3 vViewDir, mat4 modelViewMatrix, mat4 viewMatrix) {
    float dist = length(vWorldPos - lPos);
    if (dist > lProps.y) return vec3(0.0);

    vec3 lDir = lworldLight(lPos, vPos, modelViewMatrix, viewMatrix);
    vec3 sDir = degrees(-lData.xyz);
    float radius = lData.w;
    vec3 surfacePos = vWorldPos;
    vec3 surfaceToLight = normalize(lPos - surfacePos);
    float lightToSurfaceAngle = degrees(acos(dot(-surfaceToLight, normalize(sDir))));
    float attenuation = 1.0;

    vec3 nColor = lightPoint(config, lColor, lPos, lData, lData2, lData3, lProps, vPos, vWorldPos, vViewDir, modelViewMatrix, viewMatrix);

    float featherMin = 1.0 - lData2.x*0.1;
    float featherMax = 1.0 + lData2.x*0.1;

    attenuation *= smoothstep(lightToSurfaceAngle*featherMin, lightToSurfaceAngle*featherMax, radius);

    nColor *= attenuation;
    return nColor;
}

vec3 lightArea(LightConfig config, vec3 lColor, vec3 lPos, vec4 lData, vec4 lData2, vec4 lData3, vec4 lProps, vec3 vPos, vec3 vWorldPos, vec3 vViewDir, mat4 modelViewMatrix, mat4 viewMatrix, sampler2D tLTC1, sampler2D tLTC2) {
    float dist = length(vWorldPos - lPos);
    if (dist > lProps.y) return vec3(0.0);

    vec3 color = vec3(0.0);

    vec3 normal = config.normal;
    vec3 viewDir = normalize(vViewDir);
    vec3 position = -vViewDir;
    float roughness = lData.w;
    vec3 mPos = lData.xyz;
    vec3 halfWidth = lData2.xyz;
    vec3 halfHeight = lData3.xyz;

    float falloff = pow(lcrange(dist, 0.0, lProps.y, 1.0, 0.0), 2.0);

    vec3 rectCoords[ 4 ];
    rectCoords[ 0 ] = mPos + halfWidth - halfHeight;
    rectCoords[ 1 ] = mPos - halfWidth - halfHeight;
    rectCoords[ 2 ] = mPos - halfWidth + halfHeight;
    rectCoords[ 3 ] = mPos + halfWidth + halfHeight;

    vec2 uv = LTC_Uv( normal, viewDir, roughness );

    #test !!window.Metal
    uv.y = 1.0 - uv.y;
    #endtest

    vec4 t1 = texture2D(tLTC1, uv);
    vec4 t2 = texture2D(tLTC2, uv);

    mat3 mInv = mat3(
    vec3( t1.x, 0, t1.y ),
    vec3(    0, 1,    0 ),
    vec3( t1.z, 0, t1.w )
    );

    vec3 fresnel = ( lColor * t2.x + ( vec3( 1.0 ) - lColor ) * t2.y );
    color += lColor * fresnel * LTC_Evaluate( normal, viewDir, position, mInv, rectCoords ) * falloff * lProps.x;
    color += lColor * LTC_Evaluate( normal, viewDir, position, mat3( 1.0 ), rectCoords ) * falloff * lProps.x;

    return color;
}{@}LitMaterial.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;

#!VARYINGS
varying vec2 vUv;
varying vec3 vPos;

#!SHADER: Vertex

#require(lighting.vs)

void main() {
    vUv = uv;
    vPos = position;
    setupLight(position);
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: Fragment

#require(lighting.fs)
#require(shadows.fs)

void main() {
    setupLight();

    vec3 color = texture2D(tMap, vUv).rgb;
    color *= getShadow(vPos);

    color += getCombinedColor();

    gl_FragColor = vec4(color, 1.0);
}{@}Phong.glsl{@}float pclamp(float v) {
    return clamp(v, 0.0, 1.0);
}

float dPhong(float shininess, float dotNH) {
    return (shininess * 0.5 + 1.0) * pow(dotNH, shininess);
}

vec3 schlick(vec3 specularColor, float dotLH) {
    float fresnel = exp2((-5.55437 * dotLH - 6.98316) * dotLH);
    return (1.0 - specularColor) * fresnel + specularColor;
}

vec3 calcBlinnPhong(vec3 specularColor, float shininess, vec3 normal, vec3 lightDir, vec3 viewDir) {
    vec3 halfDir = normalize(lightDir + viewDir);
    
    float dotNH = pclamp(dot(normal, halfDir));
    float dotLH = pclamp(dot(lightDir, halfDir));

    vec3 F = schlick(specularColor, dotLH);
    float G = 0.85;
    float D = dPhong(shininess, dotNH);
    
    return F * G * D;
}

vec3 calcBlinnPhong(vec3 specularColor, float shininess, vec3 normal, vec3 lightDir, vec3 viewDir, float minTreshold) {
    vec3 halfDir = normalize(lightDir + viewDir);

    float dotNH = pclamp(dot(normal, halfDir));
    float dotLH = pclamp(dot(lightDir, halfDir));

    dotNH = lrange(dotNH, 0.0, 1.0, minTreshold, 1.0);
    dotLH = lrange(dotLH, 0.0, 1.0, minTreshold, 1.0);

    vec3 F = schlick(specularColor, dotLH);
    float G = 0.85;
    float D = dPhong(shininess, dotNH);

    return F * G * D;
}

vec3 phong(float amount, vec3 diffuse, vec3 specular, float shininess, float attenuation, vec3 normal, vec3 lightDir, vec3 viewDir, float minThreshold) {
    float cosineTerm = pclamp(lrange(dot(normal, lightDir), 0.0, 1.0, minThreshold, 1.0));
    vec3 brdf = calcBlinnPhong(specular, shininess, normal, lightDir, viewDir, minThreshold);
    return brdf * amount * diffuse * attenuation * cosineTerm;
}{@}mousefluid.fs{@}uniform sampler2D tFluid;
uniform sampler2D tFluidMask;

vec2 getFluidVelocity() {
    float fluidMask = smoothstep(0.1, 0.7, texture2D(tFluidMask, vUv).r);
    return texture2D(tFluid, vUv).xy * fluidMask;
}

vec3 getFluidVelocityMask() {
    float fluidMask = smoothstep(0.1, 0.7, texture2D(tFluidMask, vUv).r);
    return vec3(texture2D(tFluid, vUv).xy * fluidMask, fluidMask);
}{@}ProtonAntimatter.fs{@}uniform sampler2D tOrigin;
uniform sampler2D tAttribs;
uniform float uMaxCount;
//uniforms

#require(range.glsl)
//requires

void main() {
    vec2 uv = vUv;
    #test !window.Metal
    uv = gl_FragCoord.xy / fSize;
    #endtest

    vec3 origin = texture2D(tOrigin, uv).xyz;
    vec4 inputData = texture2D(tInput, uv);
    vec3 pos = inputData.xyz;
    vec4 random = texture2D(tAttribs, uv);
    float data = inputData.w;

    if (vUv.x + vUv.y * fSize > uMaxCount) {
        gl_FragColor = vec4(9999.0);
        return;
    }

    //code

    gl_FragColor = vec4(pos, data);
}{@}ProtonAntimatterLifecycle.fs{@}uniform sampler2D tOrigin;
uniform sampler2D tAttribs;
uniform sampler2D tSpawn;
uniform float uMaxCount;
//uniforms

#require(range.glsl)
//requires

void main() {
    vec3 origin = texture2D(tOrigin, vUv).rgb;
    vec4 inputData = texture2D(tInput, vUv);
    vec3 pos = inputData.xyz;
    vec4 random = texture2D(tAttribs, vUv);
    float data = inputData.w;

    if (vUv.x + vUv.y * fSize > uMaxCount) {
        gl_FragColor = vec4(9999.0);
        return;
    }

    vec4 spawn = texture2D(tSpawn, vUv);
    float life = spawn.x;

    if (spawn.x < -500.0) {
        pos = spawn.xyz;
        pos.x += 999.0;
        spawn.x = 1.0;
        gl_FragColor = vec4(pos, data);
        return;
    }

    //abovespawn
    if (spawn.x <= 0.0) {
        pos.x = 9999.0;
        gl_FragColor = vec4(pos, data);
        return;
    }

    //abovecode
    //code

    gl_FragColor = vec4(pos, data);
}{@}ProtonNeutrino.fs{@}//uniforms

#require(range.glsl)
//requires

void main() {
    //code
}{@}ProtonTube.glsl{@}#!ATTRIBUTES
attribute float angle;
attribute vec2 tuv;
attribute float cIndex;
attribute float cNumber;

#!UNIFORMS
uniform sampler2D tPos;
uniform sampler2D tLife;
uniform float radialSegments;
uniform float thickness;
uniform float taper;

#!VARYINGS
varying float vLength;
varying vec3 vNormal;
varying vec3 vViewPosition;
varying vec3 vPos;
varying vec2 vUv;
varying vec2 vUv2;
varying float vIndex;
varying float vLife;
varying vec3 vDiscard;

#!SHADER: Vertex

//neutrinoparams

#require(ProtonTubesUniforms.fs)
#require(range.glsl)
#require(conditionals.glsl)

void main() {
    float headIndex = getIndex(cNumber, 0.0, lineSegments);
    vec2 iuv = getUVFromIndex(headIndex, textureSize);
    vUv2 = iuv;
    float life = texture2D(tLife, iuv).x;
    vLife = life;

    float scale = 1.0;
    //neutrinovs
    vec2 volume = vec2(thickness * 0.065 * scale);

    vec3 transformed;
    vec3 objectNormal;

    //extrude tube
    float posIndex = getIndex(cNumber, cIndex, lineSegments);
    float nextIndex = getIndex(cNumber, cIndex + 1.0, lineSegments);

    vLength = cIndex / (lineSegments - 2.0);
    vIndex = cIndex;

    vec3 current = texture2D(tPos, getUVFromIndex(posIndex, textureSize)).xyz;
    vec3 next = texture2D(tPos, getUVFromIndex(nextIndex, textureSize)).xyz;

    float dIndex = cIndex;
    
    
    //Michael check this one in your machine
    //this checks with a while that the lines are not going to infinity
    //drawing a previous index.
    while(dIndex > 0. && (any(greaterThan(abs(current), vec3(100.))) || any(greaterThan(abs(next), vec3(100.)))  )) {
        dIndex -= 1.;
        posIndex = getIndex(cNumber, dIndex, lineSegments);
        nextIndex = getIndex(cNumber, dIndex + 1.0, lineSegments);
        vLength = dIndex / (lineSegments - 2.0);
        vIndex = dIndex;
        current = texture2D(tPos, getUVFromIndex(posIndex, textureSize)).xyz;
        next = texture2D(tPos, getUVFromIndex(nextIndex, textureSize)).xyz;
    }
    
    

    vDiscard = next - current;

    vec3 T = normalize(next - current);
    vec3 B = normalize(cross(T, next + current));
    vec3 N = -normalize(cross(B, T));

    float tubeAngle = angle;
    float circX = cos(tubeAngle);
    float circY = sin(tubeAngle);

    volume *= mix(crange(vLength, 1.0 - taper, 1.0, 1.0, 0.0) * crange(vLength, 0.0, taper, 0.0, 1.0), 1.0, when_eq(taper, 0.0));

    objectNormal.xyz = normalize(B * circX + N * circY);
    transformed.xyz = current + B * volume.x * circX + N * volume.y * circY;
    //extrude tube

    vec3 transformedNormal = normalMatrix * objectNormal;

    vec3 pos = transformed;
    vec4 mvPosition = modelViewMatrix * vec4(transformed, 1.0);
    vViewPosition = -mvPosition.xyz;
    vPos = pos;
    gl_Position = projectionMatrix * mvPosition;

    //neutrinovspost

    vNormal = normalize(transformedNormal);
    vUv = tuv.yx;
}

#!SHADER: Fragment
void main() {
    gl_FragColor = vec4(1.0);
}{@}ProtonTubesMain.fs{@}void main() {
    vec3 index = getData(tIndices, vUv);

    float CHAIN = index.x;
    float LINE = index.y;
    float HEAD = index.z;

    if (HEAD > 0.9) {

        //main

    } else {

        float followIndex = getIndex(LINE, CHAIN-1.0, lineSegments);
        float headIndex = getIndex(LINE, 0.0, lineSegments);
        vec3 followPos = texture2D(tInput, getUVFromIndex(followIndex, textureSize)).xyz;
        vec4 followSpawn = texture2D(tSpawn, getUVFromIndex(headIndex, textureSize));

        if (followSpawn.x <= 0.0) {
            pos.x = 9999.0;
            gl_FragColor = vec4(pos, data);
            return;
        }

        if (length(followPos - pos) > uResetDelta) {
            followPos = texture2D(tInput, getUVFromIndex(headIndex, textureSize)).xyz;
            pos = followPos;
        }

        pos += (followPos - pos) * (uLerp * timeScale * HZ);
    }
}{@}ProtonTubesUniforms.fs{@}uniform sampler2D tIndices;
uniform float textureSize;
uniform float lineSegments;
uniform float uLerp;
uniform float uResetDelta;

vec2 getUVFromIndex(float index, float textureSize) {
    float size = textureSize;
    vec2 ruv = vec2(0.0);
    float p0 = index / size;
    float y = floor(p0);
    float x = p0 - y;
    ruv.x = x;
    ruv.y = y / size;
    return ruv;
}

float getIndex(float line, float chain, float lineSegments) {
    return (line * lineSegments) + chain;
}{@}SceneLayout.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform float uAlpha;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
void main() {
    vec3 pos = position;
    vUv = uv;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment
void main() {
    gl_FragColor = texture2D(tMap, vUv);
    gl_FragColor.a *= uAlpha;
    gl_FragColor.rgb /= gl_FragColor.a;
}{@}ShadowInspector.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
void main() {
    vUv = uv;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: Fragment

#require(depthvalue.fs)

void main() {
    gl_FragColor = vec4(vec3(getDepthValue(tMap, vUv, 10.0, 51.0)), 1.0);
}{@}SnapshotFrame.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
void main() {
	vUv = uv;
	gl_Position = vec4(position, 1.0);
}

#!SHADER: Fragment
void main() {
	gl_FragColor = texture2D(tMap, vUv);
}
{@}SplineParticleInstance.glsl{@}#!ATTRIBUTES
attribute vec2 lookup;

#!UNIFORMS
uniform sampler2D tPos;

#!VARYINGS

#!SHADER: Vertex

#require(instance.vs)
#require(rotation.glsl)

void main() {
    vec3 offset = texture2D(tPos, lookup).xyz;
    vec3 p = vec3(rotationMatrix(vec3(0.0, 0.0, 1.0), radians(time*10000000.0)) * vec4(position, 1.0));
    vec3 pos = transformPosition(p, offset);
    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment
void main() {
    gl_FragColor = vec4(1.0);
}{@}SplineParticleLife.fs{@}uniform sampler2D tAttribs;
uniform sampler2D tPos;
uniform sampler2D tOrigin;
uniform float uMaxCount;
uniform float uSplineCount;
uniform float uSetup;
uniform float uDecayRate;
uniform float uTimeMultiplier;
uniform float uIHold;
uniform vec2 uDecayRange;
uniform vec2 uRelease;
uniform float uStartOffset;
uniform vec2 uFlowRange;
uniform vec2 uSplineSpeed;
uniform float uInfinite;
uniform float uDelayStart;
uniform float uMaxDelay;
uniform float uMaxSDelay;
uniform float uHoldBack;
uniform float uHoldBack2;
uniform float uStartSpacing;
uniform vec4 uLifeSlow;
uniform float HZ;

#require(range.glsl)
#require(conditionals.glsl)
#require(simplenoise.glsl)

float sround(float i) {
    return floor(i + 0.5);
}

float randomSeed(float seed) {
    float n = sin(seed) * 10.0;
    return n - floor(n);
}

float srand(float seed, float min, float max) {
    return (min + randomSeed(seed) * (max - min));
}

void main() {
    vec2 uv = vUv;

    if (vUv.x + vUv.y * fSize > uMaxCount) {
        gl_FragColor = vec4(9999.0);
        return;
    }

    vec4 inputData = getData4(tInput, uv);
    vec4 random = getData4(tAttribs, uv);
    vec4 random2 = (getData4(tOrigin, uv) / 2.0) + 0.5;
    vec4 pos = getData4(tPos, uv);

    vec4 outputData;
    outputData.x = sround(crange(random.x, 0.0, 1.0, 0.0, uSplineCount-1.0));

//    float decay = crange(random.w, 0.0, 1.0, uDecayRange.x, uDecayRange.y);
//
//    outputData.y = inputData.y + mix(0.02 * uDecaySpeed.x * decay, 0.002 * uDecaySpeed.y * decay, when_gt(inputData.y, 0.999));
//    outputData.y = clamp(outputData.y, 0.0, 2.0);

    outputData.y = inputData.y - (0.01 * uDecayRate * mix(uDecayRange.x, uDecayRange.y, random2.y) * timeScale * HZ);
    outputData.y = clamp(outputData.y, 0.0, 1.0);

    if (uSetup > 0.5) {
        outputData.z = crange(random.w, 0.0, 1.0, 0.0, uStartOffset);
        outputData.z += srand(outputData.x, 0.0, uStartSpacing);
    } else {
        float delayed = 1.0;
        float delayedSpline = 1.0;

        float sRandom = crange(cnoise(vec2(random.x)), -1.0, 1.0, 0.0, 1.0);

        bool isStarting = inputData.z == 0.0;

        if (uDelayStart > 0.0) {
            delayed = time - uDelayStart > uMaxDelay * random2.y ? 1.0 : 0.0;
            delayedSpline = time - uDelayStart > uMaxSDelay * random.x ? 1.0 : 0.0;
        }

        float lifeSlow = crange(inputData.z, uLifeSlow.x, uLifeSlow.y, uLifeSlow.z, uLifeSlow.w);
        outputData.z = inputData.z + (0.001 * timeScale * uTimeMultiplier * lifeSlow * HZ * crange(random2.z, 0.0, 1.0, uFlowRange.x, uFlowRange.y) * crange(sRandom, 0.0, 1.0, uSplineSpeed.x, uSplineSpeed.y));

        if (uRelease.y > 1.0) {
            if (inputData.z < 0.001 || inputData.z > 1.0) {
                float minR = uRelease.x / uRelease.y;
                float maxR = (uRelease.x+1.0) / uRelease.y;
                if (random.w < minR || random.w > maxR) {
                    outputData.z = 0.0;
                }
            }
        }
//
        if (isStarting) outputData.z *= delayed * delayedSpline * step(1.0 - ((1.0 - uHoldBack) * (1.0 - uHoldBack2)), random2.x);

        if (outputData.z > 1.0) {
            outputData.w = 0.0;
            if (uInfinite > 0.5) outputData.z = 0.0;
        } else if (outputData.z < 0.01) {
            outputData.y = 1.0;
        }

        if (uIHold > 0.5) outputData.z = 0.0;
    }

    gl_FragColor = outputData;
}{@}SplineParticlePreset.fs{@}void main() {
sRandom = random;
sOrigin = origin;

float travel = texture2D(tLife, vUv).z;
vec3 target = getSplinePos(travel);

if (uSetup > 0.5 || travel < 0.001) {
    pos = target;
}

pos += (target - pos) * 0.07 * HZ;
}{@}splineparticles.fs{@}uniform sampler2D tSpline;
uniform sampler2D tLife;
uniform float uSplineTexSize;
uniform float uPerSpline;
uniform float uSplineCount;
uniform float uInfinite;
uniform float uSetup;

vec4 sRandom;
vec3 sOrigin;

float splinenoise(vec3 v) {
    float t = v.z * 0.3;
    v.y *= 0.8;
    float noise = 0.0;
    float s = 0.5;
    noise += range(sin(v.x * 0.9 / s + t * 10.0) + sin(v.x * 2.4 / s + t * 15.0) + sin(v.x * -3.5 / s + t * 4.0) + sin(v.x * -2.5 / s + t * 7.1), -1.0, 1.0, -0.3, 0.3);
    noise += range(sin(v.y * -0.3 / s + t * 18.0) + sin(v.y * 1.6 / s + t * 18.0) + sin(v.y * 2.6 / s + t * 8.0) + sin(v.y * -2.6 / s + t * 4.5), -1.0, 1.0, -0.3, 0.3);
    return noise;
}

float sround(float i) {
    return floor(i + 0.5);
}

float randomSeed(float seed) {
    float n = sin(seed) * 10000000.0;
    return n - floor(n);
}

float srand(float seed, float min, float max) {
    return sround((min + randomSeed(seed) * (max - min)));
}

float getSplineIndex() {
    return sround(crange(sRandom.x, 0.0, 1.0, 0.0, uSplineCount-1.0));
}

vec2 getSplineLookupUV(float index, float time) {
    float pixel = uPerSpline * (index + time);
    return vec2(mod(pixel, uSplineTexSize), floor(pixel / uSplineTexSize)) / uSplineTexSize;
}

float ssineOut(float t) {
    return sin(t * 1.5707963267948966);
}

float scnoise(vec3 v) {
    float t = v.z * 0.3;
    v.y *= 0.8;
    float noise = 0.0;
    float s = 0.5;
    noise += range(sin(v.x * 0.9 / s + t * 10.0) + sin(v.x * 2.4 / s + t * 15.0) + sin(v.x * -3.5 / s + t * 4.0) + sin(v.x * -2.5 / s + t * 7.1), -1.0, 1.0, -0.3, 0.3);
    noise += range(sin(v.y * -0.3 / s + t * 18.0) + sin(v.y * 1.6 / s + t * 18.0) + sin(v.y * 2.6 / s + t * 8.0) + sin(v.y * -2.6 / s + t * 4.5), -1.0, 1.0, -0.3, 0.3);
    return noise;
}

vec3 getSplineThickness(vec3 pos, float time) {
    float angle = radians(360.0 * sRandom.z);

    float gamma = ssineOut(crange(scnoise(sOrigin.xyz * uDistribution), -1.0, 1.0, 0.0, 1.0));
    float fizzy = pow(mix(uDistributionRange.x, uDistributionRange.y, gamma), 3.0);

    float splineRandom = 0.0;//srand(getSplineIndex() * 10000.0, 0.0, 1000.0) / 1000.0;
    float splineRandomStep = step(uThicknessStep.x, splineRandom);
    float distribution = mix(uThicknessStep.y, 1.0, 1.0 - splineRandomStep);

    float radius = 0.5 * uSplineThickness * distribution * fizzy;

    radius *= crange(splinenoise((pos * uRangeScale) + time*uThicknessSpeed), -1.0, 1.0, 1.0 - uRangeThickness, 1.0 + uRangeThickness);
    radius *= mix(1.0, uExtrudeRandom, sRandom.y);

    return normalize(sOrigin) * radius;
}

vec3 getSplinePosRaw(float time) {
    float step = 1.0 / uPerSpline;
    float index = getSplineIndex();

    float next = time + step;
    vec2 uv0 = vec2(0.);
    vec2 uv1 = vec2(1.);

    if(next <= 1.) {
        uv0 = getSplineLookupUV(index, time);
        uv1 = getSplineLookupUV(index, next);
    } else {
        uv0 = getSplineLookupUV(index, 1.);
        uv1 = getSplineLookupUV(index, time - step);
    }
    
    float interpolate = mod(time, step) * uPerSpline;

    vec3 cpos = texture2D(tSpline, uv0).xyz;
    vec3 npos = texture2D(tSpline, uv1).xyz;
    vec3 pos = mix(cpos, npos, interpolate);

    if (uSCurlNoiseSpeed > 0.0) {
        pos += curlNoise((pos * uSCurlNoiseScale*0.1) + (time * uSCurlTimeScale*0.1)) * uSCurlNoiseSpeed * 0.01 * HZ;
    }

    return pos;
}

vec3 getSplinePos(float time) {
    vec3 pos = getSplinePosRaw(time);
    pos += getSplineThickness(pos, time);
    return pos;
}{@}splineshader.glsl{@}uniform sampler2D tSpline;
uniform float uSplineTexSize;
uniform float uPerSpline;

#require(conditionals.glsl)

float sround(float i) {
    return floor(i + 0.5);
}

vec2 getSplineLookupUV(float index, float time) {
    float pixel = (index * uPerSpline) + (time * uPerSpline);

    float size = uSplineTexSize;
    float p0 = pixel / size;
    float y = floor(p0);
    float x = p0 - y;

    vec2 uv = vec2(0.0);
    uv.x = x;
    uv.y = y / size;
    return uv;
}

vec3 getSplinePos(float index, float time) {
    vec2 uv = getSplineLookupUV(index, time);
    vec3 pos = texture2D(tSpline, uv).xyz;
    return pos;
}

float isMoving(float index, float time) {
    vec3 cpos = getSplinePos(index, time);
    vec3 npos = getSplinePos(index, time + (1.0 / uPerSpline));

    float moving = when_gt(length(cpos - npos), 0.001);
    moving = mix(moving, 1.0, when_gt(time, 0.5));

    return moving;
}{@}Text3D.glsl{@}#!ATTRIBUTES
attribute vec3 animation;

#!UNIFORMS
uniform sampler2D tMap;
uniform vec3 uColor;
uniform float uAlpha;
uniform float uOpacity;
uniform vec3 uTranslate;
uniform vec3 uRotate;
uniform float uTransition;
uniform float uWordCount;
uniform float uLineCount;
uniform float uLetterCount;
uniform float uByWord;
uniform float uByLine;
uniform float uPadding;
uniform vec3 uBoundingMin;
uniform vec3 uBoundingMax;
uniform float uScrollDelta;
uniform vec2 uMouse;
uniform sampler2D tFluid;
uniform sampler2D tFluidMask;

#!VARYINGS
varying float vTrans;
varying vec2 vUv;
varying vec3 vPos;
varying vec3 vWorldPos;

#!SHADER: Vertex

#require(range.glsl)
#require(eases.glsl)
#require(rotation.glsl)
#require(conditionals.glsl)

void main() {
    vUv = uv;
    vTrans = 1.0;

    vec3 pos = position;

    if (uTransition > 0.0 && uTransition < 1.0) {
        float padding = uPadding;
        float letter = (animation.x + 1.0) / uLetterCount;
        float word = (animation.y + 1.0) / uWordCount;
        float line = (animation.z + 1.0) / uLineCount;

        float letterTrans = rangeTransition(uTransition, letter, padding);
        float wordTrans = rangeTransition(uTransition, word, padding);
        float lineTrans = rangeTransition(uTransition, line, padding);

        vTrans = mix(cubicOut(letterTrans), cubicOut(wordTrans), uByWord);
        vTrans = mix(vTrans, cubicOut(lineTrans), uByLine);

        float invTrans = (1.0 - vTrans);
        vec3 nRotate = normalize(uRotate);
        vec3 axisX = vec3(1.0, 0.0, 0.0);
        vec3 axisY = vec3(0.0, 1.0, 0.0);
        vec3 axisZ = vec3(0.0, 0.0, 1.0);
        vec3 axis = mix(axisX, axisY, when_gt(nRotate.y, nRotate.x));
        axis = mix(axis, axisZ, when_gt(nRotate.z, nRotate.x));
        pos = vec3(vec4(position, 1.0) * rotationMatrix(axis, radians(max(max(uRotate.x, uRotate.y), uRotate.z) * invTrans)));
        pos += uTranslate * invTrans;
    }

    vPos = pos;
	vWorldPos = vec3(modelMatrix * vec4(pos, 1.0));

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment

#require(range.glsl)
#require(msdf.glsl)
#require(simplenoise.glsl)
#require(transformUV.glsl)

vec2 getBoundingUV() {
    vec2 uv;
    uv.x = crange(vPos.x, uBoundingMin.x, uBoundingMax.x, 0.0, 1.0);
    uv.y = crange(vPos.y, uBoundingMin.y, uBoundingMax.y, 0.0, 1.0);
    return uv;
}

void main() {
    vec2 uv = vUv;
    vec2 screenuv = gl_FragCoord.xy / resolution;
    vec2 squareScreenuv = scaleUV(screenuv, vec2(1.0, resolution.x/resolution.y));
    vec2 mouse = scaleUV(vec2(uMouse.x, 1.0-uMouse.y), vec2(1.0, resolution.x/resolution.y));

    mouse += cnoise(screenuv*10.0 + time * 0.2 + length(mouse) * 5.0) * 0.01;

    vec2 fluid = texture2D(tFluid, screenuv).xy;
    float fluidMask = smoothstep(0.0, 1.0, texture2D(tFluidMask, screenuv).r);
    float fluidPush = pow(abs(fluid.x)*0.01, 2.5);
    float fluidEdge = fluidPush * smoothstep(0.0, 0.5, fluidMask) * smoothstep(1.0, 0.8, fluidMask);

    //uv.y -= uScrollDelta * 0.1 * mix(-1.0, 1.0, step(0.05, mod(uv.x, 0.5))) * mod(uv.y, 0.3);
    uv += fluidEdge * 0.1;

    float alpha = msdf(tMap, uv);

    //float noise = 0.5 + smoothstep(-1.0, 1.0, cnoise(vec3(vUv*50.0, time* 0.3))) * 0.5;

    vec4 color = vec4(uColor, alpha * uAlpha * uOpacity * vTrans);

    float mouseLen = (1.0-step(0.1, length(squareScreenuv-mouse)));

    // float lines = sin(screenuv.x * resolution.x * 0.5) * (0.5 + cnoise(screenuv*30.0 + time * 0.2));
    // lines = step(0.2, lines);

    vec2 lineUV = screenuv + fluidPush * 0.1;
    float lines = fract(screenuv.x * 300.0) * fract(screenuv.y * 300.0);
    lines = step(0.7, lines);
    color.a = mix(color.a, lines, fluidEdge);

    #drawbuffer Color gl_FragColor = color;
    #drawbuffer Refraction gl_FragColor = color;
}
{@}TweenUILPathFallbackShader.glsl{@}#!ATTRIBUTES
attribute float speed;

#!UNIFORMS
uniform vec3 uColor;
uniform vec3 uColor2;
uniform float uOpacity;

#!VARYINGS
varying vec3 vColor;

#!SHADER: Vertex

void main() {
    vColor = mix(uColor, uColor2, speed);
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: Fragment
void main() {
    gl_FragColor = vec4(vColor, uOpacity);
}
{@}TweenUILPathShader.glsl{@}#!ATTRIBUTES
attribute float speed;

#!UNIFORMS
uniform vec3 uColor2;

#!VARYINGS

#!SHADER: Vertex

void main() {
    vColor = mix(uColor, uColor2, speed);
}

void customDirection() {
    // Use screen space coordinates for final position, so line thickness is
    // independent of camera.
    finalPosition = vec4(currentP.x / aspect, currentP.y, min(0.0, finalPosition.z), 1.0);
}

#!SHADER: Fragment
float tri(float v) {
    return mix(v, 1.0 - v, step(0.5, v)) * 2.0;
}

void main() {
    float signedDist = tri(vUv.y) - 0.5;
    gl_FragColor.a *= clamp(signedDist/fwidth(signedDist) + 0.5, 0.0, 1.0);
}
{@}UnrealBloom.fs{@}uniform sampler2D tUnrealBloom;

vec3 getUnrealBloom(vec2 uv) {
    return texture2D(tUnrealBloom, uv).rgb;
}{@}UnrealBloomComposite.glsl{@}#!ATTRIBUTES

#!UNIFORMS

uniform sampler2D blurTexture1;
uniform float bloomStrength;
uniform float bloomRadius;
uniform vec3 bloomTintColor;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex.vs
void main() {
    vUv = uv;
    gl_Position = vec4(position, 1.0);
}

#!SHADER: Fragment.fs

float lerpBloomFactor(const in float factor) {
    float mirrorFactor = 1.2 - factor;
    return mix(factor, mirrorFactor, bloomRadius);
}

void main() {
    gl_FragColor = bloomStrength * (lerpBloomFactor(1.0) * vec4(bloomTintColor, 1.0) * texture2D(blurTexture1, vUv));
}{@}UnrealBloomGaussian.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D colorTexture;
uniform vec2 texSize;
uniform vec2 direction;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex.vs
void main() {
    vUv = uv;
    gl_Position = vec4(position, 1.0);
}

#!SHADER: Fragment.fs

float gaussianPdf(in float x, in float sigma) {
    return 0.39894 * exp(-0.5 * x * x / (sigma * sigma)) / sigma;
}

void main() {
    vec2 invSize = 1.0 / texSize;
    float fSigma = float(SIGMA);
    float weightSum = gaussianPdf(0.0, fSigma);
    vec3 diffuseSum = texture2D( colorTexture, vUv).rgb * weightSum;
    for(int i = 1; i < KERNEL_RADIUS; i ++) {
        float x = float(i);
        float w = gaussianPdf(x, fSigma);
        vec2 uvOffset = direction * invSize * x;
        vec3 sample1 = texture2D( colorTexture, vUv + uvOffset).rgb;
        vec3 sample2 = texture2D( colorTexture, vUv - uvOffset).rgb;
        diffuseSum += (sample1 + sample2) * w;
        weightSum += 2.0 * w;
    }
    gl_FragColor = vec4(diffuseSum/weightSum, 1.0);
}{@}UnrealBloomLuminosity.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tDiffuse;
uniform vec3 defaultColor;
uniform float defaultOpacity;
uniform float luminosityThreshold;
uniform float smoothWidth;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex.vs
void main() {
    vUv = uv;
    gl_Position = vec4(position, 1.0);
}

#!SHADER: Fragment.fs

#require(luma.fs)

void main() {
    vec4 texel = texture2D(tDiffuse, vUv);
    float v = luma(texel.xyz);
    vec4 outputColor = vec4(defaultColor.rgb, defaultOpacity);
    float alpha = smoothstep(luminosityThreshold, luminosityThreshold + smoothWidth, v);
    gl_FragColor = mix(outputColor, texel, alpha);
}{@}UnrealBloomPass.fs{@}#require(UnrealBloom.fs)

void main() {
    vec4 color = texture2D(tDiffuse, vUv);
    color.rgb += getUnrealBloom(vUv);
    gl_FragColor = color;
}{@}luma.fs{@}float luma(vec3 color) {
  return dot(color, vec3(0.299, 0.587, 0.114));
}

float luma(vec4 color) {
  return dot(color.rgb, vec3(0.299, 0.587, 0.114));
}{@}GazeSelector.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform float uTime;
uniform vec3 uColor;
uniform float uAlpha;
uniform float uAlpha2;
uniform float uVisible;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
void main() {
    vUv = uv;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: Fragment

#define pi 3.1415926538
#require(transformUV.glsl)
#require(range.glsl)
#require(simplenoise.glsl)

float circle(vec2 _st, in float _radius){
    vec2 dist = _st-vec2(0.5);
    return 1.-smoothstep(_radius-(_radius*0.1), _radius+(_radius*0.1), dot(dist,dist)*4.0);
}

float arc(vec2 uv, float outerRadius, float innerRadius, float angle) {
    uv = rotateUV(uv, radians(180.0));
    float cc = circle(uv, outerRadius) - circle(uv, innerRadius);
    vec2 d = vec2(0.5) - uv;

    float angdist = mod(atan(d.x, d.y), 2.0*pi);
    cc *= mix(uAlpha2*0.6, uAlpha, uTime);

    float dotCircle = circle(uv, mix(0.0025, outerRadius, uTime)) - circle(uv, mix(0.0, mix(innerRadius*0.8, innerRadius, uTime), uTime));
    cc += dotCircle * mix(uAlpha2*0.6, uAlpha, uTime) * mix(0.4, 0.8, uTime);

    return cc;
}

void main() {
    float alpha = 1.0;

    float radius = crange(uAlpha, 0.0, 1.0, 0.2, 0.3);
    float offset = crange(uAlpha, 0.0, 1.0, 1.06, 1.1);

    vec2 arcUV = scaleUV(vUv, vec2(0.4));
    alpha *= arc(arcUV, radius*offset, radius, radians(uTime * 360.0));
    alpha *= uVisible;

    vec2 rippleUV = vUv;
    rippleUV += cnoise(rippleUV*3.0+time*0.2)*0.005;
    float ripple = fract(length(rippleUV-0.5)*mix(4.0, 7.0, uTime)-time*0.2);

    float midPoint = mix(0.6, 0.1, uTime);
    ripple *= smoothstep(0.0, midPoint, ripple) * smoothstep(1.0, midPoint, ripple);
    ripple *= smoothstep(0.5, 0.25, length(rippleUV-0.5)) * smoothstep(0.1, 0.15, length(rippleUV-0.5));
    alpha += ripple * mix(0.07, 0.3, uTime) * uVisible;

    gl_FragColor = vec4(uColor, alpha);
}{@}GazeSelector.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform float uTime;
uniform vec3 uColor;
uniform float uAlpha;
uniform float uAlpha2;
uniform float uVisible;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
void main() {
    vUv = uv;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: Fragment

#define pi 3.1415926538
#require(transformUV.glsl)
#require(range.glsl)
#require(simplenoise.glsl)

float circle(vec2 _st, in float _radius){
    vec2 dist = _st-vec2(0.5);
    return 1.-smoothstep(_radius-(_radius*0.1), _radius+(_radius*0.1), dot(dist,dist)*4.0);
}

float arc(vec2 uv, float outerRadius, float innerRadius, float angle) {
    uv = rotateUV(uv, radians(180.0));
    float cc = circle(uv, outerRadius) - circle(uv, innerRadius);
    vec2 d = vec2(0.5) - uv;

    float angdist = mod(atan(d.x, d.y), 2.0*pi);
    cc *= mix(uAlpha2*0.6, uAlpha, uTime);

    float dotCircle = circle(uv, mix(0.0025, outerRadius, uTime)) - circle(uv, mix(0.0, mix(innerRadius*0.8, innerRadius, uTime), uTime));
    cc += dotCircle * mix(uAlpha2*0.6, uAlpha, uTime) * mix(0.4, 0.8, uTime);

    return cc;
}

void main() {
    float alpha = 1.0;

    float radius = crange(uAlpha, 0.0, 1.0, 0.2, 0.3);
    float offset = crange(uAlpha, 0.0, 1.0, 1.06, 1.1);

    vec2 arcUV = scaleUV(vUv, vec2(0.4));
    alpha *= arc(arcUV, radius*offset, radius, radians(uTime * 360.0));
    alpha *= uVisible;

    vec2 rippleUV = vUv;
    rippleUV += cnoise(rippleUV*3.0+time*0.2)*0.005;
    float ripple = fract(length(rippleUV-0.5)*mix(4.0, 7.0, uTime)-time*0.2);

    float midPoint = mix(0.6, 0.1, uTime);
    ripple *= smoothstep(0.0, midPoint, ripple) * smoothstep(1.0, midPoint, ripple);
    ripple *= smoothstep(0.5, 0.25, length(rippleUV-0.5)) * smoothstep(0.1, 0.15, length(rippleUV-0.5));
    alpha += ripple * mix(0.07, 0.3, uTime) * uVisible;

    gl_FragColor = vec4(uColor, alpha);
}{@}ARCameraQuad.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
void main() {
    vUv = uv;
    gl_Position = vec4(position, 1.0);
}

#!SHADER: Fragment
void main() {
    #test !!window.Metal
    vUv.y = 1.0 - vUv.y;
    #endtest

    gl_FragColor = texture2D(tMap, vUv);
}{@}VRInputControllerDefault.glsl{@}#!ATTRIBUTES

#!UNIFORMS

#!VARYINGS
varying vec3 vViewDir;
varying vec3 vNormal;
varying vec3 vPos;

#!SHADER: Vertex
void main() {
    vec4 mvPosition = modelViewMatrix * vec4(position, 1.0);
    vViewDir = -mvPosition.xyz;
    vPos = position;
    vNormal = normalMatrix * normal;
    gl_Position = projectionMatrix * mvPosition;
}

#!SHADER: Fragment

#require(fresnel.glsl)
#require(range.glsl)

void main() {
    float f = getFresnel(vNormal, vViewDir, 0.8);

    f *= crange(vPos.z, 0.04, 0.1, 1.0, 0.0);

    vec3 color = vec3(1.0);
    gl_FragColor = vec4(color, f);
}{@}VRHand.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform vec3 uColor;
uniform float uStatic;

#!VARYINGS
varying vec2 vUv;
varying vec3 vPos;
varying vec3 vNormal;
varying vec3 vViewDir;

#!SHADER: Vertex

#require(skinning.glsl)

void main() {
    vNormal = normalize(normalMatrix * normal);
    vUv = uv;
    vViewDir = -vec3(modelViewMatrix * vec4(position, 1.0));
    vec3 pos = position;

    if (uStatic < 0.5) {
        applySkin(pos, vNormal);
    }

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment

#require(fresnel.glsl)

void main() {
    gl_FragColor = vec4(uColor * (1.0 - getFresnel(vNormal, vViewDir, 5.0)), 1.0);
}