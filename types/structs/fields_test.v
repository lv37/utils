module structs

struct Xyz {
	xyz bool
}

struct Abc {
	abc bool
}

fn test_key_in_struct() {
	assert key_in_struct[Abc]('xyz') == false
	assert key_in_struct[Abc]('abc') == true
	assert key_in_struct[Abc]('') == false

	assert key_in_struct[Xyz]('xyz') == true
	assert key_in_struct[Xyz]('abc') == false
	assert key_in_struct[Xyz]('') == false
}
