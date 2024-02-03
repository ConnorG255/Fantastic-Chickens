extends Node2D

func _ready():
	var ip="123.85.255.232"
	
	var code=code(ip)
	print("code:",code)
	
	print("decode:",decode(code))

