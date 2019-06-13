#ifndef VECTOR_MATH_HPP
#define VECTOR_MATH_HPP

struct Vector3 {
  union {
    struct {
      float x, y, z;
    };
    float v[3];
  };
  Vector3() : x(0), y(0), z(0) {}
  Vector3(float x, float y, float z) : x(x), y(y), z(z) {}
};

struct Vector2 {
  union {
    struct {
      float x, y;
    };
    float v[2];
  };
  Vector2() : x(0), y(0) {}
  Vector2(float x, float y) : x(x), y(y) {}
};

#endif