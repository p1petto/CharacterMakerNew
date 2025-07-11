extends Node2D
@onready var character = $"../SubViewportContainer/SubViewport/Character"
@onready var button_container = $"../UI/DirectionButtons"
@onready var animation_button = $"../UI/DirectionButtons/AnimationButton"
@onready var animation_player_button = $"../UI/AnimationPlayer"

var animation_frame = 0  
@export var animation_speed: float = 1.0  
var animation_timer: float = 0.0  

func _ready():
	for button in button_container.get_children():
		if button.is_in_group("DirectionButton"):
			button.direction_changed.connect(set_start_position)
			
	animation_button.animation_changed.connect(change_animation)

func _process(delta: float) -> void:
	if Global.animation_is_run:
		animation_timer += delta * animation_speed
		
		if animation_timer >= 1.0: 
			animate_children()
			animation_timer = 0.0  

	
func set_start_position():
	animation_frame = 0
	animation_timer = 0.0
	character.cur_frame = 0
	for child in character.get_children():
		if child.is_in_group("Dynamic"):
			child.setup_polygon(Global.current_dir)
		if child.is_in_group("ConditionallyDynamic"):
			child.animated_sprite.frame = 0
			child.border.frame = 0
			child.position = child.start_position
	
func get_offset_name():
	var property_name = ""
	if Global.current_animation == "idle":
		property_name = "idle_ainmation_offset"
	elif Global.current_animation == "walk":
		property_name = "walk_animation_offset"
	else:
		property_name = "idle_ainmation_offset"  
	if Global.current_dir == "down" or Global.current_dir == "top":
		property_name = property_name + "_vertical"
	else:
		property_name = property_name + "_horizontal"
	return property_name
	

func animate_children() -> void:

	for child in character.get_children():
		var property_name = get_offset_name()
	
		if child.get(property_name) != null:
			var offset_array = child.get(property_name)
			if offset_array is Array and offset_array.size() > 0:
			
				var frame_index = animation_frame % offset_array.size()
				var offset = offset_array[frame_index]
				
				
									
				if child.is_in_group("ConditionallyDynamic") :
					child.position += offset
					child.update_frame(frame_index)
				elif child.is_in_group("Dynamic") :
					var start_position
					if Global.current_dir == "down":
						start_position = child.dynamic_part.position_down
					elif Global.current_dir == "top":
						start_position = child.dynamic_part.position_top
					elif Global.current_dir == "right":
						start_position = child.dynamic_part.position_right
					elif Global.current_dir == "left":
						start_position = child.dynamic_part.position_left
					child.position = start_position + offset
				
				character.cur_frame = frame_index
		
		elif child.is_in_group("StaticClothes") and child.resource_clothing:
			var anchor_node = character
			if child.resource_clothing.anchor_node:
				anchor_node = anchor_node.get_node(child.resource_clothing.anchor_node)
			
			if anchor_node.get(property_name) != null:
				var offset_array = anchor_node.get(property_name)
				if offset_array is Array and offset_array.size() > 0:
			
					var frame_index = animation_frame % offset_array.size()
					var offset = offset_array[frame_index]
					
		
					child.position = child.resource_clothing.pos + offset
					
		
					if child.has_method("update_frame"):
						child.update_frame(frame_index)
				
	

	animation_frame += 1
	



func change_animation():
		
	for child in character.get_children():
		if child.is_in_group("ConditionallyDynamic"):
			child.change_state(Global.current_animation)
			
	set_start_position()
	
	
func clear_all_states():
	animation_player_button.button_pressed = false
	Global.current_dir = "down"
	Global.current_animation = "idle"
	animation_button.label.text = Global.current_animation.to_upper()
	change_animation()
	character.on_direction_changed()


func _on_animation_player_button_up() -> void:
	if Global.animation_is_run:
		Global.animation_is_run = false
	else: 
		Global.animation_is_run = true
	set_start_position()
