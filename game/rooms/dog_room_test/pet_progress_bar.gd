extends ProgressBar

@export var goal_amount: float = 0.0

signal completed


func update_progress(amount: float) -> void:
	print(amount)
	value = amount
	
	if value >= max_value:
		completed.emit()

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
