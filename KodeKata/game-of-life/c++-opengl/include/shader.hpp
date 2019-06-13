#ifndef SHADER_HPP
#define SHADER_HPP

#include <GL/glew.h>
#include <string>

struct Shader {
  GLuint program;

  Shader(std::string vertexShaderFile, std::string fragmentShaderFile);
};

#endif