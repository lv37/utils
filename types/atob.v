module types

// Convert type A to type B
// Supports:
// any     -->  string
// $int    -->  $int
// $int    -->  $float
// $int    -->  $enum
// $int    -->  bool
// $float  -->  $int
// $float  -->  $float
// $float  -->  $enum
// $float  -->  bool
// $enum   -->  $int
// $enum   -->  $float
// $enum   -->  bool
// bool    -->  $int
// bool    -->  $float
// bool    -->  $enum
// string  -->  $int
// string  -->  $float
// string  -->  $enum
// map[A]B -->  map[X]Y
// $array  -->  $array
@[inline]
pub fn atob[A, B](a A) B {
	$if B !is A { // TODO: remove this when the compiler bug is fixed
		$if B !is string {
			$if B !is $int {
				$if B !is i32 {
					$if B !is $float {
						$if B !is $enum {
							$if B !is bool  {
								$if B !is $map {
									$if B !is $array {
										$compile_error('Incompatible type B')
									}
								}
							}
						}
					}
				}
			}
		}
	}
	$if B is $int { // TODO: remove this when the compiler bug is fixed
		$if A !is $int {
			$if A !is i32 {
				$if A !is $float {
					$if A !is $enum {
						$if A !is string {
							$compile_error('Incompatible type A')
						}
					}
				}
			}
		}
	}
	$if B is $float {
		$if A !is $int {
			$if A !is i32 {
				$if A !is $float {
					$if A !is $enum {
						$if A !is string {
							$compile_error('Incompatible type A')
						}
					}
				}
			}
		}
	}
	$if B is $enum {
		$if A !is $int {
			$if A !is i32 {
				$if A !is $float {
					$if A !is $enum {
						$if A !is string {
							$compile_error('Incompatible type A')
						}
					}
				}
			}
		}
	}
	$if B is bool {
		$if A !is $int {
			$if A !is i32 {
				$if A !is $float {
					$if A !is $enum {
						$if A !is string {
							$compile_error('Incompatible type A')
						}
					}
				}
			}
		}
	}
	$if B is $array_dynamic { // TODO: remove this when the compiler bug is fixed
		$if A !is $array_dynamic {
			$if A !is $array_fixed {
				$compile_error('Incompatible type A')
			}
		}
	}
	$if B is $array_fixed { // TODO: remove this when the compiler bug is fixed
		$if A !is $array_dynamic {
			$if A !is $array_fixed {
				$compile_error('Incompatible type A')
			}
		}
	}

	$if A is B {
		return a
	} $else $if B is string {
		return a.str()
	} $else $if B is $int || B is i32 || B is $float || B is $enum || B is bool {
		$if A is $int || A is i32 || A is $float || A is $enum { return unsafe { B(a) } }
		$else $if A is string {
			return string_to[B](a)
		}
	} $else $if B is $map && A is $map {
		return map_to_map[A, B](a)
	} $else $if B is $array_dynamic {
		mut b := B{ len: a.len }
		$if A is $array_dynamic  {
			if a.len == 0 { return b }
			array_dynamic_to_array_dynamic(a, mut b)
			return b
		} $else $if A is $array_fixed {
			array_fixed_to_array_dynamic(a, mut b)
			return b
		}
	} $else $if B is $array_fixed {
		mut b := B{}
		d := b[0]
		array_to_array_fixed(a, mut b, d)
		return b
	}
	return B{}
}

// TODO: Redo this when the compiler becomes more stable
fn map_to_map[A, B](a A) B {
	$if A !is $map { $compile_error('A must be a \$map type') }
	$if B !is $map { $compile_error('B must be a \$map type') }
	b := B{}
	return map_to_map_two(A(a), b)
}

fn map_to_map_two[A, B, X, Y](a map[A]B, _ map[X]Y) map[X]Y {
	$if A is X {
		$if B is Y {
			return a
		} $else {
			mut out := map[X]Y{}
			for k, v in a {
				out[k] = atob[B, Y](v)
			}
			return out
		}
	} $else {
		mut out := map[X]Y{}
		$if B is Y {
			for k, v in a {
				out[atob[A, X](k)] = v
			}
		} $else {
			for k, v in a {
				out[atob[A, X](k)] = atob[B, Y](v)
			}
		}
		return out
	}
	return map[X]Y{}
}

// string  -->  $int
// string  -->  $float
// string  -->  string
// string  -->  $enum
// string  -->  bool
@[inline]
fn string_to[T](a string) T {
	$if T is string { return a }
	$else $if T is u8 { return a.u8() }
	$else $if T is i8 { return a.i8() }
	$else $if T is u16 { return a.u16() }
	$else $if T is i16 { return a.i16() }
	$else $if T is u32 { return a.u32() }
	$else $if T is i32 { return T(a.int()) }
	$else $if T is int { return a.int() }
	$else $if T is u64 { return a.u64() }
	$else $if T is usize { return T(a.u64()) }
	$else $if T is i64 { return a.i64() }
	$else $if T is isize { return T(a.i64()) }
	$else $if T is f32 { return a.f32() }
	$else $if T is f64 { return a.f64() }
	$else $if T is bool { return a.bool() }
	$else $if T is $enum {
		$for v in T.values {
			if v.name == a {
				return v.value
			}
		}
	} $else $if T is $int || T is float { return T(0) }
	return T{}
}

@[inline]
fn atob_wrapper[A, B](a A, _ B) B {
	return atob[A, B](a)
}

fn array_dynamic_to_array_dynamic[A, B](a []A, mut b []B) {
	b = a.map(|v| atob[A, B](v))
}

fn array_fixed_to_array_dynamic[A, B](a A, mut b []B) {
	for i, e in a {
		d := B{}
		b[i] = atob_wrapper(e, d)
	}
}

fn array_to_array_fixed[A, B, D](a A, mut b B, d D) {
	for i, e in a {
		b[i] = atob_wrapper(e, d)
	}
}