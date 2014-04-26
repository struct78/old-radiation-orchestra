class Orchestra extends Thread {
  boolean isActive=true;
  double interval;
  long previousTime;
  Composition composition;
  
  Orchestra(Composition _composition) {
    composition = _composition;
    
    // interval currently hard coded to quarter beats
    previousTime = System.nanoTime();
    recalculateInterval();
  }
  
  void recalculateInterval() {
    int currentBPM = composition.tempo.BPM;
    composition.tempo.update();
    //interval = 1000.0 / (composition.tempo.BPM / 60.0) / composition.tempo.PPQN;
    interval = 1000.0 / (composition.tempo.BPM / 60.0) / composition.tempo.CPB / (composition.tempo.PPQN/4);
    interval = (1000.0 / (composition.tempo.BPM / 60.0) / composition.tempo.CPB);
    println(composition.tempo.BPM);
    println(composition.tempo.PPQN);
    println(interval);
    //interval = 1000.0 / (composition.tempo.BPM / 60.0) / composition.CPB / (composition.PPQN/4);
   // interval = 1000.0 / (Math.abs(tempo.BPM-currentBPM) / 60.0) / cpb / (ppqn/4);
  }

  void pause() {
    isActive = !isActive;
  }
  
  void run() {
      try {
      while(isActive) {
        // calculate time difference since last beat & wait if necessary
        double tick = (System.nanoTime()-previousTime)*1.0e-6;
        while (tick < interval) {
          tick = (System.nanoTime()-previousTime)*1.0e-6;
        }
        
        recalculateInterval();
        for ( int x = 0 ; x < composition.instruments.size() ; x++ ) {
          Instrument instrument = composition.instruments.get(x);
          instrument.play();
        }
        
        // calculate real time until next beat
        
        long delay = (long)(interval-(System.nanoTime()-previousTime)*1.0e-6);
        previousTime = System.nanoTime();
        
        Thread.sleep(1);
      }
    } 
    catch(InterruptedException e) {
      println("Force quit...");
    }
  }
} 
