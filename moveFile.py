import sys
import shutil
import os
from os.path import join
import commands
import utils

"""
Este script mueve el archivo comprimido de un experimento
que llega a la capeta de llegada hacia la carpeta de experimentos,
luego descomprime el archivo
"""

def moveFile(filename):
	
	# del archivo de configuracion se 
	# obtiene la carpeta de llegada de experimentos
	# y la carpeta de experimentos
	config = utils.config();
	COMMING_EXPERIMENT_FOLDER = config["COMMING_EXPERIMENT_FOLDER"]
	EXPERIMENT_FOLDER = config["EXPERIMENT_FOLDER"]
	# rutas de origen y destino
	src = join(COMMING_EXPERIMENT_FOLDER,filename);
	dst = join(EXPERIMENT_FOLDER,filename);
	
	try:
		# se mueve el archivo
		shutil.move(src, dst)
		# se descomprime el archivo
		command = "tar -xzf " + dst + " -C " + EXPERIMENT_FOLDER;
		result = commands.getstatusoutput(command)
		if (result[0] != 0):
			return "Error al descomprimir" + str(result);
		# se elimina el archivo comprimido
		os.remove(dst);
	except Exception as e:
		return str(e)

	return None


if __name__ == "__main__":

	if(len(sys.argv)==0):
		raise ValueError('Falta un argumento')

	filename = sys.argv[1]
	result = moveFile(filename);
	if (result==None):
		print "Todo correcto"
	else:
		print result