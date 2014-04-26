class Tempo {
  String folder;
  
  // Performance mode
  int bar = 0;
  int beat = 0;
  int click = 0;
  int change = 0;
  int CPB = 0;
  int BPB = 0;
  int PPQN = 0;
  
  Pulse[] pulses;
  Pulse pulse;
  int BPM = 0;
  
  Tempo(int _clicksPerBeat, int _beatsPerBar, int _ppqn) {
    CPB = _clicksPerBeat;
    BPB = _beatsPerBar;
    PPQN = _ppqn;
  }

  void loadFromFile() {
    Table table = loadTable(folder + "/tempo.csv", "header");
    
    // TODO NULL check
    pulses = new Pulse[table.getRowCount()];
    int x = 0;
    for (TableRow row : table.rows()) {
      Pulse pulse = new Pulse();
      String barnoteclick = row.getString("BarNoteClick");
      int[] steps = int(barnoteclick.split(":"));
      int value = row.getInt("Value");

      pulse.bar = steps[0];
      pulse.beat = steps[1];
      pulse.click = steps[2];
      pulse.value = value;
      pulses[x] = pulse;
      
      x++;
    }
    
    pulse = pulses[0];
  }
  
  private int calculateTempo(int value) {
    return 60000000/value;
  }
  
  public void update() {
    if (pulse.beat == beat && pulse.bar == bar &&  pulse.click == click) {
      BPM = calculateTempo(pulse.value);
      change++;
      
      if (change<pulses.length) { 
        pulse = pulses[change];
      }
    }
    
    // Update UI
    ui.updateTimer(click);
    ui.updateBPMTimer(BPM);
    
    click++;
    if (click==CPB) {
      click=0;
      beat++;

      if (beat>BPB) {
        beat = 0;
        bar++;
      }
    }
  }
}


