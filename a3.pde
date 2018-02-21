Table table;
float[][] data;
int m,n;
float [] minnum;
float [] maxnum;
String [] name;
String [] axisname;
boolean[] flip;
boolean[] paint;
float[][] pointx;
float[][] pointy;
float[][] slope;
float[][] intercept;
float[][] y;
int id;
int ix, iy, ex, ey;

float ypercent;
float xpercent;
float percent;
int margin = 50;
int axisw = 10;
int btnw = 50;
int dotx = 10;
int doty = 4;
int xpos[];
int xgap;
float [] a;
float [] b;

color [] colors;
color [][] newcolor;
int axisnum;
boolean paintbyaxis;
int highlight;

int stx, sty;
int enx, eny;
boolean bounding;

PGraphics online = null;
PGraphics inbox = null;

void setup(){
  size(800, 640);
  surface.setResizable(true);
  table = loadTable("iriss.csv");
  println(table.getRowCount() + " total rows in table"); 
  println(table.getColumnCount() + " total columns in table");
  m = table.getColumnCount() - 1;
  n = table.getRowCount() - 1;
  data = new float[m][n];
  pointx = new float[m][n];
  pointy = new float[m][n];
  slope = new float[m-1][n];
  intercept = new float[m-1][n];
  y = new float[m][n];

  for (int i = 0; i<m; i++) {
    for (int j= 0; j<n; j++) {
      data[i][j] = table.getFloat(j+1,i+1);
    }
  }
  
  colors = new color[n];
  name = new String [n];
  for (int j = 0; j<n; j++) {
    name[j] = ""+table.getInt(j,0);
    colors[j] = color(255-j*(255/(float)n),0,(0+j*(255/(float)n)));
  }
  xpos = new int[m];
  xgap = (800 - 2*margin - m*axisw)/(m-1);  

  minnum = new float[m];
  maxnum = new float[m];
  a = new float[m];
  b = new float[m];
  axisname = new String[m];
  flip = new boolean[m];
  paint = new boolean[m];
  for (int i = 0; i < m; i++) {
    xpos[i] = i*axisw + i*xgap;
    minnum[i] = min(data[i]);
    maxnum[i] = max(data[i]);
    axisname[i] = table.getString(0,i+1);
    flip[i] = false;
    paint[i] = false;
  }
  //printArray(minnum);
  //printArray(flip);
  newcolor = new color[m][n];
  
  online = createGraphics(width, height);
  inbox = createGraphics(width, height);
}

