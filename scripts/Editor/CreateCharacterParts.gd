@tool
extends EditorScript

const spriteDirPath: String = "res://assets/sprites/"
const characterPartPath: String = "res://assets/characterParts/"
const defaultSpriteKeyword: String = "default"
var fs: EditorFileSystem = EditorInterface.get_resource_filesystem()

# Called when the script is executed (using File -> Run in Script Editor).
func _run() -> void:
	iterate_folder(spriteDirPath)
	print("Done!")

func iterate_folder(folderPath: String) -> void:
	if folderPath.containsn("Base"):
		print("Ignoring base body directory")
		return
	
	var baseDir: DirAccess = DirAccess.open(folderPath)
	if DirAccess.get_open_error():
		print("Invalid directory: %s" % folderPath)
		return
	
	baseDir.list_dir_begin()
	var current: String = baseDir.get_next()
	while current != "":
		if current == "default":
			continue
		elif baseDir.current_is_dir():
			var nextPath: String = baseDir.get_current_dir().path_join(current)
			print("Next Folder: %s" % nextPath)
			iterate_folder(nextPath)
		else:
			process_sprite(folderPath, current)
			print("File: %s/%s" % [folderPath, current])
		current = baseDir.get_next()

func process_sprite(folderPath: String, fileName: String) -> void:
	if fileName == "icon.svg" or fileName.ends_with(".import"):
		print("Ignoring imports and default icon.")
		return
	var spriteDir: DirAccess = DirAccess.open(folderPath)
	if DirAccess.get_open_error():
		print("Invalid directory: %s" % spriteDir)
		return
	
	var partFolderName: String = folderPath.rsplit("/", true, 1)[1]
	if folderPath.containsn(defaultSpriteKeyword):
		partFolderName = partFolderName.path_join(defaultSpriteKeyword)
		
#	var newPart: CharacterPart = CharacterPart.new()
#	newPart.displayName = fileName
	var partDir:DirAccess = DirAccess.open(partFolderName)
	if DirAccess.get_open_error():
		print("Cant get subdir: %s" % partFolderName)
		return
	partDir.list_dir_begin()
	for file: String in partDir.get_files():
		print(file)
#	print("New folder name: %s" % [characterPartPath.path_join(partFolderName)])