extends Area2D
@export var speed = 0
func start(pos):
	position = pos
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	position.x += speed * delta
	
func _on_attackduration_timeout():
	queue_free()
	
func _on_area_entered(area):
	if area.is_in_group("enemy"):
		area.explode()
		queue_free()
	

