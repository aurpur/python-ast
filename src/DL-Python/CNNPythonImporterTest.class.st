Class {
	#name : #CNNPythonImporterTest,
	#superclass : #TestCase,
	#instVars : [
		'model',
		'detector',
		'cnnVisitor'
	],
	#category : #'DL-Python-Tests'
}

{ #category : #running }
CNNPythonImporterTest >> createFamixModel: pythonCode [

	| pyFamixVisior |
	pyFamixVisior := MSEPythonToFamixImporterVisitor new.
	(PythonParser parseWithErrors: pythonCode) acceptVisitor: pyFamixVisior.
	^pyFamixVisior model.

]

{ #category : #running }
CNNPythonImporterTest >> setUp [

	cnnVisitor := CNNPythonImporter new.
]

{ #category : #tests }
CNNPythonImporterTest >> testLayerHasActivation [

	| famixModel cnnModel layers |
	famixModel := self createFamixModel: '
model.add(Conv2D(32, (5, 5)))
model.add(Activation(''relu''))
'.

	cnnModel := cnnVisitor createCNNModel: famixModel.

	layers := cnnModel allWithType: CNNFamixLayer.

	self assert: layers first activations size equals: 1.

	self
		assert: layers first activations first class
		equals: CNNFamixActivation.

	self
		assert: layers first activations first invocation class
		equals: FamixPythonInvocation
]

{ #category : #tests }
CNNPythonImporterTest >> testLayerHasBatchNormRegularization [

	| famixModel cnnModel layers |
	famixModel := self createFamixModel: '
conv6 = Convolution2D(192, 3, strides=(2,2), padding=''valid'')
bn2 = BatchNormalization()
relu6 = Activation(''relu'')
'.

	cnnModel := cnnVisitor createCNNModel: famixModel.

	layers := cnnModel allWithType: CNNFamixLayer.

	self assert: layers first regularizations size equals: 1.

	self
		assert:
		(cnnVisitor isBatchnorm:  layers first regularizations first invocation)
		equals: true
]

{ #category : #tests }
CNNPythonImporterTest >> testLayerHasConvolution [

	| famixModel cnnModel layers |
	famixModel := self createFamixModel: '
model.add(Conv2D(32, (5, 5)))
model.add(Activation(''relu''))
'.

	cnnModel := cnnVisitor createCNNModel: famixModel.

	layers := cnnModel allWithType: CNNFamixLayer.
	self
		assert: layers first convolution class
		equals: CNNFamixConvolution.
	self
		assert: layers first convolution invocation class
		equals: FamixPythonInvocation
]

{ #category : #tests }
CNNPythonImporterTest >> testLayerHasDropoutRegularization [

	| famixModel cnnModel layers |
	famixModel := self createFamixModel: '
model.add(Conv2D(32, (3, 3)))
model.add(Activation(''relu''))
model.add(Dropout(0.2))
'.

	cnnModel := cnnVisitor createCNNModel: famixModel.

	layers := cnnModel allWithType: CNNFamixLayer.

	self assert: layers first regularizations size equals: 1.

	self
		assert:
		(cnnVisitor isDropout: layers first regularizations first invocation)
		equals: true.
]

{ #category : #tests }
CNNPythonImporterTest >> testLayerHasPooling [

	| famixModel cnnModel layers |
	famixModel := self createFamixModel: '
model.add(Conv2D(32, (3, 3)))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2)))
'.

	cnnModel := cnnVisitor createCNNModel: famixModel.

	layers := cnnModel allWithType: CNNFamixLayer.

	self assert: layers first poolings size equals: 1.

	self
		assert: layers first poolings first class
		equals: CNNFamixPooling.
	self
		assert: layers first poolings first invocation class
		equals: FamixPythonInvocation
]

{ #category : #tests }
CNNPythonImporterTest >> testLayerHasRegularization [

	| famixModel cnnModel layers |
	famixModel := self createFamixModel: '
model.add(Conv2D(32, (3, 3)))
model.add(Activation(''relu''))
model.add(Dropout(0.2))
'.

	cnnModel := cnnVisitor createCNNModel: famixModel.

	layers := cnnModel allWithType: CNNFamixLayer.

	self assert: layers first regularizations size equals: 1.

	self
		assert: layers first regularizations first class
		equals: CNNFamixRegularization.
	self
		assert: layers first regularizations first invocation class
		equals: FamixPythonInvocation
]

{ #category : #tests }
CNNPythonImporterTest >> testLayers [

	| famixModel cnnModel |
	famixModel := self createFamixModel: '
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

	cnnModel := cnnVisitor createCNNModel: famixModel.

	self assert: (cnnModel allWithType: CNNFamixLayer) size equals: 4.

	self
		assert: (cnnModel allWithType: CNNFamixLayer) first name
		equals: 'L1'.
		
]

{ #category : #tests }
CNNPythonImporterTest >> testProgram [

	| famixModel cnnModel programs |
	famixModel := self createFamixModel: '
model = Sequential()
	
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

	cnnModel := cnnVisitor createCNNModel: famixModel.

	programs := cnnModel allWithType: CNNFamixProgram.

	self assert: programs size equals: 1.

	self assert: programs first name equals: 'default Python Model'.

	self assert: programs first type equals: 'Sequential'
]
