#!/usr/bin/env python3

import json
import pandas as pd
import os
from git import Repo
import datetime as dt

def get_title(file):
    return [cell for cell in file['cells'] if cell['cell_type'] == 'markdown'][0]['source'][0].replace('#', '').strip()

def get_subtitle(file):
    return [cell for cell in file['cells'] if cell['cell_type'] == 'markdown' and '>' in cell['source'][0]][0]['source'][0].replace('>', '').strip()

def get_lines_code(file):
    return len([cell for cell in file['cells'] if cell['cell_type'] == 'code'])

def get_lines_md(file):
    return len([cell for cell in file['cells'] if cell['cell_type'] == 'markdown'])

def get_plots(file):
    plots = 0
    for cell in file['cells']:
        if cell['cell_type'] == 'code' and len(cell['outputs']) > 0:
            for output in cell['outputs']:
                if output.__contains__('data'):
                    for content_type in output['data'].keys():
                        if 'image' in content_type:
                            plots += 1
    return plots

def get_modificado(filename):
    return dt.datetime.fromtimestamp(os.path.getmtime(filename))

def get_outside(filename):
    with open(filename, 'r') as f:
        return json.load(f)

def get_notebook_attributes(filename):
    base_url = 'https://mauforonda.github.io/notas/'
    timeformat = '%Y-%m-%d'
    commits = repo.git.log('--format=%at', filename).split('\n')
    with open(filename, 'r') as f:
        file = json.load(f)
    
    if len(commits) > 0:
        created = dt.datetime.fromtimestamp(int(commits[-1])).strftime(timeformat)
    else:
        created = dt.datetime.now().strftime(timeformat)
    
    slug = filename.split('/')[-1].split('.')[0]
    path = base_url + slug + '.html'
    cover = 'cover/' + slug + '.png'
    title = get_title(file)
    subtitle = get_subtitle(file)
    last_modified = get_modificado(filename).strftime(timeformat)
    lines_code = get_lines_code(file)
    lines_md = get_lines_md(file)
    plots = get_plots(file)
    
    return dict(
        outside = False,
        path = path,
        cover = cover,
        title = title,
        subtitle = subtitle,
        created = created,
        last_modified = last_modified,
        lines_code = lines_code,
        lines_md = lines_md,
        plots = plots
    )

repo = Repo('.')
notebooks = [get_notebook_attributes(f) for f in os.listdir('.') if '.ipynb' in f and os.path.isfile(f)]
outside = get_outside('publish/outside.json')
notebooks.extend(outside)

with open('publish/index.json', 'w+') as f:
    index = pd.DataFrame(notebooks).sort_values('created', ascending=False).to_dict(orient='records')
    json.dump(index, f)
