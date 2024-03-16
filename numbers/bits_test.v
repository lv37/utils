module numbers

import types

fn bit_arr[T](n []int) T {
	return types.atob[[]int, T](n)
}

fn t[T]() {
	assert bits[T, u8](0) == bit_arr[T]([0, 0, 0, 0, 0, 0, 0, 0])
	assert bits[T, u8](1) == bit_arr[T]([0, 0, 0, 0, 0, 0, 0, 1])
	assert bits[T, u8](2) == bit_arr[T]([0, 0, 0, 0, 0, 0, 1, 0])
	assert bits[T, u8](4) == bit_arr[T]([0, 0, 0, 0, 0, 1, 0, 0])
	assert bits[T, u8](8) == bit_arr[T]([0, 0, 0, 0, 1, 0, 0, 0])
	assert bits[T, u8](16) == bit_arr[T]([0, 0, 0, 1, 0, 0, 0, 0])
	assert bits[T, u8](32) == bit_arr[T]([0, 0, 1, 0, 0, 0, 0, 0])
	assert bits[T, u8](64) == bit_arr[T]([0, 1, 0, 0, 0, 0, 0, 0])
	assert bits[T, u8](128) == bit_arr[T]([1, 0, 0, 0, 0, 0, 0, 0])
	assert bits[T, u8](255) == bit_arr[T]([1, 1, 1, 1, 1, 1, 1, 1])
}

fn test_bits() {
	t[[]bool]()
	t[[u8]bool]()
}
