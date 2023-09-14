import fisica.*;

FWorld mundo;
ArrayList<Plataforma> plataformas;
Personaje personaje;

Andamio andamio;
FCircle puntero;
FDistanceJoint telarana;

int andamioY = 100;
int andamioX = 600;

float punteroX;
float punteroY;

PImage fondo;
int posp = 600;
int posf = 0;

PGraphics pgraphics;

void setup() {
  size (1000, 600);
  fondo = loadImage("fondo2.png");

  Fisica.init(this);

  mundo = new FWorld();
  mundo.setGravity(0, 400);

  pgraphics = createGraphics(width*3, height);

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

  //-----------ANDAMIOS-----------
  andamio = new Andamio();
  andamio.inicializar(andamioX, andamioY);
  mundo.add(andamio);
}

void draw() {

  mundo.step();

  pgraphics.beginDraw();
  pgraphics.image(fondo, posf, 0, 2998, 600);
  mundo.draw(pgraphics);

  pgraphics.endDraw();

  personaje.actualizar();

  float xCamara = personaje.getX();
  image(pgraphics, -xCamara+100, 0);

  if (!mousePressed && puntero != null) {
    mundo.remove(puntero);
    puntero = null;
  }
  punteroX = mouseX;
  punteroY = mouseY;
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

void mousePressed() {

  if (puntero == null) {
    puntero = new FCircle(30);
    mundo.add(puntero);

    // Ajustar las coordenadas del puntero en función de la posición de la cámara y el personaje
    float xCam = personaje.getX();
    punteroX = mouseX + xCam - 100; // Ajusta la posición del puntero en relación con la cámara y el personaje
    punteroY = mouseY;

    puntero.setPosition(punteroX, punteroY);
    puntero.setStatic(true);
    puntero.setGrabbable(false);
  }

  float aIzq = andamio.getX() - 150;
  float aDer = andamio.getX() + 150;
  float aArriba = andamio.getY() - 20;
  float aAbajo = andamio.getY() + 20;


  if (punteroX >= aIzq && punteroX <= aDer && punteroY >= aArriba && punteroY <= aAbajo) {
    telarana = new FDistanceJoint (personaje, puntero);
    mundo.add (telarana);
    telarana.setDamping (0);
    telarana.setFrequency(2);
    telarana.setLength (200);
  }
}

void contactStarted(FContact contact) {
  FBody body1 = contact.getBody1();
  FBody body2 = contact.getBody2();
  if ((body1.getName() == "personaje" && body2.getName() == "plataforma") || (body1.getName() == "plataforma" && body2.getName () == "personaje")) {
    if (contact.getNormalX() == 0 && personaje.getVelocityY() >= 0) {
      if (body1.getName() == "personaje" && contact.getNormalY() > 0) {
        personaje.puedeSaltar = true;
      } else if (body2.getName() == "personaje" && contact.getNormalY() < 0) {
        personaje.puedeSaltar = true;
      }
    }
  }
}
