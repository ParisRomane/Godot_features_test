extends Control

var set_button = []
var dial = Dialog.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dial.character = BddJsonLoader.open("res://bdd/character/georges.json")
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
	print(dial.choosing(i))
	new_choices()
	
func new_choices():
	dial.new_choices()
	for i in range(len(dial.current_choices)) :
		var chose = dial.current_choices[i]
		var descr = dial.possible_choices[chose][dial.language]
		get_node("VBoxContainer/VBoxContainer/"+str(i)).text = descr
