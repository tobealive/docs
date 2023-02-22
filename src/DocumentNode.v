module main

import time
import os

[heap]
struct DocumentNode {
	ConfigNode
mut:
	html_url          string
	markdown_content  string
	contents          []&DocumentNode
	modification_time time.Time
	parent            &DocumentNode = unsafe { nil }
}

enum NodeOffset {
	prev = -1
	next = 1
}

fn new_document_node(config_node &ConfigNode, parent &DocumentNode) !&DocumentNode {
	markdown_content := os.read_file(config_node.url) or { '' }
	html_path := config_node.url.replace_once('${docs_path}/', '').replace('.md', '.html')

	mut transformer := MarkdownTransformer{
		content: markdown_content
	}

	return &DocumentNode{
		title: config_node.title
		url: config_node.url
		is_folder: config_node.is_folder
		markdown_content: transformer.process()
		html_url: if config_node.is_folder { '' } else { html_path }
		modification_time: get_last_modification_date_of_file(config_node.url) or { time.now() }
		parent: parent
	}
}

fn build_document_tree(config_node &ConfigNode, root_node &DocumentNode) !&DocumentNode {
	mut document_node := new_document_node(config_node, root_node)!
	mut contents := []&DocumentNode{}

	for child in config_node.contents {
		if child.is_folder {
			contents << build_document_tree(child, document_node)!
		} else {
			contents << new_document_node(child, document_node)!
		}
	}

	document_node.contents = contents

	return document_node
}

fn (n &DocumentNode) next() &DocumentNode {
	return n.get_node_with_offset(.next)
}

fn (n &DocumentNode) prev() &DocumentNode {
	return n.get_node_with_offset(.prev)
}

fn (n &DocumentNode) get_node_with_offset(offset NodeOffset) &DocumentNode {
	parent := n.parent

	if parent == unsafe { nil } {
		return &DocumentNode{}
	}

	node_index := parent.contents.index(n)
	offset_int := if offset == .prev { -1 } else { 1 }
	found_node := parent.contents[node_index + offset_int] or {
		parent.get_node_with_offset(offset)
	}

	if found_node.markdown_content != '' {
		return found_node
	}

	if found_node.contents.len > 0 {
		if offset == .next {
			return found_node.contents.first()
		} else {
			return found_node.contents.last()
		}
	}

	return parent.get_node_with_offset(offset)
}
