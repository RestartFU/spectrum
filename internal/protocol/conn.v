module protocol

import net
import internal.protocol.packet
import time

pub struct SpectrumConn {
mut:
	conn &net.TcpConn
}

pub fn (mut sp SpectrumConn) write_packet(pk packet.Packet) ! {
	time.sleep(time.millisecond * 100)
	sp.conn.write(pk.encode())!
}

pub fn (mut sp SpectrumConn)expect_packet[T]() !&T {
	pk := sp.read_packet()!
	if pk is T {
		return pk
	}
	return error("expected packet of type ${T.name} but received other type")
}

pub fn (mut sp SpectrumConn) read_packet() !packet.Packet {
	mut buf := []u8{len:65000}
	n := sp.conn.read(mut &buf)!
	if n <= 0 {
		return error("87")
	}

	time.sleep(time.millisecond * 100)

	buf = buf[..n]
	id_split := buf.bytestr().split("|")
	pk := packet_from_id(unsafe { packet.ID(id_split[0].int()) })!
	return pk.decode(id_split[1].bytes())!
}

pub fn (mut sp SpectrumConn)close() !{
	sp.conn.close()!
}