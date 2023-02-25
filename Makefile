elixir-basics.pdf: README.md
	pandoc --toc -N -s --pdf-engine=xelatex -V documentclass=scrartcl \
		-V papersize=a4 -V urlcolor=blue -V lang=en -V date="`date +'%Y-%m-%d'`" \
		-V mainfont='Crimson Pro' -V sansfont='Lato' -V monofont='Inconsolata' \
		$< -o $@

