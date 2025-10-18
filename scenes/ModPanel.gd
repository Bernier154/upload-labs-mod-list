extends Panel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mod_desc = "";
	for mod_data: ModData in ModLoaderMod.get_mod_data_all().values():
		var active = 'Active' if mod_data.is_active else 'Inactive'
		mod_desc = str(mod_desc, ' ', mod_data.manifest.name, ' v', mod_data.manifest.version_number, ' (', active, ')\n\n')
	$InfoContainer/Mods.text = mod_desc
