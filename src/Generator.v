module main

import markdown
import os

const (
	template_path  = './templates/index.html'
	main_page_path = './src/templates/main-page.html'
)

[noinit]
struct Generator {
	root_node   &DocumentNode
	output_path string
}

fn new_generator(document_node &DocumentNode, output_path string) !&Generator {
	return &Generator{
		root_node: document_node
		output_path: output_path
	}
}

fn (g &Generator) generate() ! {
	write_output_file('index.html', g.render_index_page_from_template(g.root_node, g.root_node))!

	g.generate_from_tree(g.root_node)!
}

fn (g &Generator) generate_from_tree(node &DocumentNode) ! {
	for child in node.contents {
		mut transformer := HTMLTransformer{
			content: markdown.to_html(child.markdown_content)
		}
		page_content := g.render_page_from_template(g.root_node, child, child.markdown_content,
			transformer.process())

		if child.html_url != '' {
			mkdir_if_not_exists(os.join_path(output_path, os.dir(child.html_url)))!
			write_output_file(child.html_url, page_content)!
		}

		if child.contents.len > 0 {
			g.generate_from_tree(child)!
		}
	}
}

fn (_ &Generator) render_page_from_template(root_node &DocumentNode, node &DocumentNode, markdown_content string, html_content string) string {
	next_node := node.next()
	prev_node := node.prev()

	markdown_subtopics := split_source_by_topics(markdown_content, 2)
	subtopics := extract_topics_from_markdown_parts(markdown_subtopics, true)
	content := html_content

	return $tmpl(template_path)
}

fn (_ &Generator) render_index_page_from_template(root_node &DocumentNode, node &DocumentNode) string {
	// get first subtopic of root node
	next_node := root_node.contents.first().contents.first()
	prev_node := node.prev()

	markdown_subtopics := []string{}
	subtopics := []Topic{}

	main_page_content := os.read_file(main_page_path) or {
		eprintln('Could not read main page content')
		return ''
	}
	content := main_page_content

	return $tmpl(template_path)
}
