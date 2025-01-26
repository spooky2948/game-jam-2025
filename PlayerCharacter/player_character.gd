extends CharacterBody2D
class_name Player

#preloaded scenes:
#signals

#Physics Related Attributes
const SPEED = 400.0
const DASH_SPEED = 1000.0
const JUMP_VELOCITY = -500.0

var double_jump: bool = false 
var dash: bool = true #determines whether the player can dash or not
var last_direction: int #last_direction tells you which direction the player was in last.
var lock_dash: bool = false #locks the velocity when dashing.
var has_control:bool = true #bool which determines whether the player has control over the character 
var is_in_place: bool = false #if the player is NOT in control and is IN place, then it will not change its x or y dir.

#Player Character Attributes (HP,MP)

func _ready():
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if has_control:
		if not is_on_floor():
			velocity += get_gravity() * delta
		else:
			double_jump = true

		# Handle jump and double jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif Input.is_action_just_pressed("ui_accept") and double_jump:
			velocity.y = JUMP_VELOCITY
			double_jump = false

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
			last_direction = direction
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		# handles dash.
		if Input.is_action_just_pressed("Dash") and dash:
			dash = false
			lock_dash = true 
			has_control = false
			$DashCooldown.start(1) #adds a 1 second cooldown to dash 
			$ControlCooldown.start(0.1)
			$DashTimer.start(0.1) #makes the dash happen for 0.1 seconds 
			print(get_last_motion())
		
			pass
	
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
	lock_dash = false
	pass # Replace with function body.

func _on_dashcooldown_timeout() -> void:
	dash = true
	pass # Replace with function body.


func _on_control_cooldown_timeout() -> void:
	has_control = true
	is_in_place = false
	pass # Replace with function body.
 
