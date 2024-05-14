extends XROrigin3D

@export var swim_speed : float = 1.

@export var lefthand : XRController3D
@export var righthand : XRController3D
@export var camera : XRCamera3D

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
	
	if left_grab > 0.5:
		for v in left_objects:
			v.queue_free()
	if right_grab > 0.5:
		for v in right_objects:
			v.queue_free()

func _on_grabarea_r_body_entered(body):
	right_objects.append(body)

func _on_grabarea_r_body_exited(body):
	right_objects.erase(body)

func _on_grabarea_l_body_entered(body):
	left_objects.append(body)

func _on_grabarea_l_body_exited(body):
	left_objects.erase(body)
