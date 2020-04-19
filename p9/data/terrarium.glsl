
#ifdef GL_ES
precision highp float;
#endif

#define PROCESSING_COLOR_SHADER

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D ppixels;

vec4 GREEN = vec4(0.0,1.0,0.0,1.);
vec4 BLUE = vec4(0.0,0.0,1.0,1.);
vec4 BLACK = vec4(0.,0.,0.,1.);
vec4 WHITE = vec4(1.,1.,1.,1.);

float random (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 pixel = 1./resolution;

	float m_x = mouse.x / resolution.x;
  float m_y = mouse.y / resolution.y;

	vec4 me = texture2D(ppixels, position);

	vec4 lu = texture2D(ppixels, position.xy + vec2(-1.0, 1.0)/resolution.xy);
	vec4 u = texture2D(ppixels, position.xy + vec2(0.0, 1.0)/resolution.xy);
	vec4 ru = texture2D(ppixels, position.xy + vec2(1.0, 1.0)/resolution.xy);

	vec4 l = texture2D(ppixels, position.xy + vec2(-1.0, 0.0)/resolution.xy);
	vec4 r = texture2D(ppixels, position.xy + vec2(1.0, 0.0)/resolution.xy);

	vec4 ld = texture2D(ppixels, position.xy + vec2(-1.0, -1.0)/resolution.xy);
	vec4 d = texture2D(ppixels, position.xy + vec2(0.0, -1.0)/resolution.xy);
	vec4 rd = texture2D(ppixels, position.xy + vec2(1.0, -1.0)/resolution.xy);

	// si hay un pixel verde alrededor, aleatoriamente se pinta el pixel actual de verde si es azul
	float sum_green = lu.g + u.g + ru.g + l.g + r.g + ld.g + d.g + rd.g;
	float randv = random(vec2(time) + vec2(position));
	/*if(sum_green >= 1.0 && randv < 1.0/100.0) {
		gl_FragColor = GREEN;
	} else*/ if (sum_green >= 1.0 && length(me - BLUE) < 0.01 && randv < 1.0/10.0) { // Pixeles azules cercanos a verdes se pintan de verde
		gl_FragColor = GREEN;
		return;
	} else {
		gl_FragColor = me.rgba;
	}

	// pinta de verde donde se pulse, 0,0 reservado para borrar la pulsación anterior
	if(length(position-mouse) <= 0.01 && mouse.x != 0.0 && mouse.y != 0.0) {
		gl_FragColor = GREEN;
	}

	// (1) Pinta de azul si el superior es azul
	// ... el superior se pintará de negro (2)
	if(length(u - BLUE) < 0.01 && length(me - BLACK) < 0.01) {
		gl_FragColor = BLUE;
	}
	// (2) Si el inferior es negro y el actual es azul, se borra el pixel actual a negro
	// ... el inferior se pintara de azul (1)
	if(length(d - BLUE) > 0.01 && length(me - BLUE) < 0.01) {
		gl_FragColor = BLACK;
	}

	// Si se llega al suelo el pixel azul, se pinta de negro para que desaparezca
	if(position.y <= 0.01) {
		gl_FragColor = BLACK;
	}

	// Genera lluvia de pixeles azules
	if(abs(position.y - 1.0) <= 0.01) {
		randv = random(vec2(time) + vec2(position));
		if(randv < 1.0/50.0) {
			gl_FragColor = BLUE;
		}
	}


	//vec4 color = me.rgba;
	//gl_FragColor = color;
}
