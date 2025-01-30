extends CharacterBody2D
class_name Player

#preloaded scenes:
#signals

enum PlayerState {
	NORMAL,
	DASH,
	IN_PLACE
}

"""
# <<<<<<< HEAD
const SPEED = 500.0 #was 400
const DASH_SPEED = 1500.0
const JUMP_VELOCITY = -700.0
const ACCELERATION = 5000
const DECELERATION = 7000
const AIR_DECEL = 1000
"""

# =======
const SPEED = 1400.0
const DASH_SPEED = 7000.0
const JUMP_VELOCITY = -3500.0
const ACCELERATION = 10000
const DECELERATION = 13000
const AIR_DECEL = 3000
# >>>>>>> tilemap-test


var double_jump: bool = false #determines whether the player can double jump
var can_dash: bool = true #determines whether the player can dash or not
var last_direction: int #last_direction tells you which direction the player was in last.
var coyote_jump: bool = false #allows the player leeway on a ground jump if they have just left the floor 
var state: PlayerState = PlayerState.NORMAL

#Player Character Attributes (HP,MP)

func _ready():
	pass

func _physics_process(delta: float) -> void:
	if state == PlayerState.NORMAL:
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
			last_direction = sign(direction)
		elif is_on_floor():
			velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, AIR_DECEL * delta)
		
		# handles dash.
		if Input.is_action_just_pressed("Dash") and can_dash:
			can_dash = false
			state = PlayerState.DASH
			$DashCooldown.start(1) #adds a 1 second cooldown to dash 
			$DashTimer.start(0.1) #makes the dash happen for 0.1 seconds 
			print(get_last_motion())
			
	elif state == PlayerState.DASH:
		velocity.x = last_direction * DASH_SPEED 
		velocity.y = 0
	elif state == PlayerState.IN_PLACE:
		velocity.x = 0
		velocity.y = 0

	move_and_slide()

func set_y_velocity(y):
	velocity.y = y
	
#when timer finishes, dash can happen again.
func _on_dash_timer_timeout() -> void:
	velocity.x = sign(velocity.x) * SPEED
	state = PlayerState.NORMAL

func _on_dashcooldown_timeout() -> void:
	can_dash = true
 
func _on_coyote_timer_timeout() -> void:
	coyote_jump = false
