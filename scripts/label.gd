extends Label

@export var font_24: FontFile
@export var font_20: FontFile
@export var font_16: FontFile
@export var font_12: FontFile
@export var font_8: FontFile

var fonts = []

func _ready():
	fonts = [font_24, font_20, font_16, font_12, font_8]
	fit_text_to_width()

func fit_text_to_width():
	var max_width = 160
	for f in fonts:
		if f == null:
			continue
		var text_width = f.get_string_size(text).x
		if text_width <= max_width:
			add_theme_font_override("font", f)
			return
	add_theme_font_override("font", fonts[-1])
