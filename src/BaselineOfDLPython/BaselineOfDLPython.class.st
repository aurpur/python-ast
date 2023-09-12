Class {
	#name : #BaselineOfDLPython,
	#superclass : #BaselineOf,
	#category : #BaselineOfDLPython
}

{ #category : #baselines }
BaselineOfDLPython >> baseline: spec [

	<baseline>
	spec
		package: 'DL-Python-Generators';
		package: 'DL-Python-Detectors';
		package: 'DL-Python-Tests';
		package: 'DL-Python-Importers';
		package: 'CNN-Famix-Entities'.
	spec
		group: 'default'
		with:
		#( 'DL-Python-Generators' 'DL-Python-Detectors'
		   'DL-Python-Tests' 'DL-Python-Importers' 'CNN-Famix-Entities' )
]
