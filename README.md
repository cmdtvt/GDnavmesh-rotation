


## Godot navmesh rotation

*(This repo was made because many requests to show example code of an video i made. This is just a quick example and explanation how to rotate entity that is using godot's navmesh.)*

This is a simple example how to get the direction and rotate the character while it's moving using Godot's navmesh. In a below example is a implementation where entity on navmesh (example a enemy) tries to move next given coorinates on `path` list.

While moving to these coordinates with `move_and_slide` we can get the acceleration of this entity. From this acceleration we can figure out the direction that the entity should be facing. Then with `look_at` function we can make the given entity face that direction. (I'm using `self.look_at()` because self is reference to this current entity that the code is attached to)

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
Link to video where code is in action: [YouTube](https://www.youtube.com/watch?v=Z0yW9icSGd8)

#### Other problem that might arise.

 - If your entity (Enemy) is stuck in air and is not responding to the
   coordinates it should travel to you could try rising the navmesh of
   the ground a bit. (Took me ages to figure this out)
   
 - Currently the rotation of the entity is instant. To make this smooth just add some kind of counter so the entity is rotated bit by bit.

