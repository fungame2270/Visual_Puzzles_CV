shader_type spatial;
render_mode unshaded;
uniform sampler2D screen_texture;

uniform float range : hint_range(0.0, 0.1, 0.005)= 0.05;
uniform float noiseQuality : hint_range(0.0, 300.0, 0.1)= 250.0;
uniform float noiseIntensity : hint_range(-0.6, 0.6, 0.0010)= 0.0088;
uniform float offsetIntensity : hint_range(-0.1, 0.1, 0.001) = 0.03;
uniform float colorOffsetIntensity : hint_range(0.0, 5.0, 0.001) = 1.3;

float rand(vec2 co)
{
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void fragment()
{
    vec2 uv = UV;

    float UVY = uv.y;
    UVY *= noiseQuality;
    UVY = float(int(UVY)) * (1.0 / noiseQuality);
    float noise = rand(vec2(TIME * 0.00001, UVY));
    uv.x += noise * noiseIntensity;

    vec2 offsetR = vec2(0.009 * sin(TIME), 0.0) * colorOffsetIntensity;
    vec2 offsetG = vec2(0.0073 * (cos(TIME * 0.97)), 0.0) * colorOffsetIntensity;

    float r = texture(screen_texture, uv + offsetR).r;
    float g = texture(screen_texture, uv + offsetG).g;
    float b = texture(screen_texture, uv).b;
    vec4 tex = vec4(r, g, b, 1.0);
    ALBEDO = tex.rgb;
}