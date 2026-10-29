extends Control

@onready var _create_game_button: Button = %CreateGameButton
@onready var _load_game_button: Button = %LoadGameButton
@onready var _back_button: Button = %BackButton


func _ready() -> void:
	_create_game_button.pressed.connect(_on_create_game_pressed)
	_load_game_button.pressed.connect(SceneRouter.go_to.bind(SceneRouter.LOAD_GAME))
	_back_button.pressed.connect(SceneRouter.go_to.bind(SceneRouter.MAIN_MENU))


func _on_create_game_pressed() -> void:
	SessionManager.start_new_session()
	SceneRouter.go_to(SceneRouter.GAMEPLAY)
