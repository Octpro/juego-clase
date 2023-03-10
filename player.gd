extends CharacterBody2D

signal golpe
@export var speed = 300
#var velocity := Vector2.ZERO
const UP_DIRECTION := Vector2.UP
var life = 3
var plata = 0

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

	$Authority.visible = is_multiplayer_authority()

	if not is_multiplayer_authority(): return
	$PlayerName.text = get_tree().get_first_node_in_group("player_name").text
	$PlayerName.modulate = Color(0, 1, 0)

func _physics_process(delta):
	
	if not is_multiplayer_authority(): return
#---------------- movement -------------------
	var vertical_dir = (
		Input.get_action_strength("ui_down") -
		Input.get_action_strength("ui_up")
	)
	
	var horizontal_dir = (
		Input.get_action_strength("ui_right") -
		Input.get_action_strength("ui_left")
	)

	velocity.y = vertical_dir * speed
	velocity.x = horizontal_dir * speed
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed	

	set_velocity(velocity)
	set_up_direction(UP_DIRECTION)
	move_and_slide()

#--------------------------------------------------
	if velocity.x == 0 and velocity.y == 0:
		$AnimatedSprite2D.play("Idle")
	elif velocity.x < 0:
		$AnimatedSprite2D.play("Run")
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.play("Run")
		$AnimatedSprite2D.flip_h = false
