public class TransitionMatrix {
  public TransitionMatrix() {
    
  }
  /*
   // loop over all state sets and set the count of the co-occurrence in the
    // transition probability matrix
    for (int[] array : states) {
      for (int i = 0; i < array.length - 1; i++) {
        int count = (int) transitionProbabilities.get(array[i], array[i + 1]);
        transitionProbabilities.set(array[i], array[i + 1], ++count);
      }
    }

    final int[] rowEntries = transitionProbabilities.rowIndices();
    for (int rowIndex : rowEntries) {
      DoubleVector rowVector = transitionProbabilities.getRowVector(rowIndex);
      double sum = rowVector.sum();
      Iterator<DoubleVectorElement> iterateNonZero = rowVector.iterateNonZero();
      // loop over all counts and take the log of the probability
      while (iterateNonZero.hasNext()) {
        DoubleVectorElement columnElement = iterateNonZero.next();
        int columnIndex = columnElement.getIndex();
        double probability = FastMath.log(columnElement.getValue())
            - FastMath.log(sum);
        transitionProbabilities.set(rowIndex, columnIndex, probability);
      }
    }
*/
  
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
          //probability = (float).90*matrix[i][j]/rowSum+.10/128;
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
