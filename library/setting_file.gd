class_name SettingFile


enum VALUE_TYPE {
    INT, BOOL, STRING, DICTIONARY,
}

const PATHS_TO_SETTING: Array = [
    "data/setting.json",
    "res://bin/setting.json",
]

const RNG_SEED: String = "rng_seed"
const SHOW_FULL_MAP: String = "show_full_map"
const WIZARD_MODE: String = "wizard_mode"
const PALETTE: String = "palette"


static func load() -> void:
    var json: ParsedFile

    for i: String in PATHS_TO_SETTING:
        json = FileIo.read_as_json(i)
        if json.parse_success:
            break

    _set_rng_seed(json.output_json)
    _set_show_full_map(json.output_json)
    _set_wizard_mode(json.output_json)
    _set_palette(json.output_json)


static func _set_wizard_mode(setting: Dictionary) -> void:
    var setting_value: SettingValue = _parse_setting(setting, WIZARD_MODE,
            VALUE_TYPE.BOOL)
    if setting_value.is_valid:
        TransferData.set_wizard_mode(setting_value.bool_value)


static func _set_show_full_map(setting: Dictionary) -> void:
    var setting_value: SettingValue = _parse_setting(setting, SHOW_FULL_MAP,
            VALUE_TYPE.BOOL)
    if setting_value.is_valid:
        TransferData.set_show_full_map(setting_value.bool_value)


static func _set_rng_seed(setting: Dictionary) -> void:
    var setting_value: SettingValue = _parse_setting(setting, RNG_SEED,
            VALUE_TYPE.INT)
    var rng_seed: int

    if setting_value.is_valid and (setting_value.int_value > 0):
        rng_seed = setting_value.int_value
    else:
        rng_seed = 0
    TransferData.set_rng_seed(rng_seed)


static func _set_palette(setting: Dictionary) -> void:
    var setting_value: SettingValue = _parse_setting(setting, PALETTE,
            VALUE_TYPE.DICTIONARY)
    var palette: Dictionary

    if setting_value.is_valid:
        palette = Palette.get_verified_palette(setting_value.dictionary_value)
        TransferData.set_palette(palette)


static func _parse_setting(setting: Dictionary, key: String, value_type: int) \
        -> SettingValue:
    var float_value: float
    var bool_value: bool
    var string_value: String
    var dictionary_value: Dictionary
    var setting_value: SettingValue = SettingValue.new()

    setting_value.is_valid = false
    if not setting.has(key):
        return setting_value

    match value_type:
        VALUE_TYPE.INT:
            match typeof(setting[key]):
                TYPE_FLOAT:
                    float_value = setting[key]
                    setting_value.int_value = float_value as int
                    setting_value.is_valid = true
        VALUE_TYPE.BOOL:
            match typeof(setting[key]):
                TYPE_BOOL:
                    bool_value = setting[key]
                    setting_value.bool_value = bool_value
                    setting_value.is_valid = true
                TYPE_FLOAT:
                    float_value = setting[key]
                    setting_value.bool_value = float_value >= 1
                    setting_value.is_valid = true
        VALUE_TYPE.STRING:
            match typeof(setting[key]):
                TYPE_STRING:
                    string_value = setting[key]
                    setting_value.string_value = string_value
                    setting_value.is_valid = true
        VALUE_TYPE.DICTIONARY:
            match typeof(setting[key]):
                TYPE_DICTIONARY:
                    dictionary_value = setting[key]
                    setting_value.dictionary_value = dictionary_value
                    setting_value.is_valid = true
    return setting_value


class SettingValue:
    var is_valid: bool

    var int_value: int
    var bool_value: bool
    var string_value: String
    var dictionary_value: Dictionary
