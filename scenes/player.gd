extends XROrigin3D

@export var swim_speed : float = 1.

@export var lefthand : XRController3D
@export var righthand : XRController3D
@export var camera : XRCamera3D

var lh_full : bool = false
var rh_full : bool = false
@export var lh_slot : Node3D
@export var rh_slot : Node3D

@export var all_trash : Node3D

@export var left_collision : Area3D
var left_objects = []
@export var right_collision : Area3D
var right_objects = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var left_stick := lefthand.get_vector2("primary")
	var left_grab := lefthand.get_float("grip")
	var right_grab := righthand.get_float("grip")
	
	#movement
	if left_stick.y > 0.25:
		global_position -= delta * left_stick.y * swim_speed * camera.global_transform.basis.z
	
	if left_grab > 0.9 and not lh_full:
		for v in left_objects:
			var p = v.global_position
			var r = v.global_rotation
			all_trash.remove_child(v)
			lh_slot.add_child(v)
			v.collision_layer = 4
			v.global_position = p
			v.global_rotation = r
			lh_full = true
			break
	if left_grab < 0.1 and lh_full:
		var obj = lh_slot.get_child(0)
		var p = obj.global_position
		var r = obj.global_rotation
		lh_slot.remove_child(obj)
		all_trash.add_child(obj)
		obj.collision_layer = 2
		obj.global_position = p
		obj.global_rotation = r
		lh_full = false
	if right_grab > 0.9 and not rh_full:
		for v in right_objects:
			var p = v.global_position
			var r = v.global_rotation
			all_trash.remove_child(v)
			rh_slot.add_child(v)
			v.collision_layer = 4
			v.global_position = p
			v.global_rotation = r
			rh_full = true
			break
	if right_grab < 0.1 and rh_full:
		var obj = rh_slot.get_child(0)
		var p = obj.global_position
		var r = obj.global_rotation
		rh_slot.remove_child(obj)
		all_trash.add_child(obj)
		obj.collision_layer = 2
		obj.global_position = p
		obj.global_rotation = r
		rh_full = false

func _on_grabarea_r_body_entered(body):
	right_objects.append(body)

func _on_grabarea_r_body_exited(body):
	right_objects.erase(body)

func _on_grabarea_l_body_entered(body):
	left_objects.append(body)

func _on_grabarea_l_body_exited(body):
	left_objects.erase(body)

func _on_trashbag_body_entered(body):
	
	for obj in rh_slot.get_children():
		if obj == body:
			body.queue_free()
			rh_full = false
	for obj in lh_slot.get_children():
		if obj == body:
			body.queue_free()
			lh_full = false
