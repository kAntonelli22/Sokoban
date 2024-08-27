extends CharacterBody2D

@onready var tilemap = get_parent().get_parent()
@onready var sprite = $Sprite2D
@onready var raycast = $RayCast2D

var is_moving : bool = false

func _physics_process(delta):
	if !is_moving:
		return
	
	if global_position == sprite.global_position:
		is_moving = false
		return
	
	sprite.global_position = sprite.global_position.move_toward(global_position, 5)

func push_box(direction):
	var current_tile : Vector2i = tilemap.local_to_map(global_position)
	var target_tile : Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y
	)
	
	var tile_data : TileData = tilemap.get_cell_tile_data(0, target_tile)
	
	if !tile_data == null:
		if tile_data.get_custom_data("non-walkable"):
			return false
			
	raycast.target_position = direction * 64
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		return false
	
	is_moving = true
	
	global_position = tilemap.map_to_local(target_tile)
	sprite.global_position = tilemap.map_to_local(current_tile)
	
	# move box
	
	return true
