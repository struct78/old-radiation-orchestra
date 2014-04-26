import java.util.Date;
import java.util.concurrent.TimeUnit;

class UI extends UIBase {
  Composition composition;
  PApplet applet;
  int width = 700;
  int height = 500;
  int padding = 20;
  ControlTimer timer;
  Textlabel timerLabel;
  Textlabel beatLabel;
  Textlabel bpmLabel;
  
  Group instrumentGroup;
  Group timerGroup;
  Group buttonGroup;
  Group sliderGroup;
  Group controlGroup;
  
  ControlFont bigLabelFont;
  
  long timeStart;
  
  UI() {
    setup();
  }
  
  UI(PApplet _applet, Composition _composition) {
    applet = _applet;
    composition = _composition;
    setup();
  }
  
  public void setup() {  
    frameRate(30);
    size(width, height);
    background(0, 0, 0);
    noStroke();
    p5 = new ControlP5(applet);
    
    PFont pfont = createFont("Helvetica Neue UltraLight", 30, true); // use true/false for smooth/no-smooth
    bigLabelFont = new ControlFont(pfont, 30);
     
    createGroups();
  } 
  
  void refresh() {
    background(0, 0, 0);  
  }
  
  public void createGroups() {
    instrumentGroup = createGroup("instrumentGroup", 20, 20, 200);
    sliderGroup = createGroup("sliderGroup", 170, 20, 350);
    controlGroup = createGroup("controlGroup", 450, 20, 250);
    timerGroup = createGroup("timerGroup", 448, 70, 300);
  }
  
  public void createToggleButtons() {
    int buttonWidth = 100;
    int buttonHeight = 30;
    
    createButton("pause", "Pause", 110, 0, buttonWidth, buttonHeight, controlGroup);
    createButton("play", "Play", 0, 0, buttonWidth, buttonHeight, controlGroup);
  }
  
  void createInstrumentButtons() {
    int x = 0;
    int y = 0;
    
    ControllerChangeListener listener = new ControllerChangeListener(composition.instruments);
    
    for (int i = 0 ; i < composition.instruments.size() ; i++) {
      String name = composition.instruments.get(i).name;
      
      createLabel(name + "label", name.toUpperCase(), x, (y+5), instrumentGroup);
      createButton(name + "button", "CC 7", x+115, y, 30, 20, instrumentGroup, listener);
         
      y+=padding+(padding/2);
    }
  }
  
  void createInstrumentSlider() {
    int x = 0;
    int y = 0;
    Slider slider;
   
    for (int i = 0 ; i < composition.instruments.size() ; i++) {
      String name = composition.instruments.get(i).name;
      
      slider = createSlider(name + "slider", x, y, 255, 20, 0, 127, "", "", sliderGroup);
      slider.valueLabel().setVisible(false);
       
      y+=padding+(padding/2);
    }
  }
  
  void updateInstrumentSlider(String name, int value) {
    Slider slider = (Slider)p5.controller(name + "slider");
    if (slider != null) {
      slider.setValue(value);
      slider.valueLabel().setVisible(false);
    }
  }
  
  
  void createTimers() {
    createLabel("timerSmallLabel", "TIME ELAPSED", 0, 0, timerGroup);
    timerLabel = createLabel("timerLabel", "00:00:00", 0, 7, timerGroup, bigLabelFont);
    
    createLabel("beatSmallLabel", "BAR:BEAT:CLICK", 0, 55, timerGroup);
    beatLabel = createLabel("beatLabel", "00:00:000", 0, 62, timerGroup, bigLabelFont);
    
    
    createLabel("bpmSmallLabel", "BPM", 0, 115, timerGroup);
    bpmLabel = createLabel("bpmLabel", "000 BPM", 0, 121, timerGroup, bigLabelFont);
  }
   
    
  void updateTimer(int clicks) {
    long ticks = millis()-timeStart;
    timerLabel.setText(formatInterval(ticks));
  }
  
  void updateBeatTimer(int bar, int beat, int click) {
    beatLabel.setText(String.format("%02d:%02d:%03d", bar, beat, click));
  }

  // Update BPM Timer
  void updateBPMTimer(int bpm) {
    bpmLabel.setText(String.format("%03d BPM", bpm));
  }
  
  
  
  // Timer functions
  void startTimer() {
    timeStart = millis();
  }
}

public class ControllerChangeListener implements ControlListener {
  public ArrayList<Instrument> instruments;
  
  ControllerChangeListener(ArrayList<Instrument> _instruments) {
    instruments = _instruments;
  }
  
  public void controlEvent(ControlEvent event) {
    if (event.isController()) {
      for ( int x = 0 ; x < instruments.size() ; x++ ) {
        Instrument instrument = instruments.get(x);
        if (new String(instrument.name + "button").equals(event.getController().getName())) {
          // Maps volume slider to a controller channel
          println(instrument.bus);
          instrument.bus.sendControllerChange(instrument.controllerChannel, 7, 1);
        }
      }
    }
  }
}
