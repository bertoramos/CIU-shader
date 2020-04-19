
PShader ps_terrarium;
PGraphics pg_terrarium;
PImage img_terrarium;

void setup_terrarium()
{
  pg_terrarium = createGraphics(width, height, P2D);
  pg_terrarium.noSmooth();
  ps_terrarium = loadShader("terrarium.glsl");
  ps_terrarium.set("resolution", float(pg_terrarium.width), float(pg_terrarium.height));
}

void draw_terrarium() {
  if(mousePressed) {
    float x = map(mouseX, 0, width, 0, 1);
    float y = map(mouseY, 0, height, 1, 0);
    ps_terrarium.set("mouse", x, y); 
  } else {
    ps_terrarium.set("mouse", 0.0, 0.0); 
  }
  
  ps_terrarium.set("time", millis()/1000.0);
  
  
  pg_terrarium.beginDraw();
  pg_terrarium.background(0);
  pg_terrarium.shader(ps_terrarium);
  pg_terrarium.rect(0, 0, pg_terrarium.width, pg_terrarium.height);
  pg_terrarium.textSize(22);
  pg_terrarium.text("Terrarium", 10, 40);
  pg_terrarium.endDraw();  
  image(pg_terrarium, 0, 0, width, height);
}
