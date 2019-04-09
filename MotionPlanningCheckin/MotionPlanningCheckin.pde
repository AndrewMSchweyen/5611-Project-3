// Test Change
import java.util.concurrent.ThreadLocalRandom;

import java.util.ArrayList; 
import java.util.*; 
import java.util.Random; 
import java.util.LinkedList;
import java.io.*; 
import java.util.PriorityQueue;

// GLOBAL Variables
Graph pointGraph;
Point obstacleCenter, charLocation;
Point start, goal;

PShape fish = new PShape();
boolean playing = true;
int scalar = 3, numberOfSamples = 500, squareSize = 200*scalar;
int obstacleX = 100*scalar, obstacleY = 100*scalar, obstalceDiameter= 20*scalar;
int agentRadius = 5*scalar;
int charX, charY;
int currentPoint = 0;
int numberOfBoids = 40;
int XTIMES = 1;
boolean pointsToggled = true, newPoint = false, printOutGraph = false, drawEdge = true, drawFish = true;
boolean startRecording = true;
double xSlope, ySlope;
float goalX = 105;
float goalY=350;

ArrayList<Point> samples = new ArrayList<Point>(0);
ArrayList<Point> pathArray = new ArrayList<Point>(0);
ArrayList<Point> ASTARPathArray = new ArrayList<Point>(0);

ArrayList<Boid> boids = new ArrayList<Boid>(0);
ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>(0);


public void settings() 
{
  size(squareSize + 450, squareSize,P3D);
}

void setup() 
{
  nodesAdded = 0;
  ASTARNODES = 0;
  stroke(0,255,0);
  goal = new Point(goalX,goalY);
  stroke(255,0,0);
  start = new Point(180*scalar,20*scalar);
  charLocation = start;
  samplePoints();
 // obstacles.add(new Obstacle(obstacleX, obstacleY-60, obstalceDiameter));
//  obstacles.add(new Obstacle(obstacleX+5, obstacleY+130, obstalceDiameter));
  removeObstaclePoints();
  createGraph();
  connectPoints(0);
  for(int i =0; i< numberOfBoids; i++)
  {
 //   boids.add(new Boid(ThreadLocalRandom.current().nextInt(20, 50),ThreadLocalRandom.current().nextInt(10, 30)));
    boids.add(new Boid(5 +30*i, ThreadLocalRandom.current().nextInt(150, 350)));
    boids.get(i).goalNode = 1;
    samples.add(new Point(boids.get(i).position.x, boids.get(i).position.y));
    boids.get(i).path = ASTAR(samples.size()-1, 1);
  }

  
  drawPoints();

  
  //Fish Obj
  fish = loadShape("RuddFish.obj");
  fish.scale(.4);
}

void draw() 
{
  if(startRecording)
  {
    background(255, 255, 255);
    stroke(0);
    drawPoints();
    // drawCharacter();
    for(int i =0; i< numberOfBoids; i++)
    {
      boids.get(i).run(boids);
      drawBoidEdges(boids.get(i));
    }
      drawObstacles();
   //   pointGraph.printGraph();
  }
  strokeWeight(10);
  point(goal.x, goal.y);
  pointGraph.printGraph();
  //pushMatrix();
  //translate(width/2,height/2);
  //rotateZ(PI/2);
  //rotateX(PI*8/16);
  //shape(fish);
  //popMatrix();
  //  textSize(32);
  //fill(0, 0, 0);
  //text("UCS nodes explored = " + nodesAdded, 350, 200);
  //text("ASTAR nodes explored = "   + ASTARNODES, 350, 240);
}

                /* Add randomized points throughout the entire grid based on 'squareSize'
                *  Adds specific number of points based on 'numberOfSamples'
                */
void samplePoints()
{
    Random rand = new Random(); 
  samples.add(new Point(rand.nextInt(squareSize +450), rand.nextInt(squareSize)));
  samples.add(new Point(goal.x,goal.y));

  for (int i= 0; i < numberOfSamples-2; i++)
  {
    samples.add(new Point(rand.nextInt(squareSize +450), rand.nextInt(squareSize)));
  }
}

                /* Default graph created off of number of samples*/
void createGraph()
{
  pointGraph = new Graph(samples.size());
}

                /* Function used to display all sample points */
void drawPoints()
{
   stroke(0);
  if(pointsToggled)
  {
      //circle(start.x,start.y, 5);
      circle(goal.x,goal.y, 5);
      strokeWeight(3);
      for (int i= 0; i < samples.size(); i++)
    {
      point(samples.get(i).x, samples.get(i).y);
    }
    strokeWeight(10);
    stroke(0);
    for (int i= 0; i < pathArray.size(); i++)
    {
      point(pathArray.get(i).x, pathArray.get(i).y);
    }
    stroke(153);
     for (int i= 0; i < ASTARPathArray.size(); i++)
    {
      point(ASTARPathArray.get(i).x, ASTARPathArray.get(i).y);
    }
    strokeWeight(1);
  }
}

void drawObstacles()
{
    fill(255,0,0);
   for(int i =0; i < obstacles.size(); i++)
   {
     circle(obstacles.get(i).x, obstacles.get(i).y, obstacles.get(i).radius);
   }
}

void drawBoidEdges(Boid boid)
{
  for(int i =0; i < boid.path.size()-1; i++)
  {
    line(boid.path.get(i).x, boid.path.get(i).y , boid.path.get(i+1).x , boid.path.get(i+1).y);
  }
}

