class Concert {
  PerformanceType type;
  Composition currentSong;
  ArrayList<String> playlist;
  ArrayList<Composition> songs;
  ArrayList<Message> messages;
  int index = 0;
  int numberOfSongs;
  int[] songLength;
  
  Concert(ArrayList<String> _playlist, PerformanceType _type) {
    type = _type;
    playlist = _playlist;
  }
  
  public void generateTransitionMatrix() {
    // Generate the probability matrix for all of these songs
    TransitionMatrix matrix = new TransitionMatrix();
    int[][] generated = matrix.generateMatrix(messages);
    float[][] probabilities = matrix.generateProbabilityMatrix(generated);
    
    String[] lines = new String[probabilities.length];
    for (int i = 0; i < probabilities.length; i++) {
      lines[i] = "[";
      for (int j = 0; j < probabilities[i].length; j++) {
        lines[i] += probabilities[i][j] + ((j==probabilities[i].length-1)?"":",");
      }
      lines[i] += "]";
    }
    
    messages = null;
    saveStrings("data/transitionmatrix.txt", lines);
    
    
    // TODO
    // Generate songs
    /*
    for (int x = 0 ; x < numberOfSongs ; x++ ) {
      Composition composition = new Composition();
      composition.CLICKS_PER_BEAT = 192;
      composition.BEATS_PER_BAR = 4;
      composition.PULSES_PER_QUARTER_NOTE = 24;
      composition.BEAT_TYPE = 4;
    }*/
  }
  
  public void load() {
    messages = new ArrayList<Message>();
    songs = new ArrayList<Composition>();
    
    for ( String song : playlist ) {
      Composition composition = new Composition(song);
      composition.loadFromFile();
      songs.add(composition);
      messages.addAll(composition.messages);
    }
    
    currentSong = songs.get(0);
  }
  
  public void start() {
    currentSong.play();
  }
  
  public void pause() {
    currentSong.pause();
  }
}
