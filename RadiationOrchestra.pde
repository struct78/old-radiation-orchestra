/*
TODO SOON:
1 - Write event handlers
2 - Write geiger counter emulator
3 - Write serial interface for Arduino/Processing communication
4 - Redo UI. Default window = Playlist. 1) Spawn popout window for track information 2) Create popout window for emulator 
5 - Close MIDI ports on exit
*/

// Import Namespaces
import themidibus.*; //Import the library
import controlP5.*;

// UI
UI ui;

Concert concert;

void setup() {
  // Create playlist
  ArrayList<String> playlist = new ArrayList<String>();
  playlist.add("tristan-and-isolde");
  playlist.add("die-walkure-magic-fire");
  playlist.add("songs-without-words-book-2-opus-30-no-1");
  
  // Create concert
  concert = new Concert(playlist, PerformanceType.GENERATIVE);
  concert.load();
  
  // Properies and methods below are necessary for a generative performance
  concert.numberOfSongs = 10;
  concert.songLength = new int[] { 100, 140 }; // Bars
  concert.generateTransitionMatrix();
  
  // Initialise the UI
  ui = new UI(this, concert.currentSong);
  ui.createToggleButtons();
  ui.createInstrumentButtons();
  ui.createInstrumentSlider();
  ui.createTimers();
}

void play() {
  // Start concert
  concert.start();
  
  // Start UI timers
  ui.startTimer();
}

void pause() {
  concert.pause();
}

void draw() {
  ui.refresh();
}

void stop() {
  super.stop();
}
