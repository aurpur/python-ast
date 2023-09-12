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
		package: 'MoosePy';
		package: 'DL-Python'
		with: [ spec requires: #( 'PythonParser' 'FamixPythonImporter' ) ].
	spec group: 'default' with: #( 'DL-Python' 'MoosePy' )
]
