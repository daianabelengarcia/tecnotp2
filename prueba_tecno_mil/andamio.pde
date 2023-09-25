class Andamio extends FBox {
  float originalY;
  float x;
  PImage andamio;

  Andamio (int tamx, int tamy) {
    super (tamx, tamy);
    andamio = loadImage("data/andamios2.png");
  }
  void inicializar (int andamioX, int andamioY) {
    x = andamioX;
    originalY = andamioY;
    setDensity(0);
    setRotatable(false);
    setGrabbable (false);

    setPosition (x, originalY);
  }
  void actualizar (float velocidad) {
    float nuevaPosX = getX() - velocidad;  
    
    attachImage(andamio);

    if (nuevaPosX < -getWidth()) {
      nuevaPosX = width;
    }
    setPosition(nuevaPosX, getY());
  }
}
