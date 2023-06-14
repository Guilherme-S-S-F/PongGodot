extends Node

@onready var player = $"Paddle Player"
@onready var ai = $"Paddle AI"
@onready var ball = $Ball

@onready var pauseText = $pauseAdvice

@onready var topWall = $Background/TopWall
@onready var bottomWall = $Background/BottomWall

const PADDLE_SIZE = Vector2(0.5,4)
const BALL_SIZE = Vector2(0.1,0.1)

const ORIGIN_BALL_POS = Vector2.ZERO
const ORIGIN_PLAYER_POS = Vector2(-548,0)
const ORIGIN_AI_POS = Vector2(548,0)

var score_player:int = 0
var score_ai:int = 0

var restart = false
var pause = true

var is_dragging = false
var touchplace = 0
var touch = false

var vel = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	topWall.position.y = -16.6
	bottomWall.position.y = 16.6
	
	player.position = ORIGIN_PLAYER_POS
	player.scale = PADDLE_SIZE
	
	ai.position = ORIGIN_AI_POS
	ai.scale = PADDLE_SIZE
	
	ball.position = ORIGIN_BALL_POS
	ball.scale = BALL_SIZE
	restart = true

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			is_dragging = true
		else:
			is_dragging = false
			touch = true
	if is_dragging:
		touchplace = event.position
	
	if touch:
		pause = false
		touch = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !restart:
		moveBall()
		playerMove()
	elif restart:
		if !pause:
			pauseText.hide()
			startRound()
		else:
			pauseText.show()

func startRound():
	restart = false
	vel = Vector2(randi_range(-1,1),randi_range(-1,1)).normalized()
	if vel.x == 0 or vel.y == 0:
		startRound()
	
func changeBallDir():
	vel.x = -vel.x
	vel.y = -vel.y

func playerMove():
	if is_dragging:
		player.position.y = touchplace.y

func moveBall():
	ball.position.x += vel.x * 4
	ball.position.y += vel.y * 4


func _on_area_2d_area_entered(area):
	if area.is_in_group("BounceWall"):
		vel.y = -vel.y
	elif area.is_in_group("playerWall"):
		score_ai += 1
		restart = true
		startRound()
	elif area.is_in_group("aiWall"):
		score_player += 1
		restart = true
	else:
		changeBallDir()
	
