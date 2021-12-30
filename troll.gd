extends KinematicBody2D

const MOTION_SPEED = 160 # Pixels/second.

export( NodePath ) onready var interact_zone = get_node( interact_zone ) as Area2D
export( NodePath ) onready var interact_labels = get_node( interact_labels ) as Control

var current_interactable

func _ready():
	SignalManager.connect( "item_dropped", self, "_on_item_dropped" )

func _physics_process(_delta):
	var motion = Vector2()
	motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	motion.y /= 2
	motion = motion.normalized() * MOTION_SPEED
	#warning-ignore:return_value_discarded
	move_and_slide(motion)

func _process( _delta ):
	if not current_interactable:
		var overlapping_area = interact_zone.get_overlapping_areas()
		
		if overlapping_area.size() > 0 and overlapping_area[ 0 ].has_method( "interact" ):
			current_interactable = overlapping_area[ 0 ]
			interact_labels.display( current_interactable )

func _input( event ):
	if event.is_action_pressed( "interact" ) and current_interactable:
		current_interactable.interact()

func _on_interactable_zone_area_exited( area ):
	if current_interactable == area:
		if current_interactable.has_method( "out_of_range" ):
			current_interactable.out_of_range()
		
		interact_labels.hide()
		current_interactable = null

func _on_item_dropped( item ):
	var floor_item = ResourceManager.tscn.floor_item.instance()
	floor_item.item = item
	get_parent().add_child( floor_item )
	floor_item.position = position





