run: build
	./generator

build:
	v -o generator src

server:
	python3 -m http.server -d output 8080

fmt:
	v fmt -w .
