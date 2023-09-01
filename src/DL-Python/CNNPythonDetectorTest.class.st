Class {
	#name : #CNNPythonDetectorTest,
	#superclass : #TestCase,
	#instVars : [
		'model',
		'detector'
	],
	#category : #'DL-Python-Tests'
}

{ #category : #accessing }
CNNPythonDetectorTest >> detector [

	^ detector
]

{ #category : #running }
CNNPythonDetectorTest >> setUp [


	detector := CNNPythonDetector new
]

{ #category : #tests }
CNNPythonDetectorTest >> testAllBiasWithBatchNormalization [

	| candidateName batchNorms |
	model := detector parseThenModelingFromString: '
model.add(Conv2D(32, (5, 5), input_shape=input_shape, padding=''same'', use_bias=''false''))
model.add(BatchNormalization())
model.add(Activation(''relu''))

model.add(Conv2D(32, (3, 3)))
model.add(BatchNormalization())
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.2))

model.add(Conv2D(64, (3, 3), padding=''same''))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.2))
'.

	batchNorms := detector allBiasWithBatchNormalization: model.
	self assert: batchNorms anyOne class equals: FamixPythonInvocation.

	self assert: batchNorms size equals: 1.

	candidateName := batchNorms first
		                 cacheAt: 'canditate'
		                 ifAbsent: [ nil ].
	self assert: candidateName equals: 'BatchNormalization'
]

{ #category : #tests }
CNNPythonDetectorTest >> testAllInvocationsWithNonDominatingDownSampling [

	model := detector parseThenModelingFromString: '
conv9 = Convolution2D(nb_classes, 1, padding=''valid'')
relu9 = Activation(''relu'')

gap = AveragePooling2D(pool_size=(7,7)) #<-- Design Smell
flt = Flatten()
sftm = Activation(''softmax'')
'.

	self
		assert:
			(detector allInvocationsWithNonDominatingDownSampling: model) anyOne
				class
		equals: FamixPythonInvocation
]

{ #category : #tests }
CNNPythonDetectorTest >> testAllNonRepresentativeStatisticsEstimation [

	| candidateName dropouts |
	model := detector parseThenModelingFromString: '
model.add(Conv2D(32, (5, 5)))
model.add(Dropout(0.2))
model.add(Activation(''relu''))
model.add(BatchNormalization())

model.add(Conv2D(32, (3, 3)))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.2))
model.add(BatchNormalization())
model.add(Activation(''relu''))

'.

	dropouts := detector allNonRepresentativeStatisticsEstimation: model.
	self assert: dropouts anyOne class equals: FamixPythonInvocation.

	self assert: dropouts size equals: 2.

	candidateName := dropouts first
		                 cacheAt: 'canditate'
		                 ifAbsent: [ nil ].
	self assert: candidateName equals: 'Dropout'
]

{ #category : #tests }
CNNPythonDetectorTest >> testAllUselessDropout [

	| dropouts candidateName |
	model := detector parseThenModelingFromString: '
model.add(Conv2D(256, (3, 3), input_shape=X.shape[1:], padding=''same''))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))
model.add(Dropout(0.2))

model.add(Conv2D(222, (3, 3), padding=''same''))
model.add(Dropout(0.2))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))

model.add(Conv2D(256, (3, 3), padding=''same''))
model.add(Dropout(0.25))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))

model.add(Conv2D(256, (3, 3), padding=''same''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))
'.

	dropouts := (detector allUselessDropout: model).
	self assert: dropouts first class equals: FamixPythonInvocation.
		self assert: dropouts size equals: 2.

	candidateName := dropouts first cacheAt: 'canditate' ifAbsent: [ nil ].
	self assert: candidateName equals: 'Dropout'
]

{ #category : #tests }
CNNPythonDetectorTest >> testConvolutionsWithLargekernel [

	| lKernelInvocations |
	model := detector parseThenModelingFromString: '
model.add(Conv2D(32, (5, 5)))
model.add(Activation(''relu''))

model.add(Conv2D(32, (3, 3)))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2)))

model.add(Conv2D(32, (3, 3)))
model.add(MaxPooling2D(pool_size=(2, 2)))

model.add(Conv2D(32, (3, 3)))
model.add(MaxPooling2D(pool_size=(2, 2)))
'.

	lKernelInvocations := detector convolutionsWithLargekernel: model.
	self
		assert: lKernelInvocations anyOne class
		equals: FamixPythonInvocation.

	self assert: lKernelInvocations size equals: 1
]

{ #category : #tests }
CNNPythonDetectorTest >> testHasBiasWithBatchNormalization [

	model := detector parseThenModelingFromString: '
model.add(Conv2D(32, (5, 5), input_shape=input_shape, padding=''same'', use_bias=''false''))
model.add(BatchNormalization())
model.add(Activation(''relu''))

model.add(Conv2D(32, (3, 3)))
model.add(BatchNormalization())
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.2))

model.add(Conv2D(64, (3, 3), padding=''same''))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.2))
'.

	self assert: (detector hasBiasWithBatchNormalization:  model) equals: true
]

