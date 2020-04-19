#ifdef GL_ES
precision mediump float;
#endif

varying vec4 vertTexCoord;
uniform sampler2D texture;
uniform float u_time;
varying vec4 vertColor;

void main() {
  vec2 p = vertTexCoord.st;
  if(cos(.1 * p.y + 3.0 * u_time) <= 0.01) {
    discard;
  }
  gl_FragColor = vertColor;
}
