#!/usr/bin/env bash

index='publish/index.json'
base='https://mauforonda.github.io/notas/'
dateformat="+%Y-%m-%d"
i=0
n=$(ls *.ipynb | wc -l)

echo '[' > $index

for ipynb in $(ls *.ipynb | git_by_date); do

    created=$(git log --format="%at" $ipynb | tail -1)
    if test -z "$created";then
	created=$(date "$dateformat")
    else
	created=$(date -d @$created "$dateformat")
    fi
    
    let i++
    filename=$(echo $ipynb | sed -E 's/\.ipynb//g')
    modified=$(date -r $ipynb "$dateformat")
    path=$(echo ${filename})
    title=$(jq '[.cells[]|select( .cell_type | contains("markdown"))]|first.source[0]' $ipynb | sed -E 's/# //')
    subtitle=$(jq '[.cells[]|select( .cell_type | contains("markdown"))] | [.[]|select(.source|first|contains(">"))] | first.source[0]' $ipynb | sed -E 's/> //')
    lines_code=$(jq '.cells[]|select( .cell_type | contains("code"))|.source|length' $ipynb | paste -sd+ | bc)
    lines_md=$(jq '.cells[]|select( .cell_type | contains("markdown"))|.source|length' $ipynb | paste -sd+ | bc)
    plots=$(jq '[[.cells[]|select(.cell_type == "code" and .outputs != [])][]|.outputs[]|select(.data|has("image/png"))]|length' $ipynb)

    entry=$(echo "{'path':'$path', 'title':$title, 'subtitle':$subtitle, 'created':'$created', 'last_modified':'$modified', 'lines_code':$lines_code, 'lines_md':$lines_md, 'plots':$plots}" | sed -E "s/'/\"/g")

    if [ $i != $n ]; then
	entry=$(echo "$entry,")
    fi

    echo $entry >> $index
    
done

echo "]" >> $index
