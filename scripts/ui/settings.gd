extends Control

@onready var _back_button: Button = %BackButton


func _ready() -> void:
	_back_button.pressed.connect(SceneRouter.go_to.bind(SceneRouter.MAIN_MENU))
