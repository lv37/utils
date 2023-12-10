module structs

pub fn key_in_struct[T](key string) bool {
	$for f in T.fields {
		if key == f.name {
			return true
		}
	}
	return false
}
