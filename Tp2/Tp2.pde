//-----------VIDEO-----------
// https://drive.google.com/file/d/1awMukyuEg5PoHGNSq5IyUwdEcLtNHuzQ/view?usp=drive_link


int PUERTO_OSC  = 12345 ;
Receptor receptor;

import fisica.*;
import processing.sound.*;

FWorld mundo;

Personaje personaje;
LogicaDeEstados logica;

FBox puntero;
float punteroX;
float punteroY;
float origenX;
float origenY;
float f;
int ruido = 30;

Telarana telarana;
boolean hayTelarana;

Andamio andamio;
Andamio andamio2;
float velocidad = 5;
int andamioY = 0;
int andamioX = 500;
int andamioX2 = 1200;
int tamax = 400;
int tamay = 40;

boolean antesHabiaBlob;

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
Plataforma plataformaFinal;
float velplataforma = 3;

// -- Blob --
float ultimaPosicionBlobDesaparecidoX;
float ultimaPosicionBlobDesaparecidoY;

float mx, my;

// -- Sonido --
SoundFile sonidoInicio;
SoundFile sonidoAmbiente;
SoundFile sonidoGanaste;
SoundFile sonidoLanzaTelarana;
SoundFile sonidoCaida;
SoundFile sonidoCaePlataforma;
SoundFile sonidoEmbocaAndamio;
SoundFile sonidoPerdiste;
SoundFile sonidoWiii;

void setup() {

  size (1000, 600);

  setupOSC(PUERTO_OSC);
  receptor = new Receptor();

  logica = new LogicaDeEstados();

  Fisica.init(this);

  mundo = new FWorld();
  mundo.setEdges(0, 0, 1000, 1000);
  mundo.setGravity(0, 800);

  //------------PLATAFORMAS----------   // NOTA: Podríamos ponerle una imagen a las plataformas
  plataforma = new Plataforma (600, 40);
  plataforma.inicializar(200, height-20);
  mundo.add(plataforma);

  plataforma3 = new Plataforma (600, 80);
  plataforma3.inicializar(1000, height-40);
  mundo.add(plataforma3);
  
  plataformaFinal = new Plataforma (600,40);
  plataformaFinal.inicializar(1500, height-20);
        mundo.add(plataformaFinal);

  //-----------PERSONAJE----------
  personaje = new Personaje (145, 183);
  personaje.inicializar(150, height-150);
  mundo.add(personaje);

  //-----------ANDAMIOS-----------     
  andamio = new Andamio(tamax, tamay);
  andamio.inicializar(andamioX, andamioY);
  mundo.add(andamio);
  andamio2 = new Andamio(tamax, tamay);
  andamio2.inicializar(andamioX2, andamioY);
  mundo.add(andamio2);

  f = 0.9;

  //-----------SONIDO----------
  sonidoInicio = new SoundFile(this, "Inicio.wav");
  sonidoAmbiente = new SoundFile (this, "Ambiente.wav");
  sonidoGanaste = new SoundFile (this, "Ganaste.wav");
  sonidoLanzaTelarana = new SoundFile (this, "Telaraña.wav");
  sonidoCaida = new SoundFile (this, "Caida.wav");
  sonidoCaePlataforma = new SoundFile (this, "CaePlataforma.wav");
  sonidoEmbocaAndamio = new SoundFile (this, "EmbocaAndamio.wav");
  sonidoPerdiste = new SoundFile (this, "Perdiste.wav");
  sonidoWiii = new SoundFile (this, "Wiii.wav");

  sonidoInicio.stop();
  sonidoAmbiente.play();
  sonidoGanaste.stop();
  sonidoLanzaTelarana.stop();
  sonidoCaida.stop();
  sonidoCaePlataforma.stop();
  sonidoEmbocaAndamio.stop();
  sonidoPerdiste.stop();
  sonidoWiii.stop();
}

