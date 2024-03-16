# Installation

```bash
vpm install wygsh.utils
```

# Examples

Convert `map[string]int` to `map[int]string`

```v
import wygsh.utils.types

a := { '123': 1, '999': 3 }
b := { 123: '1', 999: '3' }

assert types.atob[map[string]int, map[int]string](a) == b
```

Convert `[4]int` to `[]int`

```v
import wygsh.utils.types

a := [4]int{init: index}
b := []int{len: 4, init: index}

c := types.atob[[4]int, []int](a)
assert c == b
assert typeof(c).name == '[]int'
```

Merge maps recursively

```v
import wygsh.utils.maps

a := {
	0: {
		0: '00'
	}
	1: {
		0: '11'
	}
}

```