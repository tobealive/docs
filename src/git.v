module main

import os
import time

fn get_last_modification_date_of_file(path string) !time.Time {
	result := os.execute('git log -1 --pretty="format:%ct" ${path}')

	if result.exit_code != 0 {
		return error(result.output)
	}

	return time.unix(result.output.int())
}
