precision highp float;

uniform sampler2D uSampler;
uniform float uHue;
uniform float uSaturation;
uniform float uVibrance;
uniform float uWarmth;
uniform float uBrightness;

varying vec2 vTextureCoord;

// sRGB working space, D50 reference white
// See http://www.brucelindbloom.com/Eqn_RGB_XYZ_Matrix.html

mat3 mRGBtoXYZ = mat3(
    0.4360747, 0.2225045, 0.0139322,
    0.3850649, 0.7168786, 0.0971045,
    0.1430804, 0.0606169, 0.7141733
);

mat3 mXYZtoRGB = mat3(
    3.1338561, -0.9787684, 0.0719453,
    -1.6168667, 1.9161415, -0.2289914,
    -0.4906146, 0.0334540, 1.4052427
);


// Bradford method for Chromatic Adaptation
// See http://www.brucelindbloom.com/Eqn_ChromAdapt.html

mat3 mBradford = mat3(
    0.8951000, -0.7502000, 0.0389000,
    0.2664000, 1.7135000, -0.0685000,
    -0.1614000, 0.0367000, 1.0296000
);

mat3 mBradfordInv = mat3(
    0.9869929, 0.4323053, -0.0085287,
    -0.1470543, 0.5183603, 0.0400428,
    0.1599627, 0.0492912, 0.9684867
);

float Luminance(vec3 c) {
    return dot(c, vec3(0.299, 0.587, 0.114));
}

/*

The following function is adapted from GPUImage

https://github.com/BradLarson/GPUImage

Copyright (c) 2012, Brad Larson, Ben Cochran, Hugues Lismonde, Keitaroh Kobayashi, Alaric Cole, Matthew Clark, Jacob Gundersen, Chris Williams.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
Neither the name of the GPUImage framework nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

vec3 ClipColor(vec3 c) {
    float l = Luminance(c);
    float n = min(min(c.r, c.g), c.b);
    float x = max(max(c.r, c.g), c.b);
    
    if (n < 0.0) {
        c.r = l + ((c.r - l) * l) / (l - n);
        c.g = l + ((c.g - l) * l) / (l - n);
        c.b = l + ((c.b - l) * l) / (l - n);
    }
    if (x > 1.0) {
        c.r = l + ((c.r - l) * (1.0 - l)) / (x - l);
        c.g = l + ((c.g - l) * (1.0 - l)) / (x - l);
        c.b = l + ((c.b - l) * (1.0 - l)) / (x - l);
    }
 
    return c;
 }


void main(void) {

    vec4 color = texture2D(uSampler, vTextureCoord);

	//for premultiplied image
	if(color.a != 0.0)	color.rgb /= color.a;

    float angle = uHue * 3.14159265;
    float s = sin(angle), c = cos(angle);
    vec3 weights = (vec3(2.0 * c, -sqrt(3.0) * s - c, sqrt(3.0) * s - c) + 1.0) / 3.0;
    float len = length(color.rgb);
    color.rgb = vec3(
        dot(color.rgb, weights.xyz),
        dot(color.rgb, weights.zxy),
        dot(color.rgb, weights.yzx));

	color.rgb = clamp(color.rgb, 0.0, 1.0);

    float average = (color.r + color.g + color.b) / 3.0;

    float luminance = Luminance(color.rgb);
    
    float saturation = uSaturation;

    if (saturation > 0.0) {
        saturation = saturation * 0.5;
        color.rgb += (luminance - color.rgb) * (1.0 - 1.0 / (1.001 - saturation));
    } else {
        color.rgb += (luminance - color.rgb) * (-saturation);
    }

	color.rgb = clamp(color.rgb, 0.0, 1.0);
    
    luminance = Luminance(color.rgb);

    
    float mn = min(min(color.r, color.g), color.b);
    float mx = max(max(color.r, color.g), color.b);
    float invsat = pow(1.0 - (mx - mn), 2.0);

    color.rgb = mix(vec3(luminance), color.rgb, uVibrance * invsat + 1.0);
    

    vec3 refWhiteTo;
    vec3 refWhiteFrom = vec3(1.0, 1.0, 1.0);

    if (uWarmth > 0.0) {
        refWhiteTo = mix(vec3(1.0, 1.0, 1.0), vec3(0.8, 0.8, 0.2), uWarmth * 0.75);
    } else {
        refWhiteTo = mix(vec3(1.0, 1.0, 1.0), vec3(0.1, 0.2, 0.8), -uWarmth * 0.75);
    }

    vec3 crSrc = mBradford * refWhiteFrom;
    vec3 crDst = mBradford * refWhiteTo;

    mat3 mcr = mat3(
        crDst.x / crSrc.x, 0.0, 0.0,
        0.0, crDst.y / crSrc.y, 0.0,
        0.0, 0.0, crDst.z / crSrc.z
    );

    mat3 mChromatic = mBradfordInv * mcr * mBradford;

    vec3 xyz = mChromatic * (mRGBtoXYZ * color.rgb);
    vec3 rgb = mXYZtoRGB * xyz;

    float oldLuminance = Luminance(color.rgb);
    float newLuminance = Luminance(rgb);

    rgb += vec3(oldLuminance) - vec3(newLuminance);
    rgb = ClipColor(rgb);

	if(color.a != 0.0)
	{
		rgb += uBrightness;
	}

	rgb = clamp(rgb, 0.0, 1.0);

	//for premultiplied image
	rgb *= color.a;

    gl_FragColor = vec4(rgb, color.a);

}