NAME=$(shell basename $$PWD)

.PHONY: default
default: docker-html

.PHONY: html
html:
	asciidoctor -D build/html book.adoc

pdf: clean-pdf build/pdf/$(NAME).pdf

build/pdf/book.pdf: book.adoc
	asciidoctor-pdf -D build/pdf -r asciidoctor-pdf-cjk -a pdf-stylesdir=resources/themes -a pdf-style=basic book.adoc

build/pdf/$(NAME).pdf: build/pdf/book.pdf
	mv $< $@
	./bin/finish_by_pdfcpu $@

.PHONY: all
all: html pdf

.PHONY: clean
clean:
	rm -rf build

.PHONY: clean-pdf
clean-pdf:
	rm -f build/pdf/*.pdf

.PHONY: docker-html
docker-html:
	./bin/docker_asciidoctor asciidoctor \
		-v \
		-D build/html \
		book.adoc

.PHONY: docker-pdf
docker-pdf:
	./bin/docker_asciidoctor asciidoctor-pdf \
		-v \
		-D build/pdf \
		-a pdf-fontsdir=./resources/fonts \
		-a pdf-themesdir=./resources/themes \
		-a pdf-theme=a5book \
		book.adoc
	./bin/finish_by_pdfcpu build/pdf/book.pdf

.PHONY: docker-all
docker-all: docker-html docker-pdf
