module main

const (
	docs_path   = 'docs'
	output_path = 'output'
	assets_path = 'src/templates/assets'
)

fn main() {
	clean_output_directory()!
	create_output_directory()!

	generator := new_generator(docs_path, output_path)!
	generator.generate()!

	copy_assets_to_output()!
}
