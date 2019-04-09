public class Obstacle
{
  float x;
  float y;
  float z =0;
  float radius;
  public Obstacle(float x, float y, float radius )
  {
    this.x  = x;
    this.y = y;
    this.radius = radius;
  }
  
  public Obstacle(float x, float y, float z, float radius)
  {
    this.x  = x;
    this.y = y;
    this.z = z;
    this.radius = radius;
  }
  
  public float distanceTo(Point point)
  {
    return sqrt(sq(this.x - point.x) + sq(this.y - point.y)) ;
  }
  
}
