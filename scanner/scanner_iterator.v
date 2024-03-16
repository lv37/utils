module scanner

struct ScannerCharIterator {
mut:
	scanner &Scanner = unsafe { nil }
}

fn (mut sci ScannerCharIterator) next() ?u8 {
	return sci.scanner.next_char() or { none }
}

struct ScannerNumberIterator[T] {
mut:
	scanner &Scanner = unsafe { nil }
}

fn (mut sci ScannerNumberIterator[T]) next() ?T {
	return sci.scanner.next_num[T]() or { return none }
}

interface ScannerBoolIteratorInt {
mut:
	next() ?bool
}

struct ScannerBoolIterator {
	cfg ScannerNextBoolCfg
mut:
	scanner &Scanner = unsafe { nil }
}

pub fn (mut sci ScannerBoolIterator) next() ?bool {
	return sci.scanner.next_bool(sci.cfg) or { return none }
}

struct ScannerStringIterator[T] {
	cfg NextStringCfg
	end T
mut:
	scanner &Scanner = unsafe { nil }
}

pub fn (mut sci ScannerStringIterator[T]) next() ?string {
	s, _ := sci.scanner.next_string[T](sci.end, sci.cfg) or { return none }
	return s
}
