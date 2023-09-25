class LogicaDeEstados {
  int estadoActual;

  PImage fondo;
  PImage logo;
  PImage mira;
  PImage tela;
  PImage bandera;
  int posp = 1000;
  int posf = 0;
  int contador = 0;

  LogicaDeEstados() {
    estadoActual = 1; 

    fondo = loadImage("data/fondo2.jpg");
    logo = loadImage("data/logoConDino.png");
    tela = loadImage("data/telarana.png");
    bandera = loadImage("data/bandera.png");

    hayTelarana = false;
  }

  void cambiarEstado(boolean hayBlob, float ultimaPosicionBlobDesaparecidoX, float ultimaPosicionBlobDesaparecidoY) {

    // Botones con luz
    if (!hayBlob) {
      if (ultimaPosicionBlobDesaparecidoX > width/2-50 && ultimaPosicionBlobDesaparecidoX < width/2+50 && ultimaPosicionBlobDesaparecidoY > (height/2+150)-25 && ultimaPosicionBlobDesaparecidoY < (height/2+150)+25) {
        estadoActual = 2;

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
      if ((estadoActual == 3 || estadoActual == 4) && (ultimaPosicionBlobDesaparecidoX > width/2-50 && ultimaPosicionBlobDesaparecidoX < width/2+50 && ultimaPosicionBlobDesaparecidoY > (height/2+50)-25 && ultimaPosicionBlobDesaparecidoY < (height/2+50)+25)) {
        estadoActual = 1;

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

    if (personaje.getY() >= height+100) {  // Si se cae de la plataforma el dino pierde
      estadoActual = 4;
      borrar();
      reiniciar();

      // Sonido
      sonidoInicio.stop();
      sonidoAmbiente.stop();
      sonidoGanaste.stop();
      sonidoLanzaTelarana.stop();
      sonidoCaida.stop();
      sonidoCaePlataforma.stop();
      sonidoEmbocaAndamio.stop();
      sonidoPerdiste.play();
      sonidoWiii.stop();
    }
  }

  void actualizar() {
    if (estadoActual == 1) {   // Código para el estado del inicio.
      fill(0);
      textMode(CENTER);
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
      text("Dispare una telaraña aquí para empezar", width/2-110, height/2+100);
      pop();
    } else if (estadoActual == 2) {   // Código para el estado del juego.
      //mundo.step();

      image(fondo, posf, 0); 

      mundo.draw();

      personaje.actualizar();

      contador++; // Tiempo

      posf--;
      if (posf <= -5000) { //Fondo vuelve a comenzar
        posf = 0;
      }

      personaje.actualizar();

      andamio.actualizar(velocidad);
      andamio2.actualizar(velocidad);

      plataforma.actualizar(velplataforma);
      plataforma3.actualizar(velplataforma);

      if (contador >= 10 * 60) {               // A los 10 segundos aparece la imagen de la bandera de llegada
        image (bandera, 800, height/2 + 80);   // Recordatorio: Buscar una mejor manera de poner la bandera y que esté en contacto con la plataforma y el personaje
      }
      if (contador >= 12*60) {      // A los 12 segundos cambia a la pantalla de ganar y se reinicia el juego
        estadoActual = 3;
        borrar();
        reiniciar();

        // Sonido
        sonidoInicio.stop();
        sonidoAmbiente.stop();
        sonidoGanaste.play();
        sonidoLanzaTelarana.stop();
        sonidoCaida.stop();
        sonidoCaePlataforma.stop();
        sonidoEmbocaAndamio.stop();
        sonidoPerdiste.stop();
        sonidoWiii.stop();
      }
    } else if (estadoActual == 3) {   // Código para el estado de ganar.
      fill(0);
      rect(0, 0, width, height);

      push();
      fill(255);
      textSize(24);
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
    } else if (estadoActual == 4) {   // Código para el estado de perder.
      fill(0);
      rect(0, 0, width, height);

      push();
      fill(255);
      textSize(24);
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
  }

  void luzDesaparece(float PosicionBlobDesaparecidoX, float PosicionBlobDesaparecidoY) {

    if (puntero == null) {
      puntero = new FBox(20, 20);
      puntero.attachImage(tela);

      //puntero.setFill(255, 100, 100);  // ---> Formas de personalizar FCircle, FBox o cualquier objeto de Fisica.
      //puntero.setNoStroke();           //      Lo comenté para tenerlo a mano, por las dudas
      //puntero.setStrokeWeight(5);
      //puntero.setStroke(255, 0, 50);

      mundo.add(puntero);

      punteroX = PosicionBlobDesaparecidoX ; // Ajusta la posición del puntero en relación con la cámara y el personaje
      punteroY = PosicionBlobDesaparecidoY;

      puntero.setPosition(punteroX, punteroY);
      puntero.setStatic(true);
      puntero.setGrabbable(false);
    }

    telarana = new Telarana (personaje, puntero);
    telarana.inicializar(andamio.getX(), andamio.getY(), andamio2.getX(), andamio2.getY());
    telarana.hayTelarana(punteroX, punteroY);
  }

  void reiniciar() {
    contador = 0;
    //mundo = new FWorld();
    //mundo.setEdges(0, 0, 1000, 1000);
    //mundo.setGravity(0, 800);

    //------------PLATAFORMAS----------
    plataforma = new Plataforma (600, 40);
    plataforma.inicializar(0, height-20);
    mundo.add(plataforma);

    plataforma3 = new Plataforma (600, 80);
    plataforma3.inicializar(800, height-40);
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

  void borrar() {
    mundo.remove(plataforma);
    mundo.remove(plataforma3);
    mundo.remove(personaje);
    mundo.remove(andamio);
    mundo.remove(andamio2);
  }
}
