module arrays

// return an error if the callback returns one
pub fn map_opt[A, B](a []A, cb fn (v A) !B) ![]B {
	mut b := []B{ cap: a.len }
	for e in a {
		b << cb(e)!
	}
	return b
}