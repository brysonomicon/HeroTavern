@tool
extends EditorScript

const spriteDirPath: String = "res://assets/sprites/"
const characterPartPath: String = "res://components/characterParts/"
const defaultSpriteKeyword: String = "default"
var fs: EditorFileSystem = EditorInterface.get_resource_filesystem()

# Called when the script is executed (using File -> Run in Script Editor).
func _run() -> void:
	iterate_folder(spriteDirPath)
	print("Done!")

func iterate_folder(folderPath: String) -> void:
	if folderPath.containsn("Base"):
	#	print("Ignoring base body directory")
		return
	
	var baseDir: DirAccess = DirAccess.open(folderPath)
	if DirAccess.get_open_error():
		print("Invalid directory: %s" % folderPath)
		return
	
	baseDir.list_dir_begin()
	var current: String = baseDir.get_next()
	while current != "":
		if baseDir.current_is_dir():
			var nextPath: String = baseDir.get_current_dir().path_join(current)
			iterate_folder(nextPath)
		elif current.get_extension() != "png":
			pass
		elif current == "characterBase.png":
			pass
		else:
			process_sprite(folderPath, current)
		current = baseDir.get_next()

func process_sprite(spriteFolder: String, spriteName: String) -> void:
	if spriteFolder.ends_with("default"):
		return
	
	var partPath: String = create_character_part_folder(spriteFolder)
	if partPath == "":
		return
	
	var partDir:DirAccess = DirAccess.open(partPath)
	if DirAccess.get_open_error():
		push_error("Cant get part path: %s" % partPath)
	
	var spriteNameClean: String = spriteName.to_camel_case()
	partDir.list_dir_begin()
	for file: String in partDir.get_files():
		# We don't want to re-make files.
		if spriteNameClean.get_basename() == file.get_basename():
			push_warning("Found part for ", file)
			return
	
	create_character_part(partDir.get_current_dir(), spriteFolder.path_join(spriteName))

func create_character_part_folder(spriteFolder: String) -> String:
	var partFolderName: String = spriteFolder.rsplit("/", true, 1)[1]

	# Check if we are making an item for the default sets.
	if spriteFolder.containsn(defaultSpriteKeyword):
		partFolderName = partFolderName.path_join(defaultSpriteKeyword)
	
	var newPartPath: String = characterPartPath.path_join(partFolderName)
	
	#Create the folder, if needed
	if not DirAccess.dir_exists_absolute(newPartPath):
		var error: Error = DirAccess.make_dir_recursive_absolute(newPartPath)
		if error == OK:
			push_warning("Creating ", newPartPath)
		else:
			push_error("Failed to create ", newPartPath)
			return ""
	
	return newPartPath

func create_character_part(partDir: String, spritePath: String) -> void:
	var image: Image = get_texture_from_sprite(spritePath)
	if image == null:
		return
	
	var newPart: CharacterPart = CharacterPart.factory(
		get_part_slot(partDir),
		spritePath.rsplit("/", false, 1)[1].get_basename().to_camel_case(),
		ImageTexture.create_from_image(image),
	)

	var partName: String = newPart.displayName + ".tres"
	var resourcePath: String = partDir.path_join(partName)
	var save_error: Error = ResourceSaver.save(newPart, resourcePath)
	if save_error != OK:
		push_error("Failed to save ", partName)
	else:
		print("Created new CharacterPart: ", resourcePath)
		EditorInterface.get_resource_filesystem().scan()

func get_part_slot(partDir: String) -> Character.Slot:
	var partDirChunks: PackedStringArray = partDir.rsplit("/", false, 2).slice(-2)
	for chunk:String in partDirChunks:
		var upper: String = chunk.to_upper()
		if Character.Slot.has(upper):
			var slot: Character.Slot = Character.Slot.get(upper)
			return slot
	push_warning("Could not find slot for ", partDir)
	# CB: I chose eyes because a character missing their eyes should be noticable.
	return Character.Slot.EYES

func get_texture_from_sprite(spritePath: String) -> Image:
	var file: FileAccess = FileAccess.open(spritePath, FileAccess.READ)
	if FileAccess.get_open_error() != OK:
		push_error("Failed to open %s" % spritePath)
		return null

	var image: Image = Image.new()
	var buffer: PackedByteArray = file.get_buffer(file.get_length())
	var error: Error = image.load_png_from_buffer(buffer)
	if error != OK:
		push_error("Failed to load %s from buffer!" % spritePath)
		return null
	return image