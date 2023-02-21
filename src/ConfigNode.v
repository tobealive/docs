module main

import os
import json

const (
	config_filename = '.config.json'
)

[heap]
struct ConfigNode {
	title string
mut:
	contents  []ConfigNode
	url       string
	is_folder bool
	is_root   bool
}

fn build_config_tree(path string) !&ConfigNode {
	mut node_config := read_node_config(path) or { return &ConfigNode{} }
	node_config.is_folder = true
	node_config.url = os.join_path(path, node_config.url)

	mut contents := []ConfigNode{}

	for child in node_config.contents {
		is_folder := !child.url.contains('.')

		if is_folder {
			contents << build_config_tree(os.join_path(path, child.url))!
		} else {
			contents << &ConfigNode{
				...child
				url: os.join_path(path, child.url)
			}
		}
	}

	node_config.contents = contents

	return &node_config
}

fn (c &ConfigNode) get_parent_dir_name() string {
	return os.base(os.dir(c.url))
}

fn read_node_config(path string) !ConfigNode {
	config_path := os.join_path(path, config_filename)
	raw_config := os.read_file(config_path)!

	return json.decode(ConfigNode, raw_config)
}
