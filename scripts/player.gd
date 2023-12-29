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
var directionn
var forcemulti = 1
var canmove = true



func _enter_tree():
	set_multiplayer_authority(str(name).to_int())
#head movement captures
func _ready():
	if not is_multiplayer_authority(): return
	camera.current = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	pass
	
#head speeeen
func _unhandled_input(event):
	if not is_multiplayer_authority(): return
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * sense)
		camera.rotate_x(-event.relative.y * sense)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	
func _process(delta):
	if not is_multiplayer_authority(): return
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()

@rpc("any_peer", "call_local", "reliable")
func shoot():
	pewanim.play("gunmove")
	var b = bullet.instantiate()
	b.position = spoint.global_position
	b.transform.basis =  spoint.global_transform.basis
	#b.name = "bullet" + name
	b.apply_force(-spoint.global_transform.basis.z.normalized() * bulletspeed)
	get_parent().add_child(b, true)

func _physics_process(delta):
	if not is_multiplayer_authority(): return
	if Input.is_action_pressed("LMB"):
		if !pewanim.is_playing():
			shoot.rpc()
	
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

	if canmove:
		directionn = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if directionn:
			velocity.x = directionn.x * SPEED
			velocity.z = directionn.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

@rpc("any_peer")
func despawnbullet(b):
	b.queue_free()
	
	
func hit():
	await(get_tree().create_timer(1).timeout)
	canmove = true 
	
func _on_area_3d_body_entered(body):
	if body.is_in_group("bullet"):
		canmove = false
		
		var direct = body.get_linear_velocity()
		hit();
		velocity.y += 2 * forcemulti
		velocity.x += direct.x * 0.1 * forcemulti
		velocity.z += direct.z * 0.1 * forcemulti
		
		forcemulti += 1 
		despawnbullet(body)
	
		
		
	pass # Replace with function body.


func _on_area_3d_area_entered(area):
	if area.is_in_group("barrier"):
		forcemulti = 0
		position = Vector3.ZERO
		self.velocity = Vector3.ZERO
	pass # Replace with function body.
