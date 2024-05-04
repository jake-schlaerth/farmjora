extends Node2D

@export var inventory_item: InventoryItem

func _on_pickup_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.collect(inventory_item)
		self.queue_free()
