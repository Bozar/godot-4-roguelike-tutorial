class_name SpriteRoot
extends Node2D


func _on_SpriteFactory_sprite_created(tagged_sprites: Array) -> void:
    for i: TaggedSprite in tagged_sprites:
        add_child(i.sprite)


func _on_SpriteFactory_sprite_removed(sprites: Array) -> void:
        for i: Sprite2D in sprites:
            i.queue_free()
