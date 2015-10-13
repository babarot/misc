get_styles="from pygments.styles import get_all_styles
styles = list(get_all_styles())
print styles
"
echo "$get_styles" | python
