extends Node2D

@onready var light = $DirectionalLight2D
@onready var health_bar = $CanvasLayer/HealthBar
@onready var player = $Player/Player

func _process(_delta):
	var tween = get_tree().create_tween()
	tween.tween_property(light, 'energy', 0.2, 2)

func _ready():
	health_bar.max_value = player.max_health
	health_bar.value = health_bar.max_value
		
func _on_player_health_changed(new_health):
	health_bar.value = new_health
