Class {
	#name : #CNNPythonLayer,
	#superclass : #Object,
	#instVars : [
		'convolution',
		'invocations'
	],
	#category : #'DL-Python-Detectors'
}

{ #category : #accessing }
CNNPythonLayer >> addInvocation: anObject [

	invocations add: anObject
]

{ #category : #accessing }
CNNPythonLayer >> convolution [

	^ convolution
]

{ #category : #accessing }
CNNPythonLayer >> convolution: anObject [

	convolution := anObject
]

{ #category : #testing }
CNNPythonLayer >> hasDownSampling [
	^invocations anySatisfy: [ :invocation |
		self isPooling: invocation
	]
]

{ #category : #testing }
CNNPythonLayer >> hasUselessDropout [

]

{ #category : #initialization }
CNNPythonLayer >> initialize [
	super initialize.

	invocations := OrderedCollection new
]

{ #category : #accessing }
CNNPythonLayer >> invocations [

	^ invocations
]

{ #category : #accessing }
CNNPythonLayer >> invocations: anObject [

	invocations := anObject
]

{ #category : #testing }
CNNPythonLayer >> isHomogeneousTo: aLayer [
]

{ #category : #testing }
CNNPythonLayer >> isPooling: invocation [
	^'*pooling*' match: (self getInvocationCandidateName: invocation)
]
