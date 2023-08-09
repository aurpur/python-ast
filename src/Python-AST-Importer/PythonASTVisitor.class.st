Class {
	#name : #PythonASTVisitor,
	#superclass : #Object,
	#instVars : [
		'model'
	],
	#category : #'Python-AST-Importer-visitor'
}

{ #category : #'reflective operations' }
PythonASTVisitor >> doesNotUnderstand: aMethod [

	| code |
	self flag: #TODO. "To remove"
	(aMethod selector beginsWith: 'visit') ifFalse: [ ^ self ].
	code := aMethod selector asString , ' aNode
    self flag: #TODO.
    self shouldBeImplemented'.
	self class compile: code classified: 'visiting'
]

{ #category : #initialization }
PythonASTVisitor >> initialize [ 
	super initialize.
	model := PythonASTModel new name: 'mon model ast'.
]

{ #category : #initialization }
PythonASTVisitor >> model [

	^ model
]

{ #category : #initialization }
PythonASTVisitor >> model: anObject [

	model := anObject
]

{ #category : #initialization }
PythonASTVisitor >> newEntity: aFamixClass [

	^ aFamixClass new
		  mooseModel: model;
		  yourself
]

{ #category : #visiting }
PythonASTVisitor >> visitAlias: anAliasNode [

	^ {
		  (#name -> (anAliasNode at: #name)).
		  (#asname -> (anAliasNode at: #asname)).
		  (#lineno -> (anAliasNode at: #lineno)) } asDictionary
]

{ #category : #visiting }
PythonASTVisitor >> visitArg: anArgNode [
    ^ { (#name -> (anArgNode at: #arg)) } asDictionary
]

{ #category : #visiting }
PythonASTVisitor >> visitArguments: anArgumentNode [

	^ self visitJsonElement: (anArgumentNode at: #args)
]

{ #category : #visiting }
PythonASTVisitor >> visitAssign: aJsonNode [

	| assign variables i myVariable variablesName myTarget target |
	assign := self newEntity: PythonASTAssign.
	assign lineNumber: (aJsonNode at: #lineno).

	variablesName := self visitJsonElement: (aJsonNode at: #targets).

	i := 1.
	variablesName collect: [ :variable |
		assign addVariable: ((self newEntity: PythonASTVariable)
				 name: variable;
				 isTuple: false;
				 position: i).
		i := i + 1 ].

	"	variables := variablesName collect: [ :variable |
		myVariable := self newEntity: PythonASTVariable.
		myVariable position: i.
		myVariable name: variable.
		
		myVariable isTuple: false.
		yourself.
		i := i + 1.
		

		""assign addVariable: myVariable.""
		  ]."


	myTarget := self visitJsonElement: (aJsonNode at: #value).
	"If target is invocation"
	target := self newEntity: PythonASTTarget.
	target addInvocation: myTarget.

	target invocations.
	"TODO : Else target is value"

	assign target: target.


	^ assign
]

{ #category : #visiting }
PythonASTVisitor >> visitAttribute: aNode [
    self flag: #TODO.
    self shouldBeImplemented
]

{ #category : #visiting }
PythonASTVisitor >> visitCall: aJsonCode [

	| invocation |
	invocation := self newEntity: PythonASTInvocation.

	invocation lineNumber: (aJsonCode at: #lineno).
	invocation name: (self visitJsonElement: (aJsonCode at: #func)).

	^ invocation
]

{ #category : #visiting }
PythonASTVisitor >> visitExpr: aJsonCode [

	^ self visitJsonElement: (aJsonCode at: #value)
]

{ #category : #visiting }
PythonASTVisitor >> visitFunctionDef: aJsonCode [

	| function parameters arguments functionBody statementBlocks test |
	function := self newEntity: PythonASTFunctionDefinition.

	function name: (aJsonCode at: #name).
	function lineNumber: (aJsonCode at: #lineno).
	
	parameters := self visitJsonElement: (aJsonCode at: #args).

	"TODO : mettre la valeur par défaut"
	parameters collect: [ :parameter |
		function addParameter:
			((self newEntity: PythonASTParameter) name: (parameter at: #name)) ].
		
	functionBody := self newEntity: PythonASTBody.
	
	
	statementBlocks := aJsonCode at: #body.
	
	
	statementBlocks collect: [ :statementBlock|
		(self visitJsonElement: (statementBlock))
		].
	
	function body: functionBody.
	
	

^function
]

{ #category : #visiting }
PythonASTVisitor >> visitImport: aJsonCode [


	| myNames |
	myNames := self visitJsonElement: (aJsonCode at: #names).

	^ myNames collect: [ :myName |
		  (self newEntity: PythonASTImport)
			  name: (myName at: #name);
			  asName: (myName at: #asname);
			  lineNumber: (myName at: #lineno) asNumber ]
]

{ #category : #visiting }
PythonASTVisitor >> visitImportFrom: aJsonCode [

	| myFrom myNames |
	myFrom := aJsonCode at: #module.
	myNames := self visitJsonElement: (aJsonCode at: #names).

	^ myNames collect: [ :myName |
		  (self newEntity: PythonASTImport)
			  name: (myName at: #name);
			  from: myFrom;
			  asName: (myName at: #asname);
			  lineNumber: (myName at: #lineno) asNumber ]
]

{ #category : #navigation }
PythonASTVisitor >> visitJsonArray: aJsonArray [
	^aJsonArray 
		collect: [:jsonNode | self visitJsonElement: jsonNode ]
]

{ #category : #navigation }
PythonASTVisitor >> visitJsonElement: aJsonNode [

	aJsonNode ifNil: [ ^ nil ].
	aJsonNode isDictionary ifTrue: [ ^ self visitJsonMap: aJsonNode ].
	aJsonNode isArray ifTrue: [ ^ self visitJsonArray: aJsonNode ]
]

{ #category : #navigation }
PythonASTVisitor >> visitJsonEntity: aJsonNode [
	|selector|
	selector := 'visit', (aJsonNode at: #'_type') capitalized , ':'.
	^ self perform: selector asSymbol with: aJsonNode
]

{ #category : #navigation }
PythonASTVisitor >> visitJsonMap: aJsonDictionary [

	"aJsonDictionary removeKey: 'anno' ifAbsent: [ ""nothing"" ]."

	^ (aJsonDictionary includesKey: '_type')
		  ifTrue: [ self visitJsonEntity: aJsonDictionary ]
		  ifFalse: [ 
			  aJsonDictionary associations collect: [ :assoc | 
				  self visitJsonNode: assoc key value: assoc value ] ]
]

{ #category : #navigation }
PythonASTVisitor >> visitJsonNode: key value: aValue [
	| selector |
	selector := ('visit' , key capitalized , ':') asSymbol.
	^self perform: selector with: aValue .
]

{ #category : #visiting }
PythonASTVisitor >> visitModule: aJsonCode [

| module |
module := self newEntity: PythonASTModule.
module name: 'sample.json'.
module lineNumber: 0.

self visitJsonElement: (aJsonCode at: #body).

^module
]

{ #category : #visiting }
PythonASTVisitor >> visitName: aJsonNode [
    ^ aJsonNode at: #id
]

{ #category : #visiting }
PythonASTVisitor >> visitTuple: aNode [
    self flag: #TODO.
    self shouldBeImplemented
]
