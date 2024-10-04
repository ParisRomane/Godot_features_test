class_name Inventory extends Node

var money : int = 0
var item_list : Array[Item]

# Called when the node enters the scene tree for the first time.
func put_item(new_item : Item) -> void:
	"""
	Put an item in the inventory. if that item is already here, just increase it's quantity.
	"""
	var is_not_here_yet :bool = true
	for item in self.item_list : 
		if (item.item_name == new_item.item_name) :
			item.quantity += new_item.quantity
			is_not_here_yet = false
			break
	if is_not_here_yet : 
		item_list.append(new_item)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func retrive_item(desired_item : Item) -> bool:
	for ind in len(item_list) : 
		var item = item_list[ind]
		# find the right article
		if (item.item_name == desired_item.item_name) :
			# check if there is enough of the sayed article
			if item.quantity < desired_item.quantity :
				print("not enough item "+desired_item.item_name)
				return false
			elif item.quantity == desired_item.quantity :
				item_list.pop_at(ind)
				return true
			else : 
				item.quantity -= desired_item.quantity
				return true
	# if no desired item in inventory,
	print("no item named "+desired_item.item_name)
	return false

func get_price(get_price_item : Item) -> int:
	for item in self.item_list : 
		if (item.item_name == get_price_item.item_name) :
			return item.max_price
	return -1
