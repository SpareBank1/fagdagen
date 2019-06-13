#ifndef VERTEXBUFFER_HPP
#define VERTEXBUFFER_HPP

#include <GL/glew.h>
#include <math.hpp>
#include <vector>

struct VertexBuffer {

  enum VBOType {
    VERTICES = 0,
    TEXCOORDS,
    INDICES,
    MAX_VBO
  };

  enum Type {
    PLANE
  };

  GLuint vao;
  GLuint vbo[VBOType::MAX_VBO];

  std::vector<Vector3> vertices;
  std::vector<Vector2> texcoords;
  std::vector<GLuint> indices;

  VertexBuffer(Type type);
  ~VertexBuffer();
private:
  bool buildBuffers();
};

#endif
