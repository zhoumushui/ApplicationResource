precision highp float;

uniform sampler2D texture;
varying vec2 vTextureCoord;

float discretize(float f, float d)
{
    return floor(f*d + 0.5)/d;
}

vec2 discretize(vec2 v, float d)
{
    return vec2(discretize(v.x, d), discretize(v.y, d));
}

void main()
{
    vec2 texCoord = discretize(vTextureCoord, 128.0);
    gl_FragColor = texture2D(texture, texCoord);
}