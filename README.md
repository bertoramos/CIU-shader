
# Shader
###### Alberto Ramos Sánchez

### Controles

 - *Cambiar de modo* ◄ ► : Tecla izquierda y derecha.
 - En modo *julia-set* :
  - *Zoom* ▲ ▼ : acercar-alejar imagen.
 - En modo *terrarium* :
  - *Arrastrar ratón pulsando* : añadir plantas
 - En modo *pointillism sphere* y *stripes sphere* :
  - *Mover ratón* : dirección de la luz.


## Modo *Julia Set*

Julia set es un conjunto definido por la función recursiva compleja ![Julia Set Complex Function](https://wikimedia.org/api/rest_v1/media/math/render/svg/90caa1b30f369561576d013b858c8bc6c42aff38).

La representación del conjunto se consigue iterando, para cada punto del plano complejo, sobre la función. Teniendo un valor complejo c, se dice que un valor del plano complejo pertenere al conjunto si la sucesión queda acotada:

![sucesion0](https://wikimedia.org/api/rest_v1/media/math/render/svg/94b9c940e4b2b57c571ea8528e89473a43aa7c96)
\\
 ![sucesion1](https://wikimedia.org/api/rest_v1/media/math/render/svg/ea17613cecf92dbe8bb5f464a3862b08678ecd08)

Sabemos que la sucesión está acotada si la función alcanza un valor R denominado radio de escape.

#### Ejemplo en pseudocógido

```c
R = escape radius  # choose R > 0 such that R**2 - R >= sqrt(cx**2 + cy**2)

for each pixel (x, y) on the screen, do:   
{
    zx = scaled x coordinate of pixel # (scale to be between -R and R)
       # zx represents the real part of z.
    zy = scaled y coordinate of pixel # (scale to be between -R and R)
       # zy represents the imaginary part of z.

    iteration = 0
    max_iteration = 1000

    while (zx * zx + zy * zy < R**2  AND  iteration < max_iteration)
    {
        xtemp = zx * zx - zy * zy
        zy = 2 * zx * zy  + cy
        zx = xtemp + cx

        iteration = iteration + 1
    }

    if (iteration == max_iteration)
        return black;
    else
        return iteration;
}
```

El color de cada punto en el mapa es seleccionado a partir del valor de iteración en el que se alcanza el valor R. Si se supera el número de iteraciones, el color será rojo en nuestro caso (al utilizar el modelo de color HSV).

```c++
float hue = it/maxit * 360.0;
float saturation = 1.0;
float value = it > 1.0 ? 1.0 : 0.0;
```

Finalmente, convertimos el color de HSV a RGB con la función *hsv2rgb*.

El número complejo *c* se selecciona con el ratón, entre -0.6 y 0.0 para cada componente.

## Modo *terrarium*

En el modo *terrarium* se le permite al usuario crear píxeles de color verde que simulan semillas de plantas que crecen cuando una lluvia representada por píxeles de color azul caen de la pantalla.

Para representar la lluvia de píxeles azules, primeramente, se dibujan aleatoriamente, en la parte superior de la pantalla, pixeles azules. En cada iteración, si se encuentra un píxel azul sobre el píxel actual, se pinta el actual de azul, y el pixel azul de negro. Con esta operación conseguimos simular que el píxel está cayendo. En el caso de que el píxel llegue a la parte inferior, este se pinta de negro, para eliminarlo de la pantalla.

```c
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

```

Cuando una gota de lluvia toca un píxel verde, esta se convertirá en verde, simulando así el crecimiento de la planta.

Esto se consigue comprobando si el píxel actual es azul y alrededor existe alguno verde. Si es así, se decide aleatoriamente si pintar el actual de verde o no.

```c
if (sum_green >= 1.0 && length(me - BLUE) < 0.01 && randv < 1.0/10.0) { // Pixeles azules cercanos a verdes se pintan de verde
		gl_FragColor = GREEN;
		return;
	} else {
		gl_FragColor = me.rgba;
	}
```

## Modo *pointillism sphere*

En este modo, se cambia el efecto de una luz que ilumina una esfera, consiguiendo el efecto puntillismo sobre ella.

Esto lo conseguimos dibujando una círculo de radio dependiente del brillo del color de la textura en un cierto punto. Cuanto más brillante es el píxel, mayor será el círculo dibujado

```c
vec3 col = vertColor.rgb;
float bright = (col.r+col.g+col.b)/3.0;

float dist = sqrt(dx*dx + dy*dy);
float rad = bright * pixel * 0.8;
float m = step(dist, rad);

vec3 new_color = mix(vec3(0.0), vec3(1.0), m);

gl_FragColor = vec4(new_color, 1.0);
```

## Modo *stripes sphere*

En este modo dibujamos una esfera, que es cortada en tiras.

Para conseguir este efecto, eliminamos el color en ciertos puntos de la textura, según el valor de la función seno en cierto instante de tiempo.

```c
if(cos(.1 * p.y + 3.0 * u_time) <= 0.01) {
  discard;
}
gl_FragColor = vertColor;
```


### References

- [Julia set](https://en.wikipedia.org/wiki/Julia_set#Pseudocode_for_multi-Julia_sets)
- [HSV model](https://en.wikipedia.org/wiki/HSL_and_HSV)
