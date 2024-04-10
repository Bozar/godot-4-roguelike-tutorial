class_name NodeReference


const SPRITE_ROOT: String = "SpriteRoot"
const PC_ACTION: String = "PcAction"
const PLAYER_INPUT: String = "PlayerInput"
const SPRITE_COORD: String = "SpriteCoord"
const SPRITE_TAG: String = "SpriteTag"

const SPRITE_FACTORY: String = "/root/SpriteFactory"
const SPRITE_STATE: String = "/root/SpriteState"

const SIGNAL_SPRITE_CREATED: String = "sprite_created"
const SIGNAL_SPRITE_REMOVED: String = "sprite_removed"

const SIGNAL_ACTION_PRESSED: String = "action_pressed"


# {source_node: {signal_name: [target_node_1, ...]}, ...}
const SIGNAL_CONNECTIONS: Dictionary = {
    SPRITE_FACTORY: {
        SIGNAL_SPRITE_CREATED: [
            SPRITE_ROOT, PC_ACTION, SPRITE_COORD, SPRITE_TAG,
        ],
        SIGNAL_SPRITE_REMOVED: [
            SPRITE_ROOT, SPRITE_COORD, SPRITE_TAG,
        ],
    },
    PLAYER_INPUT: {
        SIGNAL_ACTION_PRESSED: [
            PC_ACTION,
        ],
    },
}


# {source_node: [target_node_1, ...], ...}
const NODE_CONNECTIONS: Dictionary = {
    SPRITE_COORD: [
        SPRITE_STATE,
    ],
    SPRITE_TAG: [
        SPRITE_STATE,
    ],
}
