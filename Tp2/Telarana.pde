class Telarana extends FDistanceJoint {
  float aIzq; 
  float aDer;
  float aArriba;
  float aAbajo;

  float aIzq2;
  float aDer2;
  float aArriba2;
  float aAbajo2; 

  boolean telaranaLanzada = false;
  boolean sonidoReproducido = false; 
  boolean sonidofunca = false;

  float vel = 0.1;


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
      telaranaLanzada = true;

      stroke (255);
      strokeWeight(3);
      //line (personaje.getX(), personaje.getY(), punteroX, punteroY);
      t = t+vel;
      float x= lerp(personaje.getX(), punteroX, t);
      float y= lerp(personaje.getY(), punteroY, t);

      //strokeWeight(20);
      line(personaje.getX(), personaje.getY(), x, y);
      if (t >= 1) {
        t = 0.9;
      }
      println(t);

      if (!sonidoLanzaTelarana.isPlaying()) {
        sonidoLanzaTelarana.play(1.8);
      }

      //telaranaLanzada = true;
    } else {
      sonidoLanzaTelarana.stop();
      telaranaLanzada = false;
      t = 0;
    }
  }
}
