Class {
	#name : #CNNPythonConvolution,
	#superclass : #Object,
	#instVars : [
		'homogenous'
	],
	#category : #'DL-Python-Detectors'
}

{ #category : #accessing }
CNNPythonConvolution >> addHomogeneous: anObject [

	homogenous add: anObject 
]

{ #category : #accessing }
CNNPythonConvolution >> homogenous [

	^ homogenous
]

{ #category : #accessing }
CNNPythonConvolution >> homogenous: anObject [

	homogenous := anObject
]

{ #category : #testing }
CNNPythonConvolution >> initialize [

	super initialize.

	homogenous := OrderedCollection new
]

{ #category : #testing }
CNNPythonConvolution >> isHomogeneous [
	^homogenous isNotNil
]
