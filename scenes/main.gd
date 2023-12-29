extends Node3D

@onready var main_menu = $"CanvasLayer/main menu"
@onready var address = $"CanvasLayer/main menu/MarginContainer/VBoxContainer/address"

const aPlayer = preload("res://prefabs/player.tscn")
const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()


func addPlayer(peer_id):
	var player = aPlayer.instantiate()
	player.name = str(peer_id)
	get_node("/root/main/Network").add_child(player)
	
	
func _on_join_pressed():
	main_menu.hide()
	
	enet_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enet_peer
	
	pass # Replace with function body.


func _on_host_pressed():
	main_menu.hide()
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(addPlayer)
	
	addPlayer(multiplayer.get_unique_id())
	
	
	pass # Replace with function body.

