extends RigidBody3D

var bulletspeed = 50
func _ready():
	pass
	#may want to use apply force but need to get it so it works with the rotation
	
func _physics_process(delta):
	position += transform.basis * Vector3(0,0,-bulletspeed) * delta
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		#damage
		queue_free()
	else:
		queue_free()
	pass # Replace with function body.
