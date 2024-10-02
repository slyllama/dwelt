extends Panel
# WebUpdates
# Get news and information from slyllama.net - mainly to learn how

const HTTP_PATH = "https://slyllama.net/dwelt.txt"

func _ready():
	$UpdateRequest.request_completed.connect(func(result, _response, _headers, body):
		if result > 0:
			$UpdateText.text = "Couldn't get news."
		else:
			var _get_text = body.get_string_from_utf8()
			$UpdateText.text = _get_text)
	$UpdateRequest.request(HTTP_PATH)
