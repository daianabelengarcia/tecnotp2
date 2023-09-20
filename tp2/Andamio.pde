class Andamio extends FBox {

  Andamio (int tamx, int tamy) {
  super (tamx, tamy);
  }
  void inicializar (int andamioX, int andamioY) {
  setPosition (andamioX, andamioY);
  setStatic (true);
  setDensity(0);
  setRotatable(false);
  setGrabbable (false);
  }
}
