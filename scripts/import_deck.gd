extends Node2D

@onready var ydk_code_textbox = $TextEdit

var card_data_array = []

signal deck_imported(decklist: Array)

func _ready():
	var json_text = load_json_file("res://cardinfo.json")
	if json_text.is_empty():
		printerr("Ne mogu da učitam ili je fajl prazan")
		return

	var parsed = safe_parse_json(json_text)
	if typeof(parsed) == TYPE_DICTIONARY and parsed.has("data"):
		card_data_array = parsed["data"]
	else:
		printerr("JSON format nije očekivan!")

func _input(event):
	if visible:
		if event is InputEventKey and event.pressed and not event.echo:
			if event.keycode == KEY_ENTER:
				_on_import_deck_button_pressed()
				
func load_json_file(path: String) -> String:
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		printerr("Ne mogu da otvorim fajl: ", path)
		return ""
	var text = file.get_as_text()
	file.close()
	return text

func safe_parse_json(json_text: String) -> Dictionary:
	var parse_result = JSON.parse_string(json_text)
	if parse_result == null:
		printerr("JSON parse error: Nevalidan JSON format")
		return {}
	return parse_result

func _on_import_deck_button_pressed() -> void:

	var ydk_text = ydk_code_textbox.text.strip_edges()
	var ydk_file_content = decode_ydke(ydk_text)
	var card_ids = parse_ydk(ydk_file_content)
	var card_names = get_card_names(card_ids)
	
	ydk_code_textbox.text = ""
	emit_signal("deck_imported", card_names)
	
func decode_ydke(ydke_text: String) -> String:
	if not ydke_text.begins_with("ydke://"):
		printerr("Nevalidan YDKE format!")
		return ""

	var encoded_parts = ydke_text.trim_prefix("ydke://").split("!")
	var sections = ["#main", "#extra", "!side"]
	var result_lines = []
	var section_index := 0

	for part in encoded_parts:
		if part.is_empty():
			continue

		var byte_data: PackedByteArray = Marshalls.base64_to_raw(part)
		if byte_data.is_empty():
			printerr("Greška pri dekodiranju Base64!")
			continue

		result_lines.append(sections[section_index])
		var i := 0
		while i + 4 <= byte_data.size():
			var card_id := (
				byte_data[i] |
				(byte_data[i + 1] << 8) |
				(byte_data[i + 2] << 16) |
				(byte_data[i + 3] << 24)
			)
			result_lines.append(str(card_id))
			i += 4

		section_index += 1
	
	return "\n".join(result_lines)


func parse_ydk(ydk_text: String) -> Array:
	var lines = ydk_text.split("\n", false)
	var ids = []
	var in_main_section = false
	
	for line in lines:
		line = line.strip_edges()
		if line == "#extra":
			break
		elif line == "#main":
			in_main_section = true
		elif in_main_section and line.is_valid_int():
			ids.append(line.to_int())
	
	return ids

func get_card_names(card_ids: Array) -> Array:
	var card_names = []
	for card_id in card_ids:
		card_names.append(find_card_name_by_id(card_id))
	return card_names


func find_card_name_by_id(card_id: int) -> String:
	for card in card_data_array:
		if card is Dictionary and card.has("id") and card["id"] == card_id:
			return card.get("name", "Nepoznata karta ID: " + str(card_id))
	return "Nepoznata karta ID: " + str(card_id)

func _on_cancel_button_pressed() -> void:
	ydk_code_textbox.text = ""
	hide()
