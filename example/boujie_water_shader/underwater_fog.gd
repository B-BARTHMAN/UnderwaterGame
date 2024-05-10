extends FogVolume

@export var visible_height_offset := 0.0
@export var camera : XRCamera3D

func _process(_delta):
	var camera = get_parent().get_camera()
	if camera:
		visible = camera.position.y < (position.y + visible_height_offset)
