module packet

pub struct HWIDCheckResult{
	pub:
	valid bool
}

pub fn (h HWIDCheckResult) encode() []u8 {
	return "${int(ID.hwid_check_result)}|${h.valid}\\".bytes()
}

pub fn (_ HWIDCheckResult) decode(buf []u8) !Packet {
	str := buf.bytestr().split("\\")
	if str.len < 1 {
		return error("39")
	}
	return HWIDCheckResult{
		valid: str[0].bool()
	}
}