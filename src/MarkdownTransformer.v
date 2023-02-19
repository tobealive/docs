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
	t.content = t.content.replace('```v play', '```v\n\nplay')
}
