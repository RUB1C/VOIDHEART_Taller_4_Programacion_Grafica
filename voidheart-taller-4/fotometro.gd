class_name Fotometro
extends Node

@export var sol_sistema: SistemaSol

func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	medir()

func medir() -> void:
	var img := get_viewport().get_texture().get_image()
	var centro := Vector2i(img.get_width() / 2, int(img.get_height() * 0.75))
	var medido := img.get_pixelv(centro).r
	var predicho: float = sol_sistema.prediccion_piso(sol_sistema.ciclo.hora)
	var error := absf(medido - predicho)
	
	print("--- FOTÓMETRO ---")
	print("Hora: ", sol_sistema.ciclo.hora)
	print("Medido (R): ", snappedf(medido, 0.001))
	print("Predicho (R): ", snappedf(predicho, 0.001))
	print("Error: ", snappedf(error, 0.001))
