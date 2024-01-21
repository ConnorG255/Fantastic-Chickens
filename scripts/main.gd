extends Node


@onready var main_menu = $"CanvasLayer/main menu"
@onready var address_entry = $"CanvasLayer/main menu/MarginContainer/VBoxContainer/address"

const Player = preload("res://prefabs/player.tscn")
const PORT = 9970
var enet_peer = ENetMultiplayerPeer.new()

func _unhandled_input(event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()



func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	add_child(player)
	

func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()



func upnp_setup():
	var upnp = UPNP.new()
	var err = upnp.discover()
	if err == OK:
		if upnp.get_gateway() and upnp.get_gateway().is_valid_gateway():
			upnp.get_gateway().add_port_mapping(PORT, PORT, "GAME_NAME Multiplayer", "UDP")
			upnp.get_gateway().add_port_mapping(PORT, PORT, "GAME_NAME Multiplayer", "TCP")
	else:
		push_error("UPNP error: %d" % err)
	
	print("Success! Join Address: %s" % upnp.query_external_address())


func _on_host_pressed():
	main_menu.hide()

	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	
	add_player(multiplayer.get_unique_id())
	
	upnp_setup()

	pass # Replace with function body.


func _on_join_pressed():
	main_menu.hide()

	#address_entry.text
	enet_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enet_peer
	pass # Replace with function body.
