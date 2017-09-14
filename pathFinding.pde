/**
 *
 * @author Florian Strohm
 *
 **/

import java.util.Queue;
import java.util.PriorityQueue;
import java.util.Comparator; 
import java.util.LinkedList;

private int cellSize = 35;
private boolean[][] board = new boolean[28][28];
private int[] start = new int[2];
private int[] destination = new int[2];

private LinkedList<int[]> aStarResult;
private LinkedList<int[]> aStarVisited;

PFont font;
PFont fontBold;

private color black = color(40);
private color darkBlue = color(40, 142, 175);
private color blue = color(70, 182, 245);
private color blackHover = color(30);
private color darkBlueHover = color(40, 132, 175);
private color red = color(220, 20, 70);
private color yellow = color(195, 152, 50);
private color darkGray = color(80);
private color white = color(255);
private color green = color(25, 170, 20);

void setup() {
  size(1350, 981);
  start[0] = 0;
  start[1] = 0;
  destination[0] = 27;
  destination[1] = 27;
  font = createFont("Calibri", 16, true);
  fontBold = createFont("Calibri Bold", 16, true);
  noStroke();
  background(darkGray);
  drawMenu();
}

void draw() {
  // Draw cells
  for (int i = 0; i < board.length; i++) {
    for (int j = 0; j < board[0].length; j++) {
      if (!board[i][j]) {
        fill(darkBlue);
        rect(i*cellSize+1, j*cellSize+1, cellSize-1, cellSize-1 );
      } else if (board[i][j]) {
        fill(black);
        rect(i*cellSize+1, j*cellSize+1, cellSize-1, cellSize-1);
      }
    }
  }

  // Create hover effect
  int x = mouseX/cellSize;
  int y = mouseY/cellSize;
  if (x < 28 && y < 28 && x >=0 && y >=0) {
    if (board[x][y] == true) {
      fill(blackHover);
      rect(x*cellSize+1, y*cellSize+1, cellSize-1, cellSize-1);
    } else if (board[x][y] == false) {
      fill(darkBlueHover);
      rect(x*cellSize+1, y*cellSize+1, cellSize-1, cellSize-1);
    }
  }

  // Color cells that were visited during the A* search.
  if (aStarVisited != null) {
    for (int[] cell : aStarVisited) {
      fill(blue);
      rect(cell[0]*cellSize+1, cell[1]*cellSize+1, cellSize-1, cellSize-1);
    }
  }

  // Draw A* result;
  if (aStarResult != null) {
    for (int[] cell : aStarResult) {
      fill(green);
      rect(cell[0]*cellSize+1, cell[1]*cellSize+1, cellSize-1, cellSize-1);
    }
  }

  // Draw start and destination
  fill(red);
  rect(start[0]*cellSize+1, start[1]*cellSize+1, cellSize-1, cellSize-1);
  fill(yellow);
  rect(destination[0]*cellSize+1, destination[1]*cellSize+1, cellSize-1, cellSize-1);
}

private void drawMenu() {
  fill(darkGray);
  rect(981, 0, 1400, 981);
  fill(white);
  textFont(font, 36);
  text("A* Visualization", 1020, 80);
  textFont(font, 26);

  fill(red);
  rect(1020, 140, 35, 35);
  text("Starting Point", 1065, 165);
  fill(white);
  text("Change start with 'S'", 1020, 210);

  fill(yellow);
  rect(1020, 250, 35, 35);
  text("Destination Point", 1065, 275);
  fill(white);
  text("Change destination with 'D'", 1020, 320);

  fill(black);
  rect(1020, 360, 35, 35);
  text("Wall", 1065, 385);
  fill(white);
  text("Draw a maze with", 1020, 430);
  text("your mouse by holding", 1020, 460);
  text("any mouse button", 1020, 490);

  fill(green);
  rect(1020, 530, 35, 35);
  text("Shortest Path", 1065, 555);
  fill(white);
  text("Shortest path from 'S' to 'D'", 1020, 600);
  text("found by the A* algorithm", 1020, 630);

  fill(blue);
  rect(1020, 670, 35, 35);
  text("Visited Cells", 1065, 695);
  fill(white);
  text("Cells that were visited", 1020, 740);
  text("by the algorithm", 1020, 770);

  textFont(fontBold, 26);
  rect(1020, 800, 300, 2);
  text("Start", 1020, 845);
  text("Clear", 1020, 875);
  text("Reset", 1020, 905);

  textFont(font, 26);
  text("the algorithm with 'A'", 1090, 845);
  text("best path with 'C'", 1090, 875);
  text("walls with 'R'", 1090, 905);
}

