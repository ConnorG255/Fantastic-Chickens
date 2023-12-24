extends CharacterBody3D


const cspeed = 5
var SPEED = 5.0
const JUMP_VELOCITY = 4.5
const sense = 0.003
const boost = 1.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var chicken = $chicken


#head movement captures
func _ready():
	
	camera.current = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass
#head speeeen
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * sense)
		camera.rotate_x(-event.relative.y * sense)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	
func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
		

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta


	if Input.is_action_just_pressed("Space") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
# Theres a better way to do this but I dont know how to do it sooooo
	if Input.is_action_pressed("LShift"):
		SPEED = boost * cspeed
	else:
		SPEED = cspeed

	
	chicken.rotation = head.rotation
	var input_dir = Input.get_vector("A", "D", "W", "S")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
