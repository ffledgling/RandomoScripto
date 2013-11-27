************************************************************
* File: youtube.vim                                        *
* Author: Anhad Jai Singh                                  *
* Licence: WTFPL2                                          *
************************************************************

* Even though it's WTFPL2, a mention or attribution would is always nice :)

* This is probably very rough around the edges,
  therefore feedback from experienced souls is always welcome!

> This plugin :
    >> Searches YouTube
    >> Picks the first result
    >> Plays it in VLC in the background

> Requirements:
    >> Vim with python support (+python)
    >> VLC's CLI


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
        Hint: Look at vlc/cvlc command line args

