module scanner

fn pow10[T, U](n U) T {
	$if T is $float {
		return if n == U(1) {
			T(10)
		} else if n == U(2) {
			T(100)
		} else if n == U(3) {
			T(1000)
		} else if n == U(4) {
			T(10000)
		} else if n == U(5) {
			T(100000)
		} else if n == U(6) {
			T(1000000)
		} else if n == U(7) {
			T(10000000)
		} else if n == U(8) {
			T(100000000)
		} else if n == U(9) {
			T(1000000000)
		} else if n == U(10) {
			T(10000000000)
		} else if n == U(11) {
			T(100000000000)
		} else if n == U(12) {
			T(1000000000000)
		} else if n == U(13) {
			T(10000000000000)
		} else if n == U(14) {
			T(100000000000000)
		} else if n == U(15) {
			T(1000000000000000)
		} else if n == U(16) {
			T(10000000000000000)
		} else if n == U(17) {
			T(100000000000000000)
		} else if n == U(18) {
			T(1000000000000000000)
		} else if n == U(19) {
			T(10000000000000000000)
		} else if n == U(-1) {
			T(0.1)
		} else if n == U(-2) {
			T(0.01)
		} else if n == U(-3) {
			T(0.001)
		} else if n == U(-4) {
			T(0.0001)
		} else if n == U(-5) {
			T(0.00001)
		} else if n == U(-6) {
			T(0.000001)
		} else if n == U(-7) {
			T(0.0000001)
		} else if n == U(-8) {
			T(0.00000001)
		} else if n == U(-9) {
			T(0.000000001)
		} else if n == U(-10) {
			T(0.0000000001)
		} else if n == U(-11) {
			T(0.00000000001)
		} else if n == U(-12) {
			T(0.000000000001)
		} else if n == U(-13) {
			T(0.0000000000001)
		} else if n == U(-14) {
			T(0.00000000000001)
		} else if n == U(-15) {
			T(0.000000000000001)
		} else if n == U(-16) {
			T(0.0000000000000001)
		} else if n == U(-17) {
			T(0.00000000000000001)
		} else if n == U(-18) {
			T(0.000000000000000001)
		} else if n == U(-19) {
			T(0.0000000000000000001)
		} else if n == U(-20) {
			T(0.00000000000000000001)
		} else if n == U(-21) {
			T(0.000000000000000000001)
		} else if n == U(-22) {
			T(0.0000000000000000000001)
		} else if n == U(-23) {
			T(0.00000000000000000000001)
		} else if n == U(-24) {
			T(0.000000000000000000000001)
		} else if n == U(-25) {
			T(0.0000000000000000000000001)
		} else if n == U(-26) {
			T(0.00000000000000000000000001)
		} else if n == U(-27) {
			T(0.000000000000000000000000001)
		} else if n == U(-28) {
			T(0.0000000000000000000000000001)
		} else if n == U(-29) {
			T(0.00000000000000000000000000001)
		} else if n == U(-30) {
			T(0.000000000000000000000000000001)
		} else if n == U(-31) {
			T(0.0000000000000000000000000000001)
		} else if n == U(-32) {
			T(0.00000000000000000000000000000001)
		} else if n == U(-33) {
			T(0.000000000000000000000000000000001)
		} else if n == U(-34) {
			T(0.0000000000000000000000000000000001)
		} else if n == U(-35) {
			T(0.00000000000000000000000000000000001)
		} else if n == U(-36) {
			T(0.000000000000000000000000000000000001)
		} else if n == U(-37) {
			T(0.0000000000000000000000000000000000001)
		} else if n == U(-38) {
			T(0.00000000000000000000000000000000000001)
		} else if n == U(-39) {
			T(0.000000000000000000000000000000000000001)
		} else if n == U(-40) {
			T(0.0000000000000000000000000000000000000001)
		} else if n == U(-41) {
			T(0.00000000000000000000000000000000000000001)
		} else if n == U(-42) {
			T(0.000000000000000000000000000000000000000001)
		} else if n == U(-43) {
			T(0.0000000000000000000000000000000000000000001)
		} else if n == U(-44) {
			T(0.00000000000000000000000000000000000000000001)
		} else if n == U(-45) {
			T(0.000000000000000000000000000000000000000000001)
		} else if n == U(-46) {
			T(0.0000000000000000000000000000000000000000000001)
		} else if n == U(-47) {
			T(0.00000000000000000000000000000000000000000000001)
		} else if n == U(-48) {
			T(0.000000000000000000000000000000000000000000000001)
		} else if n == U(-49) {
			T(0.0000000000000000000000000000000000000000000000001)
		} else if n == U(-50) {
			T(0.00000000000000000000000000000000000000000000000001)
		} else if n < 0 {
			T(0.00000000000000000000000000000000000000000000000001) * pow10[T, U](U(50) + n)
		} else if n > 0 {
			T(10000000000000000000) * pow10[T, U](U(19) - n)
		} else {
			1
		}
	} $else {
		mut out := T(1)
		for _ in U(0) .. n {
			out *= 10
		}
		return out
	}
	return T{}
}