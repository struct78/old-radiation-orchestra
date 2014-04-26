class Instrument {
  String name;
  String folder;
  String file;
  
  MidiBus bus;
  ArrayList<Message> messages;
  Message message;
  PerformanceType type;

  // Performance mode
  int channel;
  int controllerChannel;
  int bar;
  int beat;
  int click;
  int finalBar;
  int finalBeat;
  int finalClick;
  int note = 0;
  
  int CLICKS_PER_BEAT;
  int BEATS_PER_BAR;
  
  void stop() {
    //bus.close(); 
  }

  void loadFromFile() {
    Table table = loadTable(folder + "/" + file.toString(), "header");
    messages = new ArrayList<Message>();

    int x = 0;
    for (TableRow row : table.rows()) {
      Message message = new Message();
      String barnoteclick = row.getString("BarNoteClick");
      String msg = row.getString("Message");
      String pitch = row.getString("Pitch");
      String velocity = row.getString("Velocity");
      int[] steps = int(barnoteclick.split(":"));

      // TODO
      // Change format depending on Message (e.g. PrCh)
      message.bar = steps[0];
      message.beat = steps[1];
      message.click = steps[2];
      message.message = msg;
      message.pitch = int(pitch.split("=")[1]);
      if (velocity != null) {
        message.velocity = int(velocity.split("=")[1]);
      }
      messages.add(message);
      x++;
      
      finalBar = message.bar;
      finalBeat = message.beat;
      finalClick = message.click;
    }
    
    message = messages.get(0);
  }
  
  void play() { 
       while (message.beat == beat &&  message.bar == bar &&  message.click == click) {
        if (bar>=1) {
          ui.updateInstrumentSlider(name, message.velocity);
        }
        if (message.message.equals("On")) {
          bus.sendNoteOn(channel, message.pitch, message.velocity); // Send a Midi noteOn
        }
        if (message.message.equals("Off")) {
          bus.sendNoteOff(channel, message.pitch, message.velocity);
        }

        // TODO - poly pressure/parameter change messages;
        // Parameter change message fades notes in and out
        if (message.message.equals("Par")) {
          bus.sendControllerChange(controllerChannel, message.pitch, message.velocity);
        }

        note++;
        // Move to the next message
        if (note<messages.size()) {
          message = messages.get(note);
        }
        else {
          this.stop();
          return;
        }
      }
      
      ui.updateBeatTimer(bar, beat, click);
      click++;
      if (click==CLICKS_PER_BEAT) {
        click=0;
        beat++;
  
        if (beat==BEATS_PER_BAR) {
          beat = 0;
          bar++;
        }
      }
  }
}

