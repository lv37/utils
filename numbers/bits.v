@[translated]
module numbers

pub fn bits[U, T](n T) U {
	$if U !is $array { $compile_error('U must be an array type') }
	$if T is bool { return [n] }
	$else $if T !is $int { $compile_error('T must be an integer type') }
	$else {
		mut out := U(unsafe { nil }) // workaround for compiler bug
		$if U is $array_fixed {
			out = U{}
		} $else {
			out = U{ len: int(sizeof[T]()) * 8 }
		}
		mask := T(1 << (out.len - 1))
		mut nc := n
		for i in 0..out.len {
			out[i] = nc & mask != 0
			nc <<= 1
		}
		return out
	}
	return U{}
}