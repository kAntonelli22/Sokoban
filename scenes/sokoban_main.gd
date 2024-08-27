extends Node2D

@onready var worker := $"Warehouse Worker"
@onready var switch_timer = $SwitchTimer
@onready var level_number = 1
@onready var levels := [
	preload("res://levels/level_1.tscn"),
	preload("res://levels/level_2.tscn"),
	preload("res://levels/level_3.tscn"),
	preload("res://levels/level_4.tscn"),
	preload("res://levels/level_5.tscn"),
	preload("res://levels/level_6.tscn"),
	preload("res://levels/level_7.tscn"),
]
var current_level
var goals
var box_sprite = preload("res://assets/boxes/crate_42.png")
var box_sprite_dim = preload("res://assets/boxes/crate_07.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	load_level(level_number)


func load_level(level_number):
	# remove the old level
	if current_level:
		current_level.queue_free()
	
	# load new level
	current_level = levels[level_number - 1].instantiate()
	add_child(current_level)
	goals = current_level.get_node("Goals").get_children()
	
	# update worker to work on new level and reset position
	worker.global_position = Vector2(96, 96)
	worker.sprite.play("move_down")
	worker.sprite.stop()
	move_child(worker, -1)
	worker.tilemap = current_level


func _on_restart_pressed():
	load_level(level_number)


func _on_pause_pressed():
	pass # Replace with function body.


func _on_switch_timer_timeout():
	load_level(level_number)
