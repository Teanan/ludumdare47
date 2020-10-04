extends Node

export var pitch = {
	0: 1,     # D3
	1: 1.08,  # D#3
	2: 1.17,  # E3
	3: 1.25,  # F3
	4: 1.33,  # F#3
	5: 1.42,  # G3
	6: 1.5,   # G#3
	7: 1.58,  # A4
	8: 1.67,  # A#4
	9: 1.75,  # B4
	10: 1.83, # C4
	11: 1.92, # C#4
	12: 2,    # D4
	13: 2.08, # D#4
	14: 2.17, # E4
	17: 2.42, # G4
}

export var notes = [
	[0, 4, 7, 12], [5, 9, 12, 17], [0, 4, 9, 12], [2, 7, 11, 14]
]

export var bar = 1

func _ready():
	$MixingDeskMusic.init_song("Song")
	$MixingDeskMusic.start_alone("Song", "strings")
	$MixingDeskMusic.fade_in("Song", "bass")

func full():
	$MixingDeskMusic.fade_in("Song", "drums")
	$MixingDeskMusic.fade_in("Song", "recorder")

func _process(_delta):
	bar = ((($MixingDeskMusic.bar + 1) / 2) - 1) % 4
