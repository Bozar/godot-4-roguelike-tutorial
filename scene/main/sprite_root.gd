class_name SpriteRoot
extends Node2D


func _on_SpriteFactory_sprite_created(tagged_sprites: Array) -> void:
    for i: TaggedSprite in tagged_sprites:
        add_child(i.sprite)


func _on_SpriteFactory_sprite_removed(sprites: Array) -> void:
        for i: Sprite2D in sprites:
            i.queue_free()


func _on_PlayerInput_action_pressed(input_tag: StringName) -> void:
    match input_tag:
        InputTag.CLOSE_MENU:
            visible = true
        InputTag.OPEN_DEBUG_MENU:
            visible = false
        InputTag.OPEN_HELP_MENU:
            visible = false
