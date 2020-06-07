extends Area2D

export (Texture) var icon_texture
export (String, "apply", "rotate", "flip", "delete") var tool_type
export (int) var tool_ability

func _ready():
	$ToolBG/ToolIcon.texture = icon_texture
	
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.is_pressed():
		self.on_click()

func on_click():
	$ToolBG/ToolSelectBG.visible = true
	get_parent().on_tool_selected(self)

func deselect():
	$ToolBG/ToolSelectBG.visible = false
