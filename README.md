battleships
===========

Battleships game written in Ruby.
* Logo generated from - http://www.flamingtext.co.uk/
* Pixi.js used as the main game engine for the isometric tiles
* JQuery used for basic DOM binding
* Sinatra used as a simple web app framework along with erb templates
* Tiles were used from Peepsquest, thanks - http://peepsquest.com/tutorials/isometric-tiles-with-height.html

DONE
----

* Basic CSS for fonts for game
* MAIN - Display LETTERS and numbers for the positions
* MAIN - Handle player coordinate entry and display of error message
* MAIN - Add tile state for destroyed piece of ship

TODO
----

* Change form POST to an AJAX post so we can register a callback and play the destroy sound
* MAIN - Fix state where player destroys a tile already destroyed - should not register hit
* MAIN - Game state end checking and the game over screen
* MAIN - Display of players at top, e.g. human: jon, computer: dave
* MAIN - Show board for opponent, also show players board
* MAIN - Debug link for placement of ships
* MAIN - Add tile states for start of ship and end of ship (HS, HM, HE), (VS, VM, VE)
* MAIN - Add abandon game button/link

* START - Start screen
* START - Select players at beginning of game - addition of human, start game button
* START - Handle player placement of ships at beginning

* SPRITE - get graphics for isometric battleships (middle piece, begin piece, end piece)
* SPRITE - customise the sea tile to be more authentic
* SPRITE - animate the tile if possible for the sea
* SPRITE - show the destroyed ship piece
* SPRITE - handle update with sprite explosion animation

* SOUND - http://goldfirestudios.com/blog/104/howler.js-Modern-Web-Audio-Javascript-Library
* SOUND - explosion for piece destroyed
* SOUND - explosion for destroyed ship

* STRUCTURE - cleanup the Javascript, modularise and prototype correctly

* BONUS - Show a high scores screen, store the result of finished games in a simple JSON structure on disk

Game Development Engines
------------------------

* JSISO - http://jsiso.com/
* Quintus - http://www.remcodraijer.nl/quintus
* MelonJS - http://melonjs.org/
* JAWAJS - http://jawsjs.com/
* Game.js - http://gamejs.org/
* FrozenJS - http://frozenjs.com/docs/
* Sheetengine - http://sheetengine.codeplex.com/

Full list - http://html5gameengine.com/

Tile Editor - https://github.com/bjorn/tiled
