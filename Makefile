build:
	v -o generator src

generate: build
	./generator

watch:
	sass --watch --style compressed src/templates/assets/styles/style.scss:src/templates/assets/styles/style.css

server: generate
	python3 -m http.server -d output 8081

fmt:
	v fmt -w .
