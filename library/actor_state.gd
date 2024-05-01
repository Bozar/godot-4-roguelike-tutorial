class_name ActorState


var hit_damage: int:
    set(value):
        hit_damage = min(GameData.HIT_DAMAGE, max(0, value))
