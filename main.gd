extends Node2D



func _on_quit_pressed():
	get_tree().quit()


func _on_play_pressed():
	# Start game from Level 1
	const path: String = "res://level_1.tscn"
	var error = get_tree().change_scene_to_file(path)
	# Error Checking
	if error == ERR_CANT_OPEN:
		print("Failed to load path into a PackedScene")
	elif error == ERR_CANT_CREATE:
		print("Failed to instantiate scene")
	elif error == OK:
		print("Loaded: Level 1")
