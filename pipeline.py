import sys
import os
from os.path import join
import utils
from moveFile import moveFile
from saveDB import saveDB

def run(filename):
	# se mueve el archivo al directorio experimentos
	result = moveFile(filename);
	if(result != None):
		return result;

	# se obtiene la ruta del experimento
	config = utils.config();
	EXPERIMENT_FOLDER = config["EXPERIMENT_FOLDER"]
	folder_experiment = filename.replace(".tar.gz","");
	path_experiment = join(EXPERIMENT_FOLDER,folder_experiment)

	# se guarda el experimento en la base de datos
	result = saveDB(folder_experiment);
	if(result!=None):
		return result;

	# agregar los siguientes pasos del pipeline


	return None;

if __name__ == "__main__":

	if(len(sys.argv)==0):
		raise ValueError('Falta un argumento')

	filename = sys.argv[1]
	result = run(filename);
	if (result==None):
		print "Todo correcto"
	else:
		print result