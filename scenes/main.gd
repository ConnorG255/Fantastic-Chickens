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
	

func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()
	

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
	multiplayer.peer_disconnected.connect(remove_player)
	addPlayer(multiplayer.get_unique_id())
	upnp_setup()
	
func upnp_setup():
	var upnp = UPNP.new()
	var discoverupnp = upnp.discover()
	print("Working: " % upnp.query_external_address())

