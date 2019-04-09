class Path
{
  ArrayList<Point> pathArray = new ArrayList<Point>(0);
  int currentPoint = 0;
  public Path(ArrayList<Point> pathArray)
  {
    this.pathArray = pathArray;
  }
  
  void incrementPoint()
  {
    currentPoint ++;
  }
}
