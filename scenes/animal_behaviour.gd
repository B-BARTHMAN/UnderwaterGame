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

	if ($Path3D/PathFollow3D.progress_ratio >= 1):
		add_path_node()
		path.remove_point(0)
		$Path3D/PathFollow3D.progress_ratio = 0
	
func add_path_node() -> void:
	var new_point = path.get_point_position(path.point_count - 1)
	var new_dir = -fish.global_transform.basis.z.normalized() * path_length
	new_dir = new_dir.rotated(fish.global_transform.basis.x, randf_range(-PI / 1, PI / 1))
	new_dir = new_dir.rotated(fish.global_tsransform.basis.y, randf_range(-PI / 1, PI / 1))
	new_dir = new_dir.rotated(fish.global_transform.basis.z, randf_range(-PI / 1, PI / 1))
	new_point = new_point + new_dir
	path.add_point(new_point, 2*get_rdm_dir(), Vector3.ZERO)
	path.set_point_out(path.point_count - 2, -path.get_point_in(path.point_count - 2))



func initialize(start_position, player_position):
	path = $Path3D.curve
	fish = get_node("Path3D/PathFollow3D/Pivot")
	var next_point = start_position + (player_position - start_position).normalized() * path_length
	path.add_point(start_position, Vector3.ZERO, get_rdm_dir())
	path.add_point(next_point, get_rdm_dir(), -get_rdm_dir())
	
func get_rdm_dir() -> Vector3:
		return Vector3(randf(),randf(),randf()).normalized()
		
func get_fish_pos() -> Vector3:
		return $Path3D/PathFollow3D/Pivot.global_position
