class_name ConstructionController
extends Node
## Runs the construction flow: site -> confirmation -> construction. Each site
## has a fixed building type (BuildingSite.definition), so there is no building
## selection step. Cancelling closes the flow and changes nothing.

var _settlement: SettlementState
var _confirm_dialog: ConstructionConfirmDialog

## Site of the flow in progress. It is fixed for the whole flow, so the player
## cannot switch sites halfway.
var _target_site: BuildingSite


func setup(settlement: SettlementState, confirm_dialog: ConstructionConfirmDialog) -> void:
	_settlement = settlement
	_confirm_dialog = confirm_dialog
	_confirm_dialog.confirmed.connect(_on_confirmed)
	_confirm_dialog.cancelled.connect(_end_flow)


func begin_construction(site: BuildingSite) -> void:
	if _target_site != null or not _settlement.is_site_available(site.site_id):
		return
	_target_site = site
	_confirm_dialog.open(site.definition)


func _on_confirmed() -> void:
	# Guards against repeated Build clicks: the flow is reset after the first one.
	if _target_site == null:
		return
	var site := _target_site
	_end_flow()
	_settlement.construct_building(site.site_id, site.definition.id)


func _end_flow() -> void:
	_target_site = null
	_confirm_dialog.close()
