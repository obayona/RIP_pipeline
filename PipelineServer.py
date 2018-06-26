import os
import socket
import pipeline
import utils


HOST = 'localhost'
PORT = 7777

def getExperiments():
	config = utils.config();
	COMMING_EXPERIMENT_FOLDER = config["COMMING_EXPERIMENT_FOLDER"]
	experiments = [exp for exp in os.listdir(COMMING_EXPERIMENT_FOLDER) 
                    if ("Experimento" in exp and ".tar.gz" in exp)]
	return experiments



def listen():
	connection = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	connection.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
	connection.bind((HOST, PORT))
	connection.listen(10)
	while True:
		current_connection, address = connection.accept()
		while True:
			data = current_connection.recv(2048)
			if not data:
				break;
			if data=="START_PIPELINE": 
				experiments = getExperiments();
				if(len(experiments)==0):
					current_connection.send("No hay experimentos");
				for e in experiments:
					result = pipeline.run(e)
					if result == None:
						current_connection.send("OK");
					else:
						current_connection.send(result);
				data = "0"	
            
if __name__ == "__main__":
	try:
		listen()
	except KeyboardInterrupt:
		pass