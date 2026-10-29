extends Control
## Shows the list of saved games. No save provider exists yet, so the list is
## always empty; a future provider only needs to call show_saves() with its
## entries.

@onready var _save_list: VBoxContainer = %SaveList
@onready var _empty_label: Label = %EmptyLabel
@onready var _back_button: Button = %BackButton


func _ready() -> void:
	_back_button.pressed.connect(SceneRouter.go_to.bind(SceneRouter.NEW_GAME))
	show_saves([])


## Rebuilds the list from display names of available saves.
func show_saves(save_names: Array[String]) -> void:
	for child in _save_list.get_children():
		if child != _empty_label:
			child.queue_free()
	_empty_label.visible = save_names.is_empty()
	for save_name in save_names:
		var entry := Button.new()
		entry.text = save_name
		_save_list.add_child(entry)
