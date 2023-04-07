module command

import pkg.color

pub struct Info {}
pub fn (_ Info) name() string {
	return "info"
}

pub fn (_ Info) description() string {
	return "displays information about cheat settings."
}

pub fn (mut _ Info) run(args []string) ! {
	println(color.magenta("${args.join("\n")}"))
}