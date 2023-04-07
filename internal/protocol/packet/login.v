module packet

pub struct Login {
pub:
	password string
	username string
}

pub fn (l Login) encode() []u8 {
	return "${int(ID.login)}|${l.password}\\${l.username}".bytes()
}

pub fn (_ Login) decode(buf []u8) !Packet {
	str := buf.bytestr().split("\\")
	if str.len < 2 {
		return error("49")
	}
	return Login{
		password: str[0]
		username: str[1]
	}
}