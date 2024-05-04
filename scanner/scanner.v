module scanner

import io
import strconv
import os

interface Scannable {
mut:
	flush()
	read(mut buf []u8) !int
	seek(pos i64, mode os.SeekMode) !
	tell() !i64
}

struct FlushNothing {
mut:
	r ReadSeek
}

@[inline]
fn (mut f FlushNothing) read(mut buf []u8) !int {
	return f.r.read(mut buf)
}

@[inline]
fn (mut f FlushNothing) seek(pos i64, mode os.SeekMode) ! {
	return f.r.seek(pos, mode)
}

@[inline]
fn (mut f FlushNothing) tell() !i64 {
	return f.r.tell()
}

@[inline]
fn (_ FlushNothing) flush() {}

interface ReadSeek {
mut:
	read(mut buf []u8) !int
	seek(pos i64, mode os.SeekMode) !
	tell() !i64
}

@[heap; noinit]
pub struct Scanner {
	size_limit int = 1024 * 1024 * 1
mut:
	buf          []u8 = []u8{len: 1}
	pos          i64
	eof_char     u8
	eof_char_pos i64 = -1
pub mut:
	reader    Scannable
	char_iter ScannerCharIterator = ScannerCharIterator{
		scanner: unsafe { nil }
	}
}

@[params]
pub struct ScannerCfg {
pub:
	cap        int = 2048
	size_limit int = 1024 * 1024 * 1
}

// Accepts os.File or a file path string
@[inline]
pub fn Scanner.new[T](r T, cfg ScannerCfg) &Scanner {
	$if T !is ReadSeek {
		$if T !is io.Reader {
			$if T !is Scannable {
				$compile_error('Incompatible type T')
			}
		}
	}
	mut a := Scannable(os.File{})
	$if T is Scannable {
		a = Scannable(r)
	} $else $if T is ReadSeek {
		Scannable(FlushNothing{
			r: ReadSeek(r)
		})
	} $else $if T is io.Reader {
		z := io.Reader(r)
		a = Scannable(FlushNothing{
			r: ReadSeek(SeekReader{
				reader: &z
			})
		})
	} $else {
		a = Scannable(os.File{})
	}
	mut s := &Scanner{
		reader: a
	}
	s.char_iter.scanner = s
	return s
}

@[inline]
pub fn (o &Scanner) clone() &Scanner {
	mut clone := &Scanner{
		...o
	}
	clone.char_iter.scanner = clone
	return clone
}

@[inline]
pub fn (o &Scanner) num_iter[T]() ScannerNumberIterator[T] {
	return ScannerNumberIterator[T]{
		scanner: o
	}
}

@[inline]
pub fn (mut o Scanner) flush() {
	o.seek(0, .current)
	o.reader.flush()
}

// Get end position
@[inline]
pub fn (mut o Scanner) end() !i64 {
	current_pos := o.reader.tell()!
	o.seek(0, .end)
	end_pos := o.reader.tell()!
	o.seek(current_pos, .start)
	return end_pos
}

@[inline]
pub fn (mut o Scanner) seek(pos i64, mode os.SeekMode) {
	mut p := match mode {
		.start { pos }
		.current { o.tell() + pos }
		.end { o.end() or { return } + pos }
	}
	if p < 0 {
		p = 0
	}
	o.reader.seek(pos, mode) or {}
	o.pos = p
}

@[inline]
pub fn (mut o Scanner) tell() i64 {
	return o.pos
}

@[inline]
pub fn (mut o Scanner) tell_end() !i64 {
	current_pos := o.reader.tell()!
	o.seek(0, .end)
	end_pos := o.reader.tell()!
	o.seek(current_pos, .start)
	return end_pos - current_pos
}

// alias for o.seek(o.read_data.len)!
@[inline]
pub fn (mut o Scanner) seek_end() ! {
	o.seek(0, .end)
}

// alias for o.seek(0)!
@[inline]
pub fn (mut o Scanner) seek_start() ! {
	o.seek(0, .start)
}

// @[noinit; params]
// struct ScannerNext

@[direct_array_access; inline]
pub fn (mut o Scanner) next_char() !u8 {
	if o.eof_char_pos == o.tell() {
		o.eof_char_pos = -1
		return o.eof_char
	}
	o.reader.read(mut o.buf)!
	o.pos++
	return o.buf[0]
}

@[minify; params]
pub struct NextStringCfg {
pub:
	end_offset   int
	error_on_eof bool
}

// returns at end_char or eof. Returns error
@[direct_array_access]
pub fn (mut o Scanner) next_string[T](end T, cfg NextStringCfg) !(string, int) {
	$if T !is rune {
		$if T !is u8 {
			$if T !is []u8 {
				$if T !is string {
					$if T !is []rune {
						$compile_error('T must be of type u8, []u8, []rune or string')
					}
				}
			}
		}
	}
	o.eof()!
	mut out := ''
	mut cond := false
	mut idx := -1
	for c in o.char_iter {
		out += c.ascii_str()
		$if T is rune {
			idx = 0
			cond = c == end
		} $else $if T is u8 {
			idx = 0
			cond = c == end
		} $else $if T is []u8 {
			idx = end.index(c)
			cond = idx != -1
		} $else $if T is string {
			idx = end.index_u8(c)
			cond = idx != -1
		} $else $if T is []rune {
			idx = end.index(c)
			cond = idx != -1
		}
		if cond {
			if cfg.end_offset == 0 {
				return out, idx
			}
			if cfg.end_offset > 0 {
				for _ in 0 .. cfg.end_offset {
					out += o.next_char() or { break }.ascii_str()
				}
				return out, idx
			}
			e := cfg.end_offset + out.len
			if e > 0 {
				return out[..e], idx
			}
			return '', idx
		}
	}
	return if cfg.error_on_eof {
		EOF{}
	} else {
		out, idx
	}
}

