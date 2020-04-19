#ifdef GL_ES
precision mediump float;
#endif

varying vec4 vertTexCoord;
uniform sampler2D texture;
varying vec4 vertColor;

void main() {
  vec2 p = vertTexCoord.st;
  float pixel = 1. / 5.0;

  // Ajustamos tamaño a la ventana
  float dx = mod(p.x, pixel);
  float dy = mod(p.y, pixel);

  vec3 col = vertColor.rgb;

  float bright = (col.r+col.g+col.b)/3.0;

	float dist = sqrt(dx*dx + dy*dy);
	float rad = bright * pixel * 0.8;
	float m = step(dist, rad);

  vec3 new_color = mix(vec3(0.0), vec3(1.0), m);

  gl_FragColor = vec4(new_color, 1.0);
}
