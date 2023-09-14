class Plataforma extends FBox {

  Plataforma (int tamx, int tamy) {
    super(tamx, tamy);
  }
  void inicializar (int posx, int posy) {
    setName("plataforma");
    setPosition(posx, posy);
    setStatic(true);
  }
}
