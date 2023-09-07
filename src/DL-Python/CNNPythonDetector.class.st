Class {
	#name : #CNNPythonDetector,
	#superclass : #Object,
	#instVars : [
		'visitor',
		'allLayers',
		'importerCNN'
	],
	#category : #'DL-Python-Detectors'
}

{ #category : #inspecting }
CNNPythonDetector >> batchNormsInLayer: aLayer [

	^ aLayer regularizations select: [ :regularization |
		  self isBatchNorm:  regularization ]
]

{ #category : #'private - accessing' }
CNNPythonDetector >> convolutions: aModel [
| results |
results := OrderedCollection new.

	 aModel layers do: [ :layer |
		  (self doesLayerContainConvolution: layer) ifTrue: [
			  results add: layer convolution ] ].
	
^results
]

{ #category : #inspecting }
CNNPythonDetector >> doesLayerContainBatchNorm: aLayer [

	^ (self batchNormsInLayer: aLayer) isNotEmpty
]

{ #category : #inspecting }
CNNPythonDetector >> doesLayerContainConvolution: aLayer [

	^ aLayer convolution isNotNil
]

{ #category : #inspecting }
CNNPythonDetector >> doesLayerContainDropout: aLayer [

	^ (self dropoutsInLayer: aLayer ) isNotEmpty
]

{ #category : #inspecting }
CNNPythonDetector >> doesLayerContainPooling: aLayer [

	^ ( aLayer poolings) isNotEmpty
]

{ #category : #'private - accessing' }
CNNPythonDetector >> downSamplings: aModel [

	| candidateName  |
	^((self invocations: aModel) collect: [ :invocation |
		           candidateName := self getInvocationCandidateName:
			                            invocation.
		           ('*pooling*' match: candidateName) ifTrue: [ invocation ] ] )reject: [ :a | a isNil ].


]

{ #category : #inspecting }
CNNPythonDetector >> dropoutsInLayer: aLayer [

	^ (aLayer regularizations select: [ :regularization |
		   self isDropout: regularization ])
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


	^ (self layersWithBiasWithBatchNormalization: aModel layers)
		  isNotEmpty.
	
]

{ #category : #inspecting }
CNNPythonDetector >> hasHeterogeneousBlocks: aModel [

	^ (self homogeneousBlocks: aModel) size < 2
]

{ #category : #inspecting }
CNNPythonDetector >> hasLargeKernelConvolution: aModel [

	^ (self layersWithLargeKernelConvolution: aModel layers)
		  isNotEmpty
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

	^ (self layersWithNonDominatingDownSampling: aModel layers) isNotEmpty
]

{ #category : #inspecting }
CNNPythonDetector >> hasNonRepresentativeStatisticsEstimation: aModel [

	^ (self layersWithNonRepresentativeStatisticsEstimation: aModel layers)
		  isNotEmpty
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


	^ (self layersWithUselessDropout: aModel layers)
		  isNotEmpty.
		
		
	
]

{ #category : #'private - accessing' }
CNNPythonDetector >> homogeneousBlocks: aModel [

"homogeneous block is not a design smell. It help to build design smell Heterogeneous blocks"
	| convolutions next |
	convolutions := self convolutions: aModel.

	convolutions doWithIndex: [ :convolution :i |
		next := true.

		convolutions doWithIndex: [ :nextConvolution :j |
			i < j & (convolution isHomogeneousTo: nextConvolution) & next
				ifTrue: [
					convolution addHomogeneous: nextConvolution.
					nextConvolution itsHomogeneous: convolution.

					convolution itsHomogeneous ifNil: [
						convolution isStartOfBlock: true ] ]
				ifFalse: [ i < j ifTrue: [ next := false ] ] ] ].

	^ convolutions select: #isStartOfBlock
]

{ #category : #initialization }
CNNPythonDetector >> initialize [

	super initialize.
	importerCNN := CNNPythonImporter  new.

	allLayers := OrderedCollection new
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

{ #category : #inspecting }
CNNPythonDetector >> isAveragePooling: aPooling [

	^ importerCNN isAveragePooling: aPooling invocation
]

{ #category : #inspecting }
CNNPythonDetector >> isBatchNorm: aRegularization [

	^ importerCNN isBatchnorm:  aRegularization invocation
]

{ #category : #nicolas }
CNNPythonDetector >> isConvolution: aConvolution [

^ importerCNN isConvolution: aConvolution invocation
]

{ #category : #inspecting }
CNNPythonDetector >> isDropout: aRegularization [

	^ importerCNN isDropout: aRegularization invocation
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

{ #category : #inspecting }
CNNPythonDetector >> layerWithBiasWithBatchNormalization: aLayer [

	| position results convs batchNorms  |
	convs := OrderedCollection new.
	batchNorms := OrderedCollection new.
	position := 1.
	results := OrderedCollection new.


	batchNorms := aLayer regularizations select: [ :regularization |
		              self isBatchNorm: regularization ].


	(self doesLayerContainConvolution:  aLayer )ifTrue:[
	aLayer convolution useBias & batchNorms isNotEmpty ifTrue: [
		results := batchNorms ]].

	^ results
]

{ #category : #'private - accessing' }
CNNPythonDetector >> layerWithLargeKernelConvolution: aLayer [

	(self doesLayerContainConvolution: aLayer) ifTrue: [
		aLayer convolution kernelSize asInteger > 3 ifTrue: [ ^ aLayer ] ].
	^nil
]

{ #category : #inspecting }
CNNPythonDetector >> layerWithNonDominatingDownSampling: aLayer [

	^aLayer poolings select: [ :pooling | self isAveragePooling: pooling ].

]

{ #category : #inspecting }
CNNPythonDetector >> layerWithNonRepresentativeStatisticsEstimation: aLayer [

	| results |
	results := OrderedCollection new.

	(self doesLayerContainDropout: aLayer)
	& (self doesLayerContainBatchNorm: aLayer) ifTrue: [
		
		(self batchNormsInLayer: aLayer) do: [ :batchNorm |
			
			(self dropoutsInLayer: aLayer) do: [ :dropout |
				
				batchNorm invocation sourceAnchor startPos
				> dropout invocation sourceAnchor startPos ifTrue: [
					results add: batchNorm ] ] ] ].

	^ results
]

{ #category : #inspecting }
CNNPythonDetector >> layerWithUselessDropout: aLayer [


	| results |
	results := OrderedCollection new.

	(self doesLayerContainDropout: aLayer)
	& (self doesLayerContainPooling: aLayer) ifTrue: [
		(self dropoutsInLayer: aLayer) do: [ :dropout |
			aLayer poolings do: [ :pooling |
				dropout invocation sourceAnchor startPos
				< pooling invocation sourceAnchor startPos ifTrue: [
					results add: dropout ] ] ] ].

	^ results
]

{ #category : #inspecting }
CNNPythonDetector >> layersWithBiasWithBatchNormalization: layers [

	^ layers select: [ :layer |
		  (self layerWithBiasWithBatchNormalization: layer) isNotEmpty  ]
]

{ #category : #'private - accessing' }
CNNPythonDetector >> layersWithLargeKernelConvolution: layers [

	^ layers select: [ :layer |
		  (self layerWithLargeKernelConvolution: layer) isNotNil ]
]

{ #category : #inspecting }
CNNPythonDetector >> layersWithNonDominatingDownSampling: layers [

	^ layers select: [ :layer |
		  (self layerWithNonDominatingDownSampling: layer) isNotEmpty ]
]

{ #category : #inspecting }
CNNPythonDetector >> layersWithNonRepresentativeStatisticsEstimation: layers [

	^ layers select: [ :layer |
		  (self layerWithNonRepresentativeStatisticsEstimation: layer) isNotEmpty ]
]

{ #category : #inspecting }
CNNPythonDetector >> layersWithUselessDropout: layers [

	^layers select: [ :layer |
		(self layerWithUselessDropout: layer) isNotEmpty ]
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
