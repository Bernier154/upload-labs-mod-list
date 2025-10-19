extends Node

var mods : Array
var dirty = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var all_mod_data = ModLoaderMod.get_mod_data_all()
	var template = get_node('Modpanel/MarginContainer/VBoxContainer/ScrollContainer/ModsContainer/modItem')
	var container = get_node('Modpanel/MarginContainer/VBoxContainer/ScrollContainer/ModsContainer')
	container.remove_child(template)
	get_node('Modpanel/MarginContainer/VBoxContainer/Version').text = 'Version v'+ModLoaderMod.get_mod_data('bernier154-mod_list').manifest.version_number
	for key in all_mod_data:
		var mod_data = all_mod_data[key]
		var mod_row = template.duplicate()
		mod_row.get_node('Label').text = str(mod_data.manifest.name, ' v', mod_data.manifest.version_number)
		mod_row.get_node('CheckButton').button_pressed = mod_data.is_active
		mod_row.get_node('CheckButton').toggled.connect(_toggle_mod.bind(key,mod_row.get_node('CheckButton')))
		container.add_child(mod_row)
		
func _toggle_mod(state,mod_id,button):
	if(state):
		if !ModLoaderUserProfile.enable_mod(mod_id):
			button.button_pressed = !state
			OS.alert("Activating the mod caused an error.", "Mod activation failed")
			
	else:
		if !ModLoaderUserProfile.disable_mod(mod_id):
			button.button_pressed = !state
			OS.alert("Deactivating the mod caused an error.", "Mod deactivation failed")
			
