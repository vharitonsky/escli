#!/bin/bash -ex
if [ ! -f ./escli ]; then
	./build.sh
fi
mv escli ~/bin/