{ #category : #tests }
CNNPythonDetectorTest >> testHasHeterogeneousBlocks [

	model := detector parseThenModelingFromString: '
model.add(Conv2D(32, (5, 5)))
model.add(Activation(''relu''))

model.add(Conv2D(32, (3, 3)))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2)))

model.add(Conv2D(32, (3, 3)))
model.add(MaxPooling2D(pool_size=(2, 2)))

model.add(Conv2D(32, (3, 3)))
model.add(MaxPooling2D(pool_size=(2, 2)))

'.

	self assert: (detector hasHeterogeneousBlocks: model) equals: true
]

{ #category : #tests }
CNNPythonDetectorTest >> testHasLosingLocalCorrelation [

	model := detector parseThenModelingFromString: '
model.add(Conv2D(256, (7, 7), input_shape=X.shape[1:], padding=''same''))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))
model.add(Dropout(0.2))

model.add(Conv2D(222, (3, 3), padding=''same''))
model.add(Dropout(0.2))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))

model.add(Conv2D(256, (3, 3), padding=''same''))
model.add(Dropout(0.25))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))

model.add(Conv2D(256, (3, 3), padding=''same''))
'.

	self assert: (detector hasLosingLocalCorrelation: model) equals: true
]

{ #category : #tests }
CNNPythonDetectorTest >> testHasNoNexpandingFeatureMap [

	model := detector parseThenModelingFromString: '
model.add(Conv2D(256, (3, 3), input_shape=X.shape[1:], padding=''same''))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))
model.add(Dropout(0.2))

model.add(Conv2D(222, (3, 3), padding=''same''))
model.add(Dropout(0.2))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))

model.add(Conv2D(256, (3, 3), padding=''same''))
model.add(Dropout(0.25))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))

model.add(Conv2D(256, (3, 3), padding=''same''))
'.

	self assert: (detector hasNoNexpandingFeatureMap: model) equals: true
]

{ #category : #tests }
CNNPythonDetectorTest >> testHasNonDominatingDownSampling [

	model := detector parseThenModelingFromString: '
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

{ #category : #tests }
CNNPythonDetectorTest >> testHasNonRepresentativeStatisticsEstimation [


	model := detector parseThenModelingFromString: '
model.add(Conv2D(32, (5, 5)))
model.add(Dropout(0.2))
model.add(Activation(''relu''))
model.add(BatchNormalization())

model.add(Conv2D(32, (3, 3)))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.2))
model.add(BatchNormalization())
model.add(Activation(''relu''))

'.

	self
		assert: (detector hasNonRepresentativeStatisticsEstimation:  model)
		equals: true
]

{ #category : #tests }
CNNPythonDetectorTest >> testHasTooMuchDownSampling [

	model := detector parseThenModelingFromString: '
model.add(Conv2D(256, (3, 3), input_shape=X.shape[1:], padding=''same''))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))
model.add(Dropout(0.2))

model.add(Conv2D(222, (3, 3), padding=''same''))
model.add(Dropout(0.2))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))

model.add(Conv2D(256, (3, 3), padding=''same''))
model.add(Dropout(0.25))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))

model.add(Conv2D(256, (3, 3), padding=''same''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))

'.

	self assert: (detector hasTooMuchDownSampling: model) equals: true
]

{ #category : #tests }
CNNPythonDetectorTest >> testHasUselessDropout [

	model := detector parseThenModelingFromString: '
model.add(Conv2D(256, (3, 3), input_shape=X.shape[1:], padding=''same''))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))
model.add(Dropout(0.2))

model.add(Conv2D(222, (3, 3), padding=''same''))
model.add(Dropout(0.2))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))

model.add(Conv2D(256, (3, 3), padding=''same''))
model.add(Dropout(0.25))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))

model.add(Conv2D(256, (3, 3), padding=''same''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))
'.

	self assert: (detector hasUselessDropout: model) equals: true
]

{ #category : #tests }
CNNPythonDetectorTest >> testHomogeneousBlocks [

	| hBlocks |
	model := detector parseThenModelingFromString: '
model.add(Conv2D(32, (5, 5)))
model.add(Activation(''relu''))

model.add(Conv2D(32, (3, 3)))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2)))

model.add(Conv2D(32, (3, 3)))
model.add(MaxPooling2D(pool_size=(2, 2)))

model.add(Conv2D(32, (3, 3)))
model.add(MaxPooling2D(pool_size=(2, 2)))

'.

	hBlocks := detector homogeneousBlocks: model.
	self assert: hBlocks anyOne class equals: FamixPythonInvocation.

	self assert: hBlocks size equals: 3
]

{ #category : #tests }
CNNPythonDetectorTest >> testParseThenModelingFromFile [

	model := detector parseThenModelingFromFile:
		   '/Users/aurelikama/Documents/Projet/These/parserPythonToJson/sample_design_smell/layers_formation/gh_non_dominating_dow_sampling.py'.

	self
		assert: (detector hasBiasWithBatchNormalization: model)
		equals: true
]
