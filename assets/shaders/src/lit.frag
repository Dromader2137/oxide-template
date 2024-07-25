#version 460

layout(location = 0) out vec4 f_color;
layout(location = 0) in vec2 uv;
layout(location = 1) in vec3 normal;
layout(location = 2) in vec3 tangent;
layout(location = 3) in vec3 bitangent;

layout(std140, set = 4, binding = 0) uniform params {
	vec3 color;
	float _pad;
	uint use_color;
	uint use_normal;
} material_params;

layout(set = 3, binding = 0) uniform sampler2D color_tex;
layout(set = 3, binding = 1) uniform sampler2D normal_tex;

void main() {
	vec3 light_dir = normalize(vec3(-1.0, -0.2, 2.0));
	float ambient = 0.1;

	vec3 t_normal = vec3(0.0, 0.0, 1.0);
	if(material_params.use_normal == 1) {
	    t_normal = (2*texture(normal_tex, uv).xyz)-1.0;
	}
	mat3 tbn = mat3(tangent, bitangent, normal);

	t_normal = tbn * t_normal;
	
	float intensity = clamp(dot(-light_dir, t_normal), 0.0, 1.0) + ambient;

	if(material_params.use_color == 1) {
	    f_color = vec4((intensity * texture(color_tex, uv).xyz), 1.0);
	} else {
	    f_color = vec4((intensity * material_params.color), 1.0);
	}
}
