class_name CicloDia
extends Node

const NARANJA := Color(0.7, 0.75, 0.85)

@export var hora := 10.0
@export var duracion_dia := 48.0
@export var pausado := true

func avanzar(dt: float) -> void:
	if not pausado:
		hora = fposmod(hora + (24.0 * dt / duracion_dia), 24.0)

static func elevacion(h: float) -> float:
	return (h - 6.0) * 15.0

static func factor_sol(h: float) -> float:
	return maxf(0.0, sin(deg_to_rad(elevacion(h))))

static func color_sol(h: float) -> Color:
	return NARANJA.lerp(Color.WHITE, factor_sol(h))
