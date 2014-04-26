public class Composition {
  // Objects
  public ArrayList<Instrument> instruments;
  public Tempo tempo;
  public Orchestra orchestra;
  public PerformanceType type;
  public ArrayList<MidiBus> buses;
  public ArrayList<Message> messages;
  
  /// Misc
  public String folder;
  public String name;
  
  
  // Time keeping
  public int CLICKS_PER_BEAT;
  public int BEATS_PER_BAR;
  public int PULSES_PER_QUARTER_NOTE;
  public int BEAT_TYPE;
  
  // Private
  private int bar = 0;
  private int beat = 0;
  private int click = 0;
  private int finalBar = 0;
  private int finalBeat = 0;
  private int finalClick = 0;
  
  
  Composition() {
    type = PerformanceType.GENERATIVE;  
  }
  
  Composition(String _folder) {
    type = PerformanceType.PERFORMANCE;
    folder = _folder;
    buses = new ArrayList<MidiBus>();
    instruments = new ArrayList<Instrument>();
    messages = new ArrayList<Message>();
  }
  
  public void loadFromFile() {
    String[] data = loadStrings(folder + "/config.csv");
    
    for (int i = 0; i < data.length; i++) {
      String line = data[i];
      if (line.contains(":")) { 
        String[] row = line.split(":");
        String key = row[0];
        String value = row[1];
        
        if (key.equals("NAME")) {
            name = value;
        }
        
        if (key.equals("CLICKS_PER_BEAT")) {
            CLICKS_PER_BEAT = int(value);
        }
        
        if (key.equals("BEATS_PER_BAR")) {
            BEATS_PER_BAR = int(value);
        }
        
        if (key.equals("BEAT_TYPE")) {
            BEAT_TYPE = int(value);
        }
        
        if (key.equals("PULSES_PER_QUARTER_NOTE")) {
            PULSES_PER_QUARTER_NOTE = int(value);
        }
        
        if (key.equals("BUS")) {
          MidiBus bus = new MidiBus(this, -1, value);
          buses.add(bus);
        }
      }
    }
  
    tempo = new Tempo(CLICKS_PER_BEAT, BEATS_PER_BAR, PULSES_PER_QUARTER_NOTE); 
    tempo.folder = folder;
    tempo.loadFromFile();
    
    for (int i = 0; i < data.length; i++) {
      String line = data[i];
      if (line.contains(":")) {
        String[] row = line.split(":");
        String key = row[0];
        String value = row[1];
        
        if (key.equals("INSTRUMENT")) {
          String[] parameters = value.split(",");
          int bus = int(parameters[1]);
          Instrument instrument = new Instrument();
          instrument.CLICKS_PER_BEAT = CLICKS_PER_BEAT;
          instrument.BEATS_PER_BAR = BEATS_PER_BAR;
          instrument.name = parameters[0];
          instrument.channel = int(parameters[2]);
          instrument.controllerChannel = int(parameters[3]);
          instrument.bus = buses.get(bus);
          instrument.folder = folder;
          instrument.file = parameters[4];
          instrument.type = type;
          instrument.loadFromFile();
          
          messages.addAll(instrument.messages);
          instruments.add(instrument);
        }
      }
    }
  }
  
  // TODO: Write onUpdate event handler to keep track of bar beat click
  
  boolean isFinished() {
    return (bar>=finalBar&&beat>=finalBeat&&click>=finalClick);
  }
  
  void play() {

    
    for ( int x = 0 ; x < instruments.size() ; x++) {
      Instrument instrument = instruments.get(x); 
      if (instrument.finalBar > finalBar) {
        finalBar = instrument.finalBar;
      }
      if (instrument.finalBeat > finalBeat) {
        finalBeat = instrument.finalBeat;
      }
      if (instrument.finalClick > finalClick) {
        finalClick = instrument.finalClick;
      }
    }
    
    orchestra = new Orchestra(this);
    orchestra.start();
  }
  
  void pause() {
    orchestra.pause(); 
  }
  
}
