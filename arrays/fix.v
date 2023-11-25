module arrays

// Convert a dynamic array into a fixed array
// or change the length of a fixed array
pub fn fix_array[A, B](a A) B {
	$if A !is $array {
		$compile_error('A must be an array type')
	}
	$if B !is $array_fixed {
		$compile_error('B must be a fixed array type')
	}

	mut b := B{}
	len := if a.len > b.len { b.len } else { a.len }
	for i in 0 .. len {
		b[i] = a[i]
	}
	return b
}

// Convert a fixed array into a dynamic array
pub fn unfix_array[A, B](a A) B {
	$if A !is $array_fixed {
		$compile_error('A must be a fixed array type')
	}
	$if B !is $array_dynamic {
		$compile_error('B must be a dynamic array type')
	}

	mut b := B{
		len: a.len
	}
	for i in 0 .. a.len {
		b[i] = a[i]
	}
	return b
}
