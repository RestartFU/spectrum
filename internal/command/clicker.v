module command

import internal.clicker

struct Clicker {
	mut:
	c &clicker.Clicker
}

pub fn new_clicker(c &clicker.Clicker) Clicker {
	return Clicker{c: c}
}

pub fn (c Clicker) name() string {
	return "clicker"
}

pub fn (mut c Clicker) run(args []string) ! {
	if args.len < 2 {
		return error("not enough arguments were provided (2 needed)")
	}
	mut min := args[0].int()
	mut max := args[1].int()

	if min <= 0 {
		return error("value min needs to be at least greater than 1")
	}
	if max <= 0 {
		return error("value max needs to be at least greater than 1")
	}

	if min > max {
		max = min + 1
	}

	c.c.min = min
	c.c.max= max
}


pub fn (_ Clicker) description() string {
	return "click automatically while holding left click, when toggled."
}

pub fn (c Clicker) value() string {
	return "(F10) ${c.c.min} - ${c.c.max}"
}