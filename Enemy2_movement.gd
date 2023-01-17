extends KinematicBody

var path = []
var path_ind = 0
const move_speed = 5
onready var nav = get_parent()

var moving = false

const untill_idle = 5 # 500ms

var time = 0

func _process(delta):
	time += delta
	if time > untill_idle:
		moving = false
		time = 0

func _ready():
	add_to_group("units")


func _physics_process(delta):
	moving = false

    # If path array has a "location" start moving there
	if path_ind < path.size():
		var move_vec = (path[path_ind] - global_transform.origin)
		#print(path[path_ind])
		if move_vec.length() < 0.1:
			path_ind += 1
		else:
            #move_and_slide returns the velocity of the movement.
			var msval = move_and_slide(move_vec.normalized() * move_speed, Vector3(0, 1, 0))
			#move_and_collide(move_speed)

            #Next we will just turn the wanted object using look_at and velocity
            #transform.origin = current value of rotation
            #msval = velocity
            #Vector = In what axel we are turning the object
			self.look_at(transform.origin + msval, Vector3(0,1,0))
			moving = true
			
	if moving == false:
		self.rotate_y(30)
			
func move_to(target_pos):
	print("running move to positon script thing")
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_ind = 0
