#version 330 core

layout(location = 0) in vec4 vposition;
layout(location = 1) in vec2 vtexcoord;

uniform vec3 scale;
uniform vec3 translate;
out vec2 ftexcoord;

void main() {
	ftexcoord = vtexcoord;
	gl_Position = vposition * vec4(vec3(scale).xyz, 1.0) - vec4(translate.xyz, 0.0);
}
