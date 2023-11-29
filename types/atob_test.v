module types

enum Abc {
	zero
	one
}

// Convert type A to type B
// Supports:
// any     -->  string
// $int    -->  $int
// $int    -->  $float
// $int    -->  $enum
// $int    -->  bool
// $float  -->  $int
// $float  -->  $float
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
fn test_atob_int_to_int() {
	assert atob[usize, int](123) == int(123)
	assert atob[isize, int](123) == int(123)
	assert atob[int, string](123) == '123'
	assert atob[int, u8](123) == u8(123)
	assert atob[int, i8](123) == i8(123)
	assert atob[int, u16](123) == u16(123)
	assert atob[int, i16](123) == i16(123)
	assert atob[int, u32](123) == u32(123)
	assert atob[int, i32](123) == i32(123)
	assert atob[i32, int](123) == int(123)
	assert atob[int, u64](123) == u64(123)
	assert atob[int, i64](123) == i64(123)
	assert atob[int, usize](123) == usize(123)
	assert atob[int, isize](123) == isize(123)
}

fn test_atob_int_to_float() {
	assert atob[int, f32](123) == f32(123)
	assert atob[int, f64](123) == f64(123)
}

fn test_atob_int_to_enum() {
	assert atob[int, Abc](0) == .zero
	assert atob[int, Abc](1) == .one
}

fn test_atob_int_to_bool() {
	assert atob[int, bool](0) == false
	assert atob[int, bool](1) == true
}

fn test_atob_f32_to_int() {
	assert atob[f32, string](123) == '123.0'
	assert atob[f32, u8](123) == u8(123)
	assert atob[f32, i8](123) == i8(123)
	assert atob[f32, u16](123) == u16(123)
	assert atob[f32, i16](123) == i16(123)
	assert atob[f32, u32](123) == u32(123)
	assert atob[f32, i32](123) == i32(123)
	assert atob[i32, f32](123) == f32(123)
	assert atob[f32, u64](123) == u64(123)
	assert atob[f32, i64](123) == i64(123)
	assert atob[f32, usize](123) == usize(123)
	assert atob[f32, isize](123) == isize(123)
	assert atob[f32, int](123) == int(123)
}

fn test_atob_f32_to_f64() {
	assert atob[f32, f64](123) == f64(123)
}

fn test_atob_f32_to_enum() {
	assert atob[f32, Abc](0) == .zero
	assert atob[f32, Abc](1) == .one
}

fn test_atob_f32_to_bool() {
	assert atob[f32, bool](0) == false
	assert atob[f32, bool](1) == true
}

fn test_atob_f64_to_int() {
	assert atob[f64, string](123) == '123.0'
	assert atob[f64, u8](123) == u8(123)
	assert atob[f64, i8](123) == i8(123)
	assert atob[f64, u16](123) == u16(123)
	assert atob[f64, i16](123) == i16(123)
	assert atob[f64, u32](123) == u32(123)
	assert atob[f64, i32](123) == i32(123)
	assert atob[i32, f64](123) == f64(123)
	assert atob[f64, u64](123) == u64(123)
	assert atob[f64, i64](123) == i64(123)
	assert atob[f64, usize](123) == usize(123)
	assert atob[f64, isize](123) == isize(123)
	assert atob[f64, int](123) == int(123)
}

fn test_atob_f64_to_f32() {
	assert atob[f64, f32](123) == f32(123)
}

fn test_atob_f64_to_enum() {
	assert atob[f64, Abc](0) == .zero
	assert atob[f64, Abc](1) == .one
}

fn test_atob_f64_to_bool() {
	assert atob[f64, bool](0) == false
	assert atob[f64, bool](1) == true
}

fn test_atob_enum_to_string() {
	assert atob[Abc, string](Abc.zero) == 'zero'
	assert atob[Abc, string](Abc.one) == 'one'
}

fn test_atob_enum_to_float() {
	assert atob[Abc, f32](Abc.zero) == f32(0)
	assert atob[Abc, f32](Abc.one) == f32(1)
	assert atob[Abc, f64](Abc.zero) == f64(0)
	assert atob[Abc, f64](Abc.one) == f64(1)
}

