@tool
class_name SkillLibrary
extends Resource

@export var display_name: String
@export var skills: Array[Skill]

@export_dir var source_folder: String

@export_tool_button("Get Skills") var call_get_skills: Callable = get_skills

func get_skills() -> void:
	skills.clear()
	
	if source_folder.is_empty():
		push_warning("SkillLibrary '%s' has no source folder set" % display_name)
		return
	
	var dir: DirAccess = DirAccess.open(source_folder)
	if dir == null:
		push_error("Could not open folder: %s" % source_folder)
		return
	
	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.get_extension() == "tres":
			var resource: Resource = load(source_folder.path_join(file_name))
			var skill: Skill = resource as Skill
			if skill != null:
				skills.append(skill)
			else:
				push_warning("Non-skill resource in the skill directory ya bozo: %s" % file_name)
		file_name = dir.get_next()
		
	skills.sort_custom(func(a: Skill, b: Skill) -> bool:
		return a.display_name < b.display_name)
		
	emit_changed()
	notify_property_list_changed()
	print("Found %d skills in %s" % [skills.size(), source_folder])
