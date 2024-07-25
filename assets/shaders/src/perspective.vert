#version 460
#extension GL_EXT_buffer_reference : require

layout(location = 0) out vec2 uv_out;
layout(location = 1) out vec3 normal_out;
layout(location = 2) out vec3 tangent_out;
layout(location = 3) out vec3 bitangent_out;

layout(set = 0, binding = 0) uniform vp_data {
	mat4 view;
	mat4 projection;
} vp;

struct ModelData {
	mat4 translation;
	mat4 rotation;
	mat4 scale;
};

struct Vertex {
	vec3 position;
	vec2 uv;
	vec3 normal;
	vec4 tangent;
};

layout(std140,set = 1, binding = 0) readonly buffer ModelBuffer {
	ModelData data[];
} model;

layout(std140, buffer_reference, buffer_reference_align = 64) readonly buffer VertexBuffer
{
    Vertex vertices[];
};

layout(std430,set = 2, binding = 0) readonly buffer VertexPtrBuffer {
	VertexBuffer data[];
} vertex;

layout(std430, buffer_reference, buffer_reference_align = 4) readonly buffer IndexBuffer
{
	uint indices[];
};

layout(std430,set = 2, binding = 1) readonly buffer IndexPtrBuffer {
	IndexBuffer data[];
} index;

void main() {
	ModelData m = model.data[gl_BaseInstance];
	uint i = index.data[gl_BaseInstance].indices[gl_VertexIndex];
	Vertex v = vertex.data[gl_BaseInstance].vertices[i];
	
	mat4 model = m.translation * m.rotation * m.scale;
	mat4 mvp = vp.projection * vp.view * model;

    gl_Position = mvp * vec4(v.position, 1.0);
	normal_out = normalize((m.rotation * vec4(v.normal, 0.0)).xyz);
	tangent_out = normalize((m.rotation * vec4(v.tangent.xyz, 0.0)).xyz);
	bitangent_out = normalize(cross(normal_out, tangent_out));
	if (v.tangent.w == -1.0) {
		bitangent_out *= -1.0;
	}
	uv_out = v.uv;
}
