module main

import strings
import os
import json

fn generate_search_index() ! {
	mut gen := SearchIndexGenerator{}
	result := gen.generate()

	os.write_file('docs_index.json', result)!
}

struct SearchIndexEntry {
	id     int
	parent string [omitempty]
	title  string
	body   string
	url    string
}

struct SearchIndexGenerator {
mut:
	counter int
	entries []SearchIndexEntry
}

fn (mut s SearchIndexGenerator) generate() string {
	mut result := strings.new_builder(100)

	os.walk(docs_path, fn [mut s] (file string) {
		s.process_file(file)
	})

	result.write_string('[\n')

	for index, entry in s.entries {
		result.write_string(json.encode(entry))
		if index < s.entries.len - 1 {
			result.write_string(',\n')
		}
	}

	result.write_string('\n')
	result.write_string(']\n')
	return result.str()
}

fn (mut s SearchIndexGenerator) process_file(filepath string) {
	if !filepath.ends_with('.md') {
		return
	}
	content := os.read_file(filepath) or { return }

	lines := content.split_into_lines()
	title := lines.first().trim(' #')

	markdown_subtopics := split_source_by_topics(content, 2)
	subtopics := extract_topics_from_markdown_parts(markdown_subtopics, true)

	body := lines[1..].join('\n')

	normalized_filename := filepath.replace_once('${docs_path}/', '').replace('.md', '.html')
	html_path := 'https://docs.vosca.dev/${normalized_filename}'

	s.entries << SearchIndexEntry{
		id: s.counter++
		title: title
		body: process_content(body)
		url: html_path
	}

	for subtopic in subtopics {
		subtopic_content := subtopic.markdown_content.split_into_lines()[1..].join('\n')

		s.entries << SearchIndexEntry{
			id: s.counter++
			parent: title
			title: subtopic.title
			body: process_content(subtopic_content)
			url: html_path + '#' + subtopic.id
		}
	}
}

fn process_content(content string) string {
	return content
		.replace('\n', ' ')
		.replace('\\', '\\\\')
		.replace('\u0009', '')
		.replace('"', '\\"')
}
