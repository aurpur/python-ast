Class {
	#name : #FPyIJsonVisitor,
	#superclass : #Object,
	#instVars : [
		'model'
	],
	#category : #'Famix-Python-Importer-visitor'
}

{ #category : #visiting }
FPyIJsonVisitor >> doesNotUnderstand: aMethod [

	| code |
	self flag: #TODO. "To remove"
	(aMethod selector beginsWith: 'visit') ifFalse: [ ^ self ].
	code := aMethod selector asString , ' aNode
    self flag: #TODO.
    self shouldBeImplemented'.
	self class compile: code classified: 'visiting'
]

{ #category : #visiting }
FPyIJsonVisitor >> initialize [
	super initialize.
	model := FamixPythonModel new name: 'PythonModel'.
	
]

{ #category : #accessing }
FPyIJsonVisitor >> model [

	^ model
]

{ #category : #accessing }
FPyIJsonVisitor >> model: anObject [

	model := anObject
]

{ #category : #visiting }
FPyIJsonVisitor >> newEntity: aFamixClass [

	^ aFamixClass new
		  mooseModel: model;
		  yourself
]

{ #category : #visiting }
FPyIJsonVisitor >> visitAlias: anAliasNode [

	^ { 
		  (#name -> (anAliasNode at: #name)).
		  (#asname -> (anAliasNode at: #asname)) } asDictionary 
]

{ #category : #visiting }
FPyIJsonVisitor >> visitAssign: aJsonNode [

	self flag: #TODO "Pas necessaire dans Famix"
]

{ #category : #visiting }
FPyIJsonVisitor >> visitImportFrom: aJsonNode [

	| moduleName names |
	"-- remplir les setteur --"
	moduleName := aJsonNode at: #module.
	names := self visitJsonElement: (aJsonNode at: #names).

	^ names collect: [ :name | 
		  (self newEntity: FamixPythonImport)
			  entityName: (name at: #name);
			  fromName: moduleName;
			  asName: (name at: #asname) ]
]

{ #category : #visiting }
FPyIJsonVisitor >> visitJsonArray: aJsonArray [
	^aJsonArray 
		collect: [:jsonNode | self visitJsonElement: jsonNode ]
]

{ #category : #visiting }
FPyIJsonVisitor >> visitJsonElement: aJsonNode [

	aJsonNode ifNil: [ ^ nil ].
	aJsonNode isDictionary ifTrue: [ ^ self visitJsonMap: aJsonNode ].
	aJsonNode isArray ifTrue: [ ^ self visitJsonArray: aJsonNode ]
]

{ #category : #visiting }
FPyIJsonVisitor >> visitJsonEntity: aJsonNode [
	|selector|
	selector := 'visit', (aJsonNode at: #'_type') capitalized , ':'.
	^ self perform: selector asSymbol with: aJsonNode  
]

{ #category : #visiting }
FPyIJsonVisitor >> visitJsonMap: aJsonDictionary [

	"aJsonDictionary removeKey: 'anno' ifAbsent: [ ""nothing"" ]."

	^ (aJsonDictionary includesKey: '_type')
		  ifTrue: [ self visitJsonEntity: aJsonDictionary ]
		  ifFalse: [ 
			  aJsonDictionary associations collect: [ :assoc | 
				  self visitJsonNode: assoc key value: assoc value ] ]
]

{ #category : #visiting }
FPyIJsonVisitor >> visitJsonTypedElement: aJsonDictionary [

	| key |
	"key := aJsonDictionary removeKey: '_type'."
	^ self visitJsonEntity: aJsonDictionary
]

{ #category : #visiting }
FPyIJsonVisitor >> visitModule: aJsonNode [

	| module |
	module := self newEntity: FamixPythonModule.
	"	module
		name: 'test';
		comments: { 
				(FamixPythonComment new
					 content: 'test comment';
					 yourself).
				(FamixPythonComment new
					 content: 'test comment 2';
					 yourself) }."

	self visitJsonElement: (aJsonNode at: #body).
	^ module
]
