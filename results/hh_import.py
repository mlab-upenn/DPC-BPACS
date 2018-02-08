import csv, datetime

class hh_import:

	def __init__(self, name, source_path, tag_name):
		self.name = name
		self.path = source_path
		self.tag = tag_name

	def export(self, times, values):

		times = [time.strftime("%Y-%m-%d %H:%M:%S") for time in times]	

		with open(self.path + self.name + '.csv', 'w') as csvfile:
			field_names = ['Timestamp', 'Value']
			writer = csv.writer(csvfile, delimiter = ',')
			
			writer.writerow(['@DataPoint', self.tag])
			writer.writerow(field_names)
			
			for i in range(0, len(times)):
				if i > len(values)-1:
					break
				writer.writerow([times[i], values[i]])


if __name__ == "__main__":
	name = "Hotel"
	path = 'C:\Users\Expresso Logic\Documents\GitHub\DPC-IAX-Iconics\HHImport\Source\\'
	tag_name = 	"ua:HyperHistorian\\\\Configuration/EnergyPlus/LMP"
	importer = hh_import(name, path, tag_name)
	start = datetime.datetime(2018, 2, 7, 16, 0, 0)
	value = 100
	importer.export([start], [value])
