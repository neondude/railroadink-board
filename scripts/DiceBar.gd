extends Node2D


func _ready():
	pass # Replace with function body.
	roll_all_dice()

func roll_all_dice():
	for dice in get_children():
		dice.roll()


func _on_RollBtn_button_up():
	roll_all_dice()
