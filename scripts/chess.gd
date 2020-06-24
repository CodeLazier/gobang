extends Sprite
class_name Chess

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

export (Global.CHESS_COLOR) var ChessColor setget setChessColor
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func flash()->void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play('flash')

func setChessColor(cc:int)->void:
	if cc==Global.CHESS_COLOR.CC_WHITE:
		texture=Global.gw_texture
	else:
		texture=Global.gb_texture
		
	ChessColor=cc
