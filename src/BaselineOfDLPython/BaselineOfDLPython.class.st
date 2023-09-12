Class {
	#name : #BaselineOfDLPython,
	#superclass : #BaselineOf,
	#category : #BaselineOfDLPython
}

{ #category : #baselines }
BaselineOfDLPython >> baseline: spec [

	<baseline>
	spec 
		package: 'MoosePy';
		package: 'DL-Python'
		with: [ spec requires: #( 'PythonParser' 'FamixPythonImporter' ) ].
	spec group: 'default' with: #( 'DL-Python' 'MoosePy' )
]
