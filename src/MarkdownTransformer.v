module main

struct MarkdownTransformer {
mut:
	content string
}

fn (mut t MarkdownTransformer) process() string {
	t.process_code_blocks()

	return t.content
}

fn (mut t MarkdownTransformer) process_code_blocks() {
	mut result := ''

	for line in t.content.split_into_lines() {
		new_line := if line.starts_with('```v ') && line.contains('play') {
			'```v\n\nplay'
		} else {
			line
		}

		result += '${new_line}\n'
	}

	t.content = result
}
