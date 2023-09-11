Class {
	#name : #BaselineOfDLPython,
	#superclass : #BaselineOf,
	#category : #BaselineOfDLPython
}

{ #category : #baselines }
BaselineOfDLPython >> baseline: spec [

	<baseline>
	spec
		group: 'default'
		with:
		#( 'DL-Python-Generators' 'DL-Python-Detectors'
		   'DL-Python-Tests' 'CNN-Famix-Entities' )
]
