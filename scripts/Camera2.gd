extends Camera3D

@onready var ball = $".."
@onready var sphere = preload("res://scripts/sphere.tscn")  # Load the sphere scene
@onready var camera: Camera3D = $"."  # Reference to the Camera3D node

# RAYCAST VARS
const ray_length = 100
var mouse_pos : Vector2
var from : Vector3
var to : Vector3
var space : PhysicsDirectSpaceState3D
var query : PhysicsRayQueryParameters3D

# CAM FOLLOW VARS
var vector : Vector3

# FOLLOW BALL
func _ready() -> void:
	# PREVENT ROTATION.
	camera.set_as_top_level(true)  # Use `camera` instead of `self`

# GET MOUSE POSITION
func camera_raycast():
	mouse_pos = get_viewport().get_mouse_position()
	from = camera.project_ray_origin(mouse_pos)  # Use `camera` instead of `self`
	to = from + camera.project_ray_normal(mouse_pos) * ray_length  # Use `camera` instead of `self`
	space = camera.get_world_3d().direct_space_state  # Use `camera` instead of `self`
	# RAYCAST CHECK SECOND MASK
	query = PhysicsRayQueryParameters3D.create(from, to, 2)
	
	return space.intersect_ray(query)

# HANDLE MOUSE CLICKS
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var result = camera_raycast()
		if result:
			var hit_position = result.position
			spawn_sphere(hit_position)

# SPAWN SPHERE AT HIT POSITION
func spawn_sphere(position: Vector3) -> void:
	var new_sphere = sphere.instantiate()
	get_parent().add_child(new_sphere)
	new_sphere.global_transform.origin = position
