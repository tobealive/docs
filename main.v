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
		.filter(it.len > 0)

	for i, part in parts {
		title := part.trim(' ').split_into_lines().first().trim(' ')
		filename := title.replace_each([' ', '-', '`', '', '/', '', '\\', '', ':', '', '&', '']).to_lower()

		fixed := ('## ' + part)
			.replace_each(['## ', '# ', '### ', '## ', '#### ', '### ', '##### ', '#### ', '###### ', '##### '])

		os.write_file('docs/${filename}.md', fixed)!
	}
}