void draw() {
  receptor.actualizar(mensajes);
  mundo.step();

  boolean hayBlobEnPantalla = false; //-->(NO es que quiera poner este boolean en el draw, es que sino no funciona. No me preguntes por qué. No lo sé)

  logica.cambiarEstado(hayBlobEnPantalla, ultimaPosicionBlobDesaparecidoX, ultimaPosicionBlobDesaparecidoY);
  logica.actualizar();


  for (Blob b : receptor.blobs) {
    if (b.entro) {
      hayBlobEnPantalla = true;
    }
    if (!b.entro) {
      hayBlobEnPantalla = false;
      ultimaPosicionBlobDesaparecidoX = b.ultimaPosicionBlob.x;
      ultimaPosicionBlobDesaparecidoY = b.ultimaPosicionBlob.y;
    }
  }
  boolean salioLuz = !hayBlobEnPantalla;
  boolean entroLuz = hayBlobEnPantalla;

  if (puntero != null) {        // comentar para mouse
    mundo.remove(puntero);      // descomentar para luz
    puntero = null;
  }
  
  if (entroLuz) {
    receptor.dibujarBlobs();
  }

  if (salioLuz) {
    logica.luzDesaparece(ultimaPosicionBlobDesaparecidoX, ultimaPosicionBlobDesaparecidoY);
  }

  //if ((!mousePressed || hayBlobEnPantalla) && puntero != null) {    // comentar para luz
  //  mundo.remove(puntero);                                          // descomentar para mouse
  //  puntero = null;                                            
  //}

  println("hay blob: "+hayBlobEnPantalla);
  println("estado: "+logica.estadoActual);
  println("luz: "+salioLuz);  
  println("telaraña: "+telarana.telaranaLanzada);


  //------------CON ESTE CÓDIGO FUNCIONA LA CÁMARA SIN EL PGRAPHICS, PERO HAY QUE AJUSTAR LOS PARÁMETROS PORQUE SE VA A LA MIERDA------------
  //float xCamara = personaje.getX();
  //translate(-xCamara + 100, 0);
  //mundo.draw();
}

void mousePressed() {

  logica.luzDesaparece(mouseX, mouseY);

  // Botones con el mouse
  if (logica.estadoActual == 1 && (mouseX > (width/2+302)-162 && mouseX < (width/2+302)+162 && mouseY > (height/2+48)-45 && mouseY < (height/2+48)+45)) {
    logica.estadoActual = 2;

    // Sonido
    sonidoInicio.play();
    sonidoAmbiente.stop();
    sonidoGanaste.stop();
    sonidoLanzaTelarana.stop();
    sonidoCaida.stop();
    sonidoCaePlataforma.stop();
    sonidoEmbocaAndamio.stop();
    sonidoPerdiste.stop();
    sonidoWiii.stop();
  }
  if ((logica.estadoActual == 3 || logica.estadoActual == 4) && (mouseX > width/2-50 && mouseX < width/2+50 && mouseY > (height/2+50)-25 && mouseY < (height/2+50)+25)) {
    logica.estadoActual = 1;

    // Sonido
    sonidoInicio.stop();
    sonidoAmbiente.play();
    sonidoGanaste.stop();
    sonidoLanzaTelarana.stop();
    sonidoCaida.stop();
    sonidoCaePlataforma.stop();
    sonidoEmbocaAndamio.stop();
    sonidoPerdiste.stop();
    sonidoWiii.stop();
  }
}


//-----------SI EL DINO NO ESTÁ EN CONTACTO CON LA PLATAFORMA, NO PUEDE SALTAR-----------
void contactStarted(FContact contact) {
  FBody body1 = contact.getBody1();
  FBody body2 = contact.getBody2();
  if ((body1.getName() == "personaje" && body2.getName() == "plataforma") || (body1.getName() == "plataforma" && body2.getName () == "personaje")) {
    if (contact.getNormalX() == 0 && personaje.getVelocityY() >= 0) {
      if (body1.getName() == "personaje" && contact.getNormalY() > 0) {
        personaje.puedeSaltar = true;
        sonidoCaePlataforma.play();
      } else if (body2.getName() == "personaje" && contact.getNormalY() < 0) {
        personaje.puedeSaltar = true;
        sonidoCaePlataforma.play();
      }
    }
  }
}


