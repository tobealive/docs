module main

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

	generate_search_index()!
}
