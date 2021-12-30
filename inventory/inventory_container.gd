extends Dragable_Control

export( NodePath ) onready var inventory_container = get_node( inventory_container ) as Control

var current_inventories : Array = []

func _ready():
	SignalManager.connect( "inventory_opened", self, "_on_inventory_opened" )
	SignalManager.connect( "inventory_closed", self, "_on_inventory_closed" )


func close():
	for i in current_inventories:
		inventory_container.remove_child( i )
		i.is_open = false
	
	current_inventories = []
	hide()


func _on_inventory_opened( inventory : Inventory ):
	inventory.is_open = true
	if current_inventories.size() == 0:
		rect_size.y = 20
	
	if current_inventories.has( inventory ):
		return
	
	inventory_container.add_child( inventory )
	current_inventories.append( inventory )
	rect_size.y += inventory.rect_size.y + inventory_container.get_constant( "separation" )
	show()

func _on_inventory_closed( inventory : Inventory ):
	inventory.is_open = false
	inventory_container.remove_child( inventory )
	current_inventories.remove( current_inventories.find( inventory ) )
	rect_size.y -= inventory.rect_size.y + inventory_container.get_constant( "separation" )
	
	if current_inventories.size() == 0:
		hide()


func _on_close_pressed():
	close()
