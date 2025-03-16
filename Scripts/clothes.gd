extends TextureRect
var resource_clothes: Clothes

func initialize():
	texture = resource_clothes.clothes_texture
	change_dir()

func change_dir():
	
	if resource_clothes:
		match Global.current_dir:
			"down":
				if Global.current_animation == "idle":
					position = resource_clothes.down_idle_position
				elif Global.current_animation == "walk":
					position = resource_clothes.down_walk_position
			"right":
				if Global.current_animation == "idle":
					position = resource_clothes.right_idle_position
				elif Global.current_animation == "walk":
					position = resource_clothes.right_walk_position
			"top":
				if Global.current_animation == "idle":
					position = resource_clothes.top_idle_position
				elif Global.current_animation == "walk":
					position = resource_clothes.top_walk_position
			"left":
				if Global.current_animation == "idle":
					position = resource_clothes.left_idle_position
				elif Global.current_animation == "walk":
					position = resource_clothes.left_walk_position
		
