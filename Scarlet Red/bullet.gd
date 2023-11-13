extends Area2D
@export var speed = 2000
signal hit
func start(pos):
	position = pos

	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.x * speed * delta

func _on_area_entered(area):
	queue_free()
	if area is RigidBody2D:
		area.queue_free()
		self.queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	queue_free()


func _on_timer_timeout():
	pass
