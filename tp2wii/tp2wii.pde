int PUERTO_OSC  = 12345 ;
Receptor receptor;

import fisica.*;

FWorld mundo;

Personaje personaje;

FBox puntero;
float punteroX;
float punteroY;

FDistanceJoint telarana;
boolean hayTelarana;

Andamio andamio;
Andamio andamio2;
float velocidad = 5;
int andamioY = 100;
int andamioX = 500;
int tamax = 400;
int tamay = 40;

float aIzq; //bordes andamios
float aDer;
float aArriba;
float aAbajo;

float aIzq2;
float aDer2;
float aArriba2;
float aAbajo2; //hasta acá


Plataforma plataforma;
Plataforma plataforma3;
float velplataforma = 3;

PImage fondo;
PImage logo;
PImage mira;
PImage tela;
int posp = 1000;
int posf = 0;
int contador = 0;

// -- Blob --
float ultimaPosicionBlobDesaparecidoX;
float ultimaPosicionBlobDesaparecidoY;

int estadoActual = 2;
boolean botonPresionado = false;
float mx, my;

void setup() {

  size (1000, 600);
  fondo = loadImage("fondo2.jpg");
  logo = loadImage("logoConDino.png");
  tela = loadImage("telarana.png");

  setupOSC(PUERTO_OSC);
  receptor = new Receptor();

  Fisica.init(this);

  mundo = new FWorld();
  mundo.setEdges(0, 0, 1000, 1000);
  mundo.setGravity(0, 800);

  // pgraphics = createGraphics(width*3, height); //Para borrar el pgraphics comentar también esta linea

  //------------PLATAFORMAS----------
  //plataformas = new ArrayList <Plataforma> ();

  //for (int i = 0; i<10; i++) {
  //  Plataforma p = new Plataforma (800, 40);
  //  p.inicializar(i*posp, height-20);
  //  mundo.add(p);
  //  plataformas.add(p);
  //}
  plataforma = new Plataforma (1200, 40);
  plataforma.inicializar(0, height-20);
  mundo.add(plataforma);

  plataforma3 = new Plataforma (1200, 80);
  plataforma3.inicializar(1500, height-40);
  mundo.add(plataforma3);

  //-----------PERSONAJE----------
  personaje = new Personaje (145, 183);
  personaje.inicializar(150, height-150);
  mundo.add(personaje);

  //-----------ANDAMIOS-----------
  //andamio = new ArrayList <Andamio> ();

  //for (int i = 0; i <10; i++) {
  //  Andamio a = new Andamio (300, 40);
  //  a.inicializar(i*600, 100);
  //  mundo.add(a);
  //  andamio.add(a);
  //}
  andamio = new Andamio(tamax, tamay);
  andamio.inicializar(andamioX, andamioY);
  mundo.add(andamio);
  andamio2 = new Andamio(tamax, tamay);
  andamio2.inicializar(1200, 100);
  mundo.add(andamio2);

  hayTelarana = false;
}

