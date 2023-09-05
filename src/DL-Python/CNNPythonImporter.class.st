Class {
	#name : #CNNPythonImporter,
	#superclass : #MSEPythonToFamixImporterVisitor,
	#instVars : [
		'invocations',
		'homogenous',
		'allLayers',
		'visitor',
		'famixModel',
		'program',
		'layerNum'
	],
	#category : #'DL-Python-Importers'
}

{ #category : #model }
CNNPythonImporter >> createCNNModel: aFamixModel [
	program name: aFamixModel name.
	^ (self createLayers: (self invocations: aFamixModel)) model
]

{ #category : #'entity creation' }
CNNPythonImporter >> createLayer: invocation [

	| aLayer |
	aLayer := model newLayer.

	(self isConvolution: invocation)
		ifTrue: [
		aLayer convolution: (model newConvolution invocation: invocation) ]
		ifFalse: [
			(self isDense: invocation)
				ifTrue: [ aLayer dense: (model newDense invocation: invocation) ]
				ifFalse: [
					(self isFlatten: invocation)
						ifTrue: [
						aLayer flatten: (model newFlatten invocation: invocation) ]
						ifFalse: [ ^ nil ] ] ].
	aLayer name: 'L' , layerNum asString.
	layerNum := layerNum +1.
	^ aLayer
]

{ #category : #'entity creation' }
CNNPythonImporter >> createLayers: invocationCollection [

	| currentLayer type |
	currentLayer := nil.
	type := 'functional'.


	invocationCollection do: [ :invoc |
		(self isNewLayer: invoc)
			ifTrue: [
				currentLayer := self createLayer: invoc.
				program addLayer: currentLayer ]
			ifFalse: [
			self extractSpecificFunctionFrom: invoc to: currentLayer ].

		(self isSequential: invoc) ifTrue: [ type := 'Sequential' ].
		program type: type ]
]

{ #category : #'entity creation' }
CNNPythonImporter >> extractSpecificFunctionFrom: anInvocation to: aCurrentLayer [

	aCurrentLayer ifNotNil: [
		(self isActivation: anInvocation)
			ifTrue: [
				aCurrentLayer addActivation:
					(model newActivation invocation: anInvocation) ]
			ifFalse: [
				(self isPooling: anInvocation)
					ifTrue: [
						aCurrentLayer addPooling:
							(model newPooling invocation: anInvocation) ]
					ifFalse: [
						(self isRegularization: anInvocation)
							ifTrue: [
								aCurrentLayer addRegularization:
									(model newRegularization invocation: anInvocation) ]
							ifFalse: [
								aCurrentLayer addInvocation:
									 anInvocation] ] ] ]
]

{ #category : #helper }
CNNPythonImporter >> getCandidateName: anInvocation [

	^ anInvocation cacheAt: 'canditate' ifAbsent: [ nil ]
]

{ #category : #initialization }
CNNPythonImporter >> initialize [

	super initialize.

	model := CNNFamixModel new name: 'default cnn model'.
	program := model newProgram.
	layerNum := 1
]

{ #category : #'accessing - classes' }
CNNPythonImporter >> invocations: aModel [

	^ self sortedBySourceAnchor:(aModel allWithType: FamixPythonInvocation) asOrderedCollection
]

{ #category : #checking }
CNNPythonImporter >> isActivation: anInvocation [

	^ ('*activation' match: (self getCandidateName: anInvocation)) or: [
		  ('*relu' match: (self getCandidateName: anInvocation)) or: [
			  ('*sigmoid' match: (self getCandidateName: anInvocation)) or: [
				  ('*tanh' match: (self getCandidateName: anInvocation)) or: [
					  ('*leakyrelU' match: (self getCandidateName: anInvocation))
						  or: [
							  ('*exponential' match: (self getCandidateName: anInvocation))
								  or: [
									  ('*elu' match: (self getCandidateName: anInvocation))
										  or: [
										  '*soft*' match: (self getCandidateName: anInvocation) ] ] ] ] ] ] ]
]

{ #category : #checking }
CNNPythonImporter >> isAveragePooling: anInvocation [

	^ ('*avgpool*' match: (self getCandidateName: anInvocation)) or:[('*averagepool*' match: (self getCandidateName: anInvocation))]
]

{ #category : #checking }
CNNPythonImporter >> isBatchnorm: anInvocation [

	^ ('*batchnorm*' match: (self getCandidateName: anInvocation)) or:[
		 ('*batch_norm*' match: (self getCandidateName: anInvocation))]
]

{ #category : #checking }
CNNPythonImporter >> isConvolution: anInvocation [

	^ '*conv*' match: (self getCandidateName: anInvocation)
]

{ #category : #checking }
CNNPythonImporter >> isDense: anInvocation [

	^ ('*dense' match: (self getCandidateName: anInvocation)) or: [
		  '*linear' match: (self getCandidateName: anInvocation) ]
]

{ #category : #checking }
CNNPythonImporter >> isDropout: anInvocation [

	^ '*dropout' match: (self getCandidateName: anInvocation)
]

{ #category : #checking }
CNNPythonImporter >> isFlatten: anInvocation [

	^ '*flatten' match: (self getCandidateName: anInvocation)
]

{ #category : #checking }
CNNPythonImporter >> isGlobalPooling: anInvocation [

	^ '*global*pool*' match: (self getCandidateName: anInvocation)
]

{ #category : #checking }
CNNPythonImporter >> isMaxPooling: anInvocation [

	^ '*maxpool*' match: (self getCandidateName: anInvocation)
]

{ #category : #checking }
CNNPythonImporter >> isNewLayer: anInvocation [

	^ (self isConvolution: anInvocation) 
		or: [ (self isDense: anInvocation)
	  	or: [self isFlatten: anInvocation]]
]

{ #category : #checking }
CNNPythonImporter >> isOptimizer: anInvocation [

	^ ('*ada' match: (self getCandidateName: anInvocation)) or: [
		  ('*sgd' match: (self getCandidateName: anInvocation)) or: [
			  ('*adam*' match: (self getCandidateName: anInvocation)) or: [
				  ('*prop' match: (self getCandidateName: anInvocation)) or: [
					  ('*lbfgs' match: (self getCandidateName: anInvocation)) or: [
						  '*ftrl' match: (self getCandidateName: anInvocation) ] ] ] ] ]
]

{ #category : #checking }
CNNPythonImporter >> isPooling: anInvocation [

	^ '*pool*' match: (self getCandidateName: anInvocation)
]

{ #category : #checking }
CNNPythonImporter >> isRegularization: anInvocation [

	^ (self isDropout: anInvocation) | (self isBatchnorm: anInvocation)
]

{ #category : #checking }
CNNPythonImporter >> isSequential: anInvocation [

	^ '*sequential*' match: (self getCandidateName: anInvocation)
]

{ #category : #'accessing - classes' }
CNNPythonImporter >> layers: aModel [

	^ self sortedBySourceAnchor:
		  (self model allWithType: CNNFamixLayer) asOrderedCollection
]

{ #category : #helper }
CNNPythonImporter >> sortedBySourceAnchor: aCollection [

	^ aCollection
		  sorted: [ :a :b |
		  a sourceAnchor startPos < b sourceAnchor startPos ]
]
