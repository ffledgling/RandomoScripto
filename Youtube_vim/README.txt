************************************************************
* File: youtube.vim                                        *
* Author: Anhad Jai Singh                                  *
* Licence: WTFPL2                                          *
************************************************************

* Even though it's WTFPL2, a mention or attribution would be/is always nice :)

* This is probably very rough around the edges,
  therefore feedback from experienced souls is always welcome!

> This plugin :
    >> Searches YouTube
    >> Picks the first result
    >> Plays it in VLC in the background

> Requirements:
    >> Vim with python support (+python)
    >> VLC's CLI
    >> You probably want to setup VLC to run only one instance
       at a time and optionally setup enqueuing tracks.
       (See here: https://wiki.archlinux.org/index.php/VLC_media_player#Preventing_multiple_instances)


> Suggested enhancement:
    >> Map YoutubeSearchAndPlay() to a key combination of choice
       for quick access.
       Mapped to <F12> by default.

> Other Notes:
    >> Runs on Linux (tested on Fedora 18, Ubuntu 13.04)
    >> Probably will run on Mac (untested)
    >> Probably won't run on Windows (points and laughs at MS)
    >> Output might vary according to VLC settings, especially
       if you allow multiple VLCs to play/run in parallel

> TODO:
    >> Add a user interface:
        >>> Dump results in a scratch buffer
        >>> Let user select result to use
        >>> Play selected result
        >>> Close scratch buffer
        Hint: Look at how NERDTree works.

    >> Add "Now playing <Song Name>" to statusline

    >> Add functions to pause, resume, enqueue
       
       Hint#1: Look at vlc/cvlc command line args
       
       Hint#2: Use VLC's telnet interface, look at
       http://crunchbang.org/forums/viewtopic.php?pid=112035%23p112035#p112035

