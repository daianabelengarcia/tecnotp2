
int PUERTO_OSC  = 12345 ;
Receptor receptor;

import fisica.*;

FWorld mundo;

ArrayList<Plataforma> plataformas;

Personaje personaje;

FCircle puntero;
FDistanceJoint telarana;

ArrayList<Andamio> andamio;
int andamioY = 100;
int andamioX = 600;
int tamax = 300;
int tamay = 40;

float punteroX;
float punteroY;

PImage fondo;
PImage logo;
int posp = 600;
int posf = 0;
int contador = 0;

PGraphics pgraphics;

// -- Blob --
float ultimaPosicionBlobDesaparecidoX;
float ultimaPosicionBlobDesaparecidoY;

int estadoActual = 1;
boolean botonPresionado = false;
float mx, my;

void setup() {
  size (1000, 600);
  fondo = loadImage("fondo2.jpg");
  logo = loadImage("logoConDino.png");

  setupOSC(PUERTO_OSC);
  receptor = new Receptor();

  Fisica.init(this);

  mundo = new FWorld();
  mundo.setGravity(0, 800);

  pgraphics = createGraphics(width*3, height); //Para borrar el pgraphics comentar también esta linea

  //------------PLATAFORMAS----------
  plataformas = new ArrayList <Plataforma> ();

  for (int i = 0; i<10; i++) {
    Plataforma p = new Plataforma (400, 40);
    p.inicializar(i*posp, height-20);
    mundo.add(p);
    plataformas.add(p);
  }

  //-----------PERSONAJE----------
  personaje = new Personaje (145, 183);
  personaje.inicializar(150, height-150);
  mundo.add(personaje);

  //-----------ANDAMIOS-----------
  andamio = new ArrayList <Andamio> ();

  for (int i = 0; i <10; i++) {
    Andamio a = new Andamio (300, 40);
    a.inicializar(i*500, 100);
    mundo.add(a);
    andamio.add(a);
  }
}

