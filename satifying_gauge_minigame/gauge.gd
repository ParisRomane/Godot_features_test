extends Node2D

var timer : Timer = Timer.new()

var node_ref 
var red 
var yelow 
var green 

var pressed : bool = false
var residual : bool = false

func _ready() -> void:
	timer.connect("timeout",_on_timer_timeout)
	self.add_child(timer)
	$AnimationPlayer.play("linear")
	
	self.node_ref = get_node("arrow/ref")
	self.red = get_node("bad")
	self.yelow = get_node("ok")
	self.green = get_node("super")
	
func _process(delta: float) -> void:
	pressed = false
	if Input.is_action_pressed('ui_accept'):
		pressed = true
	draw()
		
func draw():
	if(residual != pressed):
		if pressed :
			start()
		else :
			stop() 
	elif (pressed) :
		cont()
		
func check_score() -> int :
	if not (is_in_block(red,node_ref)) :
		print("ERROR : GAUGE OUTSIZE OF ANYTHING")
		return 0
	else :
		if not (is_in_block(yelow,node_ref)) :
			return -1
		else :
			if not (is_in_block(green,node_ref)) :
				return 1
			else :
				return 5
	
	
func is_in_block( block : ColorRect, ref : Node) ->bool : 
	if ((ref.global_position.x > block.position.x and ref.global_position.x < block.position.x + block.size.x ) and
	(ref.global_position.y > block.position.y and ref.global_position.y < block.position.y + block.size.y )) :
		return true
	return false
	
func pause():
	timer.wait_time = 0.5
	timer.start()
	$AnimationPlayer.pause()
	
func _on_timer_timeout():
	$AnimationPlayer.play()
