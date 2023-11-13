extends Node2D


#var gravity = Vector2(0, 1000) #Y value should be adjusted for desired strength
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func new_game():
	pass
#func _physics_process(delta):
	#velocity += gravity * delta #The formula for the gravity


func _on_character_body_2d_presence(position):
	
	print(position)
	var alerted = position
	#emit_signal(alerted)
		
