#Global
extends Node
var windowSize
var mousePos: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	windowSize = get_viewport().get_visible_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	mousePos = get_viewport().get_mouse_position()
