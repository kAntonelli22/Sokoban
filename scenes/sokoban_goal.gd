extends Area2D

var box_on_goal : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_body_entered(body):
	box_on_goal = true
	var main_node := get_parent().get_parent().get_parent()
	body.get_node("Sprite2D").texture = main_node.box_sprite_dim
	for goal in main_node.goals:
		if goal.box_on_goal == false:
			return;
	main_node.level_number += 1
	main_node.switch_timer.start()

func _on_body_exited(body):
	box_on_goal = false
	body.get_node("Sprite2D").texture = get_parent().get_parent().get_parent().box_sprite
