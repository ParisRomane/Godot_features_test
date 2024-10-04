extends Control

var set_button = []
var dial = Dialog.new()
var name_character : String = "georges"
var color_rect : ColorRect
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.color_rect =  self.get_node("ColorRect")
	print(self.color_rect)
	dial.character = BddJsonLoader.open("res://bdd/character/"+name_character+".json")
	$VBoxContainer/Label.text = dial.character['name']
	for i in range(dial.nb_choosen) :
		var node : Button = Button.new()
		node.name = str(i)
		node.pressed.connect(choosing.bind(i))
		$VBoxContainer/VBoxContainer.add_child(node)
		set_button.append(node)
		
	print(dial.possible_choices)
	new_choices()

func choosing( i : int) :
	match dial.choosing(i) :
		0 :
			color_rect.color = Color(0,0,0,0.5)
		1 :
			color_rect.color = Color(0.0,1.0,0.1,0.6)
		-1 : 
			color_rect.color = Color(1.0,0.0,0.0,0.6)
	new_choices()
	
func new_choices():
	dial.new_choices()
	for i in range(len(dial.current_choices)) :
		var chose = dial.current_choices[i]
		var descr = dial.possible_choices[chose][dial.language]
		get_node("VBoxContainer/VBoxContainer/"+str(i)).text = descr
