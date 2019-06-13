#ifndef FRAMEBUFFER_HPP
#define FRAMEBUFFER_HPP

#include <GL/glew.h>

struct FrameBuffer {
  unsigned width;
  unsigned height;

  GLuint fbo;
  GLuint texture;
  GLuint depthRenderBuffer;
  GLuint depthTexture;

  FrameBuffer(unsigned width, unsigned height, bool createDepthTexture, GLuint initialRenderTexture = 0);
  ~FrameBuffer();

private:
  bool init(bool createDepthTexture, GLuint initialRenderTexture);
};

#endif