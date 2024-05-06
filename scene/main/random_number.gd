class_name RandomNumber
extends Node2D


var _rng: RandomNumberGenerator = RandomNumberGenerator.new()


func get_seed() -> int:
    return _rng.seed


func get_int(min_int: int, max_int: int) -> int:
    return _rng.randi_range(min_int, max_int - 1)


func get_percent_chance(chance: int) -> bool:
    return chance > get_int(0, 100)


func set_initial_seed(input_seed: int) -> void:
    var new_seed: int = input_seed

    while new_seed <= 0:
        _rng.randomize()
        new_seed = _rng.randi()
    _rng.seed = new_seed
    print("Seed: %d" % new_seed)


func _on_PlayerInput_action_pressed(input_tag: StringName) -> void:
    match input_tag:
        InputTag.COPY_SEED:
            DisplayServer.clipboard_set(str(get_seed()))
        InputTag.REPLAY_GAME:
            TransferData.set_rng_seed(get_seed())
        InputTag.RESTART_GAME:
            TransferData.set_rng_seed(0)
        InputTag.START_NEW_GAME:
            TransferData.set_rng_seed(0)
