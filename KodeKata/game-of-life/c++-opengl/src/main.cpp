#include <GL/glew.h>
#include <GLFW/glfw3.h>

#include <iostream>
#include <string>
#include <vector>
#include <memory>

#include <chrono>
#include <thread>

#include <vertexbuffer.hpp>
#include <framebuffer.hpp>
#include <texture.hpp>
#include <shader.hpp>

using std::shared_ptr;

bool getGLErrors() {
  GLenum error = glGetError();
  if(error != GL_NO_ERROR) {
    std::cerr << error << std::endl;
    return true;
  }

  return false;
}

int main(int argc, char** argv) { 

	if( !glfwInit() ) {
		fprintf( stderr, "Failed to initialize GLFW\n" );
		getchar();
		return -1;
	}

  GLFWwindow* window;
	//int windowWidth = 1920; int windowHeight = 1080; 
  int windowWidth = 1280; int windowHeight = 720;
  bool fullscreen = false;
  float delay = 2.0f;

  //std::string filename("../textures/abstract-flower-pattern.bmp");
  std::string filename("../textures/SpareBank1-1024x576.bmp");
  //std::string filename("../textures/gosper-glider-gun-320x180.bmp");
  

	glfwWindowHint(GLFW_SAMPLES, 4);
	glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
	glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
	glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE); // To make MacOS happy; should not be needed
	glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

  glfwSetTime(0.0d);

	// Open a window and create its OpenGL context
  if (fullscreen) {
    window = glfwCreateWindow( windowWidth, windowHeight, "OpenGL Game of Life", glfwGetPrimaryMonitor(), nullptr);
  } else {
    window = glfwCreateWindow( windowWidth, windowHeight, "OpenGL Game of Life", NULL, NULL);
  }
	
	if( window == NULL ){
		std::cerr << "Failed to initialize GLFW window." << std::endl;
		getchar();
		glfwTerminate();
		return -1;
	}
  
	glfwMakeContextCurrent(window);

  // But on MacOS X with a retina screen it'll be width*2 and height*2, so we get the actual framebuffer size:
	glfwGetFramebufferSize(window, &windowWidth, &windowHeight);

  	// Initialize GLEW
	glewExperimental = true; // Needed for core profile
	if (glewInit() != GLEW_OK) {
    std::cerr << "Failed to initialize GLEW." << std::endl;
		getchar();
		glfwTerminate();
		return -1;
	}

  shared_ptr<Texture> texture(new Texture(filename));
  shared_ptr<Texture> textureLogo(new Texture("../textures/SpareBank1-Logo-Fagdag.bmp"));

  if (!texture->loaded) {
    std::cerr << "Failed to load texture." << std::endl;
		glfwTerminate();
		return -1;
  }

  shared_ptr<Shader> gameOfLifeShader(new Shader("../shaders/game-of-life-vs.glsl", "../shaders/game-of-life-fs.glsl"));
  GLuint gameOfLifeTextureLocation = glGetUniformLocation(gameOfLifeShader->program, "tex"); // get texture uniform location
  GLuint gameOfLifeTextureSizeLocation = glGetUniformLocation(gameOfLifeShader->program, "textureSize");
  GLuint gameOfLifeEnabledLocation = glGetUniformLocation(gameOfLifeShader->program, "enabled");

  shared_ptr<Shader> passthroughShader(new Shader("../shaders/passthrough-vs.glsl", "../shaders/passthrough-fs.glsl"));
  GLuint passthroughWindowSizeLocation = glGetUniformLocation(gameOfLifeShader->program, "windowSize");
  GLuint passthroughTextureLocation = glGetUniformLocation(passthroughShader->program, "tex"); // get texture uniform location
  GLuint passthroughTimeLocation = glGetUniformLocation(passthroughShader->program, "time");
  GLuint passthroughScaleLocation = glGetUniformLocation(passthroughShader->program, "scale");
  GLuint passthroughTranslateLocation = glGetUniformLocation(passthroughShader->program, "translate");

  shared_ptr<VertexBuffer> vertexBuffer(new VertexBuffer(VertexBuffer::Type::PLANE));
  shared_ptr<FrameBuffer> frameBuffer1(new FrameBuffer(texture->width, texture->height, false));
  shared_ptr<FrameBuffer> frameBuffer2(new FrameBuffer(texture->width, texture->height, false, texture->texture));
  shared_ptr<FrameBuffer> frameBufferCurrent = frameBuffer1;
  shared_ptr<FrameBuffer> frameBufferPrevious = frameBuffer2;

  // VSync ON
  glfwSwapInterval(1); // 0 = OFF
  //glfwSwapInterval(0); // 0 = OFF

  do {
    // --- RENDER TO TEXTURE PASS ---
    {
      bool simulationEnabled = glfwGetTime() - delay > 0;

      glBindFramebuffer(GL_FRAMEBUFFER, frameBufferCurrent->fbo);
		  glViewport(0, 0, texture->width, texture->height);

		  // Clear the screen
      glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
      glUseProgram(gameOfLifeShader->program);

      // bind texture to texture unit 0
      glActiveTexture(GL_TEXTURE0);
      glBindTexture(GL_TEXTURE_2D, frameBufferPrevious->texture);
      
      // set texture uniform
      glUniform1i(gameOfLifeTextureLocation, 0);
      glUniform2f(gameOfLifeTextureSizeLocation, texture->width, texture->height);
      glUniform1i(gameOfLifeEnabledLocation, simulationEnabled);
      
      // Draw the contents of the VertexBuffer
      glBindVertexArray(vertexBuffer->vao);
      glDrawElements(GL_TRIANGLES, vertexBuffer->indices.size(), GL_UNSIGNED_INT, 0);

      if (getGLErrors()) { break; }
      
      glBindVertexArray(0);
      glUseProgram(0);
      glBindFramebuffer(GL_FRAMEBUFFER, 0);
    }
    // --- RENDER TO TEXTURE PASS ---

    // --- RENDER TO SCREEN PASS ---
    {
      glViewport(0, 0, windowWidth, windowHeight);
      glClear(GL_COLOR_BUFFER_BIT);
      glUseProgram(passthroughShader->program);

      // bind texture to texture unit 0
      glActiveTexture(GL_TEXTURE0);
      glBindTexture(GL_TEXTURE_2D, frameBufferCurrent->texture);
      
      // set texture uniform
      glUniform1i(passthroughTextureLocation, 0);
      glUniform2f(passthroughWindowSizeLocation, windowWidth, windowHeight);
      glUniform1f(passthroughTimeLocation, (float)(glfwGetTime() * 10.0f));
      glUniform3f(passthroughScaleLocation, 1.0f, 1.0f, 1.0f);
      glUniform3f(passthroughTranslateLocation, 0.0f, 0.0f, 0.0f);
      
      // Draw the contents of the VertexBuffer
      glBindVertexArray(vertexBuffer->vao);
      glDrawElements(GL_TRIANGLES, vertexBuffer->indices.size(), GL_UNSIGNED_INT, 0);

      { // Draw logo
        glEnable(GL_BLEND);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

        glBindTexture(GL_TEXTURE_2D, textureLogo->texture);
        glUniform1i(passthroughTextureLocation, 0);
        glUniform2f(passthroughWindowSizeLocation, windowWidth, windowHeight);
        glUniform1f(passthroughTimeLocation, (float)(glfwGetTime() * 10.0f));
        glUniform3f(passthroughScaleLocation, 0.2f, 0.1f, 1.0f);
        glUniform3f(passthroughTranslateLocation, 0.78f, 0.86f, 0.0f);

        glBindVertexArray(vertexBuffer->vao);
        glDrawElements(GL_TRIANGLES, vertexBuffer->indices.size(), GL_UNSIGNED_INT, 0);
      } // Draw logo
      
      if (getGLErrors()) { break; }
      
      glBindVertexArray(0);
      glUseProgram(0);
    }
    // --- RENDER TO SCREEN PASS ---

    // Swap framebuffers
    shared_ptr<FrameBuffer> frameBufferTmp = frameBufferCurrent;
    frameBufferCurrent = frameBufferPrevious;
    frameBufferPrevious = frameBufferTmp;
    
    // finally swap buffers
    glfwSwapBuffers(window); 
    glfwPollEvents();

    // Use to slow down simulation
    //std::this_thread::sleep_for(std::chrono::milliseconds(16));
    //std::this_thread::sleep_for(std::chrono::milliseconds(255));

  } while( glfwGetKey(window, GLFW_KEY_ESCAPE ) != GLFW_PRESS && glfwWindowShouldClose(window) == 0 );

  glfwDestroyWindow(window);
  glfwTerminate();

  return 0;
}