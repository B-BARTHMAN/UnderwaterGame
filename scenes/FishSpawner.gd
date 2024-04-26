extends Node3D

@export var fish_scene: PackedScene
@export var fish_limit = 50
@export var fish_despawn_distance = 50

var fishes = Array()

func _on_spawn_timer_timeout():
	var player_position = get_parent().get_node("Camera").global_position
	var i = 0
	while i < fishes.size():
	#for i in range(fishes.size()):
		var fish = fishes[i]
		#remove fish if it's too far away from the player
		if fish.get_fish_pos().distance_to(player_position) > fish_despawn_distance:
			print("fish: ")
			print(fish.get_fish_pos())
			print("Camera: ")
			print(player_position)
			fishes.remove_at(i)
			get_node("/root/main").remove_child(fish)
		else:
			i += 1
		
	if (fishes.size() >= fish_limit):
		return
		
	$SpawnPath/SpawnLocation.progress_ratio = randf()
	#print($SpawnPath/SpawnLocation/Dummy.position)
	var spawn_location = $SpawnPath/SpawnLocation/Dummy.global_position
	#print(spawn_location)
	#var player_position = Vector3.ZERO	# NEEDS TO BE SET CORRECTLY
	var new_fish = fish_scene.instantiate()
	new_fish.initialize(spawn_location, player_position)
	
	get_node("/root/main").add_child(new_fish)
	fishes.append(new_fish)
