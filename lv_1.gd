extends Node2D


func _on_entrada_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("")
