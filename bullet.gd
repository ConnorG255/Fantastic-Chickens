extends RigidBody3D

var bulletspeed = 1000
var force = 10

	
func _ready():
	#apply_force(Vector3(0,0,-bulletspeed), Vector3(0,0,0))
	#apply_force(transform.basis.z, -transform.basis.z * bulletspeed)
	pass

	



 
func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		var direct = get_linear_velocity()
		body.velocity.x +=  direct.x * force
		body.velocity.z +=  direct.z * force
		#body.apply_force(transform, direction * force)
		print(direct)
		queue_free()
	else:
		queue_free()
	pass # Replace with function body.
