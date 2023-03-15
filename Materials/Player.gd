extends CharacterBody3D
var mouse_sens = 0.005;
var camera_anglev=0;
var mouseDelta : Vector2 = Vector2()
var minLookAngle : float = -90.0
var maxLookAngle : float = 90.0

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var cam = $Camera3D


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		mouseDelta = event.relative
		

func _process(delta):
	rotate_y(-mouseDelta.x * mouse_sens)
	cam.rotate_x(-mouseDelta.y * mouse_sens)
	cam.rotation.x = clamp(cam.rotation.x, -PI/2, PI/2)
	
	mouseDelta = Vector2()
	
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("strafe_right", "strafe_left", "move_back", "move_front")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
