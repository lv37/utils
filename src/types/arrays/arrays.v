module arrays

import v.ast

pub fn element_type[T](_ []T) ast.Type {
	return T.idx
}