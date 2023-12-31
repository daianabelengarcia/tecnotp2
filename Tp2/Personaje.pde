class Personaje extends FBox {
  boolean puedeSaltar;
  PImage [] rexCamina = new PImage[7];
  int indexImagenes;
  PImage[] saltar = new PImage[3];
  int indexSaltar;

  boolean detenerAnimacion;

  Personaje (int tamx, int tamy) {
    super(tamx, tamy);
    indexImagenes = 0;
    for (int i = 0; i < rexCamina.length; i++) {
      rexCamina[i] = loadImage(i + ".png");
    }
    for (int i = 0; i < saltar.length; i++) {
      saltar[i] = loadImage("tira" + i + ".png");
    }
  }

  void inicializar(int x, int y) {
    puedeSaltar = false;
    detenerAnimacion = false;


    setName("personaje");
    setDensity(40);
    setPosition(x, y);
    setDamping (0);
    setRestitution(0);
    setFriction(0);
    setRotatable(false);

    if (!detenerAnimacion) {
      attachImage(rexCamina[0]);
    }
  }

  void actualizar () {
    indexImagenes = (indexImagenes+1) % rexCamina.length;
    if (frameCount%30 == 0 ) {
      attachImage(rexCamina[indexImagenes]);
    }

    if (!puedeSaltar) {
      attachImage(saltar[2]);
      detenerAnimacion = true;
    } else {
      detenerAnimacion = false;
      if (getX() >= 150) {
        float enelAire = getX();
        enelAire -= 2;
        setPosition(enelAire, getY());
      }
    }
  }
}
