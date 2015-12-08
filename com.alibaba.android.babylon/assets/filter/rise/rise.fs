precision mediump float;
uniform sampler2D inputTextureY;
uniform sampler2D inputTextureU;
uniform sampler2D inputTextureV;
uniform sampler2D inputImageTexture2; //blowout;
uniform sampler2D inputImageTexture3; //overlay;
uniform sampler2D inputImageTexture4; //map

varying vec2 textureCoordinate;
 
void main()
{
    float nx,ny,r,g,b,y,u,v;
    mediump vec4 txl,ux,vx;
    nx=textureCoordinate[0];
    ny=textureCoordinate[1];
    y=texture2D(inputTextureY,vec2(nx,ny)).r;
    u=texture2D(inputTextureU,vec2(nx,ny)).r;
    v=texture2D(inputTextureV,vec2(nx,ny)).r;

      //"  y = v;\n"+
    y=1.1643*(y-0.0625);
    u=u-0.5;
    v=v-0.5;

    r=y+1.5958*v;
    g=y-0.39173*u-0.81290*v;
    b=y+2.017*u;

  	vec4 texel = vec4(r, g, b, 1.0);
    vec3 bbTexel = texture2D(inputImageTexture2, textureCoordinate).rgb;
     
    texel.r = texture2D(inputImageTexture3, vec2(bbTexel.r, texel.r)).r;
    texel.g = texture2D(inputImageTexture3, vec2(bbTexel.g, texel.g)).g;
    texel.b = texture2D(inputImageTexture3, vec2(bbTexel.b, texel.b)).b;
     
    vec4 mapped;
    mapped.r = texture2D(inputImageTexture4, vec2(texel.r, .16666)).r;
    mapped.g = texture2D(inputImageTexture4, vec2(texel.g, .5)).g;
    mapped.b = texture2D(inputImageTexture4, vec2(texel.b, .83333)).b;
    mapped.a = 1.0;
     
    gl_FragColor = mapped;
}