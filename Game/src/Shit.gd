extends RigidBody3D
class_name Shit

@onready var timer: Timer = $"Timer"
@onready var area :Area3D = $"Trigger"
@onready var audio: AudioStreamPlayer3D = $"AudioStreamPlayer3D"

var isExtracting := false

@export var poopClips: Array[AudioStream]

func _ready():
	self.area.body_entered.connect(areaEntered)

func poopOut(dir: Vector3, force: float):
	eject(dir, force)
	pass

func playSFX():
	audio.stream = Global.randomArrayItem(poopClips)
	
	audio.pitch_scale = randf_range(0.6, 1.4)
	audio.play()

func extract(dir: Vector3, force: float):
	isExtracting = true
	fire(dir, force)
	Global.poopRemoved(self)
	
func eject(dir: Vector3, force: float):
	isExtracting = false
	fire(dir, force)
	Global.poopSpawned(self)
	
func fire(dir: Vector3, force: float):
	apply_impulse(dir * force)
	playSFX()
	
func cleanup(time: float):
	timer.wait_time = time
	timer.start()
	timer.timeout.connect(self.queue_free)
	
func areaEntered(body):
	if(body is Player && isExtracting):
		queue_free()
