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
		mut new_line := line

		if line.starts_with('```v ') {
			if line.contains('play-test') {
				new_line = '```v\n\nplay-test'
			} else if line.contains('play') {
				new_line = '```v\n\nplay'
			}
		}

		result += '${new_line}\n'
	}

	t.content = result
}
