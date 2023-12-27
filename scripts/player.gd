extends CharacterBody3D

var SPEED = 20.0
const JUMP_VELOCITY = 8

const sense = 0.003
const boost = 1.5

var bulletspeed = 1000

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var chicken = $sprites
@onready var anim = $sprites/chickena
@onready var notanim = $sprites/chickenr

@onready var spoint = $Head/Camera3D/shootingpoint
@onready var pewanim = $Head/Camera3D/rocketlaunch/AnimationPlayer
var bullet = preload("res://prefabs/bullet.tscn")



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
	if Input.is_action_pressed("LMB"):
		if !pewanim.is_playing():
			pewanim.play("gunmove")
			var b = bullet.instantiate()
			b.position = spoint.global_position
			b.transform.basis =  spoint.global_transform.basis
			#b.linear_velocity = Vector3(bulletspeed,0,0)
			b.apply_force(-spoint.global_transform.basis.z.normalized() * bulletspeed)
			get_parent().add_child(b)
	
	
	# Movement
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	if Input.is_action_just_pressed("Space") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	chicken.rotation = head.rotation
	var input_dir = Input.get_vector("A", "D", "W", "S")
	
	if input_dir and is_on_floor():
		anim.show()
		notanim.hide()
	else: 
		notanim.show()
		anim.hide()

	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
