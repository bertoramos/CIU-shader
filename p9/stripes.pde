
PShader shade_stripes;
PImage image_stripes_text;

void setup_stripes() {
  image_stripes_text = loadImage("texture.png");
  shade_stripes = loadShader("stripesFrag.glsl", "stripesVert.glsl");
}

float angle = 0.0;
void mouseDragged() {
  if(mouseX - pmouseX > 0.0) angle-= 0.1;
  else angle+=2*PI/64;
}

void draw_stripes() {
  background(0);
  
  shade_stripes.set("u_time", float(millis())/float(1000));
  shader(shade_stripes);
  
  pointLight(255, 255, 255, mouseX, mouseY, 400);
  
  translate(width/2, height/2);
  rotateX(-PI/8 + angle);
  rotateY(-PI/8);
  noStroke();
  texture(image_stripes_text);
  sphere(200);
}
