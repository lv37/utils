module scanner

import os
import io

fn test_stdin() {
	assert typeof(stdin) == typeof[fn (ScannerCfg) &Scanner]()
}

fn test_stdout() {
	assert typeof(stdout) == typeof[fn (ScannerCfg) &Scanner]()
}

fn test_stderr() {
	assert typeof(stderr) == typeof[fn (ScannerCfg) &Scanner]()
}

fn test_reader() {
	assert typeof(reader) == typeof[fn (io.Reader, ScannerCfg) &Scanner]()
}

fn test_file() {
	assert typeof(file[string]) == typeof[fn (string, ScannerCfg) !&Scanner]()
}
