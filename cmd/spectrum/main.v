module main

import internal.clicker
import os
import internal.command
import pkg.color
import time
import strings
import internal.protocol
import internal.protocol.packet
import pkg.hwid
import encoding.base58
import restartfu.pretty
import restartfu.windows.process
import restartfu.windows

type LPVOID_ALIAS = voidptr

fn main() {
	windows.prevent_console_resize()
	windows.prevent_console_scroll()
	mut msgs := map[string]string{}
	for {
		time.sleep(time.second)
		mut sp := protocol.dial_spectrum("moyai.tech:8257")!
		sp.write_packet(packet.Handshake{time_unix_divided: time.now().unix_time() / 2})!
		sp.write_packet(packet.HWIDCheck{hwid: hwid.hwid()})!
		
		hw_res := sp.expect_packet[packet.HWIDCheckResult]()!

		if !hw_res.valid {
			pretty.print_delay(color.red("| USERNAME >: "), time.millisecond * 10)
			user := os.input(color.reset)
			pretty.print_delay(color.red("| PASSWORD >: "), time.millisecond * 10)
			pass := os.input_password(color.reset)!

			sp.write_packet(packet.Login{password: pass, username: user})!

			hw_res2 := sp.expect_packet[packet.HWIDCheckResult]()!
			if !hw_res2.valid {
				pretty.print_delay(color.magenta("invalid credentials... closing in 5 seconds"), time.millisecond * 50)
				time.sleep(time.second * 5)
				exit(0)
			}
		}
		
		data := sp.expect_packet[packet.MessageData]()!
		msgs = data.messages.clone()
		break
	}

	ascii := color.red(base58.decode(msgs["ascii"])!)
	os.system("cls")
	pretty.println_delay(ascii, time.millisecond * 5)

	mut p := process.Process{}
	mut i := 1
	for {
		p = process.process_by_name('minecraft.windows.exe') or {
			if i >= 4 {
				i = 1
			}
			pretty.print_delay(color.red('\x1b[2K\r waiting for Minecraft to be opened${strings.repeat(`.`,
				i)}'),time.millisecond * 10)
			i++
			time.sleep(time.second)
			continue
		}
		print('\x1b[2K\r')
		break
	}

	mut cl := clicker.new_clicker()
	spawn cl.start()

	mut cmds := []command.Command{}
	cmds << command.Clear{
		ascii: ascii
	}
	cmds << command.Help{}
	cmds << command.Info{}
	cmds << command.new_clicker(cl)
	cmds << command.new_timer(p, voidptr(LPVOID_ALIAS(p.app_id) + 0x4175C30))
	cmds << command.new_reach(p, voidptr(LPVOID_ALIAS(p.app_id) + 0x4175B60))

	cmd_by_name := fn [mut cmds] (cmd string) !command.Command {
		for _, c in cmds {
			name := c.name().to_lower()
			if cmd.contains(name) {
				return c
			}
		}
		return error("unknown command '${cmd}'")
	}

	for {
		pretty.print_delay(color.magenta("|>: "), time.millisecond * 15)
		cmd := os.input(color.reset).to_lower()
		if cmd == "<eof>" {
			exit(0)
		}
		mut c := cmd_by_name(cmd) or {
			println(color.red(' ${err.msg()}'))
			continue
		}
		name := c.name()
		mut args := []string{}
		if mut c is command.Help {
			for _, child in cmds {
				args << ' ${child.name().to_upper()} - ${child.description().to_lower()}'
			}
		} else if mut c is command.Info {
			for _, child in cmds {
				if !(child is command.Valuable) {
					continue
				} else {
					v := child as command.Valuable
					args << ' ${child.name().to_upper()}: ${v.value()}'
				}
			}
		} else if mut c is command.Clear {
			// Do nothing
		} else {
			mut v := ""
			if c is command.Valuable {
				vc := c as command.Valuable
				v = vc.value()
			}
			args = os.input(color.magenta('- ${name.to_upper()} ${v}|>: ')).split(' ')
			if args[0] == 'exit' {
				continue
			}
		}
		c.run(args) or { println(' ${color.red(err.msg())}') }
	}
}