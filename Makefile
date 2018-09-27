default: build

build:
	dune build @install

clean:
	dune clean

test:
	dune runtest

doc:
	dune build @doc
	cp -r _build/default/_doc/_html docs

.PHONY: default build clean test doc
