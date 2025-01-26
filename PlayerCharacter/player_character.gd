extends CharacterBody2D
class_name Player

#preloaded scenes:
#signals

#Physics Related Attributes
const SPEED = 400.0
const DASH_SPEED = 1500.0
const JUMP_VELOCITY = -500.0
const ACCELERATION = 3500
const DECELERATION = 5000
const AIR_DECEL = 1000

var double_jump: bool = false 
var can_dash: bool = true #determines whether the player can dash or not
var last_direction: int #last_direction tells you which direction the player was in last.
var lock_dash: bool = false #locks the velocity when dashing.
var has_control:bool = true #bool which determines whether the player has control over the character 
var is_in_place: bool = false #if the player is NOT in control and is IN place, then it will not change its x or y dir.
var coyote_jump: bool = false

#Player Character Attributes (HP,MP)

func _ready():
	pass

func _physics_process(delta: float) -> void:
	if has_control:
		if not is_on_floor():
			velocity += get_gravity() * delta
			if coyote_jump and $CoyoteTimer.is_stopped():
				$CoyoteTimer.start(0.3)
		else:
			$CoyoteTimer.stop()
			double_jump = true
			coyote_jump = true

		# Handle jump and double jump.
		if Input.is_action_just_pressed("Jump"):
			if is_on_floor():
				velocity.y = JUMP_VELOCITY
			elif coyote_jump:
				velocity.y = JUMP_VELOCITY
				coyote_jump = false
			elif double_jump:
				velocity.y = JUMP_VELOCITY
				double_jump = false

		# Get the input direction and handle the movement/deceleration.
		var direction := Input.get_axis("Left", "Right")
		if direction:
			velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
			last_direction = direction
		elif is_on_floor():
			velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, AIR_DECEL * delta)
		
		# handles dash.
		if Input.is_action_just_pressed("Dash") and can_dash:
			can_dash = false
			lock_dash = true 
			has_control = false
			$DashCooldown.start(1) #adds a 1 second cooldown to dash 
			$ControlCooldown.start(0.1)
			$DashTimer.start(0.1) #makes the dash happen for 0.1 seconds 
			print(get_last_motion())
	
	else:	
		if lock_dash:
			velocity.x = last_direction * DASH_SPEED 
			velocity.y = 0
		elif is_in_place:
			velocity.x = 0
			velocity.y = 0
	move_and_slide()

func set_y_velocity(y):
	velocity.y = y
	
#when timer finishes, dash can happen again.
func _on_dash_timer_timeout() -> void:
	velocity.x = sign(velocity.x) * SPEED
	lock_dash = false

func _on_dashcooldown_timeout() -> void:
	can_dash = true

func _on_control_cooldown_timeout() -> void:
	has_control = true
	is_in_place = false
 
func _on_coyote_timer_timeout() -> void:
	coyote_jump = false
