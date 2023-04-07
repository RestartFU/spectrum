module hwid

import os
import encoding.base58
import encoding.base64
import encoding.base32

pub fn hwid() string {
	mut id := ""
	id += os.hostname() or {
		// Do nothing
		""
	}
	id += os.loginname() or {
		// Do nothing
		""
	}
	id += os.home_dir()
	id += os.user_os()
	uname := os.uname()
	id += uname.machine
	id += uname.nodename
	id += uname.release
	id += uname.sysname
	id += uname.version
	mut arr := base58.encode(base64.encode(base32.encode(id.bytes()))).bytes()
	arr.trim(100)
	return arr.bytestr()
}