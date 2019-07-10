point points[]; 
link links[];
int distance_const=1;
int pointsCounter;
int linksCounter;
int holded;
int highlighted;
boolean shift_pressed;

PImage pointImg,bg;

void setup(){
  
  pointImg = loadImage("point.png");
  bg = loadImage("bg.jpg");
  
  imageMode(CENTER);
  points = new point[100];
  links  = new link[100];
  pointsCounter=0;
  linksCounter=0;
  holded=-1;
  highlighted=-1;
  size(1000,1000); 
  textAlign(CENTER, CENTER);
  textSize(14);
  shift_pressed=false;
}

void draw(){
  image(bg, width/2, height/2, width, height);
  
  for(int i=0;i<linksCounter;++i){
    links[i].Draw();
  }
  
  for(int i=0;i<pointsCounter;++i){
    points[i].Draw(i);
  }
}

class point{
  int Y,X;
  point(int Xs,int Ys){
    X=Xs;
    Y=Ys;
  }
  
  void Draw(int i){
    if(i==holded){
      points[i].X=mouseX;
      points[i].Y=mouseY;
    }

    noStroke();
    fill(255);
    if(i==highlighted) fill(0,255,0);
    ellipse(points[i].X,points[i].Y,22,22); //20=srednica

    fill(0);
    text(i,points[i].X,points[i].Y);
    image(pointImg, points[i].X ,points[i].Y );
    stroke(2);
  }
}


class link{
  point p1,p2;
  link(point p1S,point p2S){
    p1=p1S;
    p2=p2S;
  }
  void Draw(){
    line(p1.X,p1.Y,p2.X,p2.Y); 
    fill(255,0,0);
    textSize(20);
    text(distance_between(p1,p2)/distance_const,(p1.X+p2.X)/2,(p2.Y+p1.Y)/2+10);
    textSize(14);
  }
}


void CreatingDroping(){
  if (find_near_mouse(20)==-1){
    if(holded!=-1){
      points[holded].X=mouseX;
      points[holded].Y=mouseY;
      holded=-1;
    }
  
    else{
      points[pointsCounter]=new point(mouseX,mouseY);
      pointsCounter++;
    }
  }
}

void Deleting(){
  if(holded!=-1) {
    deleteP(holded);
    holded=-1;
  }
  else if ( find_near_mouse(10)!=-1) deleteP(find_near_mouse(10));
}


void Connect(){
  if(find_near_mouse(10)==-1)return;
  
  if(highlighted==-1){
    highlighted=find_near_mouse(10);
  }
  else{ 
    if (highlighted!=find_near_mouse(10)){
      int temp=-1;
      for(int i=0;i<linksCounter;++i){
        if(points[find_near_mouse(10)]==links[i].p1 && points[highlighted]==links[i].p2 || points[find_near_mouse(10)]==links[i].p2 && points[highlighted]==links[i].p1){
          temp=i;
          break;
        }
      }
      if(temp!=-1){
        deleteL(temp);
      }
      else{
        if(find_near_mouse(10) < highlighted) //mniejszy pierwszy.
          links[linksCounter] = new link(points[find_near_mouse(10)],points[highlighted]);
        else links[linksCounter] = new link(points[highlighted],points[find_near_mouse(10)]);
        linksCounter++;
      }
    }
    highlighted=-1;
  }
}


int find_near_mouse(int radius){
  int temp=-1;
  int i;
  for(i=0;i<  pointsCounter;i++){
    if(i==holded) continue;
      if( (points[i].X-mouseX)*(points[i].X-mouseX) + (points[i].Y - mouseY)*(points[i].Y - mouseY) <= radius*radius){ //(promień)^2 = 200
       temp=i;
       break;
      }
    }
  return temp;
}

boolean Pick_up(){
  if(holded!=-1) return false;
  holded=find_near_mouse(10);
  if(holded==-1) return false;
  return true;
}



void deleteP(int n){
  
  for(int i=0;i<linksCounter;++i){
    if(links[i].p1==points[n]||links[i].p2==points[n]){
      deleteL(i--);
    }
  }
  
  for(int i=n;i<pointsCounter;++i){
    points[i]=points[i+1];
    if(highlighted==i) highlighted--;
  }
  pointsCounter--;
}

void deleteL(int n){
  for(int i=n;i<linksCounter;++i)
    links[i]=links[i+1];
  linksCounter--;
}

void mousePressed(){
  
  if(mouseButton ==LEFT && shift_pressed){
    Deleting();
  }
  else if(mouseButton ==LEFT){
    if(!Pick_up()) CreatingDroping();
  }
  else if (mouseButton ==RIGHT){
     Connect();
  
  
  }
}

void keyPressed(){
  if(keyCode==16){
    shift_pressed=true;
  }   
  if(keyCode==ENTER){
    export(); 
  }
}

void keyReleased(){
   if(keyCode==16){
    shift_pressed=false;
  }   
}

int distance_between(point p1,point p2){
  
  return (int)sqrt((p1.X-p2.X)*(p1.X-p2.X) + (p1.Y-p2.Y)*(p1.Y-p2.Y));
}
