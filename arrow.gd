extends Node2D

func _process(delta):
	var global_mouse_pos = get_global_mouse_position()
	look_at(global_mouse_pos)
