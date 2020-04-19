
PShader shd;
PImage img;

void setup_sphere_light() {
  img = loadImage("texture.png");
  shd = loadShader("lightFrag.glsl", "lightVert.glsl");
}

void draw_sphere_light() {
  background(0);
  
  shader(shd);
  shd.set("u_time", float(millis())/float(1000));
  shd.set("u_mouse", float(mouseX), float(mouseY));
  
  pointLight(255, 255, 255, mouseX, mouseY, 200);
  
  translate(width/2, height/2);
  noStroke();
  texture(img);
  sphere(100);
}
