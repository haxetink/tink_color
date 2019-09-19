package ;

import tink.color.*;

@:asserts
class Colors {

  static final BLACK   = Color.rgb(0x00, 0x00, 0x00);
  static final RED     = Color.rgb(0xFF, 0x00, 0x00);
  static final YELLOW  = Color.rgb(0xFF, 0xFF, 0x00);
  static final GREEN   = Color.rgb(0x00, 0xFF, 0x00);
  static final CYAN    = Color.rgb(0x00, 0xFF, 0xFF);
  static final BLUE    = Color.rgb(0x00, 0x00, 0xFF);
  static final PINK    = Color.rgb(0xFF, 0x00, 0xFF);
  static final WHITE   = Color.rgb(0xFF, 0xFF, 0xFF);

  public function new() {}

  public function testHue() {
    asserts.assert(Math.isNaN(BLACK.hue));
    asserts.assert(Math.isNaN(WHITE.hue));    
    asserts.assert(Math.isNaN(BLACK.mix(WHITE).hue));

    asserts.assert(RED.hue == 0);    
    asserts.assert(YELLOW.hue == 60);
    asserts.assert(GREEN.hue == 120);
    asserts.assert(CYAN.hue == 180);
    asserts.assert(BLUE.hue == 240);
    asserts.assert(PINK.hue == 300);

    asserts.assert(BLUE.hue == BLUE.mix(BLACK).hue);
    
    return asserts.done();
  }

  public function testValue() {

    asserts.assert(BLACK.value == 0);
    asserts.assert(RED.value == 1);    
    asserts.assert(YELLOW.value == 1);
    asserts.assert(GREEN.value == 1);
    asserts.assert(CYAN.value == 1);
    asserts.assert(BLUE.value == 1);
    asserts.assert(PINK.value == 1);
    asserts.assert(WHITE.value == 1);

    return asserts.done();    
  }

  public function testSaturation() {
    asserts.assert(BLACK.saturation == 0);
    asserts.assert(RED.saturation == 1);    
    asserts.assert(YELLOW.saturation == 1);
    asserts.assert(GREEN.saturation == 1);
    asserts.assert(CYAN.saturation == 1);
    asserts.assert(BLUE.saturation == 1);
    asserts.assert(PINK.saturation == 1);
    asserts.assert(WHITE.saturation == 0);

    return asserts.done();    
  }

  @:include public function testRGBtoHSV() {
    for (i in 0...10) {
      
      var c1 = Color.rgb(Std.random(0x100), Std.random(0x100), Std.random(0x100));
      var c2 = Color.hsv(c1.hue, c1.saturation, c1.value);

      asserts.assert(c1.red == c2.red);
      asserts.assert(c1.blue == c2.blue);
      asserts.assert(c1.green == c2.green);
      asserts.assert(c1.alpha == c2.alpha);
    }
    return asserts.done();    
  }

  public function testAll() {
    //TODO: do something here
    return asserts.done();
  }
}