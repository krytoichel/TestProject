extends Node3D

@onready var light1 = $DirectionalLight2D

func _on_quit_pressed():
	get_tree().quit()
	
func _on_play_pressed():
	var tween = get_tree().create_tween()
	tween.tween_property(light1, 'energy', 0.95, 2)
	await tween.finished
	get_tree().change_scene_to_file('res://level.tscn')

