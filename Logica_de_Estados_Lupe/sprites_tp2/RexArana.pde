class Rex{
  
 int indexImagenes = 0;
int indexTirar = 0;
int posX = 50;

float rexaranaX = 0;  // La posición x del personaje

PImage [] images = new PImage[7];
PImage [] tirar = new PImage[3];
boolean detenerAnimacion = false; // Variable para controlar la animación
  
  
  Rex(){
     for (int i = 0; i < images.length; i++) {
    images[i] = loadImage(i+".png");
  }
  for (int i = 0; i < tirar.length; i++) {
    tirar[i] = loadImage("tira"+i+".png");
  }
    
  }
  
  void Dibujar(){
    // Calcula la diferencia entre la posición del personaje y la posición de la cámara
  float xOffset = posX - rexaranaX;
  
  // Ajusta las coordenadas de dibujo según la posición de la cámara
  translate(xOffset, 0);
  
  if (!detenerAnimacion) {
    image(images[indexImagenes], posX, height-289, 178, 289);
    if (frameCount % 4 == 0) {
      indexImagenes = (indexImagenes + 1) % images.length;
      rexaranaX ++;
      fondoX --;
    }
  }
    telarana();
  // Actualiza la posición de la cámara para seguir al personaje
  rexaranaX = posX;
  
  }
  
  void telarana() {
  if (keyPressed) {
    if (key =='a'|| key == 'A') {
      image(tirar[indexTirar],posX,height-289,178,289);
      if (frameCount %4 ==0) {
      indexTirar = (indexTirar+1)%tirar.length;
      rexaranaX ++;
      fondoX --;
      }
      detenerAnimacion = true; // Detener la animación al tocar la tecla 'a' o 'A'
    }
  } else {
    detenerAnimacion = false; // Si la tecla no está presionada, reanudar la animación.
  }
  
}

}
