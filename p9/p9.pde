
int mode = 0;
// 0 - no mode set
// 1 - julia set mode
// 2 - terrarium
// 3 - pixeled light
// 4 - stripes

int n_modes = 5;

void setup() {
  size(1000, 1000, P3D);
  setup_julia_set();
  setup_terrarium();
  setup_sphere_light();
  setup_stripes();
}

void keyPressed() {
  if(key == CODED) {
    if(keyCode == RIGHT) {
      mode++;
      mode %= n_modes;
      resetShader();
    } else if(keyCode == LEFT) {
      mode--;
      mode = mode < 0 ? n_modes - 1 : mode;
      resetShader();
    }
  }
  keyJuliaPressed();
}

void draw() {
  if(mode == 1) {
    if(mousePressed) draw_julia_set();
  } else if (mode == 2) {
    draw_terrarium();
  } else if (mode == 3) {
    draw_sphere_light();
  } else if (mode == 4) {
    draw_stripes();
  } else {
    background(0);
    textSize(40);
    textAlign(CENTER);
    text( "Modes:\n" + 
        "\t1 - Julia set\n" + 
        "\t2 - Terrarium\n" +
        "\t3 - Pointillism light\n" +
        "\t4 - Shape stripes\n", 
        width/2, height/2);
  }
}
