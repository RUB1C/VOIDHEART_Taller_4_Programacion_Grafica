class_name SistemaEventos
extends Node

@export var luz_evento: OmniLight3D
@export var pico_destello := 4.0
@export var k_destello := 4.0 # 1/s: qué tan rápido se apaga el destello

@export var luz_variable: Light3D
@export var color_bajo: Color = Color(0.48, 0.62, 0.70) # #7C9EB2 (Calma)[cite: 1, 26]
@export var color_alto: Color = Color(0.14, 0.07, 0.14) # #231123 (Peligro/Estrés)[cite: 1, 26]
@export var k_variable := 4.0

var variable := 0.0 # de 0 a 1: nivel de estrés[cite: 26]

func _ready() -> void:
	for d in get_tree().get_nodes_in_group("disparadores"):
		d.evento.connect(_on_evento)
	if luz_evento:
		luz_evento.light_energy = 0.0

func _process(delta: float) -> void:
	# 1. Actualizar el destello de la luz de evento usando decaimiento exponencial[cite: 22, 24]
	if luz_evento:
		luz_evento.light_energy = decaer(luz_evento.light_energy, 0.0, k_destello, delta)

	# Teclas de prueba opcionales para subir/bajar el estrés con las flechas del teclado
	if Input.is_key_pressed(KEY_UP):
		variable = minf(1.0, variable + delta * 0.5)
	elif Input.is_key_pressed(KEY_DOWN):
		variable = maxf(0.0, variable - delta * 0.5)

	# 2. Actualizar la luz que sigue la variable de estrés[cite: 25, 26]
	if luz_variable:
		var v_clamped := clampf(variable, 0.0, 1.0)
		luz_variable.light_color = color_bajo.lerp(color_alto, v_clamped)
		var energia_deseada := 1.0 + 3.0 * v_clamped
		luz_variable.light_energy = decaer(luz_variable.light_energy, energia_deseada, k_variable, delta)

func _on_evento(posicion: Vector3) -> void:
	# Al recibir el aviso, la luz de evento salta a la posición y toma el valor del pico[cite: 24]
	if luz_evento:
		luz_evento.global_position = posicion + Vector3.UP * 1.5
		luz_evento.light_energy = pico_destello

static func decaer(actual: float, base: float, k: float, dt: float) -> float:
	var alpha := 1.0 - exp(-k * dt)
	return actual + (base - actual) * alpha
