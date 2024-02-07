extends Node


@onready var main_menu = $"CanvasLayer/main menu"
@onready var address_entry = $"CanvasLayer/main menu/MarginContainer/VBoxContainer/address"
@onready var username = $"CanvasLayer/main menu/MarginContainer/VBoxContainer/Username"
var theutext 

const Player = preload("res://prefabs/player.tscn")
const PORT = 9970
var enet_peer = ENetMultiplayerPeer.new()





func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	player.pusername = str(theutext)
	print(str(username))
	Global.players.append(player.pusername)
	Global.playercounter += 1
	print(player.pusername)
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
	
	print("Working: %s" % code(upnp.query_external_address()))

#
func _on_host_pressed():
	main_menu.hide()
	if not is_multiplayer_authority(): return
	theutext = username.text
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	
	add_player(multiplayer.get_unique_id())
	
	upnp_setup()

	pass # Replace with function body.


func _on_join_pressed():
	if not is_multiplayer_authority(): return
	main_menu.hide()
	# Cant have the username text update in player, needs to be here/ after, but also has to 
	#actually go into the add_player function
	theutext = username.text
	#decode(address_entry.text)
	enet_peer.create_client("localhost", PORT)
	
	multiplayer.multiplayer_peer = enet_peer
	pass # Replace with function body.


func ascii(x):
	return char(x+38)

func intt(x):
	return x.to_ascii_buffer()[0]-38

func code(x):
	x+="."
	var tab=[0,0,0,0]
	var oldpoint=0
	var point=x.find(".")
	for i in range(4):
		tab[i]=int(x.substr(oldpoint,point-oldpoint))
		oldpoint=point+1
		point=x.find(".",point+1)

	var base = 1
	var num = 0
	for i in range(3,-1,-1):
		num += tab[i] * base;
		base = base * 256;

	var code="";
	for _i in range(5):
		var temp = 0;
		temp = num % 85;
		code+= ascii(temp);
		num = num / 85;
	
	return code;

func decode(x):
	var tab=[0,0,0,0,0]
	for i in range(5):
		tab[i] = intt(x[i]);
	
	var base = 1;
	var num = 0;
	for i in range(5):
		num += tab[i] * base;
		base = base * 85;

	var ipx=[0,0,0,0];
	for i in range(4):
		var temp = 0;
		temp = num % 256;
		ipx[3-i] = temp;
		num = num / 256;
	var out = "";
	for i in range(4):
		out += str(ipx[i]);
		if (i != 3):
			out += ".";
	
	return out;
