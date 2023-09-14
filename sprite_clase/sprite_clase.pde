int PUERTO_OSC  = 12345 ;
Receptor receptor;

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

// -- Blob --
float ultimaPosicionBlobDesaparecidoX;
float ultimaPosicionBlobDesaparecidoY;


void setup() {
  size (1000, 600);
  fondo = loadImage("fondo2.png");

  setupOSC(PUERTO_OSC);
  receptor = new Receptor();

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
  //puntero = new FCircle(30);
  //mundo.add(puntero);
  //puntero.setStatic(true);
  //puntero.setGrabbable(false);

  //telarana = new FDistanceJoint(personaje, puntero);
  //mundo.add(telarana);
  //telarana.setDamping(0);
  //telarana.setFrequency(2);
  //telarana.setLength(500);

  andamio = new Andamio();
  andamio.inicializar(andamioX, andamioY);
  mundo.add(andamio);
}

void draw() {
  receptor.actualizar(mensajes);

  mundo.step();

  pgraphics.beginDraw();
  //pgraphics.image(fondo, posf, 0, 2998, 600);  //NO escalar
  pgraphics.image(fondo, posf, 0);
  mundo.draw(pgraphics);

  pgraphics.endDraw();

  personaje.actualizar();

  boolean hayBlobEnPantalla = false; //-->(NO es que quiera poner este boolean en el draw, es que sino no funciona. No me preguntes por qué. No lo sé)

  float xCamara = personaje.getX();
  image(pgraphics, -xCamara+100, 0);

  if ((!mousePressed || hayBlobEnPantalla) && puntero != null) {
    mundo.remove(puntero);
    puntero = null;
  }

  // -- Blob --
  for (Blob b : receptor.blobs) {
    if (b.entro) {
      //puntero.setDrawable(false);
      //mundo.remove(telarana);
      mundo.remove(puntero);
      receptor.dibujarBlobs();
    }
    if (!b.salio) {
      hayBlobEnPantalla = true;  // Si al menos un blob no ha salido, establece hayBlobEnPantalla en true
    }

    ultimaPosicionBlobDesaparecidoX = b.ultimaPosicionBlob.x;
    ultimaPosicionBlobDesaparecidoY = b.ultimaPosicionBlob.y;
  }

  if (!hayBlobEnPantalla) {  // Si no hay blobs en la pantalla, realizar otra acción
    if (ultimaPosicionBlobDesaparecidoX != 0.0 && ultimaPosicionBlobDesaparecidoY != 0.0) {  // Establece la posición del puntero en la última posición del blob que desapareció
      luzDesaparece();

      //if (puntero != null) {
      //  puntero.setPosition(ultimaPosicionBlobDesaparecidoX, ultimaPosicionBlobDesaparecidoY);
      //  mundo.add(puntero);
      //  mundo.add(telarana);
      //}
    }
    println("No hay blobs en la pantalla");
  }

  println( frameRate );
}

void keyPressed() {
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

void luzDesaparece() {

  if (puntero == null) {
    puntero = new FCircle(30);
    mundo.add(puntero);

    // Ajustar las coordenadas del puntero en función de la posición de la cámara y el personaje
    float xCam = personaje.getX();
    punteroX = ultimaPosicionBlobDesaparecidoX + xCam - 100; // Ajusta la posición del puntero en relación con la cámara y el personaje
    punteroY = ultimaPosicionBlobDesaparecidoY;

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