void draw() {
  receptor.actualizar(mensajes);

  //image(fondo, 0, 0); //Para usar sin el pgraphic descomentar esta linea

  println("contador: " + contador);
  println("estadoActual: " + estadoActual);
  println(personaje.getX());

  mundo.step();

  personaje.actualizar();

  boolean hayBlobEnPantalla = false; //-->(NO es que quiera poner este boolean en el draw, es que sino no funciona. No me preguntes por qué. No lo sé)

  if (botonPresionado) {
    estadoActual = (estadoActual % 4) + 1;
    botonPresionado = false;
  }

  if (estadoActual == 1 || estadoActual == 2) {
    receptor.dibujarBlobs();
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

  // Botones
  if (!hayBlobEnPantalla) {
    if (estadoActual == 1 && (ultimaPosicionBlobDesaparecidoX > width/2-50 && ultimaPosicionBlobDesaparecidoX < width/2+50 && ultimaPosicionBlobDesaparecidoY > (height/2+150)-25 && ultimaPosicionBlobDesaparecidoY < (height/2+150)+25)) {
      botonPresionado = true;
    }
    if ((estadoActual == 3 || estadoActual == 4) && (ultimaPosicionBlobDesaparecidoX > width/2-50 && ultimaPosicionBlobDesaparecidoX < width/2+50 && ultimaPosicionBlobDesaparecidoY > (height/2+50)-25 && ultimaPosicionBlobDesaparecidoY < (height/2+50)+25)) {
      estadoActual = 1;
    }
  }

  if (estadoActual == 1) {
    fill(0);
    rect(0, 0, width, height);
    push();
    imageMode(CENTER);
    image (logo, width/2+10, height/3);
    colorMode(RGB);
    noFill();
    stroke(252, 232, 0);
    strokeWeight(4);
    rectMode(CENTER);
    rect(width/2, height/2+150, 100, 50);

    fill(255);
    textMode(CENTER);
    text("Dispare una telaraña aquí para empezar", width/2-110, height/2+100);
    pop();
  } else if (estadoActual == 2) {
    contador++;
    mundo.step();
    personaje.actualizar();
    
    //----------CON ESTE CÓDIGO FUNCIONA CON EL PGRAPHICS----------
    pgraphics.beginDraw();
    pgraphics.image(fondo, posf, 0);
    mundo.draw(pgraphics);
    pgraphics.endDraw();

    float xCamara = personaje.getX();
    image(pgraphics, -xCamara+100, 0);

    //------------CON ESTE CÓDIGO FUNCIONA LA CÁMARA SIN EL PGRAPHICS, PERO HAY QUE AJUSTAR LOS PARÁMETROS PORQUE SE VA A LA MIERDA------------
    //float xCamara = personaje.getX();
    //pushMatrix();
    //translate(-xCamara + 100, 0);
    //mundo.draw();  
    //popMatrix();

    if ((!mousePressed || hayBlobEnPantalla) && puntero != null) {
      mundo.remove(puntero);
      puntero = null;
    }

    if (!hayBlobEnPantalla) {  // Si no hay blobs en la pantalla, realizar otra acción
      if (ultimaPosicionBlobDesaparecidoX != 0.0 && ultimaPosicionBlobDesaparecidoY != 0.0) {  // Establece la posición del puntero en la última posición del blob que desapareció
        luzDesaparece();
      }
      //println("No hay blobs en la pantalla");
    }
  } else if (estadoActual == 3) {
    fill(0);
    rect(0, 0, width, height);

    push();
    fill(255);
    textSize(24);
    textMode(CENTER);
    textAlign(CENTER);
    text("GANASTE", width/2, height/2-100);

    imageMode(CENTER);
    colorMode(RGB);
    noFill();
    stroke(252, 232, 0);
    strokeWeight(4);
    rectMode(CENTER);
    rect(width/2, height/2+50, 100, 50);

    fill(255);
    textSize(14);
    text("Dispare una telaraña aquí para reiniciar", width/2, height/2);
    pop();
  } else if (estadoActual == 4) {
    fill(0);
    rect(0, 0, width, height);

    push();
    fill(255);
    textSize(24);
    textMode(CENTER);
    textAlign(CENTER);
    text("PERDISTE", width/2, height/2-100);

    imageMode(CENTER);
    colorMode(RGB);
    noFill();
    stroke(252, 232, 0);
    strokeWeight(4);
    rectMode(CENTER);
    rect(width/2, height/2+50, 100, 50);

    fill(255);
    textSize(14);
    text("Dispare una telaraña aquí para reiniciar", width/2, height/2);
    pop();
  }

  println("frameRate: " + frameRate );
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
  if (key == '3') {
    estadoActual = 3;
  }
  if (key == '4') {
    estadoActual = 4;
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

  //----------PUNTERO SOBRE EL ANDAMIO-----------
  for (int i = 0; i < 5; i++) {
    float aIzq = andamio.get(i).getX() -150;
    float aDer = andamio.get(i).getX() +150;
    float aArriba = andamio.get(i).getY() -20;
    float aAbajo = andamio.get(i).getY() +20;

    if (punteroX >= aIzq && punteroX <= aDer && punteroY >= aArriba && punteroY <= aAbajo) {
      telarana = new FDistanceJoint (personaje, puntero);
      mundo.add (telarana);
      telarana.setDamping (1);
      telarana.setFrequency(1);
      telarana.setLength (200);
    }
  }
}

void mousePressed() {

  if (estadoActual == 2) {
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

//---------------PUNTERO SOBRE EL ANDAMIO----------
    for (int i = 0; i < 10; i++) {
      float aIzq = andamio.get(i).getX() -150; 
      float aDer = andamio.get(i).getX() +150;
      float aArriba = andamio.get(i).getY() -20;
      float aAbajo = andamio.get(i).getY() +20;

      if (punteroX >= aIzq && punteroX <= aDer && punteroY >= aArriba && punteroY <= aAbajo) {
        personaje.puedeSaltar = false;
        telarana = new FDistanceJoint (personaje, puntero);
        mundo.add (telarana);
        telarana.setDamping (1);
        telarana.setFrequency(1);
        telarana.setLength (200);
      }
    }
  }

  // Botones
  if (estadoActual == 1 && (mouseX > width/2-50 && mouseX < width/2+50 && mouseY > (height/2+150)-25 && mouseY < (height/2+150)+25)) {
    botonPresionado = true;
  }
  if ((estadoActual == 3 || estadoActual == 4) && (mouseX > width/2-50 && mouseX < width/2+50 && mouseY > (height/2+50)-25 && mouseY < (height/2+50)+25)) {
    estadoActual = 1;
  }
}

//-----------SI EL DINO NO ESTÁ EN CONTACTO CON LA PLATAFORMA, NO PUEDE SALTAR (SOLO PARA LAS TECLAS)-----------
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
