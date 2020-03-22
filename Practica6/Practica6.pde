import java.lang.*;
import processing.video.*;
import cvimage.*;
import org.opencv.core.*;
import org.opencv.objdetect.CascadeClassifier;
import org.opencv.objdetect.Objdetect;

Capture cam;
CVImage img;

CascadeClassifier face, leye, reye;
String faceFile, leyeFile, reyeFile;

int mode = 0;

void setup() {
  size(640, 480);

  cam = new Capture(this, width, height);
  cam.start(); 

  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  //println(Core.VERSION);
  img = new CVImage(cam.width, cam.height);

  faceFile = "haarcascade_frontalface_default.xml";
  leyeFile = "haarcascade_mcs_lefteye.xml";
  reyeFile = "haarcascade_mcs_righteye.xml";
  face = new CascadeClassifier(dataPath(faceFile));
  leye = new CascadeClassifier(dataPath(leyeFile));
  reye = new CascadeClassifier(dataPath(reyeFile));
}

void draw() {  
  if (cam.available()) {
    background(0);
    cam.read();

    img.copy(cam, 0, 0, cam.width, cam.height, 0, 0, img.width, img.height);
    img.copyTo();

    Mat gris = img.getGrey();

    if (mode != 2) image(img, 0, 0);

    ArrayList[] facesDetails = detectFacesAndEyes(gris, 5, 11);
    ArrayList<float[]> faces = facesDetails[0];
    ArrayList<float[]> eyes = facesDetails[1];
    
    if (mode == 0){
      for(float[] face : faces){
        CVImage faceImg = new CVImage((int)face[0], (int)face[1]);
        faceImg.copy(img, (int)face[0], (int)face[1], (int)face[2], (int)face[3], 0, 0, faceImg.width, faceImg.height);
        faceImg.copyTo();
        reverseFace(faceImg, face);
      }
    }else{
      for(float[] eye : eyes){
        drawEyes(eye);
      }
    }
    
    gris.release();
    
    drawMenu();
  }
}

void keyPressed(){
  if (key == ENTER || key == RETURN){
    mode++;
    if (mode >= 3) mode = 0;
  }
}

void drawMenu(){
  fill(255,0,0);
  text("Modo: " + mode, 0.1*width, 0.1*height);
  text("Pulse \"ENTER\" para cambiar de modo", 0.1*width, 0.15*height);
}
