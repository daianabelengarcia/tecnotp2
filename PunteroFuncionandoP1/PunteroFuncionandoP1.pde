//-------- //<>//
//  Este código lo que hace es si hay un Blob (luz) se muestra un círculo negro que lo sigue.
//  Si desaparece el Blob aparece un cuadrado rojo estático en el centro de la pantalla.
//  Todavía hay que pulir un montón de cosas. 
//  Y hay otras cosas que no las entiendo todavía.
//--------

int PUERTO_OSC = 12345;

Receptor receptor;

void setup() {
  size(800, 600);

  setupOSC(PUERTO_OSC);

  receptor = new Receptor();
}

void draw() {
  background(255);  
  receptor.actualizar(mensajes); 

  boolean hayBlobEnPantalla = false; //-->(NO es que quiera poner este boolean en el draw, es que sino no funciona. No me preguntes por qué. No lo sé)

  for (Blob b : receptor.blobs) {
    if (b.entro) {
      // Si un blob entra, dibujar la elipse negra
      receptor.dibujarBlobs(width, height);
      println("entro");
    }
    if (b.salio) {
      // Si un blob sale, dibujar un cuadrado rojo en su última posición
      println("salio");
      fill(255, 0, 0);
      rect(b.ultimaPosicionBlob.x, b.ultimaPosicionBlob.y, 40, 40);
    }
    //println("Estado: " + b.estado);
    println("Vida: " + b.vida);

    if (!b.salio) {
      // Si al menos un blob no ha salido, establece hayBlobEnPantalla en true
      hayBlobEnPantalla = true;
    }
  }

  if (!hayBlobEnPantalla) {
    // Si no hay blobs en la pantalla, realizar otra acción

    background(200);
    push();
    rectMode(CENTER);
    fill(255, 0, 0);
    rect (width/2, height/2, 70, 70);
    pop();

    println("No hay blobs en la pantalla");
  }
}
