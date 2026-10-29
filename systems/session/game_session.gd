class_name GameSession
extends RefCounted
## Transient, unsaved state of one play session.
## Gameplay data (settlement, resources, ...) will be added here later.
## Each session is a new instance, so nothing can leak between sessions.

var settlement := SettlementState.new()
