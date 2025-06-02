class_name Hand extends Control

@onready var card_container = $ColorRect/ScrollContainer/HBoxContainer
@onready var remove_hand_button = $remove_hand
var cards_in_hand: Array = []

var CardScene = preload("res://scenes/card_in_hand.tscn")

signal remove_this_hand(hand: Hand)

func add_card(name: String) -> void:
	var card = CardScene.instantiate()
	card.card_name = name
	cards_in_hand.append(name)
	card_container.add_child(card)
	card.set_card(name.strip_edges())


func _on_remove_hand_pressed() -> void:
	emit_signal("remove_this_hand", self)


func _on_remove_hand_mouse_entered() -> void:
	remove_hand_button.scale.x = 0.087
	remove_hand_button.scale.y = 0.087
	remove_hand_button.position.x -= 3
	remove_hand_button.position.y -= 3

func _on_remove_hand_mouse_exited() -> void:
	remove_hand_button.scale.x = 0.077
	remove_hand_button.scale.y = 0.077
	remove_hand_button.position.x += 3
	remove_hand_button.position.y += 3
