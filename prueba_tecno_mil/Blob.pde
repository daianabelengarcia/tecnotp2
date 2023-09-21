class Blob {

  boolean actualizado;
  boolean entro;
  boolean salio;

  int vida;
  int ultimaActualizacion;
  int limite_tiempo_salir;
  int estado;
  int estadoAnterior;
  String nombre;
  PImage mira;

  boolean blobDesaparecido;
  PVector ultimaPosicionBlob;


  // datos del blob
  int id; 
  float age;
  float centroidX;
  float centroidY;
  float averageX;
  float averageY;
  float centerX;
  float centerY;
  float velocityX;
  float velocityY;
  float area;
  float perimeter;
  float boundingRectX;
  float boundingRectY;
  float boundingRectW;
  float boundingRectH;
  float vertexNumber;

  ArrayList <Float> contorno;

  Blob(int estado) {

    entro =  false;    // No me terminan de cerrar los boolean "entro" y "salio". No funcionan bien.
    actualizado = false;
    salio = false;

    vida = 0;
    ultimaActualizacion = 0;

    limite_tiempo_salir = -1;   // Esto no entiendo que hace. Solo sé que tiene que estar en negativo.

    this.estado = estado;
    this.estadoAnterior = estado;

    blobDesaparecido = false;
    ultimaPosicionBlob = new PVector(0, 0); 

    mira = loadImage("mira2.png");

    id = -1;
    age = 0 ;
    centroidX = 0;
    centroidY = 0;
    averageX = 0;
    averageY = 0;
    centerX = 0;
    centerY = 0;
    velocityX = 0;
    velocityY = 0;
    area = 0;
    perimeter = 0;
    boundingRectX = 0;
    boundingRectY = 0;
    boundingRectW = 0;
    boundingRectH = 0;
    vertexNumber = 0;

    contorno = new ArrayList<Float>();
  }
  // -------------------------
  void asignacion() {
    if (this.estado == 1) {
      this.nombre = "entrar";
    } else if (this.estado == 2) {
      this.nombre = "salir";
    }
  }
  void cambiar() {
    if (this.nombre.equals("entrar")) {
      //fill (0);
      //ellipse (centroidX*width, centroidY*height, 50, 50);
      image (mira, centroidX*width-25, centroidY*height-25, 50, 50);

      salio = false;
      entro = true;
      vida++;
      this.estado = 1;
    } else if (this.nombre.equals("salir")) {
      fill (255, 0, 0);
      rect (centroidX*width, centroidY*height, 40, 40);

      vida = 0;
      salio = true;
      entro = false;
      this.estado = 2;
    }

    // Verificar si el estado cambió
    if (this.estado != this.estadoAnterior) {
      vida = 0; // Si cambió el estado, reinicia el contador de vida
    }
    estadoAnterior = estado; // Actualiza el estado anterior con el estado actual
  }

  // -------------------------

  void actualizar() {
    if (vida > 0) {
      entro = true;
    }
    vida++;
    vida = vida % 100;

    salio = ultimaActualizacion == limite_tiempo_salir ? true : false;

    ultimaPosicionBlob.x = centroidX * width;
    ultimaPosicionBlob.y = centroidY * height;
  }
  // -------------------------

  void actualizarDatos(OscMessage m) {

    contorno.clear();

    age = m.get(1).floatValue();
    centroidX = m.get(2).floatValue();
    centroidY = m.get(3).floatValue();
    averageX = m.get(4).floatValue();
    averageY = m.get(5).floatValue();
    centerX = m.get(6).floatValue();
    centerY = m.get(7).floatValue();
    velocityX = m.get(8).floatValue();
    velocityY = m.get(9).floatValue();
    area = m.get(10).floatValue();
    perimeter = m.get(11).floatValue();
    boundingRectX = m.get(12).floatValue();
    boundingRectY = m.get(13).floatValue();
    boundingRectW = m.get(14).floatValue();
    boundingRectH = m.get(15).floatValue();
    vertexNumber = m.get(16).floatValue();

    for (int i = 17; i < m.arguments ().length; i++) {
      contorno.add(m.get(i).floatValue());
    }
  }

  // -------------------------

  void setID( int id) {
    this.id = id;
  }

  // -------------------------

  void dibujar() {
    asignacion();
    cambiar();
  }
}
