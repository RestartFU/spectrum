module packet

pub struct Handshake {
pub:
	time_unix_divided f64
}

pub fn (h Handshake) encode() []u8 {
	return "${int(ID.handshake)}|${h.time_unix_divided}\\".bytes()
}

pub fn (h Handshake) decode(buf []u8) !Packet {
	str := buf.bytestr().split("\\")
	if str.len < 1 {
		return error("29")
	}
	return Handshake{
		time_unix_divided: str[0].f64()
	}
}