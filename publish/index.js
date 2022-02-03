function display(data){
    index = document.querySelector('.index')
    data.forEach((entry) => {
	entry_el = document.createElement('div')
	entry_el.classList.add('entry')

	topcard = document.createElement('div')
	topcard.classList.add('topcard')
	title_container = document.createElement('div')
	title_container.classList.add('title_container')
	title_el = document.createElement('a')
	title_el.classList.add('title')
	cover = document.createElement('div')
	cover.classList.add('cover')
	cover_img = document.createElement('img')
	cover_img.src = entry.cover
	cover.appendChild(cover_img)
	title_el.appendChild(cover)
	title_el.href = entry.path
	title_text = document.createElement('p')
	title_text.textContent = entry.title
	title_el.appendChild(title_text)
	subtitle_text = document.createElement('p')
	subtitle_text.classList.add('subtitle')
	subtitle_text.textContent = entry.subtitle
	title_el.appendChild(subtitle_text)
	title_container.appendChild(title_el)

	topcard.appendChild(title_container)

	meta_el = document.createElement('div')
	meta_el.classList.add('meta')

	if (entry.outside == false) {
	    lines_code_el = document.createElement('span')
	    lines_code_el.classList.add('number_code')
	    lines_code_el.textContent = `${entry.lines_code} líneas de código`
	    meta_el.appendChild(lines_code_el)
	    lines_md_el = document.createElement('span')
	    lines_md_el.classList.add('number_md')
	    lines_md_el.textContent = `${entry.lines_md} líneas de prosa`
	    meta_el.appendChild(lines_md_el)
	    plots_el = document.createElement('span')
	    plots_el.classList.add('number_plots')
	    plots_el.textContent = `${entry.plots} gráficos`
	    meta_el.appendChild(plots_el)

	}
	
	topcard.appendChild(meta_el)

	bottomcard = document.createElement('div')
	bottomcard.classList.add('bottomcard')

	created_date = new Date(entry.created.split("-"))
	created_friendly = created_date.toLocaleDateString('en-US', {day: "numeric"}) + " " + created_date.toLocaleDateString('en-US', {month: "short"})
	modified_date = new Date(entry.last_modified.split("-"))
	modified_friendly = modified_date.toLocaleDateString('en-US', {day: "numeric"}) + " " + modified_date.toLocaleDateString('en-US', {month: "short"})
	
	time_el = document.createElement('div')
	time_el.classList.add('time')
	
	time_created = document.createElement('div')
	time_created.classList.add('time_created')
	time_created.title = entry.created
	time_created.innerHTML = `creado<br>${created_friendly}`

	time_mod = document.createElement('div')
	time_mod.classList.add('time_modified')
	time_mod.title = entry.last_modified
	time_mod.innerHTML = `modificado<br>${modified_friendly}`
	time_el.appendChild(time_created)
	time_el.appendChild(time_mod)

	bottomcard.appendChild(time_el)
	
	entry_el.appendChild(topcard)
	entry_el.appendChild(bottomcard)

	index.appendChild(entry_el)
    })
}

fetch('index.json').then((response) => {
    response.json().then((data) => {
	display(data)
    })})
