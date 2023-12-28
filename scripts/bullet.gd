extends RigidBody3D

var bulletspeed = 1000
var force = 10

	
func _ready():
	#apply_force(Vector3(0,0,-bulletspeed), Vector3(0,0,0))
	#apply_force(transform.basis.z, -transform.basis.z * bulletspeed)
	pass

	

func _on_area_3d_body_entered(body):
	
	pass # Replace with function body.

 