void draw() {
  clear();
  //cursor(ARROW);
  background(255);
  bounding = false;
  //stx = 0;
  //sty = 0;
  xpercent = width/(float)800;
  ypercent = height/(float)640;
  percent = min(xpercent, ypercent);
  textSize(percent*12);
  textAlign(CENTER, CENTER);
  strokeWeight(1);
  for(int i = 0; i<m; i++) {
    strokeWeight(1);
    stroke(200);
    fill(200);
    //axisbtn
    if (paint[i] == true) fill(255);
    rect(xpercent*(margin+xpos[i]-(btnw-axisw)/2), ypercent*(0.5*margin), xpercent*btnw, ypercent*margin*0.5);    
    //axis
    fill(200);
    rect(xpercent*(margin+xpos[i]), ypercent*1.4*margin, xpercent*axisw, ypercent*(640-2*1.6*margin));
    //rectMode(CENTER);
    //flipbtn
    if (flip[i] == true) fill(255);
    rect(xpercent*(margin+xpos[i]-(btnw-axisw)/2), ypercent*(640-1.4*margin), xpercent*btnw, ypercent*margin*0.5);
    fill(0);
    //axisname
    text(axisname[i], xpercent*(margin+xpos[i]+(axisw)/2), ypercent*0.7*margin);
    text("flip", xpercent*(margin+xpos[i]+(axisw)/2), ypercent*(640-1.2*margin));
    if (flip[i] == false) {
      a[i] = minnum[i];
      b[i] = maxnum[i];
    }
    else {
      b[i] = minnum[i];
      a[i] = maxnum[i];
    }
    text(a[i], xpercent*(margin+xpos[i]+axisw/2), ypercent*1.2*margin);
    text(b[i], xpercent*(margin+xpos[i]+axisw/2), ypercent*(640-1.6*margin));    
  } 
  for (int i = 0; i<m; i++) {
    for (int j = 0; j<n; j++) {    
      strokeWeight(1);
      float value = data[i][j];
      y[i][j] = abs(value-a[i])/(maxnum[i]-minnum[i]);
      pointx[i][j] = xpercent*(margin+xpos[i]+dotx/2);
      pointy[i][j] =  ypercent*(y[i][j]*(640-2*1.6*margin)+1.4*margin);
      if(i>0) {
        slope[i-1][j] = (pointy[i][j]-pointy[i-1][j])/xgap;
        intercept[i-1][j] = pointy[i][j]-slope[i-1][j]*pointx[i][j];
      }
      fill(0);
      stroke(200);
      ellipse(pointx[i][j], pointy[i][j], xpercent*dotx, ypercent*doty);
      if (paintbyaxis == true) {
        if (paint[i] == true) {
          axisnum = i;
          //always use green to present small value
          if (flip[axisnum] == true)
            newcolor[i][j] = color(0,255*y[axisnum][j],255-255*y[axisnum][j]);
          else
            newcolor[i][j] = color(0,255-255*y[axisnum][j],255*y[axisnum][j]);
        } 
      }
      //defaule colors are depend on its id
      else newcolor[i][j] = colors[j];
      stroke(newcolor[axisnum][j]);
      if (i>0) {
        //strokeWeight(1);
        //if(highlight == j) strokeWeight(5);
        line(pointx[i-1][j], pointy[i-1][j], pointx[i][j], pointy[i][j]);
      }
      //mouse on axis
      if ((mouseX>pointx[i][j]-xpercent*dotx && mouseX<pointx[i][j]+xpercent*dotx && mouseY>pointy[i][j]-ypercent*doty && mouseY<pointy[i][j]+ypercent*doty)) {
        fill(255);
        stroke(255);
        fill(0);
        textAlign(LEFT, TOP);
        strokeWeight(5);
        stroke(newcolor[axisnum][j]);
        for (int k = 1; k<m; k++) {
          line(pointx[k-1][j], pointy[k-1][j], pointx[k][j], pointy[k][j]);
        }
        for (int l = 0; l<m; l++) {
          fill(255); strokeWeight(1);
          rect(pointx[l][j]+margin/5, pointy[l][j], 1.2*margin, margin/3);
          fill(0);
          text(data[l][j], pointx[l][j]+margin/4, pointy[l][j]);
        }
      }
      // mouse On Line
      if (mouseOnLine(mouseX,mouseY,j)) {
        //println(mouseX +" "+ mouseY +" " + mouseOnLine(mouseX, mouseY,j));
        //println(j);
        for (int k = 0; k<m; k++) {
          if (k>0) {
            strokeWeight(5);
            stroke(255,255,0);
            line(pointx[k-1][j], pointy[k-1][j], pointx[k][j], pointy[k][j]);
          }
          fill(255); strokeWeight(1);
          rect(pointx[k][j]+margin/5, pointy[k][j], 1.2*margin, margin/3);
          fill(0); textAlign(LEFT, TOP);
          text(data[k][j], pointx[k][j]+margin/4, pointy[k][j]);
        }
      }
      // box
      if (dotInbox(i,j)) {
        for (int k = 0; k<m; k++) {
          if (k>0) {
            strokeWeight(5);
            stroke(0,255,255);
            line(pointx[k-1][j], pointy[k-1][j], pointx[k][j], pointy[k][j]);
          }
          fill(255); strokeWeight(1);
          rect(pointx[k][j]+margin/5, pointy[k][j], 1.2*margin, margin/3);
          fill(0); textAlign(LEFT, TOP);
          text(data[k][j], pointx[k][j]+margin/4, pointy[k][j]);
        }
      }
    } 
  }
  //if (bounding == true) {
  stroke(0);
  fill(255, 100);
  if (mousePressed) {
    stx = mouseX;
    sty = mouseY;
    if (mouseY>ypercent*1.4*margin && mouseY<ypercent*(1.4*margin+(640-2*1.6*margin))) {
    
      cursor(CROSS);
      
      //enx = 0;
      //eny = 0;
      if (stx>0 && enx>0 && sty>ypercent*1.4*margin && sty<ypercent*(1.4*margin+(640-2*1.6*margin))) { 
        fill(255, 128);
        rect(0,0,width,height);
        rect(stx, sty, enx-stx, eny-sty);
        println(stx + " " + sty + " " + enx + " " + eny);
        ix = stx; iy = sty; ex = enx; ey = eny;
        drawInbox(ix,iy,ex,ey);
      }
      //println(stx);
      //println(enx);
    }
  }
  if (keyPressed) {
    //drawOnline();
    //image(online, 0, 0);
    //drawInbox(stx,sty,enx,eny);
    image(inbox, 0, 0);
  }
  //printArray(colors);
}

void mouseClicked() {
  for(int i = 0; i<m; i++) {
    if ((mouseX>xpercent*(margin+xpos[i]-(btnw-axisw)/2))&(mouseX<xpercent*(margin+xpos[i]-(btnw-axisw)/2+btnw))&(mouseY>ypercent*(640-1.4*margin))&(mouseY<ypercent*(640-1.4*margin+margin*0.5))) {
      flip[i] = !flip[i];
    }
    if ((mouseX>xpercent*(margin+xpos[i]-(btnw-axisw)/2))&(mouseX<xpercent*(margin+xpos[i]-(btnw-axisw)/2+btnw))&(mouseY>ypercent*(0.5*margin))&(mouseY<ypercent*(0.5*margin+margin*0.5))) {
      paint[i] = !paint[i];
      if(paint[i] == true) paintbyaxis = true;
      else paintbyaxis = false;
      for (int k = 0; k<m; k++) {
        if (k != i) {
          paint[k] = false;
        }
      }
    }
  }    
}

void mouseReleased() {
  bounding = true;
  enx = mouseX;
  eny = mouseY;
  cursor(ARROW);
  //println(stx + " " + sty + " " + enx + " " + eny); 
}

void drawOnline(){
  online.beginDraw();
  online.background(255);
  for (int i = 1; i<m; i++) {
    for (int j = 0; j<n; j++) {
      online.strokeWeight(5);
      online.stroke(colors[j]);
      online.line(pointx[i-1][j], pointy[i-1][j], pointx[i][j], pointy[i][j]);
    }
  }
  online.endDraw();
}

boolean mouseOnLine(int a, int b, int id) {
  boolean on = false;
  drawOnline();
  //println(a + " " + b + " " +select.get(a,b) + " " + colors[id]);
  if (online.get(a,b) == colors[id]) {
    on = true;
  }
  return on; 
}

void drawInbox(int ix, int iy, int ex, int ey){
  inbox.beginDraw();
  inbox.background(255);
  inbox.rectMode(CORNERS);
  inbox.fill(0);
  inbox.rect(ix,iy,ex,ey);
  inbox.endDraw();
}

boolean dotInbox(int axis, int id) {
  boolean in = false;
  drawInbox(ix, iy, ex, ey);
  if (inbox.get((int)pointx[axis][id], (int)pointy[axis][id]) == color(0)) {
    in = true;
  }
  return in;
}