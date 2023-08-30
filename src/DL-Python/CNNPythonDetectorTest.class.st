Class {
	#name : #CNNPythonDetectorTest,
	#superclass : #TestCase,
	#instVars : [
		'model',
		'detector'
	],
	#category : #'DL-Python-Tests'
}

{ #category : #running }
CNNPythonDetectorTest >> setUp [


	detector := CNNPythonDetector new
]

{ #category : #running }
CNNPythonDetectorTest >> testHasNonDominatingDownSampling [

	model := detector accept: '
conv9 = Convolution2D(nb_classes, 1, padding=''valid'')
relu9 = Activation(''relu'')

gap = AveragePooling2D(pool_size=(7,7)) #<-- Design Smell
flt = Flatten()
sftm = Activation(''softmax'')
'.


	self
		assert: (detector hasNonDominatingDownSampling: model)
		equals: true
]

{ #category : #running }
CNNPythonDetectorTest >> testNonDominatingDownSampling [

	model := detector accept: '
conv9 = Convolution2D(nb_classes, 1, padding=''valid'')
relu9 = Activation(''relu'')

gap = AveragePooling2D(pool_size=(7,7)) #<-- Design Smell
flt = Flatten()
sftm = Activation(''softmax'')
'.

	self
		assert:
		(detector invocationsWithNonDominatingDownSampling: model) first
			class
		equals: FamixPythonInvocation
]
