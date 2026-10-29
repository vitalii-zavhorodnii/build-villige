class_name BuildingDefinition
extends Resource
## Static description of a building type. Contains no runtime state and no
## placement: where and how large a building is drawn is authored on the
## BuildingSite in the settlement scene. What is actually built lives in
## BuildingState.

@export var id: StringName
@export var title: String
## Displayed construction price. Not charged yet: construction is free for now.
@export var price: int = 0
@export_multiline var description: String
## Image of the finished building.
@export var model: Texture2D
## Image of the empty construction site prepared for this building type.
@export var place_model: Texture2D
@export var icon: Texture2D
## Screen opened when the player clicks the constructed building.
@export var scene: PackedScene
