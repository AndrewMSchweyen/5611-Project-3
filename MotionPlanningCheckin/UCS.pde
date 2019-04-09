import java.util.Comparator;
import java.util.HashSet;
import java.util.InputMismatchException;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.PriorityQueue;
import java.util.Scanner;
import java.util.Set;

int nodesAdded = 0;

public static final int MAX_VALUE = 0x7fffffff;

class Node implements Comparator<Node>
{
    public int node;
    public double cost;
 
    public Node()
    {
 
    }
 
    public Node(int node, double cost)
    {
        this.node = node;
        this.cost = cost;
    }
 
    @Override
    public int compare(Node node1, Node node2)
    {
        if (node1.cost < node2.cost)
            return -1;
        if (node1.cost > node2.cost)
            return 1;
        if (node1.node < node2.node)
            return -1;
        return 0;
    }
 
    @Override
    public boolean equals(Object obj)
    {
        if (obj instanceof Node)
        {
            Node node = (Node) obj;
            if (this.node == node.node)
            {
                return true;
            }
        }
        return false;
    }
}

public class UniformCostSearch
{
    private PriorityQueue<Node> priorityQueue;
    private Set<Integer> settled;
    private double distances[];
    private int numberOfNodes;
    private double adjacencyMatrix[][];
    private LinkedList<Integer> path;
    private int[] parent;
    private int source, destination;
    public static final int MAX_VALUE = 999; 
 
    public UniformCostSearch(int numberOfNodes)
    {
        this.numberOfNodes = numberOfNodes;
        this.settled = new HashSet<Integer>();
        this.priorityQueue = new PriorityQueue(numberOfNodes, new Node());
        this.distances = new double[numberOfNodes + 1];
        this.path = new LinkedList<Integer>();
        this.adjacencyMatrix = new double[numberOfNodes + 1][numberOfNodes + 1]; 
        this.parent = new int[numberOfNodes + 1];
    }
 
    public double uniformCostSearch(double adjacencyMatrix[][], int source, int destination)
    {
        int evaluationNode;
        this.source = source;
        this.destination = destination;
 
        for (int i = 0; i < numberOfNodes; i++)
        {
            distances[i] = MAX_VALUE;
        }
 
        for (int sourcevertex = 0; sourcevertex < numberOfNodes; sourcevertex++)
        {
            for (int destinationvertex = 0; destinationvertex < numberOfNodes; destinationvertex++)
            {
                this.adjacencyMatrix[sourcevertex][destinationvertex] =
                       adjacencyMatrix[sourcevertex][destinationvertex];
      }
        }
 
        priorityQueue.add(new Node(source, 0));
        distances[source] = 0;
 
        while (!priorityQueue.isEmpty())
        {
            evaluationNode = getNodeWithMinDistanceFromPriorityQueue();
            if (evaluationNode == destination)
            {
                return distances[destination];
            } 
            settled.add(evaluationNode);
            addFrontiersToQueue(evaluationNode);
        }
        return distances[destination];
    }
 
    private void addFrontiersToQueue(int evaluationNode)
    {
        for (int destination = 0; destination < numberOfNodes; destination++)
        {
            if (!settled.contains(destination))
            {
                if (adjacencyMatrix[evaluationNode][destination] != MAX_VALUE)
                {
                    if (distances[destination] > adjacencyMatrix[evaluationNode][destination]  
                                    + distances[evaluationNode])
                    {
                        distances[destination] = adjacencyMatrix[evaluationNode][destination]  
                                               + distances[evaluationNode];              
                        parent[destination] = evaluationNode;
                    }
 
                    Node node = new Node(destination, distances[destination]);
                    if (priorityQueue.contains(node))
                    {
                        priorityQueue.remove(node);
                    }
                    priorityQueue.add(node);
                }
            }
        }
    }
 
    private int getNodeWithMinDistanceFromPriorityQueue()
    {
        Node node = priorityQueue.remove();
        nodesAdded++;
        return node.node;
    }
 
    public void createPathArray()
    {
        path.add(destination);
        boolean found = false;
        int vertex = destination;
        while (!found)
        {
            if (vertex == source)
            {
                found = true;
                continue;
            }
            path.add(parent[vertex]);
            vertex = parent[vertex];
        }
        Iterator<Integer> iterator = path.descendingIterator();
        while (iterator.hasNext())
        {
            pathArray.add(samples.get(iterator.next()));
        }
    }
}

void UCS()
{
    double adjacency_matrix[][];
    int number_of_vertices;
    int source = 0;
    int destination = 0;
    double distance;

    number_of_vertices = samples.size();
    adjacency_matrix = new double[number_of_vertices + 1][number_of_vertices + 1];
    System.out.println("Enter the Weighted Matrix for the graph");
    for (int i = 0; i < number_of_vertices; i++)
    {
        for (int j = 0; j < number_of_vertices; j++)
        {
          //println("checking collision between " + i + " and " + j);
           if(checkCollision(samples.get(i), samples.get(j))) //detected obstacle collision
           {
                adjacency_matrix[i][j] = MAX_VALUE;
         //       println("found collision " + i + " and " + j); 
           }
           else
           {
             adjacency_matrix[i][j] = samples.get(i).distanceTo(samples.get(j));
           }
            //adjacency_matrix[i][j] = samples.get(i).distanceTo(samples.get(j));
           // println("weight from "  +i + " to " + j + " is " +adjacency_matrix[i][j]);
            if (i == j)
            {
                adjacency_matrix[i][j] = 0;
                continue;
            }
            if (adjacency_matrix[i][j] == 0)
            {
                adjacency_matrix[i][j] = MAX_VALUE;
            }
        }
    }
 
    source = 0;
    destination = 1;
 
    UniformCostSearch uniformCostSearch = new UniformCostSearch(number_of_vertices);
    distance = uniformCostSearch.uniformCostSearch(adjacency_matrix,source, destination);
    uniformCostSearch.createPathArray();
}
