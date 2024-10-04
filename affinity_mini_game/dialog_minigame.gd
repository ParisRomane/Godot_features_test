class_name Dialog extends Node

var character = BddJsonLoader.open("res://bdd/character/elise.json")
var current_choices =[]
var possible_choices = BddJsonLoader.open("res://bdd/list_of_suject.json")
var language = "fr"
var nb_choices = len(possible_choices.keys())
var nb_choosen : int = 3 
func set_character(chara) -> void :
	self.character = chara
	
#func _ready() -> void:
	#print(possible_choices)
	#new_choices()
	#for chose in current_choices :
		#print( possible_choices[chose][language])
	#print(str(choosing(0))+"\n")
	#new_choices()
	#for chose in current_choices :
		#print( possible_choices[chose][language])
	#print(str(choosing(0))+"\n")
	#new_choices()
	#for chose in current_choices :
		#print( possible_choices[chose][language])
	#print(str(choosing(0))+"\n")
	
func new_choices() -> void:
	self.current_choices = []
	var keys = possible_choices.keys()
	for i in range(self.nb_choosen):
		var ind = randi_range(0,self.nb_choices-1-i)
		current_choices.append(keys[ind])
		keys.pop_at(ind)
	
func choosing(choice : int ) -> int :
	var choice_ref = current_choices[choice]
	if choice_ref in character["dialog_minigame"]["positives"] :
		return 1
	if choice_ref in character["dialog_minigame"]["neutrals"] :
		return 0
	if choice_ref in character["dialog_minigame"]["negatives"] :
		return -1
	print("ERROR ! NOT FOUND IN BDD")
	return -404

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up") :
		if (self.language == "fr"):
			language = "eng"
		else :
			language = "fr"
	
