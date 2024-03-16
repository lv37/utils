@[translated]
module numbers

import types

pub fn bits[U, T](n T) U {
	$if U !is $array {
		$compile_error('U must be an array type')
	}
	$if T is bool {
		$if U is $array_fixed {
			mut out := U{}
			types.atob_mut(n, mut out[out.len - 1])
			return out
		} $else {
			mut out := U{
				len: 1
			}
			types.atob_mut(n, mut out[0])
			return out
		}
	} $else $if T !is $int {
		$compile_error('T must be an integer type')
	} $else {
		$if U is $array_fixed {
			mut out := U{}
			mask := T(1 << (out.len - 1))
			mut nc := n
			for i in 0 .. out.len {
				out[i] = nc & mask != 0
				nc <<= 1
			}
			return out
		} $else {
			mut out := U{
				len: int(sizeof[T]()) * 8
			}
			mask := T(1 << (out.len - 1))
			mut nc := n
			for i in 0 .. out.len {
				out[i] = nc & mask != 0
				nc <<= 1
			}
			return out
		}
	}
	return U{}
}
