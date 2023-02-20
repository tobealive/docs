build:
	v -o generator src

generate: build
	./generator

server: generate
	python3 -m http.server -d output 8080

fmt:
	v fmt -w .
