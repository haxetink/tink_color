package tink.color;

import tink.color.Channel;

abstract Color(Int) {

  public var hue(get, never):Float;
    function get_hue():Float
      return compute(function (r, g, b, min, max) return switch max - min {
        case 0: Math.NaN;
        case delta:
          inline function calc(c1, c2, offset = .0)
            return (360 + 60 * (offset + (c1 - c2) / delta)) % 360;

          if (r == max) calc(g, b);
          else if (g == max) calc(b, r, 2);
          else calc(r, g, 4);
      });

  @:extern inline function compute(f):Float {
    var r = red,
        g = green,
        b = blue;

    var min = Math.min(r, Math.min(g, b)),
        max = Math.max(r, Math.max(g, b));

    return f(r, g, b, min, max);
  }

  public var saturation(get, never):Float;
    function get_saturation() return compute(
      function (r, g, b, min, max) return switch max - min {
        case 0: 0;
        case v: v / max;
      }
    );

  public var value(get, never):Float;
    function get_value()
      return compute(function (r, g, b, min, max) return max / 0xFF);

  public var red(get, never):Int;
    inline function get_red()
      return get(RED);

  public var green(get, never):Int;
    inline function get_green()
      return get(GREEN);

  public var blue(get, never):Int;
    inline function get_blue()
      return get(BLUE);

  public var alpha(get, never):Int;
    inline function get_alpha()
      return get(ALPHA);

  inline function new(i)
    this = i;

  @:arrayAccess public inline function get(chan:Channel):ChannelValue
    return this >> (chan : Int);

  public function with(chan:Channel, value:ChannelValue):Color
    return new Color((value << chan) | (this & ~(0xFF << chan)));

  @:to function toString():String
    return this.hex(8);

  static public inline function rgb(r:ChannelValue, g:ChannelValue, b:ChannelValue)
    return rgba(r, g, b, ChannelValue.FULL);

  static public inline function rgba(r:ChannelValue, g:ChannelValue, b:ChannelValue, a:ChannelValue)
    return new Color(a << ALPHA | r << RED | g << GREEN | b << BLUE);

  static public function hsv(h:Float, s:Float, v:Float)
    return hsva(h, s, v, ChannelValue.FULL);

  static public function hsva(h:Float, s:Float, v:Float, a:ChannelValue)
    return
      if (s == 0) {
        var val:ChannelValue = Math.round(v * 0xFF);
        rgba(val, val, val, a);
      }
      else {
        inline function make(r:Float, g:Float, b:Float)
          return rgba(Math.round(r * 0xFF), Math.round(g * 0xFF), Math.round(b * 0xFF), a);

        h /= 360;

        var sector = Std.int(h * 6);
        var f = h * 6 - sector;

        var p = v * (1 - s),
            q = v * (1 - f * s),
            t = v * (1 - (1 - f) * s);

        switch sector {
          case 0: make(v, t, p);
          case 1: make(q, v, p);
          case 2: make(p, v, t);
          case 3: make(p, q, v);
          case 4: make(t, p, v);
          default: make(v, p, q);
        }
      }

  public function mix(that:Color, ?factor = .5) {

    var self:Color = cast this;

    var a1 = self[ALPHA] / 0xFF,
        a2 = that[ALPHA] / 0xFF;

    var a = (a1 + a2) / 2;

    var f1 = (1 - factor),
        f2 = factor;

    if (a > 0) {
      f1 *= a1 / a;
      f2 *= a2 / a;
    }

    inline function v(f:Float):ChannelValue
      return if (f > 255.0) ChannelValue.FULL else Std.int(f);

    return rgba(
      v(self[RED] * f1 + that[RED] * f2),
      v(self[GREEN] * f1 + that[GREEN] * f2),
      v(self[BLUE] * f1 + that[BLUE] * f2),
      v(self[ALPHA] * (1 - factor) + that[ALPHA] * factor)
    );
  }

  public function toCss()
    return 'rgba($red, $green, $blue, ${alpha / 0xFF}})';

  public inline function invert()
    return new Color((this & 0xFF000000) | (~this & 0x00FFFFFF));

}