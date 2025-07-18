extends Node2D


func _on_entrada_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		get_tree().change_scene_to_file("res://lv_2.tscn")


func _on_caida_body_entered(body: Node2D) -> void:
	if(body.is_in_group("jugador")):
		body.morir()


func _on_caida_2_body_entered(body: Node2D) -> void:
	if(body.is_in_group("jugador")):
		body.morir()
