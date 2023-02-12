module main

import os

// #anchor to file name
// \(\#([\w-]+)\) -> (./$1.md)

// `file` to **file**
// `[\w/]+\.v` to **$1**

fn main() {
	docs := os.read_file('docs.md')!

	parts := docs
		.split('\n## ')
		.map(it.trim(' '))

	for i, part in parts {
		title := part.split_into_lines().first().trim(' ')
		filename := title.replace_each([' ', '-', '`', '', '/', '', '\\', '', ':', '']).to_lower()

		os.write_file('docs/${filename}.md', '## ' + part)!
	}
}
