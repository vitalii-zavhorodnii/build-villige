class_name ConstructionConfirmDialog
extends Control
## Shows the chosen building and asks the player to confirm. Contains no
## construction logic.

signal confirmed
signal cancelled

@onready var _preview: TextureRect = %Preview
@onready var _title_label: Label = %TitleLabel
@onready var _description_label: Label = %DescriptionLabel
@onready var _price_label: Label = %PriceLabel
@onready var _build_button: Button = %BuildButton
@onready var _cancel_button: Button = %CancelButton


func _ready() -> void:
	_build_button.pressed.connect(_on_build_pressed)
	_cancel_button.pressed.connect(cancelled.emit)
	visible = false


func open(definition: BuildingDefinition) -> void:
	_preview.texture = definition.model
	_title_label.text = definition.title
	_description_label.text = definition.description
	_price_label.text = "Price: %d" % definition.price
	_build_button.disabled = false
	visible = true


func close() -> void:
	visible = false


func _on_build_pressed() -> void:
	# Disabled right away so a fast double click cannot confirm twice.
	_build_button.disabled = true
	confirmed.emit()
