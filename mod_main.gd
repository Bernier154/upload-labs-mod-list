extends Node

const MOD_DIR := "bernier154-mod_list"
const LOG_NAME := "bernier154-mod_list:Main" # Full ID of the mod (AuthorName-ModName)

const screenIndex := 3

var ModListScene : PackedScene
var ModlistScreenScene : PackedScene
var ModListButton : Node
var Main2DContainer : Node
var MainContainer : Node
var ModlistScreen : Node

var mod_dir_path := ""
var translations_dir_path := ""

func _init() -> void:
	mod_dir_path = ModLoaderMod.get_unpacked_dir().path_join(MOD_DIR)
	ModListScene = load(mod_dir_path.path_join('scenes/ModList.tscn'))
	ModlistScreenScene = load(mod_dir_path.path_join('scenes/ModlistScreen.tscn'))

func _ready() -> void:
	ModLoaderLog.info("Ready", LOG_NAME)
	get_tree().root.child_entered_tree.connect(child_entered_tree)

func child_entered_tree(node: Node):
	print(node.name)
	if(node.name == 'Main'):
		ModLoaderLog.info("Found Main scene, injecting modlist menu", LOG_NAME)
		inject(node)
	

func inject(node: Node):
	Main2DContainer = node.get_node('Main2D');
	MainContainer = node.get_node('HUD/Main/MainContainer/Overlay/ScreenButtons/Container')
	
	ModlistScreen = ModlistScreenScene.instantiate()
	ModListButton = ModListScene.instantiate();
	
	_injectScreenData(Main2DContainer)
	
	ModlistScreen.visible = false
	
	MainContainer.add_child(ModListButton, true)
	Main2DContainer.add_child(ModlistScreen)
	
	Signals.set_screen.connect(_set_screen_handler)
	ModListButton.pressed.connect(_on_modlist_pressed)

	
func _set_screen_handler(screenNum,cameraCallback):
	if screenNum != screenIndex :
		ModListButton.button_pressed = false
	ModlistScreen.visible = screenNum == screenIndex

func _injectScreenData(main2D: Node):
	main2D.screen_position.append( Vector2(0, 0))
	main2D.screen_zoom.append(Vector2(1, 1))
	main2D.screen_size.append(1000)
	main2D.screen_min_zoom.append( Vector2(0.5, 0.5))

func _on_modlist_pressed() -> void :
	if Globals.cur_screen != screenIndex:
		Signals.set_screen.emit(screenIndex, Globals.camera_center)
		MainContainer.get_node('Research').button_pressed = false
		MainContainer.get_node('Desktop').button_pressed = false
	MainContainer.get_node('ModList').button_pressed = true
	
	Sound.play("click_toggle")
