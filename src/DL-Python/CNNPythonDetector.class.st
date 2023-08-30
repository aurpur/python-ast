Class {
	#name : #CNNPythonDetector,
	#superclass : #Object,
	#instVars : [
		'visitor'
	],
	#category : #'DL-Python-Detectors'
}

{ #category : #initialization }
CNNPythonDetector >> accept: aSource [

	visitor accept: (PythonParser parseWithErrors: aSource).

	^ visitor model
]

{ #category : #initialization }
CNNPythonDetector >> allInvocation: aModel [

	^ (aModel allWithType: FamixPythonInvocation )asOrderedCollection
]

{ #category : #initialization }
CNNPythonDetector >> downSamplings: aModel [

	| candidateName  |
	^((self allInvocation: aModel) collect: [ :invocation |
		           candidateName := self getInvocationCandidateName:
			                            invocation.
		           ('*pooling*' match: candidateName) ifTrue: [ invocation ] ] )reject: [ :a | a isNil ].


]

{ #category : #initialization }
CNNPythonDetector >> getInvocationCandidateName: invocation [

			  ^ invocation cacheAt: 'canditate' ifAbsent: [ nil ]
		
]

{ #category : #initialization }
CNNPythonDetector >> hasNonDominatingDownSampling: aModel [

	^ (self invocationsWithNonDominatingDownSampling: aModel) isNotEmpty
]

{ #category : #initialization }
CNNPythonDetector >> initialize [

	super initialize.
	visitor := MSEPythonToFamixImporterVisitor new.
]

{ #category : #initialization }
CNNPythonDetector >> invocationsWithNonDominatingDownSampling: aModel [

	^ (self downSamplings: aModel) collect: [ :downSampling |
		  ('*average*' match:
			   (self getInvocationCandidateName: downSampling)) ifTrue: [
			  downSampling ] ]
]

{ #category : #initialization }
CNNPythonDetector >> parseFile: aPath [
	"Example of path : '/Users/aurelikama/Documents/Projet/These/parserPythonToJson/sample_design_smell/layers_formation/gh_non_dominating_dow_sampling.py'
		          asFileReference contents."



	^ self accept: aPath
]
