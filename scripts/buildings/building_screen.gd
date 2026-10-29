extends Control
## Shared logic of all building screens. Each building has its own scene
## inheriting building_screen_base.tscn and setting only its title.

@export var screen_title: String = "Building"

@onready var _title_label: Label = %TitleLabel
@onready var _back_button: Button = %BackButton


func _ready() -> void:
	_title_label.text = screen_title
	# The settlement state lives in the session, so reopening the settlement
	# scene shows every building built so far.
	_back_button.pressed.connect(SceneRouter.go_to.bind(SceneRouter.GAMEPLAY))