/*
*
* These primitives store the current mouse position.
* This is needed to prevent multiple mouseDragged() events on the same cell.
*
*/
int currentMouseX = -1;
int currentMouseY = -1;

/*
*
* This function triggers if any mouse button is pressed.
* It checks if any cell was clicked and creates or deletes a wall accordingly.
*
*/
void mousePressed() {
  currentMouseX = mouseX/cellSize;
  currentMouseY = mouseY/cellSize;
  if (currentMouseX < 28 && currentMouseY < 28 && currentMouseX >=0 && currentMouseY >=0) {
    aStarResult = null;
    aStarVisited = null;
    if (board[currentMouseX][currentMouseY] == true) {
      board[currentMouseX][currentMouseY] = false;
    } else {
      board[currentMouseX][currentMouseY] = true;
    }
  }
}

/*
*
* This function triggers if the mouse is moved with any mouse button pressed.
* It checks if the mouse is dragged over any cell and creates or deletes a wall accordingly.
*
*/
void mouseDragged() {
  int currentMouseX = mouseX/cellSize;
  int currentMouseY = mouseY/cellSize;
  if (currentMouseX < 28 && currentMouseY < 28 && currentMouseX >=0 && currentMouseY >=0) {
    aStarResult = null;
    aStarVisited = null;
    if (this.currentMouseX != currentMouseX || this.currentMouseY != currentMouseY) {
      this.currentMouseX = currentMouseX;
      this.currentMouseY = currentMouseY;
      if (board[currentMouseX][currentMouseY] == true) {
        board[currentMouseX][currentMouseY] = false;
      } else {
        board[currentMouseX][currentMouseY] = true;
      }
    }
  }
}

/*
*
* This function triggers if any key was released.
* It checks what specific key was pressed and performes some action accordingly.
*
*/
void keyReleased() {
  if (key =='s' || key == 'S') {
    start[0] = mouseX/cellSize;
    start[1] = mouseY/cellSize;
  } else if (key =='d' || key == 'D') {
    destination[0] = mouseX/cellSize;
    destination[1] = mouseY/cellSize;
  } else if (key =='c' || key == 'C') {
    aStarResult = null;
    aStarVisited = null;
  } else if (key =='r' || key == 'R') {
    board = new boolean[28][28];
    aStarResult = null;
    aStarVisited = null;
  } else if (key =='a' || key == 'A') {
    aStar();
  }
}

