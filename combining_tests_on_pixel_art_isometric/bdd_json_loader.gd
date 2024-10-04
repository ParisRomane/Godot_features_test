extends Node

var currently_loaded : Dictionary= {}
var number_loaded : Dictionary= {}
var DEBUG : bool = false

func open(path) -> Dictionary:
	
	if not currently_loaded.find_key(path) :
		var json_as_text = FileAccess.get_file_as_string(path)
		if DEBUG :
			print(JSON.parse_string(json_as_text))
		var json_as_dict = JSON.parse_string(json_as_text)
		currently_loaded[path] = json_as_dict
		number_loaded[path] = 0
		
	number_loaded[path] += 1
	return currently_loaded[path]


func save(path, new_path=null):
	
	if not currently_loaded.find_key(path) :
		print("cannot save a not opened bdd")
		return
		
	if new_path == null :
		new_path = path
		
	var save_file = FileAccess.open(new_path, FileAccess.WRITE)
	var json_string = JSON.stringify(self.currently_loaded[path])
	save_file.store_line(json_string)

func close(path, save:bool=false) -> void:
	number_loaded[path] -= 1
	if number_loaded[path] == 0 :
		if  save : 
			self.save(path)
		number_loaded.erase(path)
		currently_loaded.erase(path)
	
