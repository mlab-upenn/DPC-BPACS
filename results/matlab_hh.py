import hh_import
import csv
import datetime

def import_file(file, tag):
	data = []
	with open(file, 'r') as csvfile:
		reader = csv.reader(csvfile)
		for row in reader:
			data = data + row;

	name = file
	path = 'C:\Users\Expresso Logic\Documents\GitHub\DPC-IAX-Iconics\HHImport\Source\\'
	tag_name = 	"ua:HyperHistorian\\\\Configuration/EnergyPlus/" + tag


	importer = hh_import.hh_import(name, path, tag_name)
	# Power tracking begins on 2018 Feb 1
	start = datetime.datetime(2018, 2, 10, 0, 0, 0)
	
	#DR begins on 2018 Jan 4
	#start = datetime.datetime(2018, 1, 4, 0, 0, 0)

	time_range = [start + datetime.timedelta(minutes = 15*i) for i in range(0, len(data))]

	importer.export(time_range, data)

import_file("baseline", "BaselinePower")
import_file("actual", "ActualPower")
import_file("lconf", "LowConfidence")
import_file("uconf", "UpperConfidence")
import_file("sa", "SupplyAirSP")
import_file("cw", "ChilledWaterSP")
import_file("clg", "CoolingSP")
import_file("tempmid", "TempMid")
import_file("uppertemp", "UpperTemp")
import_file("lowertemp", "LowerTemp")