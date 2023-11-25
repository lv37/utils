module types

// Convert type A to type B
// Supports:
// $int    -->  $int
// $int    -->  $float
// $int    -->  $enum
// $float  -->  $int
// $float  -->  $float
// string  -->  $int
// string  -->  $float
// string  -->  $enum
// any     -->  string
@[inline]
pub fn atob[A, B](a A) B {
	$if A is B {
		return a
	} $else $if B is $int || B is $float {
		$if A is $int || A is $float { return B(a) }
		$else $if A is string {
			return $if B is u8 { a.u8() }
			$else $if B is i8 { a.i8() }
			$else $if B is u16 { a.u16() }
			$else $if B is i16 { a.i16() }
			$else $if B is u32 { a.u32() }
			$else $if B is i32 || B is int { B(a.int()) }
			$else $if B is u64 || B is usize { B(a.u64()) }
			$else $if B is i64 || B is isize { B(a.i64()) }
			$else $if B is f32 { a.f32() }
			$else $if B is f64 { a.f64() }
			$else $if B is bool { a.bool() }
			$else { B(0) }
		} $else { $compile_error('Incompatible type A') }
	} $else $if B is string {
		return a.str()
	} $else $if B is $enum {
		$if A is string {
			$for v in B.values {
				if v.name == a {
					return v.value
				}
			}
		} $else $if A is $int {
			return unsafe { B(a) }
		} $else { $compile_error('Incompatible type A') }
		
	} $else {
		$compile_error('Incompatible type B')
	}
	return B{}
}