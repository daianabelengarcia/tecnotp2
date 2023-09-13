int estadoActual = 1;
boolean botonPresionado = false;
Rex rex;

int fondoX = 0;

PImage fondo;


void setup () {
  size (1000, 600);
  rex = new Rex();
  fondo = loadImage("fondo2.png");
}

void draw () {
  background(0);

  // Comprueba si el botón ha sido presionado
  if (botonPresionado) {
    estadoActual = (estadoActual % 3) + 1;
    botonPresionado = false;
  }

  // Muestra el estado actual
  if (estadoActual == 1) {
    noFill();
    //rect(450, 425, 100, 50);
    stroke(255);
    strokeWeight(5);
    ellipseMode(CENTER);
    ellipse(width/2, height/2+150, 100, 50);

    textMode(CENTER);
    text("Dispare una telaaraña aquí para empezar", width/2-110, height/2+100);
  } else if (estadoActual == 2) {
    image(fondo, fondoX, 0, 2998, 600);
    text("Estado 2", 150, 50);
    rex.Dibujar();
  } else if (estadoActual == 3) {
    text("Estado 3", 150, 50);
    fill(0, 0, 255); //rect(450, 425, 100, 50);
    stroke(255);
    strokeWeight(5);
    ellipseMode(CENTER);
    ellipse(width/2, height/2+150, 100, 50);
  }
}

void mousePressed() {
  // región del botón
  if (mouseX > 450 && mouseX < 550 && mouseY > 425 && mouseY < 475) {
    botonPresionado = true;
  }
}
