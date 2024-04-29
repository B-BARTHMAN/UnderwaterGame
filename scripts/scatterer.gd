@tool
extends MultiMeshInstance3D

@export var height : float = 2.5
@export var height_map : NoiseTexture2D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if Engine.is_editor_hint():
		
		await height_map.changed
		
		var img : Image = height_map.get_image()
		
		var arr : PackedFloat32Array = multimesh.buffer.duplicate()
		
		for i in range(multimesh.instance_count):
			
			var randx = arr[12 * i + 3]
			var randz = arr[12 * i + 11]
			
			var randxi : int = clampi(roundi((randx + 50.)/100.*512.), 0, 511)
			var randzi : int = clampi(roundi((randz + 50.)/100.*512.), 0, 511)
			
			var h : float = img.get_pixel(randxi, randzi).r * height
			
			arr.set(12 * i + 7, h)
			multimesh.buffer = arr
			#r.global_position = Vector3(randx, h, randz)

