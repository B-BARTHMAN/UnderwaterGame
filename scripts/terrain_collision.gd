#@tool

extends CollisionShape3D

@export var max_height : float
@export var height_map : NoiseTexture2D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if Engine.is_editor_hint():
		print("Generating Collision Mesh for ground")
		
		await height_map.changed
		
		var img : Image = height_map.get_image()
		
		var height : PackedFloat32Array = PackedFloat32Array()
		height.resize(101 * 101)
		
		var i = 0
		for y in range(101):
			for x in range(101):
				height.set(i, max_height * img.get_pixel(x, y).r)
				i+=1
		
		shape.map_data = height

