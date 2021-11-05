#!/usr/bin/env bash

index='index.json'
base='https://mauforonda.github.io/notas/'
i=0
n=$(ls *.ipynb | wc -l)

echo '[' > $index

for ipynb in $(ls -t *.ipynb); do
    
    let i++
    filename=$(echo $ipynb | sed -E 's/ipynb/html/g')
    path=$(echo ${base}${filename})
    title=$(jq '[.cells[]|select( .cell_type | contains("markdown"))]|first.source[0]' $ipynb | sed -E 's/# //')
    last_modified=$(date -d @$(git log -1 --pretty="format:%at" $ipynb) +%Y-%m-%d)
    lines_code=$(jq '.cells[]|select( .cell_type | contains("code"))|.source|length' $ipynb | paste -sd+ | bc)
    lines_md=$(jq '.cells[]|select( .cell_type | contains("markdown"))|.source|length' $ipynb | paste -sd+ | bc)
    plots=$(jq '[[.cells[]|select(.cell_type == "code" and .outputs != [])][]|.outputs[]|select(.data|has("image/png"))]|length' $ipynb)

    entry=$(echo "{'path':'$path', 'title':$title, 'last_modified':'$last_modified', 'lines_code':$lines_code, 'lines_md':$lines_md, 'plots':$plots}" | sed -E "s/'/\"/g")

    if [ $i != $n ]; then
	entry=$(echo "$entry,")
    fi

    echo $entry >> $index
    
done

echo "]" >> $index
