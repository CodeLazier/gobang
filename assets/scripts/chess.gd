extends Sprite
class_name Chess

signal confirm_signal


var ChessColor : int setget setChessColor


func flash()->void:
	$Tween.repeat=true
	$Tween.interpolate_property(self,"visible",false,true,0.38, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	$Tween.start()

func confirm()->void:
	$Tween.repeat=false
	for _i in range(0,2):
		$Tween.interpolate_property(self,"visible",true,false,0.23, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
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
