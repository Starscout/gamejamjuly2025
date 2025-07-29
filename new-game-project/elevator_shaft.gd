extends Node2D
var speed:float
const elevator_guy = preload("res://level/elevator guy/elevator_guy.tscn")

func _ready():
	speed = self.scale.y
	
