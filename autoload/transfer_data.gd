# class_name TransferData
extends Node2D


var rng_seed: int:
    get:
        return _rng_seed


var wizard_mode: bool:
    get:
        return _wizard_mode


var show_full_map: bool:
    get:
        return _show_full_map


var _rng_seed: int = 0
var _wizard_mode: bool = false
var _show_full_map: bool = false


func set_rng_seed(value: int) -> void:
    _rng_seed = value


func set_wizard_mode(value: bool) -> void:
    _wizard_mode = value


func set_show_full_map(value: bool) -> void:
    _show_full_map = value