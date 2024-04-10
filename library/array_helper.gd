class_name ArrayHelper


static func swap_element(source: Array, left_idx: int, right_idx: int) -> void:
    var tmp: Variant = source[left_idx]

    source[left_idx] = source[right_idx]
    source[right_idx] = tmp


# is_valid_element(element_in_source: Variant, is_valid_args: Array) -> bool
static func filter(source: Array, is_valid_element: Callable,
        is_valid_element_args: Array) -> Array:
    var filter_index: int = 0

    for i: int in range(0, source.size()):
        if is_valid_element.call(source[i], is_valid_element_args):
            swap_element(source, filter_index, i)
            filter_index += 1
    source.resize(filter_index)
    return source
