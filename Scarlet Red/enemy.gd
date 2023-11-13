extends RigidBody2D
#var target_position = Vector2(100, 100)
@export var speed = 00 # Change the speed when needs be to fit the pace
var max_speed = 3000 #This is the top speed the character will run
const GRAVITY = 600.0
var player = null
var target_position = null
signal alert
var velocity = 100

#This function calls code for the enemy bullet 
@export var enemy_proj : PackedScene
var can_shoot = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position.x += speed * delta
	velocity = Vector2.ZERO
	#if player :
	#	velocity = position.direction_to(player.position) * speed
	#target_position = 
	
func _on_body_entered(body):
	queue_free() #This is to kill
	
func _on_area_2d_area_entered(area):
	queue_free()
	
	
func fire():
	if not can_shoot:
		return
	can_shoot = false
	$enemy_gun_cooldown.start()
	var b = enemy_proj.instantiate()
	get_tree().root.add_child(b)
	#This bellow is what makes the bullets go in the general direction you want
	b.transform = $Muzzle.global_transform
