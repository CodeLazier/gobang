extends Sprite


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var gb_texture:Texture
var gw_texture:Texture

const CHESS_SPACE:Vector2=Vector2(35.36,35.36)
const CHESS_ORIGIN:Vector2=Vector2(22,23)
const CHESS_SPACE_H:Vector2=Vector2(35,0)
const CHESS_SPACE_V:Vector2=Vector2(0,35)
const CHESS_WHITE=2
const CHESS_BLACK=1
const CHESS_BLANK=0
const CHESS_INVILID=-1
const CHESS_NUMBER=15
var CHESS_ARRAY=[]

var Current_Input:int=CHESS_BLACK

func getChessState(x,y:int)->int:
	if x<0 || x>CHESS_NUMBER-1 || y<0 || y>CHESS_NUMBER-1:
		return CHESS_INVILID
	return CHESS_ARRAY[x+y*CHESS_NUMBER]
#检查是否五子连通
#p 最后下的位置
func checkChessSuccess(p:Vector2)->bool:
	var x:int=p.x
	var y:int=p.y
	var c=getChessState(x,y)
	
	var ha=[p]
	var va=[p]
	var sa_d=[p]
	var sa_u=[p]
	
	#横
	for i in range(x+1,x+5):
		if getChessState(i,y)!=c:
			break
		else:
			ha.append(Vector2(i,y))
			
	for i in range(x-1,x-5,-1):
		if getChessState(i,y)!=c:
			break
		else:
			ha.append(Vector2(i,y))
			
	#竖
	for i in range(y+1,y+5):
		if getChessState(x,i)!=c:
			break
		else:
			va.append(Vector2(x,i))
			
	for i in range(y-1,y-5,-1):
		if getChessState(x,i)!=c:
			break
		else:
			va.append(Vector2(x,i))
			
	#斜下
	for i in range(1,5):
		if getChessState(x+i,y+i)!=c:
			break
		else:
			sa_d.append(Vector2(x+i,y+i))
			
	for i in range(-1,-5,-1):
		if getChessState(x+i,y+i)!=c:
			break
		else:
			sa_d.append(Vector2(x+i,y+i))
			
	#斜上
	for i in range(1,5):
		if getChessState(x+i,y-i)!=c:
			break
		else:
			sa_d.append(Vector2(x+i,y-i))
			
	for i in range(-1,-5,-1):
		if getChessState(x+i,y-i)!=c:
			break
		else:
			sa_d.append(Vector2(x+i,y-i))
			
			
	print("横线:",ha.size())
	if ha.size()>4:
		return true
		
	print("竖线:",va.size())
	if va.size()>4:
		return true
		
	print("斜线:",sa_d.size()," ",sa_u.size())
	if sa_d.size()>4 || sa_u.size()>4:
		return true
	
	return false
	
#v 逻辑坐标
func createChess(v:Vector2,white:bool)->Sprite:
	var x:int=round(v.x)
	var y:int=round(v.y)
	if x<0 || x>CHESS_NUMBER-1 || y<0 || y>CHESS_NUMBER-1:
		return null
		
	var index:int=x+y*CHESS_NUMBER
	var cv=CHESS_ARRAY[index]
	if cv!=null && cv>0:
		return null
		
	var sprite=Sprite.new()
	if white:
		sprite.texture=gw_texture
	else:
		sprite.texture=gb_texture

	var flag:int=CHESS_WHITE
	if !white:
		flag=CHESS_BLACK
	CHESS_ARRAY[index]=flag
	
	sprite.position=Vector2(x,y) * CHESS_SPACE + CHESS_ORIGIN
	
	add_child(sprite)
	return sprite
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gb_texture=preload("res://assets/textures/gb.png")
	gw_texture=preload("res://assets/textures/gw.png")
	CHESS_ARRAY.resize(CHESS_NUMBER*CHESS_NUMBER)

func downChess(e:InputEventMouseButton):
	var v=(e.position - CHESS_ORIGIN) / CHESS_SPACE
	if createChess(v,Current_Input==CHESS_WHITE)!=null:
		if !checkChessSuccess(v.round()):
			if Current_Input==CHESS_BLACK:
				Current_Input=CHESS_WHITE
			else:
				Current_Input=CHESS_BLACK
		else:
			$Label.text="ok"
			#赢了
			

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var e=event as InputEventMouseButton
		if e.pressed:
			downChess(e)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
