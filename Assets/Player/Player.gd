extends KinematicBody2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
const MAX_SPEED = 80
const ACCELERATION = 500
const FRICTION = 500

enum {
	MOVE,
	ROLL,
	ATTACK}

var state = MOVE
var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Hello World")
	animationTree.active = true

func _process(delta: float) -> void:
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)
		ROLL:
			pass

func move_state(delta:float)->void:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position",input_vector)
		animationTree.set("parameters/Run/blend_position",input_vector)
		animationTree.set("parameters/Attack/blend_position",input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector*MAX_SPEED,ACCELERATION*delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO,FRICTION*delta)
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	
func attack_state(delta:float):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
func attack_animation_finished():
	state = MOVE