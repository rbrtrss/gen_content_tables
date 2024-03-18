#!/bin/bash

list=$1

IFS=',' read -r -a array <<< "$list"
for index in "${!array[@]}"; do
	echo "${array[$index]} -> $index"
done

