class Andamio extends FBox {

  Andamio (int tamx, int tamy) {
  super (tamx, tamy);
  }
  void inicializar (int andamioX, int andamioY) {
  setPosition (andamioX, andamioY);
  setStatic (true);
  //andamio.setDensity(10);
  //andamio.setRotatable(false);
  //andamio.setGrabbable (false);
  }
}
