module command

import os

pub struct Clear {
pub:
ascii string
}
pub fn (_ Clear) name() string {
	return "clear"
}

pub fn (_ Clear) description() string {
	return "clears the terminal."
}

pub fn (mut c Clear) run(_ []string) ! {
	os.system("cls")
	println(c.ascii)
}