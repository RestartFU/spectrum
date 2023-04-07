module command

type LPVOID_ALIAS = voidptr

pub interface Command {
	name() string
	description() string
	mut:
	run(args []string) !
}
