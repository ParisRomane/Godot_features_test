class_name Item extends Node 

var item_name : String
var max_price : int = -1
var qualities : Dictionary
var description : String = ""
var quantity : int = 1
var texture : Texture2D = load("res://icon.svg")

static func create(name :String, quantity:int=1) -> Item:
	var item_ref = BddJsonLoader.open("res://data_bases/product.json")[name]
	var item = Item.new()
	item.item_name = item_ref["item_name"]
	item.description = item_ref["description"]
	item.qualities = item_ref["qualities"]
	item.quantity = quantity
	item.texture = load(item_ref["texture"])
	item.max_price = item_ref["max_price"]
	BddJsonLoader.close("res://data_bases/product.json")
	return item
