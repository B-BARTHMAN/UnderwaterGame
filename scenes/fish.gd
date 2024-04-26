extends Node3D

@export var speed = 0.3
@export var path_length = 0.3

var path
var fish
	
func _ready():
	pass

func _physics_process(_delta):
	if ($Path3D/PathFollow3D.progress_ratio + _delta*speed >= 1):
		$Path3D/PathFollow3D.progress_ratio = 1
	else:
		$Path3D/PathFollow3D.progress_ratio += _delta*speed
	#print($Path3D/PathFollow3D.progress)
	
	#path_location.progress_ratio += _delta * speed
	#var delta_pos = path_location.position - fish.position
	#fish.look_at_from_position($Pivot.position, path_location.position, fish.get_global_transform().basis.x)
	#fish.position = path_location.position
	if ($Path3D/PathFollow3D.progress_ratio >= 1):
		#generate_path_point()
		#$Path3D.curve.remove_point(0)
		#var rdm_vec = Vector3(randf(),randf(),randf()).normalized()
		#for i in range(100):
			#generate_path_point()
		#_smooth_curve.remove_front_point(10)
		#_update_path()
		add_path_node()
		path.remove_point(0)
		$Path3D/PathFollow3D.progress_ratio = 0
		#var temp = _smooth_curve.get_point_position(_smooth_curve.point_count() - 1)
		#initialize(temp, temp + rdm_vec)
	
func add_path_node() -> void:
	var new_point = path.get_point_position(path.point_count - 1)
	var new_dir = -fish.global_transform.basis.z.normalized() * path_length
	#print(fish.global_transform.basis.z)
	#print(new_dir)
	new_dir = new_dir.rotated(fish.global_transform.basis.x, randf_range(-PI / 1, PI / 1))
	new_dir = new_dir.rotated(fish.global_transform.basis.y, randf_range(-PI / 1, PI / 1))
	new_dir = new_dir.rotated(fish.global_transform.basis.z, randf_range(-PI / 1, PI / 1))
	new_point = new_point + new_dir#ector3(2 *randf() - 1,2 *randf() - 1,2 *randf() - 1).normalized()
	path.add_point(new_point, 2*get_rdm_dir(), Vector3.ZERO)
	path.set_point_out(path.point_count - 2, -path.get_point_in(path.point_count - 2))
	#print(new_point)
	#$Path3D.curve.set_point_position(0, $Path3D/PathFollow3D/Pivot.position)



func initialize(start_position, player_position):
	path = $Path3D.curve
	#print(path.point_count)
	fish = get_node("Path3D/PathFollow3D/Pivot")
	var next_point = start_position + (player_position - start_position).normalized() * path_length
	#fish.look_at_from_position(start_position, player_position, Vector3.UP)
	#fish.rotate_z(randf_range(-PI / 4, PI / 4))
	#$Path3D.initialize(Vector3.ZERO, -fish.get_global_transform().basis.z)
	#print(start_position)
	path.add_point(start_position, Vector3.ZERO, get_rdm_dir())
	path.add_point(next_point, get_rdm_dir(), -get_rdm_dir())
	#path.add_point(next_next_point, get_rdm_dir(), Vector3.ZERO)
	#print(dir_vector)
	#for i in range(10):
		#generate_path_point()
	#_update_path()
	#$Path3D.curve.add_point(start_position, Vector3.ZERO, Vector3.ZERO)
	#$Path3D.curve.add_point(dir_vector, Vector3.ZERO, Vector3.ZERO)
	
func get_rdm_dir() -> Vector3:
		return Vector3(randf(),randf(),randf()).normalized()
		
func get_fish_pos() -> Vector3:
		return $Path3D/PathFollow3D/Pivot.global_position
