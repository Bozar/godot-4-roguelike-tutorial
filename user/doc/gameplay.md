# Gameplay

[→: Introduction| ←: Key Bindings]
[↑, PgUp: Scroll up | ↓, PgDn: Scroll down]
[Esc: Exit help]

## Win and Lose

To beat the game, you need to accumulate 9 hits. You gain a hit by killing an enemy, and lose one after 3 turns. On the top right corner there is a hit counter, which shows total hits and remaining turns for the last hit. For example, `4-2` means you have 4 hits right now, and will lose the fourth hit in 2 turns.

You lose the game if you end your turn being adjacent to a conscious enemy.

## PC Actions

You can do four actions: walk, kick back, aim and shoot. Switching between aiming mode and normal mode costs no time. All other actions take 1 turn.

Press arrow keys to move 1 grid in one of the four cardinal directions. If your destination is occupied by an enemy, whose symbol is an uppercase `G`, the enemy is kicked back by 1 grid and becomes unconscious (shown as `g`) for 1 turn, see Figure: 1-1.

    . . .      . . .
    @ G .  ->  @ . g
    . . .      . . .

    Figure: 1-1

If you kick an enemy who has a companion or wall (`#`) behind, the enemy is killed and leaves a railgun ammo (`?`) on the ground, see Figure 1-2.

    @ G G      @ ? G
    G . .  ->  ? . .
    # . .      # . .

    Figure: 1-2

Move over a railgun bullet to pick it up automatically. You can have at most 3 bullets. The current amount is shown in the top right corner of the screen. Press Space to switch between Aim Mode and Normal Mode if you have at least 1 bullet.

When in Aim Mode, your symbol is an exclamation mark (`!`). Press arrow keys to shoot. The first enemy in the trajectory is killed, no matter you can see it or not.

## NPC AI

A nearby enemy approaches you one grid per turn. A gunshot attracts enemies farther away. If an enemy starts its turn adjacent to you, it kills you with a single bite. 

An unconscious enemy cannot take any actions for 1 turn.

## Game Settings

Press v to open Debug Menu. All these settings take effect after restarting a game. Boolean settings (`Wizard` and `ShowMap`) accepts `true` or a non-zero number as true, and `false` or `0` as false.

You can also edit `data/setting.json`, which is loaded only once when starting the game for the first time. The json file has an option, `palette`, that allows you to define your own color theme. There are a few pre-defined themes in the file for your reference.

