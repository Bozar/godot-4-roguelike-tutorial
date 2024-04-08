class_name NodeReference


const SPRITE_ROOT: String = "SpriteRoot"
const PC_ACTION: String = "PcAction"
const PLAYER_INPUT: String = "PlayerInput"

const SPRITE_FACTORY: String = "/root/SpriteFactory"

const SIGNAL_SPRITE_CREATED: String = "sprite_created"
const SIGNAL_ACTION_PRESSED: String = "action_pressed"


# {source_node: {signal_name: [target_node_1, ...]}, ...}
const SIGNAL_CONNECTIONS: Dictionary = {
    SPRITE_FACTORY: {
        SIGNAL_SPRITE_CREATED: [
            SPRITE_ROOT, PC_ACTION,
        ],
    },
    PLAYER_INPUT: {
        SIGNAL_ACTION_PRESSED: [
            PC_ACTION,
        ],
    },
}
