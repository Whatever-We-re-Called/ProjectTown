extends Node
class_name ColorReveal


@export var border_color: Color
@export var speed = 5

var shader_material: ShaderMaterial
var starting_positions = []

var image_data : Image
var mask_image : Image


func reveal():
	var promises = []
	for child in starting_positions:
		var pos = child.position + Vector2(get_parent().texture.get_size().x / 2, get_parent().texture.get_size().y / 2)
		pos.floor()
		
		var promise = Promise.new()
		promises.append(promise)
		_start_flood_fill(promise, pos)
		
	# Fun wrapper to combine these all into one await
	# They all run separately, but we await until all are done until completing this method
	await Promise.async_all(promises)


func _ready():
	if not get_parent().material_override:
		get_parent().material_override = ShaderMaterial.new()
	
	shader_material = get_parent().material_override
	
	if not shader_material.shader:
		shader_material.shader = load("res://shader/color_reveal.gdshader")
	shader_material.set_shader_parameter("sprite_texture", get_parent().texture)
	
	for child in get_children():
		starting_positions.append(child)
	
	_create_mask()
	
	
func _create_mask():
	var tex = get_parent().texture
	if tex is CompressedTexture2D:
		image_data = tex.get_image()
	else:
		image_data = Image.create_from_data(tex.get_width(), tex.get_height(), false, Image.FORMAT_RGBA8, tex.get_data())

	mask_image = Image.create(image_data.get_width(), image_data.get_height(), false, Image.FORMAT_RGBA8)
	mask_image.fill(Color(0, 0, 0))
	_update_texture_from_mask(mask_image)
	

func _start_flood_fill(promise, coord):
	var queue = [coord]
	var processed_pixels = {}
	
	var range = 1

	while not queue.is_empty():
		var next_queue = []
		for current in queue:
			if not processed_pixels.has(current) and _in_bounds(current):
				var sprite_color = image_data.get_pixelv(current)
				var mask_color = mask_image.get_pixelv(current)
				if not _is_border(sprite_color) and _is_border(mask_color):
					mask_image.set_pixelv(current, Color(1, 1, 1))  # White pixel for revealing color
					processed_pixels[current] = true
					next_queue.append_array(_get_neighbors(current))
		
		range += .75
		queue = next_queue.filter(func filter(p): return p.distance_squared_to(coord) <= range * range)
		if queue.is_empty():
			queue = next_queue
		_update_texture_from_mask(mask_image)
		
		for i in speed:
			await get_tree().process_frame
	
	promise.resolve()


func _in_bounds(position):
	return position.x >= 0 and position.x < image_data.get_width() and position.y >= 0 and position.y < image_data.get_height()


func _is_border(color):
	return (color.r == border_color.r and color.b == border_color.b and color.g == border_color.g) or color.a == 0.0


func _get_neighbors(position):
	var arr = [
		position + Vector2(1, 0),
		position + Vector2(0, 1),
		position + Vector2(-1, 0),
		position + Vector2(0, -1)
	]
	
	return arr


func _update_texture_from_mask(mask_image):
	var mask_texture = ImageTexture.create_from_image(mask_image)
	shader_material.set_shader_parameter("mask_texture", mask_texture)


func _on_button_pressed():
	_create_mask()
	

func _on_button_2_pressed():
	reveal()
