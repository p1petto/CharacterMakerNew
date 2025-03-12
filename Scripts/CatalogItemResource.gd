extends Resource

class_name CatalogItem

@export_enum("Dynamic", "Conditionally_dynamic", "Static", "Accessories", "Dynamic_clothes") 
var item_type: String = "Static"

@export_enum("Body", "Head", "LeftLeg", "RightLeg", "LeftArm", "RightArm", "LeftEye", "RightEye", "Accessories") 
var item_class: String = "Body"

@export var icon: CompressedTexture2D
@export var dynamic_part: DynamicBodyPart
@export var conditionally_dynamic_part: ConditionallyDynamic
@export var static_element: Static
@export var accessorie: Accessorie
@export var dynamic_clothes: DynamicClothes

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
