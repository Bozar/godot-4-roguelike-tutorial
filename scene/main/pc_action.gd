class_name PcAction
extends Node2D


var _pc: Sprite2D


func _on_SpriteFactory_sprite_created(sprites: Array) -> void:
    if _pc != null:
        return

    for i: TaggedSprite in sprites:
        if i.sub_tag == SubTag.PC:
            _pc = i.sprite
            return


func _on_PlayerInput_action_pressed(input_tag: StringName) -> void:
    var coord: Vector2i

    match input_tag:
        InputTag.MOVE_LEFT:
            coord = Vector2i.LEFT
        InputTag.MOVE_RIGHT:
            coord = Vector2i.RIGHT
        InputTag.MOVE_UP:
            coord = Vector2i.UP
        InputTag.MOVE_DOWN:
            coord = Vector2i.DOWN
        _:
            return

    coord += ConvertCoord.get_coord(_pc)
    SpriteState.move_sprite(_pc, coord)
