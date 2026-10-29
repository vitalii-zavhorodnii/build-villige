extends Control

@onready var _play_button: Button = %PlayButton
@onready var _settings_button: Button = %SettingsButton
@onready var _quit_button: Button = %QuitButton


func _ready() -> void:
	_play_button.pressed.connect(SceneRouter.go_to.bind(SceneRouter.NEW_GAME))
	_settings_button.pressed.connect(SceneRouter.go_to.bind(SceneRouter.SETTINGS))
	_quit_button.pressed.connect(get_tree().quit)
