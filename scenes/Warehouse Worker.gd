extends Node2D

var tilemap
@onready var sprite = $AnimatedSprite2D
@onready var raycast = $RayCast2D

var is_moving : bool = false

func _physics_process(delta):
	if !is_moving:
		return
	
	if global_position == sprite.global_position:
		is_moving = false
		sprite.stop()
		return
	
	sprite.global_position = sprite.global_position.move_toward(global_position, 4)

func _process(delta):
	if is_moving:
		return
	if Input.is_action_pressed("ui_left"):
		sprite.play("move_left")
		move(Vector2.LEFT)
	elif Input.is_action_pressed("ui_right"):
		sprite.play("move_right")
		move(Vector2.RIGHT)
	elif Input.is_action_pressed("ui_up"):
		sprite.play("move_up")
		move(Vector2.UP)
	elif Input.is_action_pressed("ui_down"):
		sprite.play("move_down")
		move(Vector2.DOWN)

func move(direction):
	var current_tile : Vector2i = tilemap.local_to_map(global_position)
	var target_tile : Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y
	)
	var tile_data : TileData = tilemap.get_cell_tile_data(0, target_tile)
	
	if !tile_data == null:
		if tile_data.get_custom_data("non-walkable"):
			sprite.stop()
			return
			
	raycast.target_position = direction * 64
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		var box_pushed : bool = collider.push_box(direction)
		if !box_pushed:
			sprite.stop()
			return
		
	is_moving = true
	
	global_position = tilemap.map_to_local(target_tile)
	sprite.global_position = tilemap.map_to_local(current_tile)
