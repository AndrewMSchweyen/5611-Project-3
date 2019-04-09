
class Boid
{
  PVector position;
  PVector velocity;
  PVector acceleration;
  float alignmentRadius;
  float maxForce = .03;
  float maxVelocity = 2;
  float speedFactor = 5;
  float theta, framesPassed;
  ArrayList<Point> path;
  int currentPathIndex = 0;
  int goalNode = 0;
  
  Boid(float x, float y)
  {
    position = new PVector(x,y);
    acceleration = new PVector(0,0);
    float angle = 2*PI;
    velocity = new PVector(cos(angle), sin(angle));

    theta = 0;
  }
  
  void run(ArrayList<Boid> boids)
  {
    applyBoidForces(boids);
    update();
    updatePath();
    drawBoid();
  }
  
   void applyBoidForces(ArrayList<Boid> boids)
  {
    PVector alignForce = align(boids);
    PVector cohesionForce = cohesion(boids);
    PVector separationForce = separation(boids).mult(3);
    PVector goalForce = seekGoal(boids).mult(3);
    PVector obstacleForce = avoidObstacle(boids).mult(15);
    applyForce(alignForce);
    applyForce(cohesionForce);
    applyForce(separationForce);
    applyForce(goalForce);
    applyForce(obstacleForce);
  }
  
  void update()
  {
    velocity.add(acceleration);
    if(velocity.mag() > maxVelocity)
    {
         velocity.limit(maxVelocity);
    }
    position.add(velocity);
    acceleration.mult(0);
    framesPassed++;
  }
  
  void applyForce(PVector force) 
  {
    acceleration.add(force);
  }
  
  void drawBoid()
  {  
    theta = velocity.heading2D() + radians(90);
    if(drawFish)
    {
      pushMatrix();
      translate(position.x, position.y); 
      rotateZ(PI/2);
      rotate(theta);
      rotateX(PI/2);
      shape(fish);
      popMatrix();   
    } 
    
  }
  

  PVector slope = new PVector(0,0);
  void updatePath()
  {
      if(checkCollision(new Point(position.x, position.y), path.get(currentPathIndex)))//can't see current goal so run A* again
      {
       //    println("rerunning astar");
           path.clear();
           samples.add(new Point(position.x, position.y));
           path = ASTAR(samples.size()-1, goalNode);
           currentPathIndex=0;
      }
    if(currentPathIndex < path.size()-1)
    {

      if(!checkCollision(new Point(position.x, position.y), path.get(currentPathIndex+1)))
      {
          currentPathIndex+=1;
      }
    }
}
  
  PVector align(ArrayList<Boid> boids) //average velocity
  {
    PVector velocitySum = new PVector(0,0);
    int numberOfNeighbors = 0;
    alignmentRadius = 40;
    for(Boid curBoid: boids)
    {
       float distance = PVector.dist(position, curBoid.position);
       if(distance < alignmentRadius)
       {
         velocitySum.add(curBoid.velocity);
         numberOfNeighbors++;
       }
    }
    
    if( numberOfNeighbors > 0)
    {
      velocitySum.div(numberOfNeighbors);
      velocitySum.normalize();
      velocitySum.mult(speedFactor);
      PVector velocityForce = PVector.sub(velocitySum, velocity);
      velocityForce.limit(maxForce);
      return velocityForce;
    }
    else
    {
      return new PVector(0,0);
    }
  }
  
    PVector seekGoal (ArrayList<Boid> boids) 
  {
      return aim(new PVector (path.get(currentPathIndex).x, path.get(currentPathIndex).y));  // aim for BIG GOAL
  }
  
    PVector avoidObstacle(ArrayList<Boid> boids) //average velocity
  {
    PVector obstacleSum = new PVector(0,0);
    PVector rayVector = new PVector(0,0);
    for(Obstacle curObstacle: obstacles)
    {
      float distance = PVector.dist(position, new PVector(curObstacle.x,curObstacle.y) );
      PVector positionVector = new PVector(position.x, position.y);
      PVector obstaclePositionVector = new PVector(curObstacle.x, curObstacle.y);
      PVector.sub(positionVector,obstaclePositionVector,rayVector);
      rayVector.normalize();
      rayVector.div(pow(distance,3));
      obstacleSum.add(rayVector);
    }
    
    return obstacleSum.mult(400);//scale
  }
  
  PVector cohesion (ArrayList<Boid> boids) 
  {
    int neighborCount = 0;
    PVector neighborPositionSum = new PVector(0, 0); 
    float effectRadius = 60;
    for (Boid curBoid : boids) 
    {
      float distance = PVector.dist(position, curBoid.position);
      if ((distance > 0) && (distance < effectRadius))
      {
        neighborPositionSum.add(curBoid.position); // Add position
        neighborCount++;
      }
    }
    if (neighborCount > 0) 
    {
      neighborPositionSum.div(neighborCount);
    } 
    
    return aim(neighborPositionSum);//aggregate here
  }
  
    PVector aim(PVector target) 
    {
      PVector goal = PVector.sub(target, position);  
      goal.normalize();
      goal.mult(maxVelocity);
      PVector returnAim = PVector.sub(goal, velocity);
      returnAim.limit(maxForce); //prevent explosion
      return returnAim;
    }
    
    PVector separation (ArrayList<Boid> boids) 
    {
      float boidRadius = 60.0f;
      PVector netForce = new PVector(0, 0);
      for (Boid other : boids)
      {
        float distance = PVector.dist(position, other.position);
        if ((distance > 0) && (distance < boidRadius)) 
        {
          PVector boidToCurrentRay = PVector.sub(position, other.position);
          boidToCurrentRay.normalize();
          boidToCurrentRay.div(pow(distance,3));//exponential scaling to prevent big bomb       
          netForce.add(boidToCurrentRay);
            
        }
      }
      
      netForce.div(boids.size());
      netForce.normalize();
      netForce.sub(velocity);
      netForce.limit(maxForce);
      return netForce;
  }
  
}
    
