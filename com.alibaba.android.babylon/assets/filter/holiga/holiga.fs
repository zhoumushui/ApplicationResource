precision mediump float;
uniform sampler2D inputTextureY;
uniform sampler2D inputTextureU;
uniform sampler2D inputTextureV;
uniform sampler2D toneCurveTexture;
varying vec2 textureCoordinate;
uniform lowp float vignetteStart;
uniform lowp float vignetteEnd;
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

    lowp vec4 textureColor = vec4(r, g, b, 1.0);
    lowp vec4 outputColor  = textureColor;
    lowp float           d = distance(textureCoordinate, vec2(0.5,0.5));
    lowp vec3 rgb          = textureColor.rgb;
    d = 1.0 - smoothstep(vignetteStart, vignetteEnd, d);
    rgb *= d;
    outputColor.rgb            = rgb;
    lowp float redCurveValue   = texture2D(toneCurveTexture, vec2(outputColor.r, 0.0)).r;
    lowp float greenCurveValue = texture2D(toneCurveTexture, vec2(outputColor.g, 0.0)).g;
    lowp float blueCurveValue  = texture2D(toneCurveTexture, vec2(outputColor.b, 0.0)).b;
    outputColor                = vec4(redCurveValue, greenCurveValue, blueCurveValue,outputColor.a);
    gl_FragColor               = outputColor;
//    gl_FragColor = texture2D(toneCurveTexture,  textureCoordinate);
}