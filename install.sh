#!/bin/bash
if [ ! -f ./escli ]; then
	./build.sh
fi
mv escli ~/bin/