void draw() {
  receptor.actualizar(mensajes);
  
  mundo.step();

  image(fondo, posf, 0); //Para usar sin el pgraphic descomentar esta linea
  
  mundo.draw();

  println("contador: " + contador);
  println("estadoActual: " + estadoActual);
  println(personaje.getX());

  
  personaje.actualizar();


  boolean hayBlobEnPantalla = false; //-->(NO es que quiera poner este boolean en el draw, es que sino no funciona. No me preguntes por qué. No lo sé)

  if (botonPresionado) {
    estadoActual = (estadoActual % 4) + 1;
    botonPresionado = false;
  }

  // -- Blob (Luz) --
  for (Blob b : receptor.blobs) {
    if (b.entro) {
      //puntero.setDrawable(false);
      mundo.remove(telarana);
      mundo.remove(puntero);
      receptor.dibujarBlobs();
    }
    if (!b.salio) {
      hayBlobEnPantalla = true;  // Si al menos un blob no ha salido, establece hayBlobEnPantalla en true
    }

    // Variables que calculan la última posición de la luz antes de desaparecer
    ultimaPosicionBlobDesaparecidoX = b.ultimaPosicionBlob.x;
    ultimaPosicionBlobDesaparecidoY = b.ultimaPosicionBlob.y;
  }

  // Botones que funcionan con la luz
  if (!hayBlobEnPantalla) {
    if (estadoActual == 1 && (ultimaPosicionBlobDesaparecidoX > width/2-50 && ultimaPosicionBlobDesaparecidoX < width/2+50 && ultimaPosicionBlobDesaparecidoY > (height/2+150)-25 && ultimaPosicionBlobDesaparecidoY < (height/2+150)+25)) {
      botonPresionado = true;
    }
    if ((estadoActual == 3 || estadoActual == 4) && (ultimaPosicionBlobDesaparecidoX > width/2-50 && ultimaPosicionBlobDesaparecidoX < width/2+50 && ultimaPosicionBlobDesaparecidoY > (height/2+50)-25 && ultimaPosicionBlobDesaparecidoY < (height/2+50)+25)) {
      estadoActual = 1;
    }
  }

  if (estadoActual == 1) {  // ---> PANTALLA DE INICIO

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
    receptor.dibujarBlobs();
  } else if (estadoActual == 2) {  // ---> EL JUEGO

    contador++;   // --> (Esto no sirve de mucho. Solo lo tengo para saber cuando funciona y cuando no el estado 2, es decir, el juego)
    posf--;
    if (posf <= -5000) {
      posf = 0;
    }
    personaje.actualizar();
    andamio.actualizar(velocidad);
    andamio2.actualizar(velocidad);
    //for (Andamio a : andamio) {
    //  a.actualizar(velocidad);
    //}
    plataforma.actualizar(velplataforma);
    plataforma3.actualizar(velplataforma);

    //if (personaje.getY() >= height+100) {
    //  estadoActual = 4;
    //  borrar();
    //  reiniciar();
    //}


    //----------CON ESTE CÓDIGO FUNCIONA CON EL PGRAPHICS----------
    //pgraphics.beginDraw();
    //pgraphics.image(fondo, posf, 0);
    //mundo.draw(pgraphics);
    //pgraphics.endDraw();

    //float xCamara = personaje.getX();
    //image(pgraphics, -xCamara+100, 0);


    //------------CON ESTE CÓDIGO FUNCIONA LA CÁMARA SIN EL PGRAPHICS, PERO HAY QUE AJUSTAR LOS PARÁMETROS PORQUE SE VA A LA MIERDA------------
    //float xCamara = personaje.getX();
    //translate(-xCamara + 100, 0);
    //mundo.draw();

    if ((!mousePressed || hayBlobEnPantalla) && puntero != null) {
      mundo.remove(puntero);
      puntero = null;
    }


    if (!hayBlobEnPantalla) {  // Si no hay blobs en la pantalla, se crea el puntero
      if (ultimaPosicionBlobDesaparecidoX != 0.0 && ultimaPosicionBlobDesaparecidoY != 0.0) {  // Establece la posición del puntero en la última posición del blob que desapareció
        luzDesaparece();
      }
      //println("No hay blobs en la pantalla");
    }
    receptor.dibujarBlobs();
  } else if (estadoActual == 3) {   // ---> PANTALLA DE GANAR
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
   receptor.dibujarBlobs();
  } else if (estadoActual == 4) {   // ---> PANTALLA DE PERDER

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
    receptor.dibujarBlobs();
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
    puntero = new FBox(20, 20);
    puntero.attachImage(tela);

    //puntero.setFill(255, 100, 100);  // ---> Formas de personalizar FCircle, FBox o cualquier objeto de Fisica.
    //puntero.setNoStroke();           //      Lo comenté para tenerlo a mano, por las dudas
    //puntero.setStrokeWeight(5);
    //puntero.setStroke(255, 0, 50);

    mundo.add(puntero);

    // Ajustar las coordenadas del puntero en función de la posición de la cámara y el personaje
    float xCam = personaje.getX();
    punteroX = ultimaPosicionBlobDesaparecidoX ; // Ajusta la posición del puntero en relación con la cámara y el personaje
    punteroY = ultimaPosicionBlobDesaparecidoY;

    puntero.setPosition(punteroX, punteroY);
    puntero.setStatic(true);
    puntero.setGrabbable(false);
  }

  //----------PUNTERO SOBRE EL ANDAMIO-----------
  aIzq = andamio.getX() -150;
  aDer = andamio.getX() +150;
  aArriba = andamio.getY() -20;
  aAbajo = andamio.getY() +20;

  aIzq2 = andamio2.getX() -150;
  aDer2 = andamio2.getX() +150;
  aArriba2 = andamio2.getY() -20;
  aAbajo2 = andamio2.getY() +20;



  if ((punteroX >= aIzq && punteroX <= aDer && punteroY >= aArriba && punteroY <= aAbajo) || (punteroX >= aIzq2 && punteroX <= aDer2 && punteroY >= aArriba2 && punteroY <= aAbajo2)) {      
    telarana = new FDistanceJoint (personaje, puntero);
    mundo.add (telarana);
    telarana.setDamping (1);
    telarana.setFrequency(2);
    telarana.setLength (200);
    hayTelarana = true;
  }
}

