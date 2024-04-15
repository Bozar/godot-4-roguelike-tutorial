class_name LinkedObject


var object: Object:
    get:
        return _object
var previous_id: int
var next_id: int


var _object: Object


func _init(object_: Object) -> void:
    _object = object_
