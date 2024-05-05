# class_name TransferData
extends Node2D


var rng_seed: int:
    get:
        return _rng_seed


var _rng_seed: int = 0


func set_rng_seed(value: int) -> void:
    _rng_seed = value
