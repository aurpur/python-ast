Class {
	#name : #PySmaccToFAST,
	#superclass : #Object,
	#category : #'PythonSmaccToFast-Core'
}

{ #category : #scripts }
PySmaccToFAST class >> dumpPythonASTHierarchy [
	<script>
	self new 
		buildHierarchyFrom: PyRootNode;
		buildAccessorsOfHierarchyFrom: PysfRootNode 
	
]

{ #category : #scripts }
PySmaccToFAST class >> removePythonASTHierarchy [
	<script>
	PysfRootNode subclasses do: [ :each | each removeFromSystem ].
	PysfRootNode removeFromSystem.
	
]

{ #category : #internal }
PySmaccToFAST >> basicBuildClassNamed: aClassName superclass: aSuperclass variables: anArrayOfSymbols [
	
	| builder |
	builder := aSuperclass << aClassName.
	builder slots: anArrayOfSymbols.
	builder tag: 'Generated'.
	builder package: 'PythonSmaccToFAST'.
	builder install.
	^ builder
]

{ #category : #'build methods' }
PySmaccToFAST >> buildAccessorsOf: aTransformedClass [

	
	| rbNamespace |
	rbNamespace := RBNamespace onEnvironment: (RBClassEnvironment classes: { aTransformedClass }).

	aTransformedClass instVarNames do: [ :eac | 
	(RBCreateAccessorsForVariableTransformation
		model: rbNamespace
		variable: eac
		class: aTransformedClass 
		classVariable: false) execute ].
]

{ #category : #'build methods' }
PySmaccToFAST >> buildAccessorsOfHierarchyFrom: aClass [
	"Precondition: the transformed superclass of aClass does exist"
	
	self buildAccessorsOf: aClass.
	aClass subclassesDo: [ :asub |
		self buildAccessorsOfHierarchyFrom: asub
		]
]

{ #category : #'build classes' }
PySmaccToFAST >> buildClassFrom: aClass [

	^ self basicBuildClassNamed: (self nameFor: aClass)  
				superclass: (self class environment at: (self nameFor: aClass superclass) asSymbol) 
				variables: (self variablesFrom: aClass) 
]

{ #category : #'build classes' }
PySmaccToFAST >> buildHierarchyFrom: aClass [
	"Precondition: the transformed superclass of aClass does exist"
	
	self buildClassFrom: aClass.
	aClass subclassesDo: [ :asub |
		self buildHierarchyFrom: asub
		]
]

{ #category : #'build classes' }
PySmaccToFAST >> buildRootClassFrom: aClass [
	
	self installRoot.
	^ self basicBuildClassNamed: (self nameFor: aClass)  
				superclass:  self rootSuperclass
				variables: (self variablesFrom: aClass) 
]

{ #category : #'build classes' }
PySmaccToFAST >> buildWithSubclassesFrom: aClass [
	"Precondition: the transformed superclass of aClass does exist"
	
	self buildClassFrom: aClass.
	aClass subclassesDo: [ :asub |
		self buildClassFrom: asub
		]
]

{ #category : #initialization }
PySmaccToFAST >> initialize [ 
	super initialize.
	self installRoot
]

{ #category : #internal }
PySmaccToFAST >> installRoot [

	self class environment 
			at: 'PysfInternalRootNode'
			ifAbsent: [ self basicBuildClassNamed: #PysfInternalRootNode superclass: Object variables: #(). ]
]

{ #category : #utilities }
PySmaccToFAST >> nameFor: aClass [

	^ aClass name copyReplaceAll:  'Py' with: 'Pysf' 
]

{ #category : #utilities }
PySmaccToFAST >> rootSuperclass [

	^ self class environment at: #'PysfRootNode'
		
]

{ #category : #utilities }
PySmaccToFAST >> variablesFrom: aClass [

	^ aClass instVarNames reject: [ :s | s endsWith: 'Token' ]
]
