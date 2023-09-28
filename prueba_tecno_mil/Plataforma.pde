class Plataforma extends FBox {
  float originalY;
  float x;


  Plataforma (int tamx, int tamy) {
    super(tamx, tamy);
    setFill(100, 100, 100);  
    setNoStroke(); 
  }
  void inicializar (int posx, int posy) {
    setName("plataforma");
    x = posx;
    originalY = posy;
    setDensity(0);
    setRotatable(false);
    setGrabbable (false);

    setPosition (x, originalY);
  }
  
    void actualizar (float velocidad) {
    float nuevaPosX = getX() - velocidad;  

  if (nuevaPosX < -getWidth()) {
    nuevaPosX = width;
  }
  setPosition(nuevaPosX, getY());
  }
}
