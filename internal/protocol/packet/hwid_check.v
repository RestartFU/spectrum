module packet

pub struct HWIDCheck{
pub:
	hwid string
}

pub fn (h HWIDCheck) encode() []u8 {
	return "${int(ID.hwid_check)}|${h.hwid}\\".bytes()
}

pub fn (_ HWIDCheck) decode(buf []u8) !Packet {
	str := buf.bytestr().split("\\")
	if str.len < 1 {
		return error("09")
	}
	return HWIDCheck{
		hwid: str[0]
	}
}