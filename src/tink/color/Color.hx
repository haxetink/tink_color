package tink.color;

import tink.color.Channel;

abstract Color(Int) {

	inline function new(i)
		this = i;

	@:arrayAccess public function get(chan:Channel):ChannelValue
		return this >> (chan : Int);

	public function with(chan:Channel, value:ChannelValue):Color 
		return new Color((value << chan) | (this & ~(0xFF << chan)));

	@:to function toString():String
		return this.hex(8);

	static public inline function rgb(r:ChannelValue, g:ChannelValue, b:ChannelValue) 
		return rgba(r, g, b, ChannelValue.FULL);

	static public inline function rgba(r:ChannelValue, g:ChannelValue, b:ChannelValue, a:ChannelValue) 
		return new Color(a << ALPHA | r << RED | g << GREEN | b << BLUE);

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

	public inline function invert() 
		return new Color((this & 0xFF000000) | (~this & 0x00FFFFFF));
		
}