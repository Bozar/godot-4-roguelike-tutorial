# class_name TransferData
extends Node2D


var rng_seed: int:
    get:
        return _rng_seed


var wizard_mode: bool:
    get:
        return _wizard_mode


var _rng_seed: int = 0
var _wizard_mode: bool = false


func set_rng_seed(value: int) -> void:
    _rng_seed = value


func set_wizard_mode(value: bool) -> void:
    _wizard_mode = value