//  -------SONIDOS-------

void keyPressed() {
  if (key == 'a') {       //AMBIENTE
    sonidoInicio.stop();
    sonidoAmbiente.play();
    sonidoGanaste.stop();
    sonidoLanzaTelarana.stop();
    sonidoCaida.stop();
    sonidoCaePlataforma.stop();
    sonidoEmbocaAndamio.stop();
    sonidoPerdiste.stop();
    sonidoWiii.stop();
  } else if (key == 'b') {  //INICIO
    sonidoInicio.play();
    sonidoAmbiente.stop();
    sonidoGanaste.stop();
    sonidoLanzaTelarana.stop();
    sonidoCaida.stop();
    sonidoCaePlataforma.stop();
    sonidoEmbocaAndamio.stop();
    sonidoPerdiste.stop();
    sonidoWiii.stop();
  } else if (key == 'c') { //GANASTE -- ACORTAR
    sonidoInicio.stop();
    sonidoAmbiente.stop();
    sonidoGanaste.play();
    sonidoLanzaTelarana.stop();
    sonidoCaida.stop();
    sonidoCaePlataforma.stop();
    sonidoEmbocaAndamio.stop();
    sonidoPerdiste.stop();
    sonidoWiii.stop();
  } else if (key == 'd') {  //CAIDA
    sonidoInicio.stop();    
    sonidoAmbiente.stop();
    sonidoGanaste.stop();
    sonidoCaida.play();
    sonidoLanzaTelarana.stop();
    sonidoCaePlataforma.stop();
    sonidoEmbocaAndamio.stop();
    sonidoPerdiste.stop();
    sonidoWiii.stop();
  } else if (key == 'e') {  //LANZATELARAÑA -- ACORTAR
    sonidoInicio.stop();
    //sonidoAmbiente.stop();
    sonidoGanaste.stop();
    sonidoLanzaTelarana.play();
    sonidoCaida.stop();
    sonidoCaePlataforma.stop();
    sonidoEmbocaAndamio.stop();
    sonidoWiii.stop();
  } else if (key == 'f') {  //CAE PLATAFORMA
    sonidoInicio.stop();
    sonidoAmbiente.stop();
    sonidoGanaste.stop();
    sonidoLanzaTelarana.stop();
    sonidoCaida.stop();
    sonidoCaePlataforma.play();
    sonidoEmbocaAndamio.stop();
    sonidoPerdiste.stop();
    sonidoWiii.stop();
  } else if (key == 'g') {  //EMBOCA ANDAMIO
    sonidoInicio.stop();
    sonidoAmbiente.stop();
    sonidoGanaste.stop();
    sonidoLanzaTelarana.stop();
    sonidoCaida.stop();
    sonidoCaePlataforma.stop();
    sonidoEmbocaAndamio.play();
    sonidoPerdiste.stop();
    sonidoWiii.stop();
  } else if (key == 'h') {  //PERDISTE
    sonidoInicio.stop();
    sonidoAmbiente.stop();
    sonidoGanaste.stop();
    sonidoLanzaTelarana.stop();
    sonidoCaida.stop();
    sonidoCaePlataforma.stop();
    sonidoEmbocaAndamio.stop();
    sonidoPerdiste.play();
    sonidoWiii.stop();
  } else if (key == 'i') {  //WIII -- ACORTAR
    sonidoInicio.stop();
    sonidoAmbiente.stop();
    sonidoGanaste.stop();
    sonidoLanzaTelarana.stop();
    sonidoCaida.stop();
    sonidoCaePlataforma.stop();
    sonidoEmbocaAndamio.stop();
    sonidoPerdiste.stop();
    sonidoWiii.play();
  }
  
}
