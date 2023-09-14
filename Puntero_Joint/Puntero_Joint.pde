 //<>//
//--------
//  Este código lo que hace es si hay un Blob (luz) se muestra un círculo negro que lo sigue.
//  Si desaparece el Blob aparece un cuadrado rojo estático en el centro de la pantalla.
//  Todavía hay que pulir un montón de cosas. 
//  Y hay otras cosas que no las entiendo todavía.
//--------

int PUERTO_OSC = 12345;

Receptor receptor;

import fisica.*;

FWorld mundo;
FBox andamio;
FBox personaje;
FCircle puntero;
FDistanceJoint telarana;


float ultimaPosicionBlobDesaparecidoX;
float ultimaPosicionBlobDesaparecidoY;
//boolean blobHaEntrado = false;

void setup() {
  size (1500, 900);
  //size (1000, 500);
  setupOSC(PUERTO_OSC);
  receptor = new Receptor();
  Fisica.init (this);

  mundo = new FWorld ();
  mundo.setEdges();


  andamio = new FBox (900, 200);
  mundo.add(andamio);
  andamio.setPosition (width/2, 100);
  andamio.setStatic (true);
  andamio.setGrabbable (false);

  personaje = new FBox (100, 200);
  mundo.add(personaje);
  personaje.setPosition (300, 750);
  //personaje.setGrabbable (false);

  puntero = new FCircle(30);
  mundo.add(puntero);
  puntero.setStatic(true);
  puntero.setGrabbable(false);

  telarana = new FDistanceJoint(personaje, puntero);
  mundo.add(telarana);
  telarana.setDamping(0.1);
  telarana.setFrequency(2);
  telarana.setLength(300);
}

void draw() {
  background(255);  
  receptor.actualizar(mensajes); 

  mundo.step();  //si no llamamos esto el mundo se queda quieto (como si no pasara el tiempo)
  mundo.draw(); //dibuja el mundo de física 
  mundo.drawDebug();

  println (telarana);

  boolean hayBlobEnPantalla = false; //-->(NO es que quiera poner este boolean en el draw, es que sino no funciona. No me preguntes por qué. No lo sé)

  for (Blob b : receptor.blobs) {
    if (b.entro) {
      // Si un blob entra, dibujar la elipse negra
      //puntero.setDrawable(false);
      //mundo.remove(telarana);
      mundo.remove(puntero);
      receptor.dibujarBlobs();
      println("entro");
      println("Antes de establecer la posición del puntero:");
      println("X: " + b.ultimaPosicionBlob.x);
      println("Y: " + b.ultimaPosicionBlob.y);
    }

    if (!b.salio) {
      // Si al menos un blob no ha salido, establece hayBlobEnPantalla en true
      hayBlobEnPantalla = true;
    }

    ultimaPosicionBlobDesaparecidoX = b.ultimaPosicionBlob.x;
    ultimaPosicionBlobDesaparecidoY = b.ultimaPosicionBlob.y;
  }

  if (!hayBlobEnPantalla) {
    // Si no hay blobs en la pantalla, realizar otra acción

    if (ultimaPosicionBlobDesaparecidoX != 0.0 && ultimaPosicionBlobDesaparecidoY != 0.0) {
      // Establece la posición del puntero en la última posición del blob que desapareció
      if (puntero != null) {
        puntero.setPosition(ultimaPosicionBlobDesaparecidoX, ultimaPosicionBlobDesaparecidoY);
        fill(0);
        mundo.add(puntero);
        mundo.add(telarana);
      }
    }

    //println("Después de establecer la posición del puntero:");
    //println("X: " + puntero.getX());
    //println("Y: " + puntero.getY());

    println("No hay blobs en la pantalla");
  }
}
