#version 330 core

uniform sampler2D tex;
uniform vec2 textureSize;
uniform bool enabled;

in vec2 ftexcoord;
layout(location = 0) out vec4 FragColor;

int sampleTextureI(int x, int y) {
    return int(texture(tex, (floor(gl_FragCoord.xy + vec2(x, y)) + 0.5) / textureSize).r);
}

vec4 sampleTexture(int x, int y) {
    return texture(tex, (floor(gl_FragCoord.xy + vec2(x, y)) + 0.5) / textureSize);
}

//int sample(int x, int y) {
//  return int(round(1.0 - sampleTexture(x, y).b));
//}

int sample(int x, int y) {
  vec4 color = sampleTexture(x, y);
  if (int(round(1.0 - color.r)) == 1) { return 1; }
  if (int(round(1.0 - color.g)) == 1) { return 1; }
  if (int(round(1.0 - color.b)) == 1) { return 1; }
  return 0;
}

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main() {

  if (!enabled) {
    FragColor = texture(tex, ftexcoord).rgba;
    return;
  }

  vec4 colAlive = vec4(1.0, 0.3, 0.1, 1.0);
  vec4 colDead = vec4(1.0, 1.0, 1.0, 1.0);

  int sumSelf = sample(0, 0);
  int sumNeighbours = sample(-1, -1) + sample(0, -1) + sample(1, -1) +
                      sample(-1, 0)  +                 sample(1, 0)  +
                      sample(-1, 1)  + sample(0, 1)  + sample(1, 1);

  bool isAlive = (sumSelf == 1);

  if (!isAlive && sumNeighbours == 3) { // 3 neighbours - come alive
    FragColor = colAlive;
  } else if (isAlive && sumNeighbours < 2) { // Fewer than two neighbours - die
    FragColor = colDead;
  } else if (isAlive && sumNeighbours > 3) { // Greater than three neighbours - die
    FragColor = colDead;
  } else if (isAlive && sumNeighbours == 2 || sumNeighbours == 3) { // Must have two or three neighbours - live on
    FragColor = colAlive;
  } else { // Otherwise just keep the same fragment color
    FragColor = texture(tex, ftexcoord).rgba;
    //int col = int(round(sampleTexture(0, 0)));
    //FragColor = vec4(col, col, col, 0.0);
  }
}
