#!/bin/sh

if [ "$1" = 'dev' ]; then
	echo "Building with asset data creation"
	mkdir -p assets/shaders/bin
	rm assets/shaders/bin/*
	for file in ./assets/shaders/src/*; do 
		if [ -f "$file" ]; then 
			echo "Building shader ${file:21}"
			name="${file:21:-5}"
			glslc $file -o assets/shaders/bin/$name.spv
		fi 
	done
	cargo run --release --features oxide-engine/dev_tools
elif [ "$1" = 'dist' ]; then
	echo "Building distribution"
	cargo run --release
else 
	echo "Build option not found (dev, dist)"
fi

