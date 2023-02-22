module main

import markdown
import os

const (
	template_path = './templates/index.html'
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
	write_output_file('index.html', g.render_page_from_template(g.root_node, g.root_node,
		g.root_node.markdown_content, markdown.to_html(g.root_node.markdown_content)))!

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
