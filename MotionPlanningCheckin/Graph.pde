class Graph 
{
    int vertices;
    LinkedList<Edge> [] adjacencylist;

    Graph(int vertices) {
        this.vertices = vertices;
        adjacencylist = new LinkedList[vertices];
        //initialize adjacency lists for all the vertices
        for (int i = 0; i <vertices ; i++) {
            adjacencylist[i] = new LinkedList();
        }
    }

    public void addEdge(int source, int destination, double weight) 
    {
        if (source == destination)
        {
          return;
        }
        if(checkCollision(samples.get(source), samples.get(destination)))
        {
          return;
        }
        
        Edge edge = new Edge(source, destination, weight);
        Edge edge2 = new Edge(destination, source, weight);
        adjacencylist[source].addFirst(edge); //for directed graph
        adjacencylist[destination].addFirst(edge2);
    }

    public void printGraph(){
        for (int i = 0; i <vertices ; i++) {
            LinkedList<Edge> list = adjacencylist[i];
            for (int j = 0; j <list.size() ; j++) {
                if(printOutGraph) {
                  System.out.println("vertex-" + i + " is connected to " +
                        list.get(j).destination + " with weight " +  list.get(j).weight);
                }
                if(drawEdge) {
                  //println("drawingEdge");

                   // drawEdge(i,list.get(j).destination);
                }
            }
        }
    }
    
    public void clearGraph()
    {
      for (int i = 0; i <vertices ; i++) {
            adjacencylist[i].clear();
        }
    }
    
    public void drawEdges()
    {
      for(int i =0; i<vertices; i++)
      {
        for(int j=0; j< adjacencylist[i].size(); j++)
        {
          
        }
      }
    }
}
