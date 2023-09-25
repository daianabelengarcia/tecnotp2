import processing.sound.*;

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
  size(600, 600);
  sonidoInicio = new SoundFile(this, "Inicio.wav");
  sonidoAmbiente = new SoundFile (this, "Ambiente.wav");
  sonidoGanaste = new SoundFile (this, "Ganaste.wav");
  sonidoLanzaTelarana = new SoundFile (this, "Telaraña.wav");
  sonidoCaida = new SoundFile (this, "Caida.wav");
  sonidoCaePlataforma = new SoundFile (this, "CaePlataforma.wav");
  sonidoEmbocaAndamio = new SoundFile (this, "EmbocaAndamio.wav");
  sonidoPerdiste = new SoundFile (this, "Perdiste.wav");
  sonidoWiii = new SoundFile (this, "Wiii.wav");
}

void draw() {
  background(0);
}

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
