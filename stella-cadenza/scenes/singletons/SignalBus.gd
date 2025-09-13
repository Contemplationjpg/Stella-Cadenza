extends Node


signal display_dialogue(text_key)
signal dialogue_stopped
signal ForcePauseGame(paused : bool)
signal OddBeat()
signal EvenBeat()
signal LoadLevel(level_name : String)
signal LoadLevelAtLocation(level_name : String, global_pos : Vector2)
signal ResetPlayerLocation
signal SetPlayerLocation(location : Node2D)
signal ConfirmSetPlayerLocation
signal FlashFadeToBlack
signal FadeToBlack
signal FadeFromBlack
signal FadeNotChanging
signal JustUnblocked
signal LockPlayerSceneTransition
signal UnlockPlayerSceneTransition

signal PlaySong(song_name : String)