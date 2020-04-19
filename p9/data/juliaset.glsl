
#ifdef GL_ES
precision mediump float;
#endif

#define PROCESSING_COLOR_SHADER

//uniform float time;
uniform float cx;
uniform float cy;
uniform vec2 resolution;
uniform float R;
uniform float zoom;

vec4 hsv2rgb(float h, float s, float v) {
  float c = v * s;
  float x = c * (1.0 - abs((mod(h/60.0, 2.0)) - 1.0));
  float m = v - c;

  float r = c;
  float g = 0.0;
  float b = x;
  if (h < 60.0) {
    r = c;
    g = x;
    b = 0.0;
  } else if (h < 120.0) {
    r = x;
    g = c;
    b = 0.0;
  } else if (h < 180.0) {
    r = 0.0;
    g = c;
    b = x;
  } else if (h < 240.0) {
    r = 0.0;
    g = x;
    b = c;
  } else if (h < 300.0) {
    r = x;
    g = 0.0;
    b = c;
  } else {
    r = c;
    g = 0.0;
    b = x;
  }
  float ri = (r + m) * 255.0;
  float gi = (g + m) * 255.0;
  float bi = (b + m) * 255.0;

  return vec4(ri, gi, bi, 1.0);
}

float map(float s, float a1, float a2, float b1, float b2) {
  return b1 + ((s-a1)*(b2-b1))/(a2-a1);
}

void main(void)
{
	vec2 position = ( gl_FragCoord.xy / resolution.xy );

  //float zx = 1.5 * (gl_FragCoord.x - resolution.x / 2.0) / (0.5 * resolution.x);
  //float zy = (gl_FragCoord.y - resolution.y / 2.0) / (0.5 * resolution.y);
  float zx = map(gl_FragCoord.x, 0, resolution.x, -R*zoom, R*zoom);
  float zy = map(gl_FragCoord.y, 0, resolution.y, -R*zoom, R*zoom);

  float maxit = 300.0;
  float it = maxit;
  while(zx * zx + zy * zy < R*R && it > 0.0) {
    float xtemp = zx * zx - zy * zy + cx;
    zy = 2.0 * zx * zy + cy;
    zx = xtemp;

    it -= 1.0;
  }
  float hue = it/maxit * 360.0;
  float saturation = 1.0;
  float value = it > 1.0 ? 1.0 : 0.0;
  gl_FragColor = hsv2rgb(hue, saturation, value);
}
