import fisica.*;

FWorld mundo;
ArrayList<Plataforma> plataformas;
Personaje personaje;

PImage fondo;
int posp = 600;
int posf = 0;

void setup() {
  size (1000, 600);
  fondo = loadImage("fondo2.png");

  Fisica.init(this);

  mundo = new FWorld();
  mundo.setGravity(0,400);

  plataformas = new ArrayList <Plataforma> ();

  for (int i = 0; i<5; i++) {
    Plataforma p = new Plataforma (400, 40);
    p.inicializar(i*posp, height-20);
    mundo.add(p);
    plataformas.add(p);
  }

  personaje = new Personaje (145, 183);
  personaje.inicializar(150, height-230);
  mundo.add(personaje);
}

void draw() {
  image(fondo, posf, 0, 2998, 600);

  mundo.step();
  mundo.draw();

  personaje.actualizar();
}

void keyPressed () {
  if (keyCode == LEFT) {
  personaje.izqPresionado = true;
  }
  if (keyCode == RIGHT) {
  personaje.derPresionado = true;
  }
  if (keyCode == UP) {
    personaje.arribaPresionado = true;
  }
}

void keyReleased() {
  if (keyCode == LEFT) {
  personaje.izqPresionado = false;
  }
  if (keyCode == RIGHT) {
  personaje.derPresionado = false;
  }
  if (keyCode == UP) {
    personaje.arribaPresionado = false;
  }
}

void contactStarted(FContact contact) {
  FBody body1 = contact.getBody1();
  FBody body2 = contact.getBody2();
  if ((body1.getName() == "personaje" && body2.getName() == "plataforma") || (body1.getName() == "plataforma" && body2.getName () == "personaje")) {
    if (contact.getNormalX() == 0 && personaje.getVelocityY() >= 0) {
      if (body1.getName() == "personaje" && contact.getNormalY() > 0){
      personaje.puedeSaltar = true;
      } else if (body2.getName() == "personaje" && contact.getNormalY() < 0) {
      personaje.puedeSaltar = true;
      }
    }
  }
}
