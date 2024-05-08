# Export Settings

* Godot engine: 4.2.1
* Embed pck: True
* Include filter: `user/doc/*, resource/dungeon_prefab/*`
* Exclude filter: `bin/*, resource/REXPaint/*`

`bin/*` is not tracked by Git. Therefore it does not exist in the GitHub repository. I use it locally to store binary files.

The above settings are required for a Windows desktop project. If you want to export an HTML5 game, change following settings in addition to previous ones.

Project settings - Display - Window:

* Size - Resizable: On
* Stretch - Mode: 2d
* Stretch - Aspect: keep

Export:

* Head Include: `<link rel="stylesheet" href="customStyle.css">`
* Canvas Resize Policy: Project

In order to run the HTML5 game, deploy it on a server along with `misc/customStyle.css`.

