class Blob {

  boolean actualizado;
  boolean entro;
  boolean salio;

  int vida;
  int ultimaActualizacion;
  int limite_tiempo_salir;
  int estadoBlob;
  int estadoAnterior;
  String nombre;
  PImage mira;
  float a = 0.9;
  
  float x;
  float y;

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

  Blob(int estadoBlob) {

    entro =  true;    
    actualizado = false;
    salio = false;

    vida = 0;
    ultimaActualizacion = 0;

    limite_tiempo_salir = -1;   

    this.estadoBlob = estadoBlob;
    this.estadoAnterior = estadoBlob;

    blobDesaparecido = false;
    ultimaPosicionBlob = new PVector(0, 0); 

    mira = loadImage("data/mira2.png");

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

  void dibujarMira() {
    if (entro == true) {
      image (mira, centroidX*width-25, centroidY*height-25, 50, 50);
      //x= lerp(centerX,centroidX*width-25, a);
      //y= lerp(centerY, centroidY*height-25,  a);
      //image (mira, x, y, 50, 50);
      
      vida++;
    } else if (entro == false) {
      vida = 0;
    }

    // Verificar si el estado cambió
    if (this.estadoBlob != this.estadoAnterior) {
      vida = 0; // Si cambió el estado, reinicia el contador de vida
    }
    estadoAnterior = estadoBlob; // Actualiza el estado anterior con el estado actual
  }

  // -------------------------

  void actualizar() {
    if (vida > 0) {
      entro = true;
    } else {
      entro = false;
    }
    vida++;
    vida = vida % 100;

    salio = ultimaActualizacion == limite_tiempo_salir ? true : false;

    ultimaPosicionBlob.x = centroidX*width-25;
    ultimaPosicionBlob.y = centroidY*height-25;
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
    dibujarMira();
  }
}
