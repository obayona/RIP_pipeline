import json


def config():
	with open('config.json') as f:
		data = json.load(f)
		return data