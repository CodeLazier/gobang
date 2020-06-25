extends Sprite
class_name Chess

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
signal confirm_signal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var ChessColor : int setget setChessColor
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func flash()->void:
	$Tween.repeat=true
	$Tween.interpolate_property(self,"visible",false,true,0.38, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	$Tween.start()

func confirm()->void:
	$Tween.repeat=false
	for i in range(0,2):
		$Tween.interpolate_property(self,"visible",true,false,0.32, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
		$Tween.start()
		yield($Tween,'tween_all_completed')
	
	visible=true
	emit_signal('confirm_signal')


func setChessColor(cc:int)->void:
	if cc==Global.CHESS_COLOR.CC_WHITE:
		texture=Global.gw_texture
	else:
		texture=Global.gb_texture
		
	ChessColor=cc
