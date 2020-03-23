import gifAnimation.*;
import java.lang.*;
import processing.video.*;
import cvimage.*;
import org.opencv.core.*;
import org.opencv.objdetect.CascadeClassifier;
import org.opencv.objdetect.Objdetect;
import org.opencv.imgproc.Imgproc;

Capture cam;
CVImage img;

GifMaker ficherogif;
int frameCounter;

float blink = 0.0;
boolean increase = true;

CascadeClassifier face, leye, reye;
String faceFile, leyeFile, reyeFile;

PFont font;
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
  
  font = loadFont("GillSansMT-Bold-48.vlw");
  
  ficherogif = new GifMaker(this, "animation.gif");
  ficherogif.setRepeat(0);
  ficherogif.addFrame();
  frameCounter = 0;
}

void draw() {  
  if (cam.available()) {
    
    frameCounter++;
    if(frameCounter == 10){
      ficherogif.addFrame();
      frameCounter = 0;
    }
    
    if (mode != 2) background(0);
    cam.read();

    img.copy(cam, 0, 0, cam.width, cam.height, 0, 0, img.width, img.height);
    img.copyTo();

    Mat gris = img.getGrey();

    if (mode != 2) image(img, 0, 0);

    ArrayList[] facesDetails = detectFacesAndEyes(gris, 5, 11);
    ArrayList<float[]> faces = facesDetails[0];
    ArrayList<float[]> eyes = facesDetails[1];
    
    if (mode == 0 || mode == 3){
      for(float[] face : faces){
        CVImage faceImg = new CVImage((int)face[0], (int)face[1]);
        faceImg.copy(img, (int)face[0], (int)face[1], (int)face[2], (int)face[3], 0, 0, faceImg.width, faceImg.height);
        faceImg.copyTo();
        if (mode == 0) reverseFace(faceImg, face);
        else if (mode == 3) faceSobelAndCanny(faceImg, face);
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
    if (mode >= 4) mode = 0;
    if (mode == 2) background(0);
  }
}

void drawMenu(){
  fill(255,0,0);
  String menuMode = "";
  switch (mode){
    case 0:
      menuMode = "cabeza invertida";
      break;
    case 1:
      menuMode = "caminante blanco";
      break;
    case 2:
      menuMode = "artista";
      break;
    case 3:
      menuMode = "detective";
      break;
    default:
      break;
  }
  textFont(font, 15);
  text("Modo:", 0.1*width, 0.1*height);
  text("Pulse \"ENTER\" para cambiar de modo", 0.1*width, 0.15*height);
  fill(255, 255, 0, blink());
  text(menuMode, 0.175*width, 0.1*height);
  
}

float blink(){
  if (increase) blink += 5;
  else blink -= 5 ;
  if (blink >= 300) increase = false;
  if (blink <= 0) increase = true;
  return blink;
}
