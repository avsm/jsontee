.PHONY: all tests doc clean

all:
	./build

tests:
	./build tests

doc:
	./build doc

clean:
	rm -rf _build
