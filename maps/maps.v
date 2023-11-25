module maps

@[inline]
pub fn merge_recursive[K, V](mut a map[K]V, b map[K]V) {
	for k, v in b {
		$if V is $map {
			merge_recursive(a[k], v)
		} $else { a[k] = v }
	}
}

@[inline]
pub fn merged_recursive[K, V](a map[K]V, b map[K]V) map[K]V {
	mut out := a.clone()
	merge_recursive(out)
	return out	
}

@[inline]
pub fn merge[K, V](mut a map[K]V, b map[K]V) {
	for k, v in b {
		a[k] = v
	}
}

@[inline]
pub fn merged[K, V](a map[K]V, b map[K]V) map[K]V {
	mut out := a.clone()
	merge(out)
	return out	
}

