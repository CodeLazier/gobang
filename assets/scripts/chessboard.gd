extends Sprite

const CHESS_SPACE:Vector2=Vector2(35.36,35.36)
const CHESS_ORIGIN:Vector2=Vector2(22,23)
const CHESS_SPACE_H:Vector2=Vector2(35,0)
const CHESS_SPACE_V:Vector2=Vector2(0,35)
const CHESS_NUMBER=15
var CHESS_ARRAY=[]
var IS_WIN:bool
var IS_CONFIRM:bool=false

export(int) var confirm_max=3
var confirm_count:int=0

var chessScene=preload('res://assets/scenes/chess.tscn')
onready var btn_restart:Button=$VBoxContainer/Button
onready var chessTip:Sprite=$chessTip
onready var downChessSample:AudioStreamPlayer=$chessSample

var current_input:int
var lastChess:Chess=null

func init()->void:
	for s in CHESS_ARRAY:
		if s!=null:
			s.queue_free()
			
	IS_WIN=false
	current_input=Global.CHESS_COLOR.CC_BLACK
	CHESS_ARRAY.resize(0)
	CHESS_ARRAY.resize(15*15)
	chessTip.texture=Global.gb_texture

func set_chess(x,y:int,s:Chess)->void:
	assert(in_chessboard(x,y))
	CHESS_ARRAY[x+y*CHESS_NUMBER]=s

func in_chessboard(x,y:int)->bool:
	return ! (x<0 || x>CHESS_NUMBER-1 || y<0 || y>CHESS_NUMBER-1)


func get_chess(x,y:int)->Chess:
	if !in_chessboard(x,y):
		return null
	
	return CHESS_ARRAY[x+y*CHESS_NUMBER] as Chess

func get_chessState(x,y:int)->int:
	var sprite=get_chess(x,y)
	if sprite!=null:
		return (sprite as Chess).ChessColor
		
	return Global.CHESS_COLOR.CC_INVALID
		
func check_chessFull()->bool:
	return CHESS_ARRAY.count(null)==0
		
#检查是否五子连通
#p 最后下的位置
func check_chessSuccess(p:Vector2)->bool:
	var x:int=int(p.x)
	var y:int=int(p.y)
	var c=get_chessState(x,y)
	
	var ha=[p]
	var va=[p]
	var sa_d=[p]
	var sa_u=[p]
	
	#横
	for i in range(1,5):
		if get_chessState(i+x,y)!=c:
			break
		else:
			ha.append(Vector2(i+x,y))
			
	for i in range(-1,-5,-1):
		if get_chessState(i+x,y)!=c:
			break
		else:
			ha.append(Vector2(i+x,y))
			
	#竖
	for i in range(1,5):
		if get_chessState(x,i+y)!=c:
			break
		else:
			va.append(Vector2(x,i+y))
			
	for i in range(-1,-5,-1):
		if get_chessState(x,i+y)!=c:
			break
		else:
			va.append(Vector2(x,i+y))
			
	#斜下
	for i in range(1,5):
		if get_chessState(x+i,y+i)!=c:
			break
		else:
			sa_d.append(Vector2(x+i,y+i))
			
	for i in range(-1,-5,-1):
		if get_chessState(x+i,y+i)!=c:
			break
		else:
			sa_d.append(Vector2(x+i,y+i))
			
	#斜上
	for i in range(1,5):
		if get_chessState(x+i,y-i)!=c:
			break
		else:
			sa_u.append(Vector2(x+i,y-i))
			
	for i in range(-1,-5,-1):
		if get_chessState(x+i,y-i)!=c:
			break
		else:
			sa_u.append(Vector2(x+i,y-i))
			
			
	print("横线:",ha.size())
	print("竖线:",va.size())
	print("斜线:",sa_d.size()," ",sa_u.size())
	
	if ha.size()>4 || va.size()>4 || sa_d.size()>4 || sa_u.size()>4:
		print("---",ha)
		print("|",va)
		print('/',sa_u)
		print('\\',sa_d)
		
		if ha.size()>4:
			for p in ha:
				get_chess(p.x,p.y).flash()
				
		if va.size()>4:
			for p in va:
				get_chess(p.x,p.y).flash()
				
		if sa_d.size()>4:
			for p in sa_d:
				get_chess(p.x,p.y).flash()
				
				
		if sa_u.size()>4:
			for p in sa_u:
				get_chess(p.x,p.y).flash()
		return true
	
	return check_chessFull()


#v 逻辑坐标
func create_chess(v:Vector2,cc:int)->Sprite:
	var x:int=int(round(v.x))
	var y:int=int(round(v.y))
	
	assert(in_chessboard(x,y))


	if get_chess(x,y)!=null:
		return null
		
	downChessSample.play()
	var sprite=chessScene.instance()
	sprite.ChessColor=cc
	sprite.position=Vector2(x,y) * CHESS_SPACE + CHESS_ORIGIN
	lastChess=sprite
	add_child(sprite)
	return sprite

func confirm_chess(chess:Chess)->void:
	IS_CONFIRM=true
	chess.confirm()
	yield(chess,'confirm_signal')
	IS_CONFIRM=false

func put_chess(e:InputEventMouseButton):
	var v=(e.position - CHESS_ORIGIN) / CHESS_SPACE
	var vx:int=int(round(v.x))
	var vy:int=int(round(v.y))

	if in_chessboard(vx,vy):
		if IS_CONFIRM && lastChess!=null && get_chess(vx,vy)==null:
			var lastP=((lastChess.position - CHESS_ORIGIN) / CHESS_SPACE ).round()
			set_chess(int(lastP.x),int(lastP.y),null)
			lastChess.queue_free()
			lastChess=null
			confirm_count+=1
	
		var chess= create_chess(v,current_input)
		if chess!=null:
			set_chess(vx,vy,chess) #先放置,用于判断是否重复确认
			if confirm_count<confirm_max:
				yield(confirm_chess(chess),'completed')
			else:
				IS_CONFIRM=false
				
			confirm_count=0
			if !check_chessSuccess(v.round()):
				if current_input==Global.CHESS_COLOR.CC_BLACK:
					current_input=Global.CHESS_COLOR.CC_WHITE
					chessTip.texture=Global.gw_texture
				else:
					current_input=Global.CHESS_COLOR.CC_BLACK
					chessTip.texture=Global.gb_texture
			else:
				#Win
				IS_WIN=true
				btn_restart.visible=true



func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var e=event as InputEventMouseButton
		if e.pressed && !IS_WIN:
			put_chess(e)

func query_wanIP()->void:
	if $HTTPRequest.connect("request_completed", self, "_on_request_completed") == OK:
		$HTTPRequest.request('https://www.charfun.com/api/ipapi')
	else:
		print("connect is error!")

func _ready() -> void:
	btn_restart.visible=false
	init()


func _on_Button_pressed() -> void:
	btn_restart.visible=false
	init()
	
func _on_request_completed(_result, response_code, _headers, body):
	if response_code==200:
		var json = JSON.parse(body.get_string_from_utf8())
		$VBoxContainer/Label.text=json.result['data']['ip']
	else:
		print(response_code)


func _on_Button2_pressed() -> void:
	query_wanIP()
