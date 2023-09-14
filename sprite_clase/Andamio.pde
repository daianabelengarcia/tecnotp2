class Andamio extends FBox {

  Andamio () {
  super (300,40);
  }
  void inicializar (int andamioX, int andamioY) {
  andamio.setPosition (andamioX, andamioY);
  andamio.setStatic (true);
  andamio.setDensity(10);
  andamio.setRotatable(false);
  andamio.setGrabbable (false);
  }
}
