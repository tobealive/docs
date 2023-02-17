module main

import os

const (
	root_path   = os.abs_path('..')
	docs_path   = os.join_path(root_path, 'docs')
	output_path = os.join_path(root_path, 'output')
	assets_path = os.join_path(root_path, 'src/templates/assets')
)

fn main() {
	clean_output_directory()!
	create_output_directory()!

	generator := new_generator(docs_path, output_path)!
	generator.generate()!

	copy_assets_to_output()!
}