void drawEdge(int i, int j) {
  stroke(255,0,0);
  //if(!checkCollision(samples.get(i),samples.get(j)))
  //{
    line(samples.get(i).x,samples.get(i).y,samples.get(j).x,samples.get(j).y);
  //}
}

                /* Draws charcter used to display moving through the graph*/
PVector slope = new PVector(0,0);
void drawCharacter()
{ //<>//
  stroke(0,0,255);
  //println(newPoint);
  strokeWeight(5);
  //  println("x is " + pathArray.get(currentPoint).x + "y is " + pathArray.get(currentPoint).y);
    slope.x =  charLocation.x - pathArray.get(currentPoint).x;
    slope.y = charLocation.y - pathArray.get(currentPoint).y;  
    slope.normalize();
   // newPoint = false;

  if(currentPoint < pathArray.size()-1)
  {
    //println("checking");
    if(!checkCollision(charLocation, pathArray.get(currentPoint+1)))
    {
      //  println("incrementing currentPoint because " +charX + " " + charY + " and " +pathArray.get(currentPoint+1).x + " "+pathArray.get(currentPoint+1).y+ " don't collide");
        currentPoint+=1;
        newPoint = true;
    }
  }
  if(charLocation.distanceTo(goal) >= 1)
  {
   charLocation.x -= (slope.x*1.2);
   charLocation.y -= (slope.y*1.2);
  }
}

/* Removes all points colliding with obstacles*/
void removeObstaclePoints()
{
  
  //for (int i= 0; i < samples.size(); i++)
  //{
  //  for(int j =0; j < obstacles.size(); j ++)
  //  {
  //    if( sqrt(sq(samples.get(i).x - obstacles.get(j).x) + sq(samples.get(i).y - obstacles.get(j).y) ) < (obstalceDiameter/2 + agentRadius))
  //    {
  //      samples.remove(i);
  //      samples.trimToSize();
  //      i--;
  //    }
  //  }
  //}
}

/*Determines if p1 is within radius distance of p2's radius 
* returns true if there is a collision
*/
boolean checkCollision(Point p1, Point p2)
{ 
  double a = p1.y - p2.y;
  double b = p2.x - p1.x;
  double c = (p1.x*p2.y);
  c-= (p2.x*p1.y);
  for(int i=0; i<obstacles.size(); i++)
  {
    double x = obstacles.get(i).x;
    double y = obstacles.get(i).y;
    double radius = obstalceDiameter/2;
      // Finding the distance of line from center. 
      double dist = Math.abs((a * x + b * y + c)) /  
                       Math.sqrt(a * a + b * b); 
      double val = a * x + b * y + c;
     // println("dist is "  + dist);
      //println("x1 is " + val + "x2 is " + p2.x);
      // println("distance is " + dist);
      if (radius > dist)
      {
        return true;
      }
  }
  return false;
} 

/* Uses addEdge Graph function to connect all points recursively */
void connectPoints(int initial)
{
//  println("running");
  if(initial == samples.size()+1)
  {
    return;
  }
   for(int i = initial; i <samples.size(); i++)
   {
     //if(checkCollision(samples.get(initial), samples.get(i))) //detected obstacle collision
     //{
     //     pointGraph.addEdge(initial, i,50000);
     //     println("found collision " + initial + " and " + i); 
     //}
     //else
     //{
     pointGraph.addEdge(initial, i, samples.get(initial).distanceTo(samples.get(i)));
     //}
   }
   connectPoints(initial+1);
}

void mouseClicked() 
{
    obstacles.add(new Obstacle(mouseX, mouseY, obstalceDiameter));
}

void keyPressed() 
{
  if (keyCode == UP ) //
  {
    boids.clear();
    samples.clear();
    pointGraph.clearGraph();
    setup();
    //for(int i =0; i< numberOfBoids; i++)
    //{
    ////  boids.add(new Boid(ThreadLocal/2Random.current().nextInt(170, 220),ThreadLocalRandom.current().nextInt(10, 30)));
    //  boids.add(new Boid(100 +30*i, ThreadLocalRandom.current().nextInt(150, 200)));
    //  boids.get(i).goalNode = 1;
    //  samples.add(new Point(boids.get(i).position.x, boids.get(i).position.y));
    //  boids.get(i).path = ASTAR(samples.size()-1, 1);
    //}
    

     // pointsToggled = !pointsToggled;
  }
    if (key == 'c') //up
  {
    currentPoint+=1;
    newPoint = true;
  }
    if (key == 'e') //up
  {
    drawEdge = !drawEdge;
  }
  //    if (key == 's') //up
  //{
  //  startRecording = !startRecording;
  //}
  if (key == 'f'){
    if (drawFish){
      drawFish = false;
    } else {
      drawFish = true;
    }
  }
  
    if (key == 'w') //up
  {
    obstacles.get(0).y -= 10;
  }
  
    if (key == 'a') //up
  {
    obstacles.get(0).x -= 10;
  }
  
  if (key == 's') //up
  {
    obstacles.get(0).y += 10;
  }
  
    if (key == 'd') //up
  {
    obstacles.get(0).x += 10;
  }
   if (key == 'g') //up
  {
    goal.x = mouseX;
    goal.y = mouseY;
    goalX = mouseX;
    goalY = mouseY;
  }
  
     if (key == 'p') //up
  {
startRecording = !startRecording;
  }
  
  if (keyCode == RIGHT){
    XTIMES ++;
  }
  if (keyCode == LEFT) {
    XTIMES --;
  }
}
