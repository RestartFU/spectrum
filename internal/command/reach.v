module command

import restartfu.windows.process

struct Reach {
	p process.Process
	addr voidptr
	mut:
	val f32 = 3
}

pub fn new_reach(p process.Process, addr voidptr) Reach {
	return Reach{
		p: p,
		addr: addr
	}
}

pub fn (r Reach) name() string {
	return "reach"
}

pub fn (mut r Reach) run(args []string) ! {
	if args.len <= 0 {
		return error("not enough arguments were provided (1 needed)")
	}
	v := args[0].f32()
	if v <= 0 {
		return error("value needs to be at least greater than 1")
	}
	r.val = v
	r.write()
}


pub fn (_ Reach) description() string {
	return "hurt entities from a distance."
}

pub fn (r Reach) value() string {
	return r.val.strlong()
}

fn (r Reach) write() bool {
	ok, _ := r.p.write_memory(r.addr, &r.val, 8)
	return ok
}

fn (r Reach) read(v &f64) {

}