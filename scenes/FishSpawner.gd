extends Node3D

@export var fish_scene: PackedScene
@export var fish_limit = 50
@export var fish_despawn_distance = 50


@export var root_node : Node3D
@export var player_camera : XRCamera3D

var fishes = Array()

func _on_spawn_timer_timeout():
	var player_position = player_camera.global_position
	var i = 0
	while i < fishes.size():
	#for i in range(fishes.size()):
		var fish = fishes[i]
		#remove fish if it's too far away from the player
		if fish.get_fish_pos().distance_to(player_position) > fish_despawn_distance:
			fishes.remove_at(i)
			root_node.remove_child(fish)
		else:
			i += 1
		
	if (fishes.size() >= fish_limit):
		return
		
	$SpawnPath/SpawnLocation.progress_ratio = randf()
	var spawn_location = $SpawnPath/SpawnLocation/Dummy.global_position
	var new_fish = fish_scene.instantiate()
	new_fish.initialize(spawn_location, player_position)
	
	root_node.add_child(new_fish)
	fishes.append(new_fish)
