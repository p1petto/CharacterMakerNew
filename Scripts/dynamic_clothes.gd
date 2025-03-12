extends ColorRect

var resource_dynamic_clothes: DynamicClothes

func change_direction() -> void:
		
	if Global.current_animation == "idle":	
		match Global.current_dir:
			"down":
				position = resource_dynamic_clothes.down_position
				size = resource_dynamic_clothes.down_size
				
			"right":
				position = resource_dynamic_clothes.right_position
				size = resource_dynamic_clothes.right_size
			"top":
				position = resource_dynamic_clothes.top_position
				size = resource_dynamic_clothes.top_size
			"left":
				position = resource_dynamic_clothes.left_position
				size = resource_dynamic_clothes.left_size
	
	elif Global.current_animation == "walk":	
		match Global.current_dir:
				"down":
					position = resource_dynamic_clothes.down_position_walk
					size = resource_dynamic_clothes.down_size
				"right":
					position = resource_dynamic_clothes.right_position_walk
					size = resource_dynamic_clothes.right_size
				"top":
					position = resource_dynamic_clothes.top_position_walk
					size = resource_dynamic_clothes.top_size
				"left":
					position = resource_dynamic_clothes.left_position_walk
					size = resource_dynamic_clothes.left_size
	pivot_offset = size / 2
