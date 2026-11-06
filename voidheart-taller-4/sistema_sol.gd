class_name SistemaSol
extends Node

signal cambio_noche(es_noche: bool)

@export var sol: DirectionalLight3D
@export var entorno: WorldEnvironment
@export var energia_sol := 1.0
@export var azimut := -30.0
@export var ambiente_dia := 1.0
@export var ambiente_noche := 0.2

@onready var ciclo: CicloDia = $CicloDia

var era_noche := false

func _ready() -> void:
	aplicar_hora()
	era_noche = CicloDia.factor_sol(ciclo.hora) <= 0.0

func _process(delta: float) -> void:
	ciclo.avanzar(delta)
	aplicar_hora()
	
	var es_noche := CicloDia.factor_sol(ciclo.hora) <= 0.0
	if es_noche != era_noche:
		era_noche = es_noche
		cambio_noche.emit(es_noche)

func aplicar_hora() -> void:
	var h := ciclo.hora
	var f := CicloDia.factor_sol(h)
	
	sol.rotation_degrees = Vector3(-CicloDia.elevacion(h), azimut, 0.0)
	sol.light_energy = energia_sol * f
	sol.light_color = CicloDia.color_sol(h)
	
	entorno.environment.ambient_light_energy = lerpf(ambiente_noche, ambiente_dia, f)


static func lambert(normal: Vector3, direccion_luz: Vector3) -> float:
	return maxf(0.0, normal.dot(direccion_luz))

func prediccion_piso(h: float) -> float:
	var f := CicloDia.factor_sol(h)
	var e := energia_sol * f
	var angulo := deg_to_rad(CicloDia.elevacion(h))
	var l := Vector3(0.0, sin(angulo), 0.0).normalized()
	return lambert(Vector3.UP, l) * e * CicloDia.color_sol(h).r
