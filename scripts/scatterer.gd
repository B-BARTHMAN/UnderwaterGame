#@tool
extends Node3D

@export var height : float = 2.5
@export var height_map : NoiseTexture2D

@export var rock : PackedScene
@export var rock_count : int = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if Engine.is_editor_hint():
		
		print("removing all objects")
		
		for n in get_children():
			remove_child(n)
		
		print("placing objects")
		await height_map.changed
		
		var img : Image = height_map.get_image()
		
		for i in range(rock_count):
			
			var randx = randf_range(-50, 50)
			var randz = randf_range(-50, 50)
			
			var randxi : int = clampi(roundi((randx + 50.)/100.*512.), 0, 511)
			var randzi : int = clampi(roundi((randz + 50.)/100.*512.), 0, 511)
			
			var h : float = img.get_pixel(randxi, randzi).r * height
			
			var r := rock.instantiate()
			add_child(r)
			r.global_position = Vector3(randx, h, randz)

