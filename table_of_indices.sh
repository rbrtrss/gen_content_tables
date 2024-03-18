#!/bin/bash

index=0
interactions=false
ival=-42
file=""

while [ "$#" -gt 0 ]; do
	case "$1" in
		-i)
			interactions=true
			shift
			if [ "$#" -gt 0 ] && [[ "$1" =~ ^[0-9]+$ ]]; then
				ival="$1"
				shift
			fi
			;;
		-*)
			echo "Invalid option: $1" >&2
			exit 1
			;;
		*)
			if [ -n "$file" ]; then
				echo "Error: Multiple input values provided" >&2
				exit 1
			fi
			file=$1
			shift
	esac
done

while IFS= read -r line; do
	if [[ $line =~ ^# ]]; then
		name="${line#\#}"
			if [ $ival -lt 0 ] || [ $ival = $index ]; then
				echo "Property: $name in index: $index"
			fi
			index=$(($index + 1))
	fi
	if $interactions; then
		if [[ $line =~ ^structure  || $line =~ ^E ]]; then
			if [ $ival -lt 0 ] || [ $ival = $((index - 1)) ]; then
				./table_of_interactions.sh "$line"
			fi
		fi
	fi
done < "$file"

if [ $ival -gt $index ]; then
	echo "Error: index out of bounds, index ges up to $index"
	exit 1
fi
