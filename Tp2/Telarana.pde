class Telarana extends FDistanceJoint {
  float aIzq; //bordes andamios
  float aDer;
  float aArriba;
  float aAbajo;

  float aIzq2;
  float aDer2;
  float aArriba2;
  float aAbajo2; //hasta acá
  
  boolean telaranaLanzada = false;


  Telarana (FBox personaje, FBox puntero) {
    super (personaje, puntero);
  }
  void inicializar (float ax, float ay, float ax2, float ay2) {
    aIzq = ax -200;
    aDer = ax +200;
    aArriba = ay+80;
    aAbajo = ay +130;

    aIzq2 = ax2 -200;
    aDer2 = ax2 +200;
    aArriba2 = ay2+80;
    aAbajo2 = ay2+130;


    setDamping (1);
    setFrequency(2);
    setLength (200);
  }

  void hayTelarana (float punteroX, float punteroY) {
    if (!telaranaLanzada && ((punteroX >= aIzq && punteroX <= aDer && punteroY >= aArriba && punteroY <= aAbajo) || (punteroX >= aIzq2 && punteroX <= aDer2 && punteroY >= aArriba2 && punteroY <= aAbajo2))) {
      mundo.add(telarana);
      //sonidoLanzaTelarana.play();
      telaranaLanzada = true;
    } else {
      sonidoLanzaTelarana.stop();
    }
  }
  
}
