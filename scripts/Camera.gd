extends Camera3D

@onready var ball = $".."

#RAYCAST VARS
const ray_length = 100
var mouse_pos : Vector2
var from :Vector3
var to : Vector3
var space : PhysicsDirectSpaceState3D
var query : PhysicsRayQueryParameters3D

#CAM FOLLOW VARS
var vector : Vector3

#FOLLOW BALL
func _ready() -> void:
#PREVENT ROTATION.
	self.set_as_top_level(true)

#GET MOUSE POSITION
func camera_raycast():
	mouse_pos = get_viewport().get_mouse_position()
	from = project_ray_origin(mouse_pos) 
	to = from + project_ray_normal(mouse_pos) * ray_length
	space = get_world_3d().direct_space_state
	#RAYCAST CHECK SECOND MASK
	query = PhysicsRayQueryParameters3D.create(from,to,2)
	
	return space.intersect_ray(query)
