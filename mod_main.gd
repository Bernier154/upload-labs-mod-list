extends Node

var mod_dir_path := ModLoaderMod.get_unpacked_dir().path_join('bernier154-mod_list')
var modlistTabIndex := -1

func _init() -> void:
	setup_modloader_profile()

func _ready() -> void:
	_wait_for_main_scene()
	
func setup_modloader_profile():
	var modloader_modlist_profile = ModLoaderUserProfile.get_profile('modlist')
	if modloader_modlist_profile == null:
		ModLoaderUserProfile.create_profile('modlist')
		modloader_modlist_profile = ModLoaderUserProfile.get_profile('modlist')
	if ModLoaderUserProfile.get_current().name != modloader_modlist_profile.name:
		ModLoaderUserProfile.set_profile(modloader_modlist_profile)
	
func _wait_for_main_scene():
	get_tree().root.child_entered_tree.connect(_child_entered_tree_watcher)

func _child_entered_tree_watcher(node: Node):
	if(node.name == 'Main'):
		_injectModlistScene(node)

func _injectModlistScene(node: Node):
	var ModlistPanel = load(mod_dir_path.path_join('scenes/mods.tscn')).instantiate()
	ModlistPanel.visible = false
	
	var ModListButton = load(mod_dir_path.path_join('scenes/button.tscn')).instantiate();
	ModListButton.pressed.connect(_on_modlist_button_pressed)
	
	modlistTabIndex = get_node('/root/Main/HUD/Main/MainContainer/Overlay/Menus').get_child_count()
	get_node('/root/Main/HUD/Main/MainContainer/Overlay/Menus').add_child(ModlistPanel)
	
	get_node('/root/Main/HUD/Main/MainContainer/Overlay/ExtrasButtons/Container').add_child(ModListButton, true)
	
	
func _on_modlist_button_pressed():
	get_node('/root/Main/HUD').set_menu(Utils.menu_types.SIDE,modlistTabIndex, true)
