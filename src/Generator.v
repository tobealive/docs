module main

import markdown
import os

const (
	config_filename = '.config.json'
	template_path   = './templates/index.html'
)

[noinit]
struct Generator {
	root_node   &Node
	output_path string
}

fn new_generator(docs_path string, output_path string) !&Generator {
	return &Generator{
		root_node: build_docs_tree(docs_path)!
		output_path: output_path
	}
}

fn (g &Generator) generate() ! {
	write_output_file('index.html', g.render_page_from_template(g.root_node, 'V Documentation',
		g.root_node.body, Topic{}, Topic{})) or { return }

	g.generate_from_tree(g.root_node)!
}

fn (g &Generator) generate_from_tree(node &Node) ! {
	for child in node.contents {
		if child.body != '' {
			page_content := g.render_page_from_template(g.root_node, child.title, child.body,
				Topic{}, Topic{})
			html_filename := '${title_to_filename(child.title)}.html'
			directory_name := title_to_filename(child.parent.title)
			directory_path := os.join_path(output_path, directory_name)
			html_file_path := '${directory_name}/${html_filename}'

			mkdir_if_not_exists(directory_path)!

			mut transformer := HTMLTransformer{
				content: page_content
			}

			write_output_file(html_file_path, transformer.process())!
		}

		if child.contents.len > 0 {
			g.generate_from_tree(child)!
		}
	}
}

fn (_ &Generator) render_page_from_template(root_node &Node, title string, markdown_content string, prev_topic Topic, next_topic Topic) string {
	markdown_subtopics := split_source_by_topics(markdown_content, 2)
	subtopics := extract_topics_from_markdown_parts(markdown_subtopics, true)
	content := markdown.to_html(markdown_content)

	return $tmpl(template_path)
}
