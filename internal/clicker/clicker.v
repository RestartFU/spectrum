module clicker

import time
import crypto.rand
import restartfu.windows

fn rand_int(min int, max int) int {
	n := rand.int_u64(u64(max - min)) or { return 0 }
	return int(n) + max
}

[heap]
pub struct Clicker {
	mut:
	ms_hook windows.MouseHook
	kb_hook windows.KeyboardHook
	minecraft_window voidptr = windows.find_window(unsafe { nil },"Minecraft".to_wide())

	mouse_down  bool
	first_click bool
	toggled     bool

	last_click time.Time = time.now()

	pub mut:
	max int = 20
	min int = 10
	toggle u32 = 0x79
}

pub fn new_clicker() &Clicker {
	mut c := &Clicker{}

	spawn fn [mut c](){
		c.minecraft_window = windows.find_window(unsafe { nil },"Minecraft".to_wide())
		time.sleep(time.second * 10)
	}()

	c.ms_hook = windows.MouseHook{
		handler: fn [mut c] (d windows.MouseData) {
			if d.action != windows.wm_mousemove && d.flags == 0 {
				if d.action == 0x201 {
					c.first_click = true
					c.mouse_down = true
				} else if d.action == 0x202 {
					c.mouse_down = false
				}
			}
		}
	}

	c.kb_hook = windows.KeyboardHook{
		handler: fn [mut c] (d windows.KeyboardData) {
			if d.action == windows.wm_keyup && d.vk_code == c.toggle {
				c.toggled = !c.toggled
			}
		}
	}

	return c
}

pub fn (mut c Clicker) start() {
	c.ms_hook.hook()
	c.kb_hook.hook()

	defer {
		c.ms_hook.unhook()
		c.kb_hook.unhook()
	}

	spawn fn [mut c](){
		for {
			if c.toggled && c.mouse_down {
				if c.first_click {
					time.sleep(30 * time.millisecond)
					c.first_click = false
				} else if time.now() - c.last_click > (1000 / rand_int(c.min, c.max)) * time.millisecond && windows.get_foreground_window() == c.minecraft_window{
					windows.send_mouse_input(0x004)
					windows.send_mouse_input(0x002)
					c.last_click = time.now()
				}
			}
			time.sleep(1 * time.millisecond)
		}
	}()
	windows.dispatch_messages()
}

