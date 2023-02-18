module main

import markdown
import pcre

const (
	v_code_tag   = '<pre><code class="language-v">'
	c_code_tag   = '<pre><code class="language-c">'
	code_tag_end = '</code></pre>'
	h2_tag       = '<h2>'
	h2_tag_end   = '</h2>'
)

struct HTMLTransformer {
mut:
	content string
}

fn (mut t HTMLTransformer) process() string {
	t.add_main_class_to_first_h1()
	t.process_blockquotes()
	t.prepare_v_and_c_code_for_playground()
	t.add_anchors()

	return t.content
}

fn (mut t HTMLTransformer) add_main_class_to_first_h1() {
	t.content = t.content.replace_once('<h1', '<h1 class="main"')
}

fn (mut t HTMLTransformer) process_blockquotes() {
	blockquote_re := pcre.new_regex(r'<blockquote>([\S\s]*?)</blockquote>', 0) or { panic(err) }
	matched_blockquote := blockquote_re.match_str(t.content, 0, 0) or { return }
	blockquote := matched_blockquote.get(0) or { return }
	content := matched_blockquote.get(1) or { return }

	if content.contains('<strong>Note</strong>') {
		t.process_note_blockquotes(blockquote, content.replace('<strong>Note</strong>',
			''))
	} else if content.contains('<strong>Warning</strong>') {
		t.process_warning_blockquotes(blockquote, content.replace('<strong>Warning</strong>',
			''))
	} else {
		t.process_tip_blockquotes(blockquote, content)
	}

	t.process_blockquotes()
}

fn (mut t HTMLTransformer) process_note_blockquotes(blockquote string, content string) {
	new_blockquote := '
		<blockquote class="note">
			<svg class="prompt__icon" viewBox="0 0 24 24">
				<path d="M21 12a9 9 0 1 1-9-9 9 9 0 0 1 9 9zM10.5 7.5A1.5 1.5 0 1 0 12 6a1.5 1.5 0 0 0-1.5 1.5zm-.5 3.54v1h1V18h2v-6a.96.96 0 0 0-.96-.96z"></path>
			</svg>
			<div class="prompt__content">
				${content}
			</div>
		</blockquote>'

	t.content = t.content.replace_once(blockquote, new_blockquote)
}

fn (mut t HTMLTransformer) process_warning_blockquotes(blockquote string, content string) {
	new_blockquote := '
		<blockquote class="warning">
			<svg class="prompt__icon" viewBox="0 0 24 24">
				<path d="M12.946 3.552L21.52 18.4c.424.735.33 1.6-.519 1.6H3.855c-.85 0-1.817-.865-1.392-1.6l8.573-14.848a1.103 1.103 0 0 1 1.91 0zm.545 12.948a1.5 1.5 0 1 0-1.5 1.5 1.5 1.5 0 0 0 1.5-1.5zM13 8h-2v5h2z"></path>
			</svg>
			<div class="prompt__content">
				${content}
			</div>
		</blockquote>'

	t.content = t.content.replace_once(blockquote, new_blockquote)
}

fn (mut t HTMLTransformer) process_tip_blockquotes(blockquote string, content string) {
	new_blockquote := '
		<blockquote class="tip">
			<svg class="prompt__icon" viewBox="0 0 24 24">
				<circle cx="12.042" cy="4" r="2"></circle>
				<path d="M18.339 7a6.982 6.982 0 0 0-6.3 4 6.982 6.982 0 0 0-6.3-4H3v10h2.739a6.983 6.983 0 0 1 6.3 4 6.582 6.582 0 0 1 6-4.033h2.994L21 7z"></path>
			</svg>
			<div class="prompt__content">
				${content}
			</div>
		</blockquote>'

	t.content = t.content.replace_once(blockquote, new_blockquote)
}

fn (mut t HTMLTransformer) prepare_v_and_c_code_for_playground() {
	// Until V has no good regex library.
	mut result := ''
	mut in_v_code_tag := false

	for line in t.content.split_into_lines() {
		mut new_line := line

		if line.starts_with(v_code_tag) || line.starts_with(c_code_tag) {
			new_line = new_line
				.replace(v_code_tag, '<div class="language-v">')
				.replace(c_code_tag, '<div class="language-c">')

			in_v_code_tag = true
		}

		if in_v_code_tag {
			if line.starts_with(code_tag_end) {
				new_line = new_line.replace(code_tag_end, '</div>')

				in_v_code_tag = false
			}
		}

		result += '${new_line}\n'
	}

	t.content = result
}

fn (mut t HTMLTransformer) add_anchors() {
	mut result := ''

	for line in t.content.split_into_lines() {
		mut new_line := line

		if line.starts_with(h2_tag) && line.ends_with(h2_tag_end) {
			title := line.substr_ni(h2_tag.len, -h2_tag_end.len)
			plain_title := markdown.to_plain(title)
			id := title_to_filename(plain_title)

			new_line = new_line
				.replace(title, '${title} <a href="#${id}" class="header-anchor" aria-hidden="true">#</a>')
				.replace('<h2>', '<h2 id="${id}">')
		}

		result += '${new_line}\n'
	}

	t.content = result
}