/*
*
* This method executes the A* path finding algortihm.
*
*/
private void aStar() {
  // Create a comparator to compare Node objects.
  Comparator<Node> comp = new Comparator<Node>() {
    @Override
      public int compare(Node n1, Node n2) {
      return n1.getPriority() - n2.getPriority();
    }
  };
  // Create priority queue using the previous created comparator. This is our 'openSet'.
  final Queue<Node> openSet = new PriorityQueue<Node>(comp);
  // Create list for the 'closedSet'.
  LinkedList<Node> closedSet = new LinkedList<Node>();
  // Create a list containing all visited nodes. Only used for visualization.
  LinkedList<Node> visited = new LinkedList<Node>();
  
  // Create a node for each cell.
  Node[][] nodes = createNodes();
  // Retrieve start node and add it to the 'openSet'
  Node startNode = nodes[start[0]][start[1]];
  openSet.add(startNode);

  // This node is used to reconstruct the optimal path at the end of the algorithm.
  Node finalNode = null;

  // Iterate over the 'openSet'.
  while (openSet.peek() != null) {
    // Retrieve most relevant node from the priority queue.
    Node current = openSet.remove();

    // Check if that node is our destination and if so, exit the main loop.
    if (current.getX() == destination[0] && current.getY() == destination[1]) {
      finalNode = current;
      break;
    }

    // Add the current node to the 'closedSet'.
    closedSet.add(current);
    // Iterate over each neighbor of the current node.
    for (Node neighbor : getNeighbors(current, nodes)) {
      // Calculate the total cost for traveling from the start to this neighbor (traversing the current node).
      int newCost = current.getCostSoFar() + 1;
      // Check if this neighbor was already visited. Add it to the 'openSet' if it wasn't visited before or if the current path is better compared to the previous visit.
      if ((newCost < neighbor.getCostSoFar() || !openSet.contains(neighbor)) && !closedSet.contains(neighbor)) {
        // If the 'openSet' already contains this node, delete it. This is neccesary since we will add it to the 'openSet' with a new priority.
        if (openSet.contains(neighbor)) {
          openSet.remove(neighbor);
        }
        // Update node values and add it to the 'openSet' and the 'visited' list.
        neighbor.setCostSoFar(newCost);
        int priority = newCost + heuristic(neighbor);
        neighbor.setPriority(priority);
        neighbor.setCameFrom(current);
        openSet.add(neighbor);
        visited.add(neighbor);
      }
    }
  }

  // Store visited cells in array to visualize them.
  this.aStarVisited = new LinkedList<int[]>();
  for (Node node : visited) {
    int[] visitedCell = new int[2];
    visitedCell[0] = node.getX();
    visitedCell[1] = node.getY();
    aStarVisited.add(visitedCell);
  }

  // Reconstruct the optimal path. Store cells of the optimal path in array to visualize them.
  if (finalNode != null) {
    this.aStarResult = new LinkedList<int[]>();
    while (finalNode.getCameFrom() != null) {
      finalNode = finalNode.getCameFrom();
      int[] cellOnPath = new int[2];
      cellOnPath[0] = finalNode.getX();
      cellOnPath[1] = finalNode.getY();
      aStarResult.add(cellOnPath);
    }
  } else {
    System.out.println("No path found!");
  }
}

/*
*
* Creates a node for each cell.
*
*/
private Node[][] createNodes() {
  Node[][] nodes = new Node[28][28];
  for (int i = 0; i< 28; i++) {
    for (int j = 0; j<28; j++) {
      nodes[i][j] = new Node(null, 0, 0, i, j);
    }
  }
  return nodes;
}

/*
*
* Underestimates the distance from a node to the goal by using the Manhattan distance.
*
*/
private int heuristic(Node node) {
  int distX = Math.abs(node.getX() - destination[0]);
  int distY = Math.abs(node.getY() - destination[1]);
  return distX + distY-1;
}

/*
*
* Returns all valid neighbors of a node (left, right, bottom, up).
*
*/
private LinkedList<Node> getNeighbors(Node node, Node[][] nodes) {
  LinkedList<Node> neighbors = new LinkedList<Node>();
  // Check if a neighbor to the right is possible.
  if (node.getX() < 27) {
    // If so, check if it is not a wall.
    if (!board[node.getX()+1][node.getY()]) {
      // If so, add it to the neighbors list.
      neighbors.add(nodes[node.getX()+1][node.getY()]);
    }
  }
  if (node.getX() > 0) {
    if (!board[node.getX()-1][node.getY()]) {
      neighbors.add(nodes[node.getX()-1][node.getY()]);
    }
  }
  if (node.getY() < 27) {
    if (!board[node.getX()][node.getY()+1]) {
      neighbors.add(nodes[node.getX()][node.getY()+1]);
    }
  }
  if (node.getY() > 0) {
    if (!board[node.getX()][node.getY()-1]) {
      neighbors.add(nodes[node.getX()][node.getY()-1]);
    }
  }
  return neighbors;
}

/*
*
* The class Node contains all information of a node.
*
*/
class Node {
  private Node cameFrom;
  private int costSoFar;
  private int priority;
  private int x;
  private int y;

  Node(Node cameFrom, int costSoFar, int priority, int x, int y) {
    this.costSoFar = costSoFar;
    this.cameFrom = cameFrom;
    this.priority = priority;
    this.x = x;
    this.y = y;
  }

  public Node getCameFrom() {
    return cameFrom;
  }

  public int getCostSoFar() {
    return costSoFar;
  }

  public void setCameFrom(Node cameFrom) {
    this.cameFrom = cameFrom;
  }

  public void setCostSoFar(int costSoFar) {
    this.costSoFar = costSoFar;
  }

  public int getPriority() {
    return priority;
  }

  public void setPriority(int priority) {
    this.priority = priority;
  }

  public int getX() {
    return x;
  }

  public int getY() {
    return y;
  }
}