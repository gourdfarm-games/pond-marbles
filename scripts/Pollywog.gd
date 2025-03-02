extends RigidBody3D

@export var max_speed : int = 15
@export var accel : int = 50
@export var sensitivity : float = 2.0 

@onready var scaler = $Scaler
@onready var camera_3d = $Camera3D

var selected : bool = false
var velocity : Vector3
var speed : Vector3
var distance : float
var diraction : Vector3

func _ready() -> void:
	#PREVENT ROTATION
	scaler.set_as_top_level(true)
	pass

#CHECK IF BALL IS SELECTED
func _on_input_event(camera, event, position, normal, shape_idx) -> void:
	if event.is_action_pressed("left_mb"):
		selected = true

func _input(event) -> void:
	#CALCULATE SPEED & DIRECTION AFTER RELEASE 
	if event.is_action_released("left_mb"):
		if selected:
			#SPEED X SENSETIVITY
			speed = - (diraction * distance * accel * sensitivity).limit_length(max_speed)
			shoot(speed)
		selected = false

func _process(delta) -> void:
	#FOLLOW BALL
	scaler_follow()
	pull_metter()

#SHOOT BALL
func shoot(vector: Vector3) -> void:
	velocity = Vector3(vector.x, 0, vector.z)
	self.apply_impulse(velocity, Vector3.ZERO)

#FOLLOW BALL
func scaler_follow() -> void:
	scaler.transform.origin = scaler.transform.origin.lerp(self.transform.origin, 0.8)

func pull_metter() -> void:
	#CALLING RAYCAST FROM CAM 
	var ray_cast = camera_3d.camera_raycast()

	if not ray_cast.is_empty():
		#CALCUATE DISTANCE BETWEEN BALL AND MOUSE
		distance = self.position.distance_to(ray_cast.position)
		#CALCULATE DIRECTION BETWEEN BALL AND MOUSE
		diraction = self.transform.origin.direction_to(ray_cast.position)
		#LOOK AT MOUSE POSITION 
		scaler.look_at(Vector3(ray_cast.position.x, position.y, ray_cast.position.z))

		if selected:
			#SCALE SCALER
			scaler.scale.z = clamp(distance * sensitivity, 0, 5)
		else:
			#RESET SCALER
			scaler.scale.z = 0.01
