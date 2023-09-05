Class {
	#name : #CNNPythonDetector,
	#superclass : #Object,
	#instVars : [
		'visitor',
		'allLayers'
	],
	#category : #'DL-Python-Detectors'
}

{ #category : #inspecting }
CNNPythonDetector >> allBiasWithBatchNormalization: aModel [

	| invocations layer candidateName buff position results convs convLayer convPosition batchNorms batchNormLayer batchNormPosition bias convUseBias |
	invocations := self invocations: aModel.
	convs := OrderedCollection new.
	batchNorms := OrderedCollection new.
	position := 1.
	results := OrderedCollection new.


	invocations do: [ :invocation |
		layer := self getInvocationLayer: invocation.
		candidateName := self getInvocationCandidateName: invocation.
		buff := Dictionary new.


		buff at: 'candidat' put: candidateName.
		buff at: 'layer' put: layer.
		buff at: 'position' put: position.
		buff at: 'invocation' put: invocation.

		('*conv*' match: candidateName) ifTrue: [
			bias := self getInvocationArgumentUseBias: invocation.

			buff at: 'use_bias' put: bias.
			convs add: buff ].

		('*batchnorm*' match: candidateName) ifTrue: [
			batchNorms add: buff ].

		position := position + 1 ].


	convs do: [ :conv |
		convLayer := conv at: 'layer'.
		convPosition := conv at: 'position'.
		convUseBias := conv at: 'use_bias'.

		batchNorms do: [ :batchNorm |
			batchNormLayer := batchNorm at: 'layer'.
			batchNormPosition := batchNorm at: 'position'.

			batchNormLayer = convLayer & (convPosition < batchNormPosition)
			& (convUseBias = true) ifTrue: [
				results add: (batchNorm at: 'invocation') ] ] ].

	^ results
]

{ #category : #inspecting }
CNNPythonDetector >> allInvocationsWithNonDominatingDownSampling: aModel [

	^ (self downSamplings: aModel) collect: [ :downSampling |
		  ('*average*' match:
			   (self getInvocationCandidateName: downSampling)) ifTrue: [
			  downSampling ] ]
]

{ #category : #inspecting }
CNNPythonDetector >> allNonRepresentativeStatisticsEstimation: aModel [

	| invocations layer poolings dropouts candidateName buff position results poolingLayer poolingPosition dropoutLayer dropoutPosition |
	invocations := self invocations: aModel.
	poolings := OrderedCollection new.
	dropouts := OrderedCollection new.
	position := 1.
	results := OrderedCollection new.


	invocations do: [ :invocation |
		layer := self getInvocationLayer: invocation.
		candidateName := self getInvocationCandidateName: invocation.
		buff := Dictionary new.


		buff at: 'candidat' put: candidateName.
		buff at: 'layer' put: layer.
		buff at: 'position' put: position.
		buff at: 'invocation' put: invocation.

		('*batchnorm*' match: candidateName) ifTrue: [ poolings add: buff ].

		('*dropout*' match: candidateName) ifTrue: [ dropouts add: buff ].
		position := position + 1 ].


	poolings do: [ :pooling |
		poolingLayer := pooling at: 'layer'.
		poolingPosition := pooling at: 'position'.

		dropouts do: [ :dropout |
			dropoutLayer := dropout at: 'layer'.
			dropoutPosition := dropout at: 'position'.

			dropoutLayer = poolingLayer & (dropoutPosition < poolingPosition)
				ifTrue: [ results add: (dropout at: 'invocation') ] ] ].

	^ results
]

{ #category : #inspecting }
CNNPythonDetector >> allUselessDropout: aModel [

	| invocations layer poolings dropouts candidateName buff position results poolingLayer poolingPosition dropoutLayer dropoutPosition |
	invocations := self invocations: aModel.
	poolings := OrderedCollection new.
	dropouts := OrderedCollection new.
	position := 1.
	results := OrderedCollection new.


	invocations do: [ :invocation |
		layer := self getInvocationLayer: invocation.
		candidateName := self getInvocationCandidateName: invocation.
		buff := Dictionary new.


		buff at: 'candidat' put: candidateName.
		buff at: 'layer' put: layer.
		buff at: 'position' put: position.
		buff at: 'invocation' put: invocation.

		('*pooling*' match: candidateName) ifTrue: [ poolings add: buff ].

		('*dropout*' match: candidateName) ifTrue: [ dropouts add: buff ].
		position := position + 1 ].


	poolings do: [ :pooling |
		poolingLayer := pooling at: 'layer'.
		poolingPosition := pooling at: 'position'.

		dropouts do: [ :dropout |
			dropoutLayer := dropout at: 'layer'.
			dropoutPosition := dropout at: 'position'.

			dropoutLayer = poolingLayer & (dropoutPosition < poolingPosition)
				ifTrue: [ results add: (dropout at: 'invocation') ] ] ].

	^ results.

]

{ #category : #'private - accessing' }
CNNPythonDetector >> convolutions: aModel [

	| candidateName |
	^ ((self invocations: aModel) collect: [ :invocation |
		   candidateName := self getInvocationCandidateName: invocation.
		   ('*conv*' match: candidateName) ifTrue: [ invocation ] ])
		  reject: [ :a | a isNil ]
]

{ #category : #'private - accessing' }
CNNPythonDetector >> convolutionsWithLargekernel: aModel [

	| convolutions results convArgs |
	convolutions := self convolutions: aModel.
	results := OrderedCollection new.

	convolutions size > 1 ifTrue: [
		convolutions do: [ :convolution |
			convArgs := self getInvocationArguments: convolution.

			(convArgs second at: 'value') isString
				ifTrue: [
					(convArgs second at: 'value') asInteger > 3 ifTrue: [
						results add: convolution ] ]
				ifFalse: [
					(convArgs second at: 'value') first asInteger > 3 ifTrue: [
						results add: convolution ] ] ] ].
	^ results
]

{ #category : #'private - accessing' }
CNNPythonDetector >> downSamplings: aModel [

	| candidateName  |
	^((self invocations: aModel) collect: [ :invocation |
		           candidateName := self getInvocationCandidateName:
			                            invocation.
		           ('*pooling*' match: candidateName) ifTrue: [ invocation ] ] )reject: [ :a | a isNil ].


]

{ #category : #nicolas }
CNNPythonDetector >> findLayersFromInvocations: invocationCollection [

	| currentLayer |
	currentLayer := nil.

	invocationCollection do: [ :invoc |
		(self isConvolution: invoc)
			ifTrue: [
				currentLayer := CNNPythonLayer new
					                convolution: invoc;
					                yourself.
				allLayers add: currentLayer ]
			ifFalse: [ currentLayer ifNotNil: [ currentLayer add: invoc ] ] ].

	^ allLayers
]

{ #category : #nicolas }
CNNPythonDetector >> findLayersIn: aModel [
	^self findLayersFromInvocations: ((self invocations: aModel) sorted: [ :a :b |
		a sourceAnchor startPos < b sourceAnchor startPos
	])

]

{ #category : #'private - accessing' }
CNNPythonDetector >> getInvocationArgumentUseBias: invocation [

	| args res |
	args := invocation cacheAt: 'args' ifAbsent: [ nil ].
	res := true.

	args do: [ :arg |
		(arg at: 'label' ifAbsent: [ '' ]) = 'use_bias' ifTrue: [
			(arg at: 'value') asLowercase = 'true' ifFalse: [ res := false ] ] ].
	^ res
]

{ #category : #'private - accessing' }
CNNPythonDetector >> getInvocationArguments: invocation [

	^ invocation cacheAt: 'args' ifAbsent: [ nil ]
]

{ #category : #'private - accessing' }
CNNPythonDetector >> getInvocationCandidateName: invocation [

			  ^ invocation cacheAt: 'canditate' ifAbsent: [ nil ]
		
]

{ #category : #'private - accessing' }
CNNPythonDetector >> getInvocationLayer: invocation [

	^ invocation cacheAt: 'layer' ifAbsent: [ nil ]
]

{ #category : #inspecting }
CNNPythonDetector >> hasBiasWithBatchNormalization: aModel [

	^(self allBiasWithBatchNormalization: aModel) isNotEmpty
]

{ #category : #inspecting }
CNNPythonDetector >> hasHeterogeneousBlocks: aModel [

	^ (self homogeneousBlocks: aModel) size < 2
	  | (self convolutionsWithLargekernel: aModel) isNotEmpty.

]

{ #category : #inspecting }
CNNPythonDetector >> hasLosingLocalCorrelation: aModel [

	| convs localWindowSize |
	convs := self convolutions: aModel.

	localWindowSize := convs collect: [ :each |
		                   (self getInvocationArguments: each) second
			                   isString
			                   ifTrue: [
				                   ((self getInvocationArguments: each) second
					                    at: 'value')  asInteger ]
			                   ifFalse: [
			                   ((self getInvocationArguments: each) second at:
				                    'value') first asInteger ] ].

	^ (self isAscending: localWindowSize) not
	  | (self isSame: localWindowSize) not
]

{ #category : #inspecting }
CNNPythonDetector >> hasNoNexpandingFeatureMap: aModel [

	| convs nbFeaturesMap |
	convs := self convolutions: aModel.

	nbFeaturesMap := convs collect: [ :each |
		                 ((self getInvocationArguments: each) first at:
			                  'value') asInteger ].

	^ (self isAscending: nbFeaturesMap) not
]

{ #category : #inspecting }
CNNPythonDetector >> hasNonDominatingDownSampling: aModel [

	^ (self allInvocationsWithNonDominatingDownSampling: aModel) isNotEmpty
]

{ #category : #inspecting }
CNNPythonDetector >> hasNonRepresentativeStatisticsEstimation: aModel [

	^(self allNonRepresentativeStatisticsEstimation: aModel ) isNotEmpty
]

{ #category : #inspecting }
CNNPythonDetector >> hasTooMuchDownSampling: aModel [

	| layersNumber downSamplingNumber |
	layersNumber := allLayers size.
	downSamplingNumber := allLayers count: #hasDownSampling.

	^ layersNumber / 3 < downSamplingNumber
]

{ #category : #inspecting }
CNNPythonDetector >> hasUselessDropout: aModel [
	allLayers ifEmpty: [ self findLayersIn: aModel ].

	^allLayers anySatisfy: [ :layer | self allUselessDropout: layer ]
]

{ #category : #'private - accessing' }
CNNPythonDetector >> homogeneousBlocks: aModel [

	| convolutions nextPos results  |
	convolutions := self convolutions: aModel.
	nextPos := 2.
	results := OrderedCollection new.

"	convolutions size > 1 ifTrue: [ ""initialization""
		convolutions do: [ :convolution |
			convolution cacheAt: 'isHomogeneous' put: false ]."

		"Update homogeneous blocks"
		convolutions doWithIndex: [ :convolution :i |
			convolutions doWithIndex: [ :nextConvolution :j |
				i < j ifTrue: [
					(convolution isHomogeneousTo: nextConvolution) ifTrue: [
						convolution addHomogeneous: nextConvolution.
						nextConvolution homogeneous: convolution ] ] ] ].


		"convolutions size >= nextPos ifTrue: [
				nextConvolution := convolutions at: nextPos.


				convArgs := self getInvocationArguments: convolution.
				nextConvArgs := self getInvocationArguments: nextConvolution.

				convArgs isNotEmpty & nextConvArgs isNotEmpty ifTrue: [
					convArgs first = nextConvArgs first
					& (convArgs second = nextConvArgs second) ifTrue: [
						convolution cacheAt: 'isHomogeneous' put: true.
						nextConvolution cacheAt: 'isHomogeneous' put: true ] ].
				nextPos := nextPos + 1 ] ]."


		^ convolutions collect: #isHomogeneous
		
		"Collect homogeous blocks"
		"convolutions do: [ :convolution |
			isHomogeneous := convolution
				                 cacheAt: 'isHomogeneous'
				                 ifAbsent: [ false ].

			isHomogeneous ifTrue: [ results add: convolution ] ] ]."

"	^ results"
]

{ #category : #initialization }
CNNPythonDetector >> initialize [

	super initialize.
	visitor := MSEPythonToFamixImporterVisitor new.

	allLayers := OrderedCollection new.
]

{ #category : #'private - accessing' }
CNNPythonDetector >> invocations: aModel [

	^ (aModel allWithType: FamixPythonInvocation )asOrderedCollection
]

{ #category : #helpers }
CNNPythonDetector >> isAscending: aCollection [

	| counter len |
	counter := 2.
	len := aCollection size.

	aCollection do: [ :each |
		counter < len ifTrue: [
			each > (aCollection at: counter) ifTrue: [ ^ false ].
			counter := counter + 1 ] ].

	^ true
]

{ #category : #nicolas }
CNNPythonDetector >> isConvolution: anInvocation [
	^'*conv*' match: (self getInvocationCandidateName: anInvocation)
]

{ #category : #helpers }
CNNPythonDetector >> isSame: aCollection [

	| counter len |
	counter := 2.
	len := aCollection size.

	aCollection do: [ :each |
		counter < len ifTrue: [
			(each = (aCollection at: counter)) ifFalse: [ ^ false ].
			counter := counter + 1 ] ].

	^ true
]

{ #category : #visiting }
CNNPythonDetector >> parseThenModelingFromFile: aPath [
	"Example of path : '/Users/aurelikama/Documents/Projet/These/parserPythonToJson/sample_design_smell/layers_formation/gh_non_dominating_dow_sampling.py'
		          asFileReference contents."

	^ self parseThenModelingFromString: aPath asFileReference contents
]

{ #category : #visiting }
CNNPythonDetector >> parseThenModelingFromString: aString [

	visitor accept: (PythonParser parseWithErrors: aString).

	^ visitor model
]

{ #category : #accessing }
CNNPythonDetector >> visitor [

	^ visitor
]
