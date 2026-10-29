extends Node
## Autoload that owns every scene path and performs all scene transitions,
## so screens never hard-code each other's paths.

const MAIN_MENU := "res://scenes/ui/main_menu/main_menu.tscn"
const NEW_GAME := "res://scenes/ui/new_game/new_game.tscn"
const SETTINGS := "res://scenes/ui/settings/settings.tscn"
const LOAD_GAME := "res://scenes/ui/load_game/load_game.tscn"
const GAMEPLAY := "res://scenes/gameplay/gameplay.tscn"


func go_to(scene_path: String) -> void:
	var error := get_tree().change_scene_to_file(scene_path)
	if error != OK:
		push_error("SceneRouter: failed to open '%s' (error %d)." % [scene_path, error])


## For scenes referenced from data resources, such as building screens.
func go_to_packed(scene: PackedScene) -> void:
	var error := get_tree().change_scene_to_packed(scene)
	if error != OK:
		push_error("SceneRouter: failed to open packed scene (error %d)." % error)
