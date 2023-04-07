module packet

pub interface Packet {
	encode() []u8
	decode(buf []u8) !Packet
}
