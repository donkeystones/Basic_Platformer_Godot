extends CharacterBody2D

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 40.0
const JUMP_VELOCITY = -100.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_locked: bool = false;
var direction: Vector2 = Vector2.ZERO;

func _physics_process(delta):
	direction = Input.get_vector("ui_left", "ui_right", "ui_jump", "ui_down");
	print(direction.x);
	player_falling(delta);	
	if Input.is_action_just_pressed("ui_jump") and is_on_floor():
		player_jump(delta, direction);
	if jump_locked:
		move_jumping_player();
	if not jump_locked:
		player_run(delta, direction);
	move_and_slide();
	update_animation();
	update_facing_direction();
	
	
func player_run(delta, direction):
	if direction:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
func player_jump(delta, direction):
		animated_sprite.play("jump");
		jump_locked = true;
		
func player_falling(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

func update_animation():
	if not jump_locked:
		if direction.x != 0:
			animated_sprite.play("walk")
		else:
			animated_sprite.play("idle")
			
func update_facing_direction():
	if direction.x > 0:
		animated_sprite.flip_h = false;
	elif direction.x < 0:
		animated_sprite.flip_h = true;

func move_jumping_player():
	velocity.x += direction.x * 50;
	velocity.y = 0;
	
func _on_animated_sprite_2d_animation_finished():
	if(animated_sprite.animation == "jump"):
		jump_locked = false;
