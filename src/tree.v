module main

import os
import json

[heap]
struct Node {
	title string
	url   string
mut:
	html_url  string
	contents  []Node
	body      string
	is_folder bool
	parent    &Node = unsafe { nil }
}

fn build_docs_tree(path string) !&Node {
	mut node_config := read_node_config(path) or { return &Node{} }

	for mut child in node_config.contents {
		is_markdown_url := is_markdown_file(child.url)
		child.is_folder = !is_markdown_url
		child.parent = &node_config

		if is_markdown_url {
			markdown_path := os.join_path(path, child.url)
			markdown_content := os.read_file(markdown_path)!

			html_filename := '${title_to_filename(child.title)}.html'
			directory_name := title_to_filename(child.parent.title)
			child.html_url = '${directory_name}/${html_filename}'

			mut transformer := MarkdownTransformer{
				content: markdown_content
			}

			child.body = transformer.process()
			continue
		}

		child_path := os.join_path(path, child.url)
		child = build_docs_tree(child_path)!
	}

	return &node_config
}

fn read_node_config(path string) !Node {
	config_path := os.join_path(path, config_filename)
	raw_config := os.read_file(config_path)!

	return json.decode(Node, raw_config)
}

fn is_markdown_file(path string) bool {
	return path.ends_with('.md')
}
