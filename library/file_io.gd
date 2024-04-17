class_name FileIo


static func read_as_text(path_to_file: String) -> ParsedFile:
    var file: FileAccess = FileAccess.open(path_to_file, FileAccess.READ)
    var parsed: ParsedFile = ParsedFile.new()

    if FileAccess.get_open_error() == OK:
        parsed.parse_success = true
        parsed.output_text = file.get_as_text()
    else:
        parsed.parse_success = false
    return parsed


static func read_as_line(path_to_file: String) -> ParsedFile:
    var file: FileAccess = FileAccess.open(path_to_file, FileAccess.READ)
    var parsed: ParsedFile = ParsedFile.new()
    var row: int = 0

    if FileAccess.get_open_error() != OK:
        parsed.parse_success = false
        return parsed

    parsed.parse_success = true
    parsed.output_line = {}
    while file.get_position() < file.get_length():
        parsed.output_line[row] = file.get_line()
        row += 1
    return parsed


static func read_as_json(path_to_file: String) -> ParsedFile:
    var parsed: ParsedFile = read_as_text(path_to_file)
    var json: JSON = JSON.new()

    if parsed.parse_success and (json.parse(parsed.output_text) == OK):
        parsed.output_json = json.data
    else:
        parsed.parse_success = false
    return parsed


static func get_files(path_to_directory: String) -> Array:
    var dir: DirAccess = DirAccess.open(path_to_directory)
    var files: Array = []

    if dir:
        files = dir.get_files()
        ArrayHelper.map(files, FileIo._get_full_path, [path_to_directory])
    return files


static func _get_full_path(file_name: String, args: Array) -> String:
    var path: String = args[0]
    return path + file_name
