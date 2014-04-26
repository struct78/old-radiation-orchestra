class UIBase {
  ControlP5 p5;
  
  public Button createButton(String id, String label, int x, int y, int width, int height, Group group) {
    return p5.addButton(id)
          .setLabel(label)
          .setPosition(x, y)
          .setSize(width, height)
          .setGroup(group);
  }
  
  public Button createButton(String id, String label, int x, int y, int width, int height, Group group, ControlListener listener) {
    return p5.addButton(id)
          .setLabel(label)
          .setPosition(x, y)
          .setSize(width, height)
          .setGroup(group)
          .addListener(listener);
  }
  
  public Textlabel createLabel(String label, String text, int x, int y, Group group) {
     return p5.addTextlabel(label)
         .setText(text)
         .setPosition(x,y)
         .setGroup(group);
  }
  
  public Textlabel createLabel(String label, String text, int x, int y, Group group, ControlFont font) {
     return p5.addTextlabel(label)
         .setText(text)
         .setPosition(x,y)
         .setGroup(group)
         .setFont(font);
  }
  
  public Slider createSlider(String name, int x, int y, int width, int height, int startRange, int endRange, String label, String captionLabel, Group group) {
    return p5.addSlider(name)
         .setPosition(x,y)
         .setSize(width, height)
         .setRange(startRange, endRange)
         .setLabel(label)
         .setCaptionLabel(captionLabel)
         .setGroup(group);
  }
  
  public Group createGroup(String name, int x, int y, int width) {
    return p5.addGroup(name)
        .setPosition(x, y)
        .setWidth(width)
        .hideBar(); 
  }
  
  
  
  public String formatInterval(long l)
  {
      return String.format("%02d:%02d:%02d", 
        TimeUnit.MILLISECONDS.toHours(l),
        TimeUnit.MILLISECONDS.toMinutes(l) - 
        TimeUnit.HOURS.toMinutes(TimeUnit.MILLISECONDS.toHours(l)),
        TimeUnit.MILLISECONDS.toSeconds(l) - 
        TimeUnit.MINUTES.toSeconds(TimeUnit.MILLISECONDS.toMinutes(l)));
  }
  
}
