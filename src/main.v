module main

import os
import strings

const (
	docs_path   = 'docs'
	output_path = 'output'
	assets_path = 'src/templates/assets'
	images_path = 'docs/_images'
)

fn main() {
	clean_output_directory()!
	create_output_directory()!

	config_tree := build_config_tree(docs_path)!
	document_tree := build_document_tree(config_tree, unsafe { nil })!

	generator := new_generator(document_tree, output_path)!
	generator.generate()!

	copy_assets_to_output()!
	copy_images_to_output()!

	mut result := strings.new_builder(100)
	mut builder := &result

	result.write_string('[\n')

	mut id := 0
	mut id_ptr := &id
	os.walk(docs_path, fn [mut builder, mut id_ptr] (file string) {
		line := generate_json_line(file, mut id_ptr) or { return }
		builder.write_string(line)
	})

	result.cut_last(2) // last comma
	result.write_string('\n')
	result.write_string(']\n')

	os.write_file('docs_index.json', result.str())!
}

fn generate_json_line(filepath string, mut id_ptr &int) ?string {
	if !filepath.ends_with('.md') {
		return none
	}
	content := os.read_file(filepath) or { return '' }

	lines := content.split_into_lines()
	title := lines.first().trim(' #')

	markdown_subtopics := split_source_by_topics(content, 2)
	subtopics := extract_topics_from_markdown_parts(markdown_subtopics, true)

	mut result := strings.new_builder(100)
	body := lines[1..].join('\n')
	(*id_ptr)++

	html_path := 'https://docs.vlang.foundation/' +
		filepath.replace_once('${docs_path}/', '').replace('.md', '.html')
	result.write_string('{ "id": ${*id_ptr}, "title": "${title}", "body": "${process_content(body)}", "url": "${html_path}" },\n')

	for subtopic in subtopics {
		(*id_ptr)++

		subtopic_content := subtopic.markdown_content.split_into_lines()[1..].join('\n')
		result.write_string('{ "id": ${*id_ptr}, "parent": "${title}", "title": "${subtopic.title}", "body": "${process_content(subtopic_content)}", "url": "${html_path}#${subtopic.id}" },\n')
	}

	return result.str()
}

fn process_content(content string) string {
	return content
		.replace('\n', ' ')
		.replace('\\', '\\\\')
		.replace('\u0009', '')
		.replace('"', '\\"')
}
