# Ruby Chess
##### Written all in Ruby; runs in console with some slick prompting

<img src="https://pbs.twimg.com/profile_images/495211744633950209/CvjNepWX.png" width="30" height="30"> You can play the game live on Cloud9 [here](https://ide.c9.io/haseeb_qureshi/ruby-chess). The login is *guestaccount*, password *guestaccount*. Game can be run by running `ruby game.rb` in the console.

### Features:
* Chess AI uses greedy cost-benefit heuristics to choose move with highest immediate EV.
* Can save and load games by serializing game-state to YAML.
* All pieces inherit from common Piece class, and include "Steppable" and "Slideable" mix-ins to modularize sliding/stepping movement logic.
* Colorized UI, W-A-S-D input.
* Highlighting of all potential moves.
* It works! Play it by your lonely, lonely self!

###### Note: I'm good at coding chess, not so much at playing.
![chess](http://i.gyazo.com/e8cc96537eb692d9deb70ed227373d30.gif)
