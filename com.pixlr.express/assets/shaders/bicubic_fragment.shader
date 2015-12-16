precision highp float;

uniform float textureSizeWidth;
uniform float textureSizeHeight;
uniform float texelSizeX;
uniform float texelSizeY;
varying vec2 vTextureCoord;
uniform sampler2D uSampler;

uniform float uParam1;
uniform float uParam2;

float BSpline( float x )
{
    float f = x;
    if( f < 0.0 )
    {
        f = -f;
    }

    if( f >= 0.0 && f <= 1.0 )
    {
        return ( 2.0 / 3.0 ) + ( 0.5 ) * ( f* f * f ) - (f*f);
    }
    else if( f > 1.0 && f <= 2.0 )
    {
        return 1.0 / 6.0 * pow( ( 2.0 - f  ), 3.0 );
    }
    return 1.0;
}  

vec4 BiCubic( sampler2D textureSampler, vec2 TexCoord )
{
    //float texelSizeX = 1.0 / fWidth; //size of one texel 
    //float texelSizeY = 1.0 / fHeight; //size of one texel 
    vec4 nSum = vec4( 0.0, 0.0, 0.0, 0.0 );
    vec4 nDenom = vec4( 0.0, 0.0, 0.0, 0.0 );
    float a = fract( TexCoord.x * textureSizeWidth ); // get the decimal part
    float b = fract( TexCoord.y * textureSizeHeight ); // get the decimal part
    for( int m = -1; m <=2; m++ )
    {
        for( int n =-1; n<= 2; n++)
        {
            vec4 vecData = texture2D(textureSampler, 
                               TexCoord + vec2(texelSizeX * float( m ), 
                    texelSizeY * float( n )));
            float f  = BSpline( float( m ) - a );
            vec4 vecCooef1 = vec4( f,f,f,f );
            float f1 = BSpline ( -( float( n ) - b ) );
            vec4 vecCoeef2 = vec4( f1, f1, f1, f1 );
            nSum = nSum + ( vecData * vecCoeef2 * vecCooef1  );
            nDenom = nDenom + (( vecCoeef2 * vecCooef1 ));
        }
    }
    return nSum / nDenom;
}



void main() { 

    gl_FragColor = BiCubic(uSampler, vTextureCoord);

}
