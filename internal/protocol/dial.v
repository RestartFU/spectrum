module protocol

import net
import time

pub fn dial_spectrum(address string) !&SpectrumConn {
	conn := net.dial_tcp(address)!
	sp := SpectrumConn{
		conn: conn
	}
	time.sleep(time.millisecond * 100)
	return &sp
}