Class {
	#name : #BaselineOfDLPython,
	#superclass : #BaselineOf,
	#category : #BaselineOfDLPython
}

{ #category : #baselines }
BaselineOfDLPython >> baseline: spec [

	<baseline>
	spec
		package: 'DL-Python';
		package: 'CNN-Famix-Entities'.
	spec group: 'default' with: #( 'DL-Python' 'CNN-Famix-Entities' )
]
