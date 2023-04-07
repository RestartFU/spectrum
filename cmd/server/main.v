module main

import internal.protocol
import internal.protocol.packet
import internal

fn main(){
	mut l := protocol.listen_spectrum("127.0.0.1:8257")!
	for {
		mut conn := l.accept()!
		spawn fn [mut conn, mut l](){
			defer {
				conn.close() or {}
			}

			l.authenticate(mut conn) or {
				println(err)
				return
			}

			mut data := map[string]string{}
			data["ascii"] = internal.ascii

			conn.write_packet(packet.MessageData{messages: data}) or {
				panic(err)
			}
		}()
	}
}