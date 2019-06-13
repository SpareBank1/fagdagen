#include <vertexbuffer.hpp>

VertexBuffer::VertexBuffer(Type type) : 
    vao(0), 
    vbo{0, 0, 0}
  {
  
  if (type == Type::PLANE) {
    vertices = {
      Vector3(1.0f,  1.0f,  0.0f),
      Vector3(-1.0f, 1.0f,  0.0f),
      Vector3(1.0f,  -1.0f, 0.0f),
      Vector3(-1.0f, -1.0f, 0.0f)
    };

    texcoords = {
      Vector2(1.0f, 1.0f),
      Vector2(0.0f, 1.0f),
      Vector2(1.0f, 0.0f),
      Vector2(0.0f, 0.0f)
    };

    indices = {
      0, 1, 2, // first triangle
      2, 1, 3, // second triangle
    };

    buildBuffers();
  }
}

VertexBuffer::~VertexBuffer() {
  if (vao) {
    glDeleteVertexArrays(1, &vao);
  }

  if (vbo) {
    glDeleteBuffers(VBOType::MAX_VBO, vbo);
  }
}

bool VertexBuffer::buildBuffers() {

  // Build vertex array object
  glGenVertexArrays(1, &vao);
  glBindVertexArray(vao);

  // Generate all the buffers (vertices, texcoords and indices)
  glGenBuffers(VBOType::MAX_VBO, vbo);
  
  // Pointers to data
  float* ptrVertices = (float*)(&vertices[0]);
  float* ptrTexcoords = (float*)(&texcoords[0]);
  GLuint* ptrIndices = (GLuint*)(&indices[0]);

  // Vertices
  glBindBuffer(GL_ARRAY_BUFFER, vbo[VBOType::VERTICES]);
  glBufferData(GL_ARRAY_BUFFER, sizeof(Vector3) * vertices.size(), ptrVertices, GL_STATIC_DRAW);
  glEnableVertexAttribArray(VBOType::VERTICES); // Set attribute pointer (used in shader)
  glVertexAttribPointer(VBOType::VERTICES, 3, GL_FLOAT, GL_FALSE, 0, 0);

  // Texture coordinates
  glBindBuffer(GL_ARRAY_BUFFER, vbo[VBOType::TEXCOORDS]);
  glBufferData(GL_ARRAY_BUFFER, sizeof(Vector2) * texcoords.size(), ptrTexcoords, GL_STATIC_DRAW);
  glEnableVertexAttribArray(VBOType::TEXCOORDS); // Set attribute pointer (used in shader)
  glVertexAttribPointer(VBOType::TEXCOORDS, 2, GL_FLOAT, GL_FALSE, 0, 0);
  
  // Indices
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vbo[VBOType::INDICES]);
  glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLuint) * indices.size(), ptrIndices, GL_STATIC_DRAW);
  
  // Unbind the vertex array object
  glBindVertexArray(0);

  return true;
}