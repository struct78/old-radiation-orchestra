public class TransitionMatrix {
  public int[][] generateMatrix(ArrayList<Message> messages) {
    ArrayList<Message> notes = new ArrayList<Message>();
    
    for ( Message message : messages) {
     if (message.message.equals("On")) {
       notes.add(message); 
     }
    }
    int[][] matrix = new int[128][128];
    
    for ( int i = 0 ; i < notes.size()-1; i++) {
        Message m = notes.get(i);
        Message n = notes.get(i+1);
        int x = m.pitch;
        int y = n.pitch;
        
        int count = matrix[x][y];
        matrix[x][y] = count+1;
    }
    return matrix;
  }
  
  public float[][] generateProbabilityMatrix(int[][] matrix) {
    float[][] probabilities = new float[128][128];
    for ( int i = 0 ; i < matrix.length-1; i++) {
      int rowSum = getRowSum(matrix[i]);
      float probability = 0.0F;
      float rowProbability = 0.0F;
      for ( int j = 0 ; j < matrix.length-1; j++) {
        if (matrix[i][j] > 0 ) { 
          probability = (float)matrix[i][j]/rowSum;
        }
        else {
          probability = 0;
        }
        rowProbability+=(float)probability;
        probabilities[i][j] = probability;
      }
      
      println(rowProbability);
    }
    
    return probabilities; 
  }
  
  public int getRowSum(int[] row) {
    int sum = 0; 
    for ( int i = 0 ; i < row.length ; i++ ) {
      sum+=row[i];    
    }
    return sum;
  }
}
