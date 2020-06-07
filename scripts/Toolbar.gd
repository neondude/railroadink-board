extends Node2D

export (NodePath) var play_grid_path

var prev_selection

func _ready():
#	$TrainCross.on_click()
	
	pass # Replace with function body.
	
func on_tool_selected(tool_node):
	if prev_selection != null and tool_node != prev_selection:
		prev_selection.deselect()
	prev_selection = tool_node
	
	var play_grid = get_node(play_grid_path)
	play_grid.tool_type = tool_node.tool_type
	play_grid.tool_ability = tool_node.tool_ability
	play_grid.cursor_tip.texture = tool_node.icon_texture
	Input.set_custom_mouse_cursor(tool_node.icon_texture.get_data())
