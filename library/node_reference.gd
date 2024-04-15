class_name NodeReference


const SPRITE_ROOT: String = "SpriteRoot"
const PC_ACTION: String = "PcAction"
const PLAYER_INPUT: String = "PlayerInput"
const SPRITE_COORD: String = "SpriteCoord"
const SPRITE_TAG: String = "SpriteTag"
const SCHEDULE: String = "Schedule"
const ACTOR_ACTION: String = "ActorAction"

const SPRITE_FACTORY: String = "/root/SpriteFactory"
const SPRITE_STATE: String = "/root/SpriteState"
const SCHEDULE_HELPER: String = "/root/ScheduleHelper"


const SIGNAL_SPRITE_CREATED: String = "sprite_created"
const SIGNAL_SPRITE_REMOVED: String = "sprite_removed"

const SIGNAL_ACTION_PRESSED: String = "action_pressed"

const SIGNAL_TURN_STARTED: String = "turn_started"


# {source_node: {signal_name: [target_node_1, ...]}, ...}
const SIGNAL_CONNECTIONS: Dictionary = {
    SPRITE_FACTORY: {
        SIGNAL_SPRITE_CREATED: [
            SPRITE_ROOT, PC_ACTION, SPRITE_COORD, SPRITE_TAG, SCHEDULE,
        ],
        SIGNAL_SPRITE_REMOVED: [
            SPRITE_ROOT, SPRITE_COORD, SPRITE_TAG, SCHEDULE,
        ],
    },
    PLAYER_INPUT: {
        SIGNAL_ACTION_PRESSED: [
            PC_ACTION,
        ],
    },
    SCHEDULE: {
        SIGNAL_TURN_STARTED: [
            PLAYER_INPUT, PC_ACTION, ACTOR_ACTION,
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
    SCHEDULE: [
        SCHEDULE_HELPER,
    ],
}
