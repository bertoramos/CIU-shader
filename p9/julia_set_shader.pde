
PShader julia_shader;
PGraphics julia_graphic;
float R;
float zoom;

void setup_julia_set() {
  julia_shader = loadShader("juliaset.glsl");
  julia_shader.set("resolution", float(width), float(height));
  
  julia_graphic = createGraphics(width, height, P2D);
  julia_graphic.beginDraw();
  julia_graphic.background(255, 0, 255);
  julia_graphic.textSize(22);
  julia_graphic.text("Julia Set", 10, 40);
  julia_graphic.endDraw();
  
  zoom = 1.0;
  R = 2.0;
}

void keyJuliaPressed() {
  if(key==CODED && keyCode == UP) zoom-=0.1;
  if(key==CODED && keyCode == DOWN) zoom+=0.1;
  draw_julia_set();
}

void draw_julia_set() {
  //if(mousePressed) {
    float cx = map(float(mouseX), 0, width, -0.6, 0.0);
    float cy = map(float(mouseY), 0, height, -0.6, 0.0);
    println(cx, cy);
    julia_shader.set("cx", cx);
    julia_shader.set("cy", cy);
    julia_shader.set("R", R);
    julia_shader.set("zoom", zoom);
    
    julia_graphic.beginDraw();
    julia_graphic.background(0);
    julia_graphic.shader(julia_shader);
    julia_graphic.rect(0, 0, julia_graphic.width, julia_graphic.height);
    julia_graphic.textSize(22);
    julia_graphic.text("Julia Set", 10, 40);
    julia_graphic.endDraw();
  //}
  image(julia_graphic, 0,0, width, height);
}
