module protocol

import internal.protocol.packet

fn packet_from_id(id packet.ID) !packet.Packet {
	match id {
		.handshake {return packet.Handshake{}}
		.login {return packet.Login{}}
		.hwid_check { return packet.HWIDCheck{}}
		.hwid_check_result { return packet.HWIDCheckResult{}}
		.message_data { return packet.MessageData{}}
	}
}
