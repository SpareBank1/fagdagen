#include <framebuffer.hpp>

FrameBuffer::FrameBuffer(unsigned width, unsigned height, bool createDepthTexture, GLuint initialRenderTexture) : 
    width(width),
    height(height),
    fbo(0), 
    texture(0), 
    depthRenderBuffer(0),
    depthTexture(0) {
  init(createDepthTexture, initialRenderTexture);
}

FrameBuffer::~FrameBuffer() {
  if (fbo) {
    glDeleteFramebuffers(1, &fbo);
  }

  if (texture) {
    glDeleteTextures(1, &texture);
  }

  if (depthRenderBuffer) {
    glDeleteRenderbuffers(1, &depthRenderBuffer);
  }

  if (depthTexture) {
    glDeleteTextures(1, &depthTexture);
  }
}

bool FrameBuffer::init(bool createDepthTexture, GLuint initialRenderTexture) {
	
	glGenFramebuffers(1, &fbo);
	glBindFramebuffer(GL_FRAMEBUFFER, fbo);

  if(initialRenderTexture) {
    texture = initialRenderTexture;
    glBindTexture(GL_TEXTURE_2D, texture);
  } else {
    glGenTextures(1, &texture);
    
    // "Bind" the newly created texture : all future texture functions will modify this texture
    glBindTexture(GL_TEXTURE_2D, texture);

    // Give an empty image to OpenGL ( the last "0" means "empty" )
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, 0);

    // No texture filtering
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST); 
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
  }

  // Set "texture" as our colour attachement #0
  glFramebufferTexture(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, texture, 0);
  glBindTexture(GL_TEXTURE_2D, 0);
	
	// The depth buffer
	glGenRenderbuffers(1, &depthRenderBuffer);
	glBindRenderbuffer(GL_RENDERBUFFER, depthRenderBuffer);
	glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT, width, height);
	glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderBuffer);

	if (createDepthTexture) {
	  glGenTextures(1, &depthTexture);
	  glBindTexture(GL_TEXTURE_2D, depthTexture);
	  glTexImage2D(GL_TEXTURE_2D, 0,GL_DEPTH_COMPONENT24, width, height, 0,GL_DEPTH_COMPONENT, GL_FLOAT, 0);
	  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST); 
	  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	  glFramebufferTexture(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, depthTexture, 0);
  }

	// Set the list of draw buffers.
	GLenum DrawBuffers[1] = { GL_COLOR_ATTACHMENT0 };
	glDrawBuffers(1, DrawBuffers); // "1" is the size of DrawBuffers

	// Always check that our framebuffer is ok
	if(glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
    return false;
  }
  
  return true;
}
