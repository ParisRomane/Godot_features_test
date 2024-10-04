extends CharacterBody2D

enum ACTION {IDLE,WALK}
enum DIRECTION {LEFT,RIGHT,UP,DOWN}

var action = ACTION.IDLE
var direction = DIRECTION.DOWN

var anim : AnimationPlayer
var character : Sprite2D
var face : Sprite2D

var dialog
var inventory
var area_dialog = []
var dialog_launched :bool = false
var area_inventory = []
var inventory_launched :bool = false

func _ready() -> void:
	anim  =  get_node("AnimationPlayer")
	character = get_node("Sprite2D")
	face = get_node("emotions")
	
func _process(delta):
	var mvt : Vector2 = Vector2(0,0)
	if Input.is_action_pressed("ui_right"):
		mvt.x +=1
		self.action = ACTION.WALK
		direction = DIRECTION.RIGHT
	elif Input.is_action_pressed("ui_left"):
		mvt.x -=1
		self.action = ACTION.WALK
		direction = DIRECTION.LEFT
	elif Input.is_action_pressed("ui_up"):
		mvt.y -=1
		self.action = ACTION.WALK
		direction = DIRECTION.UP
	elif Input.is_action_pressed("ui_down"):
		mvt.y +=1
		self.action = ACTION.WALK
		direction = DIRECTION.DOWN
	else : 
		self.action = ACTION.IDLE
	self.set_velocity(mvt.normalized()*100)
	self.move_and_slide()
	animate()
	
	if  Input.is_action_pressed("ui_accept") and not(area_inventory.is_empty()) and not(inventory_launched):
		inventory_launched = true
		inventory = preload("res://inventory_test.tscn").instantiate()
		inventory.global_position= Vector2.ZERO
		inventory.z_index =  1
		get_node('..').add_child(inventory)
	
	elif Input.is_action_pressed("ui_accept") and not(area_dialog.is_empty()) and not(dialog_launched):
		dialog_launched = true
		dialog = preload("res://test.tscn").instantiate()
		dialog.name_character = area_dialog[-1]
		dialog.global_position= Vector2(100,100)
		dialog.z_index =  2
		get_node('..').add_child(dialog)
	
	if Input.is_action_pressed("ui_cancel") :
		
		if dialog_launched :
			dialog_launched = false
			get_node('..').remove_child(dialog)
			
		if inventory_launched : 
			inventory_launched = false
			get_node('..').remove_child(inventory)
			
	

func animate():
	if (self.action == ACTION.WALK) and not(anim.is_playing()):
		anim.play("walk")
	if (self.action == ACTION.IDLE) and (anim.is_playing()):
		anim.stop()
	face.show()
	match direction :
		DIRECTION.LEFT :
			character.frame_coords.x = 0
			face.frame_coords.x = 0
		DIRECTION.DOWN :
			character.frame_coords.x = 1
			face.frame_coords.x = 1
		DIRECTION.RIGHT :
			character.frame_coords.x = 2
			face.frame_coords.x = 2
		DIRECTION.UP :
			character.frame_coords.x = 3
			face.hide()
			

func area_get_name(area ) :
	return area.get_node("..").name
	 

func _on_area_2d_area_entered(area: Area2D) -> void:
	match area.get_collision_layer() :
		1:
			area_dialog.append(area_get_name(area))
			print(area_dialog)
		2:
			area_inventory.append(area_get_name(area))
			print("CHEST")

func _on_area_2d_area_exited(area: Area2D) -> void:
	match area.get_collision_layer() :
		1:
			area_dialog.pop_at(area_dialog.find(area_get_name(area)))
		2:
			area_inventory.pop_at(area_inventory.find(area_get_name(area)))
