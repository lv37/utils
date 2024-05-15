module scanner

import io

struct ProcessReader {
mut:
	process &Process
	red     []u8
}

@[inline]
fn (mut pr ProcessReader) read(mut buf []u8) !int {
	if pr.red.len == buf.len {
		buf = pr.red.clone()
		pr.red = []
		return buf.len
	}
	if pr.red.len > buf.len {
		buf = pr.red[0..buf.len].clone()
		pr.red = pr.red[buf.len..pr.red.len].clone()
		return buf.len
	}
	bytes := pr.process.stdout_slurp().bytes()
	if pr.red.len == 0 {
		if bytes.len == 0 {
			return io.Eof{}
		}
		if bytes.len == buf.len {
			buf = bytes.clone()
		} else if bytes.len > buf.len {
			buf = bytes[0..buf.len].clone()
			pr.red = bytes[buf.len..bytes.len].clone()
		} else if bytes.len < buf.len {
			for i in 0 .. bytes.len {
				buf[i] = bytes[i]
			}
		}
		return buf.len
	} else if pr.red.len > buf.len {
		buf = pr.red[0..pr.red.len].clone()
		pr.red = pr.red[buf.len..pr.red.len].clone()
	} else if pr.red.len == buf.len {
		buf = pr.red.clone()
		pr.red = []
	}
	for i in 0 .. pr.red.len {
		buf[i] = pr.red[i]
	}
	len := buf.len - pr.red.len
	if bytes.len > len {
		for i in pr.red.len .. len {
			buf[i] = bytes[i]
		}
		pr.red = []
		return buf.len
	} else {
		for i in pr.red.len .. len {
			buf[i] = bytes[i]
		}
		s := pr.red.len + bytes.len
		pr.red = []
		return s
	}
}
