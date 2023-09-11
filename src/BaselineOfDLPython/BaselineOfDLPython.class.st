Class {
	#name : #BaselineOfDLPython,
	#superclass : #BaselineOf,
	#category : #BaselineOfDLPython
}

{ #category : #baselines }
BaselineOfDLPython >> baseline: spec [

	<baseline>
	spec baseline: 'PythonParser' with: [
		spec
			repository: 'github://j-brant/SmaCC';
			loads: #( 'SmaCC_Python' 'SmaCC_Python_Tests' ) ].

	spec
		baseline: 'FamixPythonImporter'
		with: [ spec repository: 'github://aurpur/famixPythonImporter' ].

	spec
		baseline: 'MoosePy'
		with: [ spec repository: 'github://moosetechnology/MoosePy' ].


	spec
		package: 'DLPython'
		with: [
		spec requires: #( 'MoosePy' 'PythonParser' 'FamixPythonImporter' ) ]
]
