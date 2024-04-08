class_name NodeReference


const SPRITE_ROOT: String = "SpriteRoot"

const SPRITE_FACTORY: String = "/root/SpriteFactory"

const SIGNAL_SPRITE_CREATED: String = "sprite_created"


# {source_node: {signal_name: [target_node_1, ...]}, ...}
const SIGNAL_CONNECTIONS: Dictionary = {
    SPRITE_FACTORY: {
        SIGNAL_SPRITE_CREATED: [
            SPRITE_ROOT,
        ],
    },
}