fn test_atob_enum_to_int() {
	assert atob[Abc, u8](Abc.zero) == u8(0)
	assert atob[Abc, i8](Abc.zero) == i8(0)
	assert atob[Abc, u16](Abc.zero) == u16(0)
	assert atob[Abc, i16](Abc.zero) == i16(0)
	assert atob[Abc, u32](Abc.zero) == u32(0)
	assert atob[Abc, i32](Abc.zero) == i32(0)
	assert atob[Abc, int](Abc.zero) == int(0)
	assert atob[Abc, u64](Abc.zero) == u64(0)
	assert atob[Abc, i64](Abc.zero) == i64(0)
	assert atob[Abc, usize](Abc.zero) == usize(0)
	assert atob[Abc, isize](Abc.zero) == isize(0)
	assert atob[Abc, u8](Abc.one) == u8(1)
	assert atob[Abc, i8](Abc.one) == i8(1)
	assert atob[Abc, u16](Abc.one) == u16(1)
	assert atob[Abc, i16](Abc.one) == i16(1)
	assert atob[Abc, u32](Abc.one) == u32(1)
	assert atob[Abc, i32](Abc.one) == i32(1)
	assert atob[Abc, int](Abc.one) == int(1)
	assert atob[Abc, u64](Abc.one) == u64(1)
	assert atob[Abc, i64](Abc.one) == i64(1)
	assert atob[Abc, usize](Abc.one) == usize(1)
	assert atob[Abc, isize](Abc.one) == isize(1)
}

fn test_atob_enum_to_bool() {
	assert atob[Abc, bool](Abc.zero) == false
	assert atob[Abc, bool](Abc.one) == true
}

fn test_atob_bool_to_int() {
	assert atob[bool, u8](false) == u8(0)
	assert atob[bool, i8](false) == i8(0)
	assert atob[bool, u16](false) == u16(0)
	assert atob[bool, i16](false) == i16(0)
	assert atob[bool, u32](false) == u32(0)
	assert atob[bool, i32](false) == i32(0)
	assert atob[bool, int](false) == int(0)
	assert atob[bool, u64](false) == u64(0)
	assert atob[bool, i64](false) == i64(0)
	assert atob[bool, usize](false) == usize(0)
	assert atob[bool, isize](false) == isize(0)
	assert atob[bool, u8](true) == u8(1)
	assert atob[bool, i8](true) == i8(1)
	assert atob[bool, u16](true) == u16(1)
	assert atob[bool, i16](true) == i16(1)
	assert atob[bool, u32](true) == u32(1)
	assert atob[bool, i32](true) == i32(1)
	assert atob[bool, int](true) == int(1)
	assert atob[bool, u64](true) == u64(1)
	assert atob[bool, i64](true) == i64(1)
	assert atob[bool, usize](true) == usize(1)
	assert atob[bool, isize](true) == isize(1)
}

fn test_atob_bool_to_float() {
	assert atob[bool, f32](false) == f32(0)
	assert atob[bool, f32](true) == f32(1)
	assert atob[bool, f64](false) == f64(0)
	assert atob[bool, f64](true) == f64(1)
}

fn test_atob_bool_to_enum() {
	assert atob[bool, Abc](false) == Abc.zero
	assert atob[bool, Abc](true) == Abc.one
}

fn test_atob_string_to_int() {
	assert atob[string, u8]('123') == u8(123)
	assert atob[string, i8]('123') == i8(123)
	assert atob[string, u16]('123') == u16(123)
	assert atob[string, i16]('123') == i16(123)
	assert atob[string, u32]('123') == u32(123)
	assert atob[string, i32]('123') == i32(123)
	assert atob[string, int]('123') == int(123)
	assert atob[string, u64]('123') == u64(123)
	assert atob[string, i64]('123') == i64(123)
	assert atob[string, usize]('123') == usize(123)
	assert atob[string, isize]('123') == isize(123)
}

fn test_atob_string_to_float() {
	assert atob[string, f32]('123') == f32(123)
	assert atob[string, f32]('123.1') == f32(123.1)
	assert atob[string, f64]('123') == f64(123)
	assert atob[string, f64]('123.1') == f64(123.1)
}

fn test_atob_string_to_enum() {
	assert atob[string, Abc]('zero') == Abc.zero
	assert atob[string, Abc]('one') == Abc.one
}

fn test_atob_string_to_bool() {
	assert atob[string, bool]('false') == false
	assert atob[string, bool]('true') == true
}

fn test_atob_map_to_map() {
	mut a := {
		'123': 1
		'456': 2
		'789': 3
	}
	mut b := map[int]string{}
	b[123] = '1'
	b[456] = '2'
	b[789] = '3'
	assert atob[map[string]int, map[int]string](a) == b
	// assert atob[map[int]string, map[string]int](b) == a // compiler bug
}