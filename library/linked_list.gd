class_name LinkedList


static func init_list(object: Object) -> Dictionary:
    var linked_object := LinkedObject.new(object)
    var linked_list: Dictionary = {}
    var id: int = object.get_instance_id()

    linked_object.previous_id = id
    linked_object.next_id = id
    linked_list[id] = linked_object

    return linked_list


static func insert_object(new_object: Object, next_object: Object,
        linked_list: Dictionary) -> bool:
    var new_id: int = new_object.get_instance_id()
    var next_id: int = next_object.get_instance_id()

    if _warn_dup_object(new_object, linked_list):
        return false
    elif _warn_no_object(next_object, linked_list):
        return false

    var next_linked: LinkedObject = linked_list[next_id]
    var previous_id: int = next_linked.previous_id
    var previous_linked: LinkedObject = linked_list[previous_id]
    var new_linked: LinkedObject = LinkedObject.new(new_object)

    previous_linked.next_id = new_id
    next_linked.previous_id = new_id

    new_linked.previous_id = previous_id
    new_linked.next_id = next_id
    linked_list[new_id] = new_linked
    return true


static func append_object(new_object: Object, previous_object: Object,
        linked_list: Dictionary) -> bool:
    var previous_id: int = previous_object.get_instance_id()
    var previous_linked: LinkedObject
    var next_linked: LinkedObject

    if _warn_no_object(previous_object, linked_list):
        return false

    previous_linked = linked_list[previous_id]
    next_linked = linked_list[previous_linked.next_id]
    return insert_object(new_object, next_linked.object, linked_list)


static func remove_object(remove_this: Object, linked_list: Dictionary) -> bool:
    if _warn_no_object(remove_this, linked_list):
        return false

    var this_id: int = remove_this.get_instance_id()
    var this_linked: LinkedObject = linked_list[this_id]
    var previous_linked: LinkedObject = linked_list[this_linked.previous_id]
    var next_linked: LinkedObject = linked_list[this_linked.next_id]

    previous_linked.next_id = next_linked.object.get_instance_id()
    next_linked.previous_id = previous_linked.object.get_instance_id()
    return linked_list.erase(this_id)


# handler(object: Object, args: Array) -> void
static func iterate_list(start_object: Object, linked_list: Dictionary,
        is_forward_iteration: bool = true,
        handler: Callable = LinkedList._default_handler,
        handler_args: Array = []) -> void:
    var start_id: int = start_object.get_instance_id()
    var linked_object: LinkedObject

    if _warn_no_object(start_object, linked_list):
        if linked_list.is_empty():
            push_warning("Linked list is empty.")
            return
        start_id = linked_list.keys()[0]

    linked_object = linked_list[start_id]
    while true:
        handler.call(linked_object.object, handler_args)
        if linked_object.next_id == start_id:
            break
        if is_forward_iteration:
            linked_object = linked_list[linked_object.next_id]
        else:
            linked_object = linked_list[linked_object.previous_id]


static func has_object(object: Object, linked_list: Dictionary) -> bool:
    return linked_list.has(object.get_instance_id())


static func get_next_object(object: Object, linked_list: Dictionary) -> Object:
    if _warn_no_object(object, linked_list):
        return null

    var this_id: int = object.get_instance_id()
    var this_linked: LinkedObject = linked_list[this_id]

    return linked_list[this_linked.next_id].object


static func get_previous_object(object: Object, linked_list: Dictionary) \
        -> Object:
    if _warn_no_object(object, linked_list):
        return null

    var this_id: int = object.get_instance_id()
    var this_linked: LinkedObject = linked_list[this_id]

    return linked_list[this_linked.previous_id].object


static func _default_handler(object: Object, _args: Array) -> void:
    print(object.name)


static func _warn_no_object(object: Object, linked_list: Dictionary) -> bool:
    if not linked_list.has(object.get_instance_id()):
        push_warning("Object not found: %s." % object.name)
        return true
    return false


static func _warn_dup_object(object: Object, linked_list: Dictionary) -> bool:
    if linked_list.has(object.get_instance_id()):
        push_warning("Object already exists: %s." % object.name)
        return true
    return false
