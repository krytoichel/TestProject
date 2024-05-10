extends Node2D

@onready var light = $DirectionalLight2D

func _process(_delta):
	var tween = get_tree().create_tween()
	tween.tween_property(light, 'energy', 0.2, 5)
		
	