@[inline]
pub fn (o &Scanner) string_iter[T](end T, cfg NextStringCfg) ScannerStringIterator[T] {
	return ScannerStringIterator[T]{
		scanner: o
		cfg: cfg
		end: end
	}
}

// returns at newline or eof
@[inline]
pub fn (mut o Scanner) next_line() !string {
	s, _ := o.next_string(`\n`, end_offset: -1)!
	return s
}

@[inline]
pub fn (mut o Scanner) eof() ! {
	if o.eof_char_pos == o.tell() {
		return
	}
	o.reader.read(mut o.buf)!
	o.eof_char = o.buf[0]
	o.eof_char_pos = o.tell()
}

@[params]
pub struct ScannerNextBoolCfg {
	case_sensitive bool
	true_words     []string = ['true']
	false_words    []string = ['false']
}

pub enum ScannerNextBoolCfgCase as u8 {
	insensitive
	first_cap
	all_cap
	no_cap
}

@[params]
pub struct FindCfg {
	case_sensitive bool = true
}

pub fn (mut o Scanner) find_first(substrs []string, cfg FindCfg) !int {
	start := o.tell()
	mut i := 0
	if cfg.case_sensitive {
		for {
			mut c := o.next_char()!
			for j, s in substrs {
				for {
					if c != s[i] {
						i = 0
						break
					}
					c = o.next_char()!
					i++
					if i >= s.len {
						return j
					}
				}
			}
		}
	} else {
		for {
			mut c := strconv.byte_to_lower(o.next_char() or { break })
			for j, s in substrs {
				for {
					if c != strconv.byte_to_lower(s[i]) {
						i = 0
						break
					}
					i++
					if i >= s.len {
						return j
					}
					c = strconv.byte_to_lower(o.next_char()!)
				}
			}
		}
	}
	o.seek(start, .start)
	return EOF{}
}

pub fn (mut o Scanner) next_bool(cfg ScannerNextBoolCfg) !bool {
	// start_pos := o.tell()
	mut all_words := cfg.true_words.clone()
	all_words << cfg.false_words

	mut i := o.find_first(all_words, case_sensitive: cfg.case_sensitive)!
	return i < cfg.true_words.len
}

pub fn (o &Scanner) bool_iter(cfg ScannerNextBoolCfg) ScannerBoolIterator {
	return ScannerBoolIterator{
		cfg: cfg
		scanner: o
	}
}

// supports $int, $float and bool
@[inline]
pub fn (mut o Scanner) next_num[T]() !T {
	$if T !is $int {
		$if T !is i32 {
			$if T !is $float {
				$if T !is bool {
					$compile_error('T must be of type \$int or \$float')
				}
			}
		}
	}
	$if T is bool {
		start_pos := o.tell()
		for c in o.char_iter {
			if c == `1` {
				return true
			}
			if c == `0` {
				return false
			}
		}
		o.seek(start_pos)
		return EOF{
			msg: 'Reached EOF without finding a number'
		}
	} $else {
		return o.next_num_int_float[T]()!
	}
}

pub fn (mut o Scanner) next_num_int_float[T]() !T {
	mut out := T(0)
	mut dec := T(0)
	mut sig := T(1)
	mut dec_e := -1
	mut ns := NumberScanner{}
	start_pos := o.tell()

	for c in o.char_iter {
		match c {
			48...57 {
				if ns.dot {
					$if T is $float {
						dec += T(c - 48) * pow10[T, int](dec_e)
						ns.pos++
						dec_e--
						continue
					} $else {
						continue
					}
				}
				out *= 10
				out += T(c - 48)
				ns.pos++
			}
			`-` {
				if _unlikely_(ns.neg_pos >= 0) {
					if ns.neg_pos + 1 == o.tell() {
						ns.neg_pos = o.tell()
						sig *= -1
					} else {
						$if T is $float {
							return sig * (out + dec)
						} $else {
							return sig * out
						}
					}
				} else if ns.pos == 0 {
					sig *= -1
				} else {
					$if T is $float {
						// o.pos--
						o.seek(-1, .current)
						return sig * (out + dec)
					} $else {
						// o.pos--
						o.seek(-1, .current)
						return sig * out
					}
				}
			}
			`.` {
				if _unlikely_(ns.dot) {
					$if T is $float {
						return sig * (out + dec)
					} $else {
						return sig * out
					}
				}
				if ns.pos != 0 {
					ns.dot = true
				}
			}
			else {
				if _unlikely_(ns.pos > 0) {
					$if T is $float {
						// o.pos--
						o.seek(-1, .current)
						return sig * (out + dec)
					} $else {
						// o.pos--
						o.seek(-1, .current)
						return sig * out
					}
				} else {
					sig = 1
				}
			}
		}
	}
	if _unlikely_(ns.pos == 0) {
		o.seek(start_pos, .start)
		return EOF{}
	}
	$if T is $float {
		return sig * (out + dec)
	} $else {
		return sig * out
	}
	return T(0)
}

@[noinit]
pub struct EOF {
	Error
	msg string
}

pub fn (e EOF) msg() string {
	return e.msg.str()
}

struct NumberScanner {
mut:
	neg_pos i64 = -1
	pos     int
	dot     bool
}
