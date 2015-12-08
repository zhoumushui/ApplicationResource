precision mediump float;
uniform sampler2D inputTextureY;
uniform sampler2D inputTextureU;
uniform sampler2D inputTextureV;
varying vec2 textureCoordinate;

uniform sampler2D curves_map;
uniform sampler2D vignette_map_plus_darker;
uniform sampler2D map;
uniform sampler2D overlay_map;
uniform sampler2D blowout_map;

void main ()
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

	const mediump mat3 saturate = mat3(1.210300, -0.089700, -0.091000, -0.176100, 1.123900, -0.177400, -0.034200, -0.034200, 1.265800);
	const mediump vec3 rgbPrime = vec3(0.25098, 0.14640522, 0.0);
	const mediump vec3 desaturate = vec3(.3, .59, .11);

	mediump vec3 texel = vec3(r, g, b);
	mediump vec2 lookup;
	lookup.y = 0.5;

	lookup.x = texel.r;
	texel.r = texture2D(curves_map, lookup).r;

	lookup.x = texel.g;
	texel.g = texture2D(curves_map, lookup).g;

	lookup.x = texel.b;
	texel.b = texture2D(curves_map, lookup).b;

	mediump vec3 result = texture2D(overlay_map, vec2(dot(desaturate, texel), 0.5)).rgb;

	texel = saturate * mix(texel, result, .5);

	mediump vec2 tc = (2.0 * textureCoordinate) - 1.0;
	mediump float d = dot(tc, tc);

	mediump vec3 sampled;

	lookup.x = texel.r;
	sampled.r = texture2D(vignette_map_plus_darker, lookup).r;

	lookup.x = texel.g;
	sampled.g = texture2D(vignette_map_plus_darker, lookup).g;

	lookup.x = texel.b;
	sampled.b = texture2D(vignette_map_plus_darker, lookup).b;

	mediump float value = smoothstep(0.0, 1.25, pow(d, 1.35)/1.65);
	texel = mix(texel, sampled, value);

	lookup.x = texel.r;
	sampled.r = texture2D(blowout_map, lookup).r;
	lookup.x = texel.g;
	sampled.g = texture2D(blowout_map, lookup).g;
	lookup.x = texel.b;
	sampled.b = texture2D(blowout_map, lookup).b;

	texel = mix(sampled, texel, value);

	mediump vec4 map_lookup_redgreen = texture2D(map, texel.xy);
	lookup.x = texel.b;
	mediump vec4 map_lookup_blue = texture2D(map, lookup);

	gl_FragColor = vec4(map_lookup_redgreen.r, map_lookup_redgreen.g, map_lookup_blue.b, 1.0);
}