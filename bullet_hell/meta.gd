extends Node

# float
var damage = "DMG" # { damage: 1.0 }

func assign(target : Node, metadata : Dictionary):
	var keys = metadata.keys()
	var vals = metadata.values()
	for i in range(metadata.size()):
		target.set_meta(keys[i], vals[i])