void mousePressed() {

  if (estadoActual == 2) {
    if (puntero == null) {
      puntero = new FBox(20, 20);
      puntero.attachImage(tela);
      mundo.add(puntero);

      // Ajustar las coordenadas del puntero en función de la posición de la cámara y el personaje
      float xCam = personaje.getX();
      punteroX = mouseX ; // Ajusta la posición del puntero en relación con la cámara y el personaje
      punteroY = mouseY;

      puntero.setPosition(punteroX, punteroY);
      puntero.setStatic(true);
      puntero.setGrabbable(false);
    }

    //---------------PUNTERO SOBRE EL ANDAMIO----------
    aIzq = andamio.getX() -150;
    aDer = andamio.getX() +150;
    aArriba = andamio.getY() -20;
    aAbajo = andamio.getY() +20;

    aIzq2 = andamio2.getX() -150;
    aDer2 = andamio2.getX() +150;
    aArriba2 = andamio2.getY() -20;
    aAbajo2 = andamio2.getY() +20;



    if ((punteroX >= aIzq && punteroX <= aDer && punteroY >= aArriba && punteroY <= aAbajo) || (punteroX >= aIzq2 && punteroX <= aDer2 && punteroY >= aArriba2 && punteroY <= aAbajo2)) {      
      telarana = new FDistanceJoint (personaje, puntero);
      mundo.add (telarana);
      telarana.setDamping (1);
      telarana.setFrequency(2);
      telarana.setLength (200);
      hayTelarana = true;
    }
  }

  // Botones que funcionan con el mouse
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
//else {
//      estadoActual = 4;  //  Aparece la pantalla de perdiste
//      // Se reinicia el juego      ----> (No sé si de esta forma eventualmente se va a romper todo, pero por ahora funciona)
//      contador = 0;
//      mundo = new FWorld();
//      mundo.setGravity(0, 800);

//      //pgraphics = createGraphics(width*3, height); //Para borrar el pgraphics comentar también esta linea

//      //------------PLATAFORMAS----------
//      //plataformas = new ArrayList <Plataforma> ();

//      //for (int i = 0; i<10; i++) {
//      //  Plataforma p = new Plataforma (800, 40);
//      //  p.inicializar(i*posp, height-20);
//      //  mundo.add(p);
//      //  plataformas.add(p);
//      //}

//      //-----------PERSONAJE----------
//      personaje = new Personaje (145, 183);
//      personaje.inicializar(150, height-150);
//      mundo.add(personaje);

//      //-----------ANDAMIOS-----------
//      //andamio = new ArrayList <Andamio> ();

//      //for (int i = 0; i <10; i++) {
//      //  Andamio a = new Andamio (300, 40);
//      //  a.inicializar(i*500, 100);
//      //  mundo.add(a);
//      //  andamio.add(a);
//      //}
//      //andamio = new Andamio (tamax, tamay);
//      //andamio.inicializar(andamioX, andamioY);
//      //mundo.add(andamio);
//    }
//  }
//}
void reiniciar() {
  contador = 0;
  //mundo = new FWorld();
  mundo.setEdges(0, 0, 1000, 1000);
  mundo.setGravity(0, 800);
  
  //------------PLATAFORMAS----------
  plataforma = new Plataforma (1200, 40);
  plataforma.inicializar(0, height-20);
  mundo.add(plataforma);

  plataforma3 = new Plataforma (1200, 80);
  plataforma3.inicializar(1500, height-40);
  mundo.add(plataforma3);

  //-----------PERSONAJE----------
  personaje = new Personaje (145, 183);
  personaje.inicializar(150, height-150);
  mundo.add(personaje);

  //-----------ANDAMIOS-----------
  andamio = new Andamio(tamax, tamay);
  andamio.inicializar(andamioX, andamioY);
  mundo.add(andamio);
  andamio2 = new Andamio(tamax, tamay);
  andamio2.inicializar(1200, 100);
  mundo.add(andamio2);

  hayTelarana = false;
}
void borrar(){
  mundo.remove(plataforma);
  mundo.remove(plataforma3);
  mundo.remove(personaje);
  mundo.remove(andamio);
  mundo.remove(andamio2);
}
