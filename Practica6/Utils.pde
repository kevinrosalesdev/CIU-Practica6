ArrayList[] detectFacesAndEyes(Mat grey, float pupilRadius, float irisRadius){
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
    for (Rect rl : leyesArr) {
      //rect(rl.x+r.x, rl.y+r.y, rl.height, rl.width);
      eyesToDraw.add(new float[]{rl.x+r.x+(rl.height/2),  rl.y+r.y+(rl.width/2), (pupilRadius + irisRadius)*((r.height*r.width)/(rl.height*rl.width*17.5)), (pupilRadius)*((r.height*r.width)/(rl.height*rl.width*17.5))});
    }
    
    leyes.release();
    auxroi.release(); 

    reyes = new MatOfRect();
    roi = new Rect(r.x+(int)(r.width*0.3), r.y, (int)(r.width*0.7), (int)(r.height*0.6));
    auxroi= new Mat(grey, roi);

    reye.detectMultiScale(auxroi, reyes, 1.15, 3, Objdetect.CASCADE_SCALE_IMAGE, new Size(30, 30), new Size(200, 200));
    Rect [] reyesArr = reyes.toArray();

    //stroke(0, 0, 255);
    for (Rect rl : reyesArr){
      //rect(rl.x+r.x+(int)(r.width*0.3), rl.y+r.y, rl.height, rl.width);
      eyesToDraw.add(new float[]{rl.x+r.x+(int)(r.width*0.3)+(rl.height/2),  rl.y+r.y+(rl.width/2), (pupilRadius + irisRadius)*((r.height*r.width)/(rl.height*rl.width*17.5)), (pupilRadius)*((r.height*r.width)/(rl.height*rl.width*17.5))});
    }
    
    reyes.release();
    auxroi.release();
    
    //stroke(255, 255, 0);
    //strokeWeight(1);
    
    //rect(r.x+(int)(r.width*0.175), r.y+(int)(r.height*0.25), r.width*0.7, r.height*0.65);
    facesToReverse.add(new float[]{r.x+(int)(r.width*0.175), r.y+(int)(r.height*0.25), r.width*0.7, r.height*0.65});
  }

  faces.release();
  
  return new ArrayList[]{facesToReverse, eyesToDraw};
}

void reverseFace(CVImage faceImg, float[] face){
  pushMatrix();
  scale(-1,-1);
  image(faceImg, -face[0]-face[2], -face[1]*0.65-face[3], face[2]*1.1, face[3]*0.75);
  popMatrix();
}

void drawEyes(float[] eye){
  noStroke();
  
  fill(0, 162, 255);
  circle(eye[0], eye[1], eye[2]);
  
  fill(0, 0, 0);
  circle(eye[0], eye[1], eye[3]);
  noFill();
}
