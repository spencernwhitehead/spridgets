class_name DraggableMesh2D
extends MeshInstance2D

@export var texture_size : Vector2 = Vector2(100, 100)
@export var rows : int = 100
@export var cols : int = 100
@export var brush_size : float = 30.0
@export var brush_strength : float = 0.3
@export var ref_sprite : Sprite2D
@export var drag_active : bool = true

var amount_dragged : float = 0.0
var prev_mouse_pos : Vector2

signal mesh_updated()


func _ready() -> void:
	if ref_sprite != null:
		texture_size.x = ref_sprite.texture.get_width() * ref_sprite.scale.x * get_parent().scale.x
		#print(texture_size.x)
		texture_size.y = ref_sprite.texture.get_height() * ref_sprite.scale.y * get_parent().scale.x
		position.x = (texture_size.x * -0.5)
		#print(position.x)
		position.y = (texture_size.y * -0.5)
		ref_sprite.self_modulate = Color(1,1,1,0)
	generate_grid()
	refresh_mesh()


# create mesh with image overlaid
func generate_grid() -> void:
	print("generating grid")
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)

	# PackedVector**Arrays for mesh construction.
	
	# list of coordinates for each point in the grid (defined by rows and cols)
	var verts = PackedVector2Array()
	# list of where to map the texture to each vertex (percentage from 0 to 1.0)
	var uvs = PackedVector2Array()
	# list of which vertexes to use to create triangles for the mesh
	# read in groups of three, each one being an index from the vertex array to make the triangle with
	var indices = PackedInt32Array()
	
	# create a vertex and uv map for each point in the grid
	for i in range(rows):
		for j in range(cols):
			# get coordinates for current vertex and uv based on current grid index
			
			# x and y of current point on grid, as percentage from 0 to 1.0
			var uv_x = i / (rows - 1.0)
			var uv_y = j / (cols - 1.0)
			uvs.append(Vector2(uv_x, uv_y))
			
			# actual coordinates for x and y
			var vert_x = texture_size.x * uv_x 
			var vert_y = texture_size.y * uv_y
			verts.append(Vector2(vert_x, vert_y))
	
	# create list of indices to generate triangle mesh
	# for each four-point square in grid, creates two triangles
	# one on top left of square and one on bottom right
	for i in range(rows - 1):
		for j in range(cols - 1):
			# get indices of each point in current square
			var top_left = rows * i + j
			var top_right = rows * i + j + 1
			var bottom_left = rows * (i + 1) + j
			var bottom_right = rows * (i + 1) + j + 1
			
			# create top left triangle
			indices.append(top_right)
			indices.append(bottom_left)
			indices.append(top_left)
			
			#create bottom right triangle
			indices.append(top_right)
			indices.append(bottom_left)
			indices.append(bottom_right)

	# Assign arrays to surface array.
	surface_array[Mesh.ARRAY_VERTEX] = verts
	surface_array[Mesh.ARRAY_TEX_UV] = uvs
	surface_array[Mesh.ARRAY_INDEX] = indices

	# Create mesh surface from mesh array.
	# No blendshapes, lods, or compression used.
	print("adding surface")
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)


# warp mesh around cursor when dragging
func _input(event: InputEvent) -> void:
	# TODO: update logic to be more general. doesn't allow other cursor types in the scene
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		Cursor.show_cursor("pet_active", true)
	else:
		Cursor.show_cursor("pet_idle", true)
	
	# doesn't apply drag logic if not active
	if !drag_active:
		return
	
	# dragging determined if mouse is moving while left mouse button held
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var arr = mesh.surface_get_arrays(0)
		var vertices = arr[Mesh.ARRAY_VERTEX]
		var drag_success := false
		
		for i in range(vertices.size()):
			# distance from current vertex to mouse
			# uses event.position to get mouse pos,
			# and to_local to make coordinates relative to image
			var vert_dist = vertices[i].distance_to(to_local(event.position))
			
			# only modify if within range of mouse
			if vert_dist < brush_size:
				drag_success = true
				
				# make deform weaker the further the current vertex is from the mouse
				var dist_factor = 1.0 - (vert_dist / brush_size) ** 2
				
				# apply deform to current vertex
				# event.relative gives current movement of mouse in relation to previous position
				vertices[i] += event.relative * brush_strength * dist_factor
		
		if !drag_success:
			return
		
		if prev_mouse_pos != null:
			amount_dragged += prev_mouse_pos.distance_to(to_local(event.position))
		prev_mouse_pos = to_local(event.position)
		
		# update mesh with deformities
		arr[Mesh.ARRAY_VERTEX] = vertices
		mesh.clear_surfaces()
		mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr)
		
		mesh_updated.emit()


func refresh_mesh() -> void:
	var arr = mesh.surface_get_arrays(0)
	mesh.clear_surfaces()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr)
