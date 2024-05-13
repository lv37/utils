module scanner

import io
import os
import v.debug

struct SeekReader {
mut:
	reader    io.Reader
	read_data []u8       = []u8{cap: 1024 * 512}
	read_fn   fn (mut io.Reader, mut []u8) !int = unsafe { nil }
	eof       bool
	pos       int
}

@[params]
struct SeekReaderCfg {
mut:
	reader    ?io.Reader
	read_data []u8 = []u8{cap: 1024 * 512}
	read_fn   fn (mut []u8) !int = unsafe { nil }
	pos       int
}

fn SeekReader.new(cfg SeekReaderCfg) SeekReader {
	mut out := SeekReader{}
	if cfg.reader != none {
		out.reader = cfg.reader or { panic('never') }
		out.read_fn = fn (mut o io.Reader, mut buf []u8) !int {
			return o.read(mut buf)
		}
	} else {
		out.read_fn = fn (mut o io.Reader, mut buf []u8) !int {
			return EOF{}
		}
	}
	out.read_data = cfg.read_data
	out.pos = cfg.pos
	return out
}

@[direct_array_access; inline]
fn (mut o SeekReader) read(mut buf []u8) !int {
	if o.eof {
		return EOF{}
	}
	if o.pos < o.read_data.len {
		if o.read_data.len < o.pos + buf.len {
			mut i := 0
			for o.pos < o.read_data.len {
				buf[i] = o.read_data[o.pos]
				i++
				o.pos++
			}
			mut b := []u8{len: o.read_data.len - o.pos}
			z := o.read_fn(mut o.reader, mut buf) or { return i }
			for j in 0 .. z {
				buf[i + j] = b[j]
			}
			return z + i
		} else {
			buf = o.read_data[o.pos..o.pos + buf.len]
			o.pos += buf.len
			return buf.len
		}
	}
	s := o.read_fn(mut o.reader, mut buf)!
	o.pos += buf.len
	return s
}

fn (mut o SeekReader) seek(pos i64, mode os.SeekMode) ! {
	p := match mode {
		.start { int(pos) }
		.current { o.pos + pos }
		.end { o.read_data.len + pos }
	}
	o.pos = p
	if p > o.read_data.len {
		mut buf := []u8{len: p - o.read_data.len}
		o.read_fn(mut o.reader, mut buf)!
		o.read_data << buf
	}
}

fn (mut o SeekReader) tell() !i64 {
	return o.pos
}
