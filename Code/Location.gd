class_name Location

extends Node

static var states: Dictionary = {}

static var current_location: Location
static var location_where_need_to_close_doors: String = ""


func _enter_tree():
	current_location = self
	load_state()
	if location_where_need_to_close_doors == name:
		location_where_need_to_close_doors = ""
		close_all_doors()


func save_state() -> void:
	## Информация о предметах.
	var items = find_children("*", "SceneItem", true, false)
	var items_info: Array = []
	for item: SceneItem in items:
		items_info.append([item.item_data, item.position])
	
	## Информация о дверях.
	var doors = find_children("*", "Door", true, false)
	var doors_info: Array = []
	for door: Door in doors:
		doors_info.append(door.is_closed) 
	
	var state: Dictionary = {
		"Items" : items_info,
		"Doors" : doors_info,
	}
	
	states[name] = state


func load_state():
	if not states.has(name):
		return
		
	var state = states[name]
	
	var items = find_children("*", "SceneItem")
	for item in items:
		item.queue_free()
	
	for item_info: Array in state["Items"]:
		var item_data: ItemData = item_info[0]
		var position: Vector2 = item_info[1]
		var item = item_data.create_item()
		item.drop(self, position)
	
	var doors = find_children("*", "Door")
	for index in doors.size():
		doors[index].is_closed = state["Doors"][index]


func close_all_doors() -> void:
	var doors = find_children("*", "Door")
	for door: Door in doors:
		door.is_closed = true


static func close_all_doors_on_location(location_name: String):
	if current_location.name != location_name:
		location_where_need_to_close_doors = location_name
	else:
		current_location.close_all_doors()
