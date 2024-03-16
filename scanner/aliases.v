module scanner

import os
import io

@[inline]
pub fn stdin(cfg ScannerCfg) &Scanner {
	return Scanner.new(os.stdin(), cfg)
}

@[inline]
pub fn stdout(cfg ScannerCfg) &Scanner {
	return Scanner.new(os.stdout(), cfg)
}

@[inline]
pub fn stderr(cfg ScannerCfg) &Scanner {
	return Scanner.new(os.stderr(), cfg)
}

@[inline]
pub fn reader(r io.Reader, cfg ScannerCfg) &Scanner {
	return Scanner.new(r, cfg)
}

@[inline]
pub fn file[T](t T, cfg ScannerCfg) !&Scanner {
	$if T is string {
		return Scanner.new(os.open(t)!, cfg)
	} $else $if T is io.Reader {
		return Scanner.new(t, cfg)
	} $else {
		$compile_error('T must be of type string, or must implement the io.Reader interface (e.g: os.File)')
	}
}

@[inline]
pub fn text(t string, _ ScannerCfg) &Scanner {
	mut s := &Scanner{
		reader: FlushNothing{SeekReader.new(read_data: t.bytes())}
	}
	s.char_iter.scanner = s
	return s
}
