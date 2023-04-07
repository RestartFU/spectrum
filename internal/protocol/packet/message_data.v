module packet

import json

pub struct MessageData {
	pub:
	messages map[string]string
}

pub fn (m MessageData) encode() []u8 {
	return "${int(ID.message_data)}|${json.encode(m.messages)}".bytes()
}

pub fn (_ MessageData) decode(buf []u8) !Packet {
	return MessageData{
		messages: json.decode(map[string]string, buf.bytestr())!
	}
}