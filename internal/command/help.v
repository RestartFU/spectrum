module command

import pkg.color

pub struct Help {}
pub fn (_ Help) name() string {
	return "help"
}

pub fn (_ Help) description() string {
	return "displays a list of available commands and cheats."
}

pub fn (mut _ Help) run(args []string) ! {
	println(color.magenta("${args.join("\n")}"))
}