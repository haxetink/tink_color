package tink.color;

abstract ChannelValue(Int) to Int {
  inline function new(i)
    this = i;

  @:to inline public function toString():String
    return this.hex(2);

  @:from static inline function ofInt(value:Int)
    return new ChannelValue(value & 0xFF);

  static public inline var FULL = new ChannelValue(0xFF);
  static public inline var ZERO = new ChannelValue(0);
}