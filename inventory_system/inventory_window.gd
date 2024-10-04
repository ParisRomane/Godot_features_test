class_name InventoryWindow extends Window

var SELL_FACTOR = 0.5
var inventory : Inventory 
var type = TYPE.SELF
var change = true
var opposite_inventory_window : InventoryWindow = null 
var desc = true

	
func set_inventory(inventory) -> void :
	self.inventory = inventory

func show_inventory() -> void :
	if self.type != TYPE.COFFRE :
		$Control/VBoxContainer/MoneyLabel.text = "money : " + str(inventory.money) + " po"
	for i in range($Control/VBoxContainer/ItemList.item_count):
		$Control/VBoxContainer/ItemList.remove_item(0)
	for item in self.inventory.item_list :
		$Control/VBoxContainer/ItemList.add_item(item.item_name + "\n" + str(item.quantity),item.texture)
	change_tooltips()
	
func change_tooltips()-> void :
	var i=0
	var current_text = null
	if (get_node("Control/VBoxContainer/ItemList").get_child_count(true) > 1):
		current_text = get_node("Control/VBoxContainer/ItemList").get_child(1,true).get_child(1,true).text
	for item in self.inventory.item_list :
		if desc :
			if (current_text == "Sell price : " + str(int(item.max_price *SELL_FACTOR)) + "\n Buy Price : "+ str(item.max_price)):
				get_node("Control/VBoxContainer/ItemList").get_child(1,true).get_child(1,true).text =  str(item.description) 
			$Control/VBoxContainer/ItemList.set_item_tooltip(i, str(item.description) ) 
		else :
			if (current_text == item.description):
				get_node("Control/VBoxContainer/ItemList").get_child(1,true).get_child(1,true).text =  "Sell price : " + str(int(item.max_price *SELL_FACTOR)) + "\n Buy Price : "+ str(item.max_price)
			$Control/VBoxContainer/ItemList.set_item_tooltip(i, "Sell price : " + str(int(item.max_price *SELL_FACTOR)) + "\n Buy Price : "+ str(item.max_price) ) 

		i+=1

func _process(delta: float) -> void:
	if change : 
		self.show_inventory()
	self.change = false
	if Input.is_action_just_pressed("w") : 
		desc = !desc 
		change_tooltips()
	


func _on_item_list_multi_selected(index: int, selected: bool) -> void:
	for item_selec in $Control/VBoxContainer/ItemList.get_selected_items():
		print("multi_cliked, ", $Control/VBoxContainer/ItemList.get_item_text(item_selec))



func _on_item_list_empty_clicked(at_position: Vector2, mouse_button_index: int) -> void:
	print("clic_emty")
	$Control/VBoxContainer/ItemList.deselect_all()


func _on_item_list_item_activated(index: int) -> void:
	print("ACTIVATED")


func _on_item_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	
	if not(opposite_inventory_window): 
		print("ERROR : CAN'T LOCATE INVENTORY TO DROP")
		return
		
	#sell if right clic
	if (mouse_button_index == 2):
		var list = $Control/VBoxContainer/ItemList.get_item_text(index).split("\n")
		
		var item = Item.create(list[0])
		
		if (Input.is_key_pressed(KEY_SHIFT)) : 
			item.quantity = int(list[1])
		else :
			item.quantity = 1
			
		var price = item.max_price
		if(self.type == TYPE.MARCHANT) or (self.opposite_inventory_window.type == TYPE.MARCHANT):
			if (price < 0):
				print("No price found")
				return
			if(self.type == TYPE.MARCHANT) :
				if (self.opposite_inventory_window.inventory.money < price):
					print(self.opposite_inventory_window.inventory.money)
					print("OPPOSITE CAN'T BUY")
					return
				else :
					if(self.opposite_inventory_window.inventory.money < price * item.quantity):
						item.quantity = floor(self.opposite_inventory_window.inventory.money / price)
					self.inventory.money += price* item.quantity
					self.opposite_inventory_window.inventory.money -= price* item.quantity
			else : 
				if (self.opposite_inventory_window.inventory.money < price*SELL_FACTOR):
					print(self.opposite_inventory_window.inventory.money)
					print("OPPOSITE CAN'T BUY")
					return
				else :
					if(self.opposite_inventory_window.inventory.money < price * item.quantity * SELL_FACTOR):
						item.quantity = floor(self.opposite_inventory_window.inventory.money / (price  * SELL_FACTOR))
					self.inventory.money += int(price*SELL_FACTOR*item.quantity)
					self.opposite_inventory_window.inventory.money -= int(price*SELL_FACTOR*item.quantity)
		
		self.inventory.retrive_item(item)
		self.opposite_inventory_window.inventory.put_item(item)
		self.change = true
		self.opposite_inventory_window.change = true
		



func _on_close_requested() -> void:
	if self.opposite_inventory_window :
		self.opposite_inventory_window.opposite_inventory_window = null
	self.queue_free()
