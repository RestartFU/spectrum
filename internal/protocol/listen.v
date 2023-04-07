module protocol

import net
import time
import internal.protocol.packet
import db.sqlite

struct SpectrumListener {
	mut:
	l  &net.TcpListener
	db sqlite.DB
}

pub fn listen_spectrum(address string) !&SpectrumListener {
	l := net.listen_tcp(net.AddrFamily.ip, address)!

	db := sqlite.connect('users.sqlite')!
	db.exec('create table if not exists users (
                hwid char(100),
                username varchar(255),
                password varchar(255)
        )')

	sp := SpectrumListener{
		l: l
		db: db
	}
	return &sp
}

pub fn (mut l SpectrumListener) accept() !&SpectrumConn {
	conn := l.l.accept()!
	sp := SpectrumConn{
		conn: conn
	}
	return &sp
}

fn (mut l SpectrumListener) valid_hwid(hwid string) bool {
	rows, _ := l.db.exec("select * from users where hwid='${hwid}'")
	if rows.len == 1 {
		return true
	}
	return false
}

fn (mut l SpectrumListener) valid_creds(username string, password string) bool {
	rows, _ := l.db.exec("select * from users where username='${username.to_lower().trim_space()}' and password='${password}'")
	if rows.len == 1 {
		return true
	}
	return false
}

pub fn (mut l SpectrumListener) authenticate(mut sp SpectrumConn) ! {
	hs := sp.expect_packet[packet.Handshake]()!
	if time.now().add_seconds(-(time.unix((i64(hs.time_unix_divided * 2)))).second) > time.now().add_seconds(10) {
		return error('failed handshake')
	}
	hw := sp.expect_packet[packet.HWIDCheck]()!
	if l.valid_hwid(hw.hwid) {
		sp.write_packet(packet.HWIDCheckResult{ valid: true })!
		return
	}
	sp.write_packet(packet.HWIDCheckResult{ valid: false })!
	
	lg := sp.expect_packet[packet.Login]()!
	if l.valid_creds(lg.username, lg.password) {
		sp.write_packet(packet.HWIDCheckResult{ valid: true })!
		l.db.exec("update users set hwid='${hw.hwid}' where username='${lg.username.to_lower().trim_space()}' and password='${lg.password}'")
		return
	}

	sp.write_packet(packet.HWIDCheckResult{ valid: false })!
	return error('could not authenticate connection')
}