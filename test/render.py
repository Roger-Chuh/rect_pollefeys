import bpy
from mathutils import Matrix
from mathutils import Vector
from math import radians
import bpy
import bpy
import string

def scene_update(context):
    if bpy.data.objects.is_updated:
        print("One or more objects were updated!")
        for ob in bpy.data.objects:
            if ob.is_updated:
                print("=>", ob.name)
 
bpy.app.handlers.scene_update_post.append(scene_update)

def write_cam_info(ob,shot):
	scn = bpy.data.scenes['Scene']
	w = scn.render.resolution_x
	h = scn.render.resolution_y
	per = scn.render.resolution_percentage
	w = w*per/100;
	h = h*per/100;
	path = 'c:\\tmp\\'
	counter = 0
	name = ob.name
	filename = path + 'cam_' +'{:03d}'.format(shot) + '_{:08d}'.format(counter) + '.txt'
	file = open(filename, 'w')
	# get camera obj and setting
	cam1 = bpy.data.cameras[name]
	RT = ob.matrix_world.inverted()
	print('inv(RT)',RT)
	# lens length
	file.write("%f \n" % cam1.lens)
	# sensor
	file.write("%f %f\n" % (cam1.sensor_width, cam1.sensor_height))
	# size
	file.write("%f %f\n" % (w, h))
	# rotation and translation
	RT.transpose();
	file.write("%16.16f %16.16f %16.16f %16.16f\n" % (RT[0][0], RT[0][1], RT[0][2], RT[0][3]))
	file.write("%16.16f %16.16f %16.16f %16.16f\n" % (RT[1][0], RT[1][1], RT[1][2], RT[1][3]))
	file.write("%16.16f %16.16f %16.16f %16.16f\n" % (RT[2][0], RT[2][1], RT[2][2], RT[2][3]))
	# close
	file.close
	counter = counter + 1

def render_multiview():
	obj = bpy.data.objects['Camera']
	fov = 50.0
	scene = bpy.data.scenes["Scene"]
	# Set camera fov in degrees
	scene.camera.data.angle = fov*(pi/180.0)
	scene.camera.rotation_mode = 'XYZ'
	bpy.data.objects['Camera'].location.x = 5
	bpy.data.objects['Camera'].location.y = 0
	bpy.data.objects['Camera'].location.z = 1
	bpy.data.objects['Camera'].rotation_euler[0] = 90*(pi/180.0)
	bpy.data.objects['Camera'].rotation_euler[1] = 0*(pi/180.0)
	bpy.data.objects['Camera'].rotation_euler[2] = 90*(pi/180.0)
	print('be4 update', bpy.data.objects['Camera'].matrix_world)
	scene.update()
	print('after update',bpy.data.objects['Camera'].matrix_world)
	render = bpy.context.scene.render;
	render.use_file_extension = True
	render.resolution_x = 640
	render.resolution_y = 480
	for step in range(0, 2):
		bpy.context.scene.render.filepath = 'c:\\tmp\\shot_%d.jpg' % step
		rotated = Matrix.Rotation(pi/16, 4, 'Z')*Vector(obj.location)
		bpy.data.objects['Camera'].location = (rotated.x,rotated.y,rotated.z)
		scene.update()
		print(bpy.data.objects['Camera'].matrix_world)
		write_cam_info(obj,step)
		bpy.ops.render.render(write_still=True)