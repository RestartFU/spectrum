module command

import restartfu.windows.process

struct Timer {
	p process.Process
	addr voidptr
mut:
	val f64 = 1
}

pub fn new_timer(p process.Process, addr voidptr) Timer {
	return Timer{
		p: p,
		addr: addr
	}
}
pub fn (t Timer) name() string {
	return "timer"
}

pub fn (mut t Timer) run(args []string) ! {
	if args.len <= 0 {
		return error("not enough arguments were provided (1 needed)")
	}
	v := args[0].f64()
	if v <= 0 {
		return error("value needs to be at least greater than 1")
	}
	t.val = v
	t.write()
}


pub fn (_ Timer) description() string {
	return "everything goes faster."
}

pub fn (t Timer) value() string {
	return t.val.strlong()
}

fn (t Timer) write() bool {
	v := t.val * 1000
	ok, _ := t.p.write_memory(t.addr, &v, 8)
	return ok
}

fn (t Timer) read(v &f64) {

}