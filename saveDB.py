import time 
from datetime import datetime
import MySQLdb
import sys
from os.path import join
import utils

"""
Este script registra el experimento en la base de datos
"""

def parseMetaDataFile(path):
	for line in open(path,"r") :
		l = line.rstrip('\n')
		if(len(l)>1):     
			array.append( l.split(':')[1])
	return array;

def _saveDB(idPlanta, idHoja, fechaHora, ruta):
	try:
		IP_DB = config["IP_DB"];
		USER_DB = config["USER_DB"];
		PASSWORD_DB = config["PASSWORD_DB"]
		NAME_DB = config["NAME_DB"]

		db = MySQLdb.connect(IP_DB, USER_DB, PASSWORD_DB, NAME_DB)
		db.autocommit(False);
		cursor = db.cursor();

		cursor.callproc("insertarPlanta",(idPlanta,))
		cursor.callproc("insertarHoja", (idPlanta,idHoja))
		cursor.callproc("insertarExperimento", (idPlanta,idHoja, fechaHora, ruta))
		db.commit();
		return None;
	except MySQLdb.Error, e:
		db.rollback();
		return str(e);

def saveDB(folder_experiment):
	# se obtiene la ruta del archivo de metadatos
	# del experimento
	config = utils.config();
	EXPERIMENT_FOLDER = config["EXPERIMENT_FOLDER"];
	metadata_file_path = join(EXPERIMENT_FOLDER,folder_experiment,"Data_Experimento.txt")
	try:
		params = parseMetaDataFile(metadata_file_path);
		# se obtienen los metadatos
		idPlanta = int(array[0]);
		idHoja = int(array[1]);
		tmp = array[2].strip()
		fechaHora = datetime.strptime(tmp, "%Y-%m-%d %H-%M-%S")
		ruta = array[3]

		#se guarda en la base de datos
		result = _saveDB(idPlanta, idHoja, fechaHora, ruta);
		return result

	except Exception as e:
		return str(e);

if __name__ == "__main__":

	if(len(sys.argv)==0):
		raise ValueError('Falta un argumento')

	folder_experiment = sys.argv[1]
	saveDB(folder_experiment);