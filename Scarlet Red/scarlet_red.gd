extends CharacterBody2D
@export var speed = 500 # Change the speed when needs be to fit the pace
var screen_size #affects the screen
var max_speed = 3000 #This is the top speed the character will run
const GRAVITY = 1100.0
var is_jumping = false
var jump_speed = -750#jump and gravity feel really good now. may stay thay way.
var friction = 1.
var acceleration = .25
#The list below is stuff that controls the ranged sate of the player
var ranged_state = false
@export var cooldown_r = 0.25#r is ranged
@export var bullet_scene : PackedScene
var can_shoot = true
#This controls melee stuff
var melee_state = true
@export var cooldown_m = 0.33#m is melee
@export var melee_scene : PackedScene
var can_strike = true
signal presence(position)
signal hit()
#cooldown for dashing
var can_dash = true
var ongoing_dash = false
#player health value and armor
var health = 100
var armor = 50

func _ready():
	screen_size = get_viewport_rect().size
	
func start():
	$GunCooldown.wait_time = cooldown_r
	$MeleeCooldown.wait_time = cooldown_m #
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.y += GRAVITY * delta
	
	var dir = Input.get_axis("move_left", "move_right")
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)
	move_and_slide()
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed# careful when editing this
	#code that helps move you faster
	if Input.is_action_pressed("sprint") and Input.is_action_pressed("move_right"):
		speed = 600
	elif Input.is_action_pressed("sprint") and Input.is_action_pressed("move_left"):
		speed = 600
	elif ongoing_dash == false:
			speed = 400
	#these are attacks and attack states
	if melee_state == true:
		if Input.is_action_just_pressed("state_change"):
			ranged_state = true
			melee_state = false
		if Input.is_action_just_pressed("Standard_attack"):
			strike()
			# the melee and ranged states need to be fixed/working now as of 11-13-2023
	elif ranged_state == true:
		if Input.is_action_just_pressed("state_change"):
			melee_state = true
			ranged_state = false
		if Input.is_action_pressed("Standard_attack"):
			look_at(get_global_mouse_position())#This to the right is how the game calculates you aim
			#the code below is what makes the weapeon not 100% accurate
			var r = randf_range(-.030, .030)
			rotate(r)
			shoot()
			rotation = 0
	#Below is what helps control the animations
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "standard"
		$AnimatedSprite2D.flip_v = false
		#look at notes
		$AnimatedSprite2D.flip_h = velocity.x < 0
		presence.emit(self.position)
	if Input.is_action_just_pressed("dash"):
		if not can_dash:
			return
		can_dash = false
		$Dash_cooldown.start()
		$dash_duration.start()
		speed = 1200
		ongoing_dash = true
	if health == 0:
		queue_free()
func shoot():
	if not can_shoot:
		return
	can_shoot = false
	$GunCooldown.start()
	var b = bullet_scene.instantiate()
	get_tree().root.add_child(b)
	#This bellow is what makes the bullets go in the general direction you want
	b.transform = $Muzzle.global_transform
	
func strike():
	if not can_strike:
		return
	can_strike = false
	$MeleeCooldown.start()
	var s = melee_scene.instantiate()
	get_tree().root.add_child(s)
	s.start(position + Vector2(0, -7))
#all the cooldown functions for the player will stay here.
func _on_gun_cooldown_timeout():
	can_shoot = true
func _on_melee_cooldown_timeout():
	can_strike = true
func _on_dash_cooldown_timeout():
	can_dash = true
func _on_dash_duration_timeout():
	speed = 400
