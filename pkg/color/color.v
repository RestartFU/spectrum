module color

pub const (
	reset = "\033[0m"
)

pub fn black(s string) string {
	return "\033[30m${s}${reset}"
}
pub fn red(s string) string {
	return "\033[31m${s}${reset}"
}
pub fn green(s string) string {
	return "\033[32m${s}${reset}"
}
pub fn orange(s string) string {
	return "\033[33m${s}${reset}"
}
pub fn blue(s string) string {
	return "\033[34m${s}${reset}"
}
pub fn magenta(s string) string {
	return "\033[35m${s}${reset}"
}
pub fn cyan(s string) string {
	return "\033[36m${s}${reset}"
}
