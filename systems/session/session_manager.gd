extends Node
## Autoload that owns the lifetime of the current GameSession.
## It knows nothing about UI or scenes; callers decide when to navigate.

signal session_started(session: GameSession)
signal session_ended

var current_session: GameSession = null


func start_new_session() -> GameSession:
	# Drop any leftover session first so a new game never inherits old state.
	end_session()
	current_session = GameSession.new()
	session_started.emit(current_session)
	return current_session


func end_session() -> void:
	if current_session == null:
		return
	current_session = null
	session_ended.emit()


func has_active_session() -> bool:
	return current_session != null
