public class Point
{
  float x;
  float y;
  float z =0;
  
  public Point(float x, float y)
  {
    this.x  = x;
    this.y = y;
  }
  
  public Point(float x, float y, float z)
  {
    this.x  = x;
    this.y = y;
    this.z = z;
  }
  
  public float distanceTo(Point point)
  {
    return sqrt(sq(this.x - point.x) + sq(this.y - point.y)) ;
  }
  
}
