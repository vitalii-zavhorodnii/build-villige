extends Control

@onready var _return_button: Button = %ReturnButton


func _ready() -> void:
	_return_button.pressed.connect(_on_return_pressed)


func _on_return_pressed() -> void:
	# Unsaved progress is intentionally discarded without confirmation.
	SessionManager.end_session()
	SceneRouter.go_to(SceneRouter.MAIN_MENU)
