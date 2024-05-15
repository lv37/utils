module scanner

import os
import io

@[inline]
pub fn stdin(cfg ScannerCfg) &Scanner {
	mut f := os.stdin()
	return Scanner.new(mut f, cfg)
}

@[inline]
pub fn stdout(cfg ScannerCfg) &Scanner {
	mut f := os.stdout()
	return Scanner.new(mut f, cfg)
}

@[inline]
pub fn stderr(cfg ScannerCfg) &Scanner {
	mut f := os.stderr()
	return Scanner.new(mut f, cfg)
}

@[inline]
pub fn reader(mut r io.Reader, cfg ScannerCfg) &Scanner {
	return Scanner.new(mut r, cfg)
}

@[inline]
pub fn file[T](t T, cfg ScannerCfg) !&Scanner {
	$if T is string {
		mut f := os.open(t)!
		return Scanner.new(mut f, cfg)
	} $else $if T is io.Reader {
		return Scanner.new(t, cfg)
	} $else {
		$compile_error('T must be of type string, or must implement the io.Reader interface (e.g: os.File)')
	}
}

@[inline]
pub fn text(t string, _ ScannerCfg) &Scanner {
	mut a := SeekReader.new(read_data: t.bytes())
	mut s := &Scanner{
		reader: &FlushNothing{&a}
	}
	s.char_iter.scanner = s
	return s
}
