Class {
	#name : #BaselineOfDLPython,
	#superclass : #BaselineOf,
	#category : #BaselineOfDLPython
}

{ #category : #baselines }
BaselineOfDLPython >> baseline: spec [

	<baseline>
	spec
		package: 'DL-Python'.
	spec group: 'default' with: #( 'DL-Python')
]
