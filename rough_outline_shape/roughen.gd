extends Polygon2D

@export var roughness_strength: float = 10.0   # Seberapa jauh vertex digeser
@export var update_interval: float = 0.2      # Interval random update (detik)
@export var outward_only: bool = true
@export var foggy_mode: bool = false         # Hanya keluar (true) atau random bebas

var _original_polygon: PackedVector2Array
var _time_passed := 0.0

func _ready():
	_original_polygon = polygon.duplicate()
	print(_original_polygon)

func _process(delta):
	_time_passed += delta
	if _time_passed >= update_interval:
		_time_passed = 0.0
		if foggy_mode:
			_apply_roughen2()
		else:
			_apply_roughen()

# =========================
# ROUGHEN CORE
# =========================
func _apply_roughen():
	var new_poly := PackedVector2Array()

	for i in range(_original_polygon.size()):
		var point = _original_polygon[i]

		# Hitung normal keluar (approx)
		var prev_i = i - 1
		if prev_i < 0:
			prev_i = _original_polygon.size() - 1
		var next_i = i + 1
		if next_i == _original_polygon.size():
			next_i = 0
			
		var prev = _original_polygon[prev_i]
		var next = _original_polygon[next_i]
		
		var edge = (next - prev).normalized()
		
		var normal = Vector2(-edge.y, edge.x) # perpendicular

		# Random offset
		var rand_val = randf()
		var offset_strength = rand_val * roughness_strength

		if not outward_only:
			offset_strength *= randf_range(-1.0, 1.0)

		var new_point = point + normal * offset_strength
		new_poly.append(new_point)

	polygon = new_poly
	
func _apply_roughen2():
	var new_poly := PackedVector2Array()

	for i in range(_original_polygon.size()):
		var point = _original_polygon[i]

		# Random direction (bebas, tidak pakai normal)
		var rand_dir = Vector2(
			randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0)
		)

		# Optional: normalize biar konsisten panjang arah
		if rand_dir.length() > 0:
			rand_dir = rand_dir.normalized()

		# Random strength
		var offset_strength = randf() * roughness_strength

		var new_point = point + rand_dir * offset_strength
		new_poly.append(new_point)

	polygon = new_poly
