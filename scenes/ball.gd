extends CharacterBody2D

var win_size : Vector2
const START_SPEED : int = 500 #speed of ball every first time you play the game
const ACCEL : int = 50 #ball speed will change as game progress
var speed: int #current speed
var dir: Vector2

const  MAX_Y_VECTOR: float = 0.6

## Called when the node enters the scene tree for the first time.
func _ready():
	win_size = get_viewport_rect().size

func new_ball():
	#randomize start position and direction of y axis
	
	## will always start at the center of screen
	position.x = win_size.x / 2
	position.y = randi_range(200, win_size.y - 200)
	speed = START_SPEED
	dir = random_direction()

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(dir * speed * delta)
	var collider
	if collision:
		collider = collision.get_collider()
		
		#if ball hits the paddle
		if collider == $"../Player" or collider == $"../CPU":
			# change speed according to acceleration
			speed += ACCEL
			# change direction
			dir = new_direction(collider)
		else: ## others like the wall
			dir = dir.bounce(collision.get_normal())

func random_direction():
	var new_dir := Vector2()
	#pick either left or right
	new_dir.x = [1, -1].pick_random()
	#more flexibility
	new_dir.y = randf_range(-1, 1)
	return new_dir.normalized()
	
func new_direction(collider):
	var ball_y = position.y
	var pad_y = collider.position.y
	var dist = ball_y - pad_y
	var new_dir := Vector2()
	
	#flip the horizontal direction
	if dir.x > 0:
		new_dir.x = -1
	else:
		new_dir.x = 1
	new_dir.y = (dist / (collider.p_height /2)) * MAX_Y_VECTOR
	return new_dir.normalized()
