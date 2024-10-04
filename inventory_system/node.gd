extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$inventory_window.opposite_inventory_window = $inventory_window2
	$inventory_window2.opposite_inventory_window = $inventory_window
	$inventory_window2.type = TYPE.MARCHANT
	$inventory_window2.title = "COFFRE"
	
	# inventory 1
	var inventory = Inventory.new()
	inventory.money = 100
	var item_1 = Item.create("apples")
	item_1.quantity = 10
	inventory.put_item(item_1)
	$inventory_window.inventory = inventory
	# inventory 2
	inventory = Inventory.new()
	inventory.money = 200
	var item_2 = Item.create("apples")
	item_2.quantity = 2
	var item_3 = Item.create("banana")
	item_3.quantity = 7
	inventory.put_item(item_3)
	inventory.put_item(item_2)
	$inventory_window2.inventory = inventory
