class Telarana extends FDistanceJoint {
  float aIzq; //bordes andamios
  float aDer;
  float aArriba;
  float aAbajo;

  float aIzq2;
  float aDer2;
  float aArriba2;
  float aAbajo2; //hasta acá

  Telarana (FBox personaje, FBox puntero) {
    super (personaje, puntero);
  }
  void inicializar (float ax, float ay, float ax2, float ay2) {
    aIzq = ax -150;
    aDer = ax +150;
    aArriba = ay -20;
    aAbajo = ay +20;

    aIzq2 = ax2 -150;
    aDer2 = ax2 +150;
    aArriba2 = ay2 -20;
    aAbajo2 = ay2 +20;


    setDamping (1);
    setFrequency(2);
    setLength (200);
  }

  void hayTelarana (float punteroX, float punteroY) {
    if ((punteroX >= aIzq && punteroX <= aDer && punteroY >= aArriba && punteroY <= aAbajo) || (punteroX >= aIzq2 && punteroX <= aDer2 && punteroY >= aArriba2 && punteroY <= aAbajo2)) {
      mundo.add(telarana);
    }
  }
  void nohayTelarana () {
    mundo.remove(telarana);
  }
}
