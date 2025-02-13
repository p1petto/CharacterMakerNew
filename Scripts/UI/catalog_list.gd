extends MarginContainer

@onready var grid = $VBoxContainer/ScrollContainer/GridContainer
@export var catalog_items: Array[CatalogItem] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for item in catalog_items:
		add_catalog_item(item)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_catalog_item(item):
	var catalog_slot_scene = preload("res://Scenes/UI/CatalogSlot.tscn")
	var catalog_slot = catalog_slot_scene.instantiate()
	catalog_slot.item = item
	grid.add_child(catalog_slot)
