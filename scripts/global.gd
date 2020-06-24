extends Node


var	gb_texture:Texture
var	gw_texture:Texture
enum CHESS_COLOR{CC_INVALID=-1,CC_BLANK=0,CC_WHITE,CC_BLACK}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gb_texture=preload("res://assets/textures/gb.png")
	gw_texture=preload("res://assets/textures/gw.png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
