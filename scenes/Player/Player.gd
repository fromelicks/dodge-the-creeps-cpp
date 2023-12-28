extends Area2D

signal hit

@export var speed := 400  # How fast the player will move (pixels/sec).
var screen_size: Vector2  # Size of the game window.


func start(pos):
	self.position = pos
	self.show()
	$CollisionShape2D.disabled = false


# Called when the node enters the scene tree for the first time.
func _ready():
	self.screen_size = get_viewport_rect().size
	self.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity := Vector2.ZERO  # The player's movement vector.
	velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	self.position += velocity * delta
	self.position = self.position.clamp(Vector2.ZERO, self.screen_size)

	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0


func _on_body_entered(_body):
	self.hide()  # Player disappears after being hit.
	self.hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
