#version 330 core

uniform sampler2D tex;
uniform vec2 windowSize;
uniform float time;

in vec2 ftexcoord;
layout(location = 0) out vec4 FragColor;

void main() {
	FragColor = texture(tex, ftexcoord);

	// From: https://github.com/opengl-tutorials/ogl/blob/master/tutorial14_render_to_texture/WobblyTexture.fragmentshader
	//vec2 uv = ftexcoord + 0.005 * vec2(sin(time + 1024.0 * ftexcoord.x), cos(time + 768.0 * ftexcoord.y));
	//FragColor = vec4(texture(tex, uv).xyz, 1.0);
}
