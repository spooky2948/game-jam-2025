using Godot;
using System;

public partial class PlayerCharacter : CharacterBody2D
{
	public const float Speed = 300.0f;
	public const float JumpVelocity = -400.0f;
	public const float DashSpeedMult = 4.0f; 
	private float lastDirection = 1.0f; //determines what way the player is looking.
	private bool doubleJump = true; 
	private bool dash = true; 
	private bool lockDash = false; //locks the player in the "dash", moving purely horizontally.
	private bool hasControl = true;

	public override void _PhysicsProcess(double delta)
	{
		Vector2 velocity = Velocity;
		if (hasControl) {
			// Add the gravity.
			if (!IsOnFloor()) // if not on floor, apply gravity
			{
				velocity += GetGravity() * (float)delta;
			}
			// otherwise... double Jump is set to true
			else { 
				doubleJump = true;
			}
			
			// Handle Double Jump
			if ( !IsOnFloor() && doubleJump && Input.IsActionJustPressed("ui_accept") ){ // if not on floor and can double jump, then do a double jump.
				doubleJump = false;
				velocity.Y = JumpVelocity;
			}

			// Handle Jump.
			if (Input.IsActionJustPressed("ui_accept") && IsOnFloor())
			{
				velocity.Y = JumpVelocity;
			}
			
			//Handle Dash 
			if (Input.IsActionJustPressed("Dash") && dash){
				dash = false;
				lockDash = true;
				hasControl = false;
				GetNode<Timer>("./DashTimer").Start(0.25f);
				GetNode<Timer>("./ControlCooldown").Start(0.25f);
				// makes the player dash for 0.25 seconds, then after 1 second the player can dash again.
				GetNode<Timer>("./DashCooldown").Start(1.0f);
				GD.Print("Dash is being pressed!");
			}

			// Get the input direction and handle the movement/deceleration.
			// As good practice, you should replace UI actions with custom gameplay actions.
			Vector2 direction = Input.GetVector("ui_left", "ui_right", "ui_up", "ui_down");
			if (direction != Vector2.Zero)
			{
				lastDirection = direction.X; 
				velocity.X = direction.X * Speed;
			}
			else
			{
				velocity.X = Mathf.MoveToward(Velocity.X, 0, Speed);
			}

			Velocity = velocity;
			MoveAndSlide();
		}
		else{
			if (lockDash) {
				velocity.X = lastDirection * Speed * DashSpeedMult;
				velocity.Y = 0;
				Velocity = velocity;
				GD.Print(lastDirection + " is the Last Direction");
				GD.Print(Speed + " is the Speed Multiplier");
				GD.Print(DashSpeedMult + "is the Dash Speed Multipler");
				GD.Print(velocity.X + " is the velocity, X");
				GD.Print(velocity + " is the velocity");
			}
			
			MoveAndSlide();
		}
	}
	
	public void OnDashTimerTimeout(){
		GD.Print("Yipee");
	}
}
