ArrayList[] detectFacesAndEyes(Mat grey, float pupilRadius, float irisRadius) {
  Mat auxroi;

  MatOfRect faces = new MatOfRect();
  face.detectMultiScale(grey, faces, 1.15, 3, Objdetect.CASCADE_SCALE_IMAGE, new Size(60, 60), new Size(200, 200));
  Rect [] facesArr = faces.toArray();
  ArrayList<float[]> facesToReverse = new ArrayList();
  ArrayList<float[]> eyesToDraw = new ArrayList();

  noFill();
  //stroke(255, 0, 0);
  //strokeWeight(4);

  MatOfRect leyes, reyes;
  for (Rect r : facesArr) {

    //rect(r.x, r.y, r.width, r.height); 

    leyes = new MatOfRect();
    Rect roi = new Rect(r.x, r.y, (int)(r.width*0.7), (int)(r.height*0.6));
    auxroi= new Mat(grey, roi);

    leye.detectMultiScale(auxroi, leyes, 1.15, 3, Objdetect.CASCADE_SCALE_IMAGE, new Size(30, 30), new Size(200, 200));
    Rect [] leyesArr = leyes.toArray();

    //stroke(0, 255, 0);
    if (mode != 2){
      for (Rect rl : leyesArr) {
        //rect(rl.x+r.x, rl.y+r.y, rl.height, rl.width);
        eyesToDraw.add(new float[]{rl.x+r.x+(rl.height/2), rl.y+r.y+(rl.width/2), (pupilRadius + irisRadius)*((r.height*r.width)/(rl.height*rl.width*17.5)), (pupilRadius)*((r.height*r.width)/(rl.height*rl.width*17.5))});
      }
    }

    leyes.release();
    auxroi.release(); 

    reyes = new MatOfRect();
    roi = new Rect(r.x+(int)(r.width*0.3), r.y, (int)(r.width*0.7), (int)(r.height*0.6));
    auxroi= new Mat(grey, roi);

    reye.detectMultiScale(auxroi, reyes, 1.15, 3, Objdetect.CASCADE_SCALE_IMAGE, new Size(30, 30), new Size(200, 200));
    Rect [] reyesArr = reyes.toArray();

    //stroke(0, 0, 255);
    if (mode != 2){
      for (Rect rl : reyesArr) {
        //rect(rl.x+r.x+(int)(r.width*0.3), rl.y+r.y, rl.height, rl.width);
        eyesToDraw.add(new float[]{rl.x+r.x+(int)(r.width*0.3)+(rl.height/2), rl.y+r.y+(rl.width/2), (pupilRadius + irisRadius)*((r.height*r.width)/(rl.height*rl.width*17.5)), (pupilRadius)*((r.height*r.width)/(rl.height*rl.width*17.5))});
      }
    }
    
    if (mode == 2){
      for (Rect rl : leyesArr){
        eyesToDraw.add(new float[]{rl.x+r.x+(rl.height/2)+(int)(r.width*0.15), rl.y+r.y+(rl.width/2), (pupilRadius + irisRadius)*((r.height*r.width)/(rl.height*rl.width*17.5)), (pupilRadius)*((r.height*r.width)/(rl.height*rl.width*17.5))});
      }
    }

    reyes.release();
    auxroi.release();

    //stroke(255, 255, 0);
    //strokeWeight(1);

    //rect(r.x+(int)(r.width*0.175), r.y+(int)(r.height*0.25), r.width*0.7, r.height*0.65);
    facesToReverse.add(new float[]{r.x+(int)(r.width*0.175), r.y+(int)(r.height*0.25), r.width*0.7, r.height*0.65});
    
    //stroke(255, 0, 0);
  }

  faces.release();

  return new ArrayList[]{facesToReverse, eyesToDraw};
}

void reverseFace(CVImage faceImg, float[] face) {
  pushMatrix();
  scale(-1, -1);
  image(faceImg, -face[0]*.965, -face[1]+face[3]/4, -face[2]*1.1, -face[3]*0.9);
  popMatrix();
}

void faceSobelAndCanny(CVImage faceImg, float[] face) {
  pushMatrix();

  CVImage img = new CVImage(faceImg.width, faceImg.height);
  CVImage auxImg = new CVImage(faceImg.width, faceImg.height);

  img.copy(faceImg, 0, 0, faceImg.width, faceImg.height/2, 0, 0, img.width, img.height);
  img.copyTo();

  Mat gris = img.getGrey();

  Imgproc.Canny(gris, gris, 20, 60, 3);

  cpMat2CVImage(gris, auxImg);

  image(auxImg, face[0], face[1]+face[3]/2, face[2]*1.1, face[3]*0.75);
  
  gris = img.getGrey();

  int depth = CvType.CV_16S;
  Mat grad_x = new Mat();
  Mat grad_y = new Mat();
  Mat abs_grad_x = new Mat();
  Mat abs_grad_y = new Mat();

  Imgproc.Sobel(gris, grad_x, depth, 1, 0);
  Core.convertScaleAbs(grad_x, abs_grad_x);

  Imgproc.Sobel(gris, grad_y, depth, 0, 1);
  Core.convertScaleAbs(grad_y, abs_grad_y);

  Core.addWeighted(abs_grad_x, 0.5, abs_grad_y, 0.5, 0, gris);

  cpMat2CVImage(gris, auxImg);

  image(auxImg, face[0], face[1]-face[3]/2, face[2]*1.1, face[3]*0.5);
  
  gris.release();
  popMatrix();
}

void  cpMat2CVImage(Mat in_mat, CVImage out_img)
{    
  byte[] data8 = new byte[in_mat.width()*in_mat.height()];

  out_img.loadPixels();
  in_mat.get(0, 0, data8);

  for (int x = 0; x < in_mat.width(); x++) {
    for (int y = 0; y < in_mat.height(); y++) {

      int loc = x + y * in_mat.width();
      int val = data8[loc] & 0xFF;
      out_img.pixels[loc] = color(val);
    }
  }
  out_img.updatePixels();
}

void drawEyes(float[] eye) {
  noStroke();
  fill(0, 162, 255);
  if (mode == 2) circle(cam.width-eye[0], eye[1], eye[2]);
  else circle(eye[0], eye[1], eye[2]);

  fill(0, 0, 0);
  if (mode == 2) circle(cam.width-eye[0], eye[1], eye[3]);
  else circle(eye[0], eye[1], eye[3]);
  noFill();
}
