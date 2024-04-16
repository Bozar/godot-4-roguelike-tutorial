class_name SpriteTag
extends Node2D


const NO_MAIN_TAG: String = "%s does not have a main tag."
const NO_SUB_TAG: String = "%s does not have a sub tag."


var _main_tags: Dictionary = {}
var _sub_tags: Dictionary = {}


func get_main_tag(sprite: Sprite2D) -> StringName:
    var id: int = sprite.get_instance_id()

    if _main_tags.has(id):
        return _main_tags[id]
    push_error(NO_MAIN_TAG % sprite.name)
    return ""


func get_sub_tag(sprite: Sprite2D) -> StringName:
    var id: int = sprite.get_instance_id()

    if _sub_tags.has(id):
        return _sub_tags[id]
    push_error(NO_SUB_TAG % sprite.name)
    return ""


func get_sprites_by_tag(main_tag: StringName, sub_tag: StringName) -> Array:
    var sprites: Array

    if sub_tag == "":
        if main_tag == "":
            push_error("Neither main_tag nor sub_tag is provided.")
            return []
        sprites = get_tree().get_nodes_in_group(main_tag)
    else:
        sprites = get_tree().get_nodes_in_group(sub_tag)
        if main_tag != "":
            ArrayHelper.filter(sprites, _has_main_tag, [main_tag])
    sprites = sprites.filter(SpriteState.is_valid_sprite)
    return sprites


func _on_SpriteFactory_sprite_created(tagged_sprites: Array) -> void:
    for i: TaggedSprite in tagged_sprites:
        _add_sprite(i.sprite, i.main_tag, i.sub_tag)


func _on_SpriteFactory_sprite_removed(sprites: Array) -> void:
    for i: Sprite2D in sprites:
        _remove_sprite(i)


func _add_sprite(sprite: Sprite2D, main_tag: StringName, sub_tag: StringName) \
        -> void:
    var id: int = sprite.get_instance_id()

    _main_tags[id] = main_tag
    _sub_tags[id] = sub_tag


func _remove_sprite(sprite: Sprite2D) -> void:
    var id: int = sprite.get_instance_id()

    if not _main_tags.erase(id):
        push_error(NO_MAIN_TAG % sprite.name)
    if not _sub_tags.erase(id):
        push_error(NO_SUB_TAG % sprite.name)


# args: [main_tag: StringName]
func _has_main_tag(sprite: Sprite2D, args: Array) -> bool:
    var main_tag: StringName = args[0]

    return sprite.is_in_group(main_tag)
