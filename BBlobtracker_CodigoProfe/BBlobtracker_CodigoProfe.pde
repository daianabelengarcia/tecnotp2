int PUERTO_OSC = 12345; //<>//

Receptor receptor;

void setup() {

  size(800, 600);

  setupOSC(PUERTO_OSC);

  receptor = new Receptor();
}

void draw() {
  background(255);  

  receptor.actualizar(mensajes); //  
  receptor.dibujarBlobs(width, height);


  // Eventos de entrada y salida
  for (Blob b : receptor.blobs) {

    if (b.entro) {
      println("--> entro blob: " + b.id);
    }
    if (b.salio) {
      println("<-- salio blob: " + b.id);
    }
  }

  //println("cantidad de blobs: " + receptor.blobs.size());
}
