extends ParallaxBackground

var speed = 30

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scroll_offset.x -= speed * delta

var rng = RandomNumberGenerator.new()
func _on_p_lforest_1_child_entered_tree(_node):
	var mrn = rng.randi_range(0,3)
	if mrn == 0:
		$PLforest1.visible = true
		$PLforest2.visible = true
		$PLforest3.visible = true
	elif mrn == 1:
		$PLhills1.visible = true
		$PLhills2.visible = true
		$PLhills3.visible = true
		$PLhills4.visible = true
	elif mrn == 2:
		$PLdesert1.visible = true
		$PLdesert2.visible = true
		$PLdesert3.visible = true
		$PLdesert4.visible = true
		$PLdesert5.visible = true
		$PLdesert6.visible = true
		$PLdesert7.visible = true
	else:
		$PLrt1.visible = true
		$PLrt2.visible = true
		$PLrt3.visible = true
		
	
	
	

	
