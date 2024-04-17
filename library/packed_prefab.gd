class_name PackedPrefab


var max_x: int:
    get:
        return _max_x
var max_y: int:
    get:
        return _max_y
var prefab: Dictionary:
    get:
        return _prefab


var _max_x: int
var _max_y: int
var _prefab: Dictionary


func _init(prefab_: Dictionary) -> void:
    _prefab = prefab_
    _max_x = prefab_.size()
    _max_y = PackedPrefab._get_max_y(prefab_)


static func _get_max_y(init_prefab: Dictionary) -> int:
    if init_prefab.is_empty():
        return 0
    elif typeof(init_prefab[0]) != TYPE_ARRAY:
        return 0
    return init_prefab[0].size()
