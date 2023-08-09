Class {
	#name : #PythonASTGenerator,
	#superclass : #FamixBasicInfrastructureGenerator,
	#instVars : [
		'assign',
		'body',
		'classDefinition',
		'constructor',
		'argument',
		'functionDefinition',
		'import',
		'invocation',
		'methodDefinition',
		'module',
		'parameter',
		'return',
		'statementBlock',
		'target',
		'value',
		'variable',
		'inheritance',
		'package'
	],
	#category : #'Python-AST-Generator'
}

{ #category : #accessing }
PythonASTGenerator class >> packageName [

	^ #'Python-AST-Entities'
]

{ #category : #accessing }
PythonASTGenerator class >> prefix [

	^ #PythonAST
]

{ #category : #definition }
PythonASTGenerator >> defineClasses [ 

	super defineClasses.
	argument := builder newClassNamed:#Argement.
	assign := builder newClassNamed: #Assign.
	body := builder newClassNamed: #Body.
	classDefinition := builder newClassNamed: #ClassDefinition.
	constructor := builder newClassNamed: #Constructor.
	functionDefinition := builder newClassNamed: #FunctionDefinition.
	import := builder newClassNamed: #Import.
	inheritance := builder newClassNamed: #Inheritance.
	invocation := builder newClassNamed: #Invocation.
	methodDefinition := builder newClassNamed: #MethodDefinition.
	module := builder newClassNamed: #Module.
	parameter := builder newClassNamed: #Parameter.
	return := builder newClassNamed: #Return.
	statementBlock := builder newClassNamed: #StatementBlock.
	target := builder newClassNamed: #Target.
	value := builder newClassNamed: #Value.
	variable := builder newClassNamed: #Variable.
	
	
	
	
]

{ #category : #definition }
PythonASTGenerator >> defineHierarchy [

	super defineHierarchy.

	assign <>-* variable.
	assign <>- target.

	body <>-* statementBlock.
	body <>-* classDefinition.
	body <>-* functionDefinition.

	classDefinition <>- constructor.
	classDefinition <>-* methodDefinition.
	classDefinition <>- statementBlock.
	classDefinition *- inheritance.

	constructor <>- statementBlock.
	constructor <>-* parameter.

	functionDefinition <>-* parameter.
	functionDefinition <>- statementBlock.
	functionDefinition <>- return.

	methodDefinition <>-* parameter.
	methodDefinition <>- statementBlock.
	methodDefinition <>- return.

	module <>-* import.
	module <>- body.

	return <>-* value.

	statementBlock <>-* assign.
	statementBlock <>-* invocation.

	target <>-* value.
	target <>-* invocation.

	value <>-* invocation
]

{ #category : #definition }
PythonASTGenerator >> defineProperties [

	super defineProperties.
	argument property: #name type: #String.
	argument property: #position type: #Number.
	argument property: #type type: #String.

	assign property: #lineNumber type: #String.

	classDefinition property: #name type: #String.
	classDefinition property: #lineNumber type: #String.

	constructor property: #lineNumber type: #String.

	functionDefinition property: #name type: #String.
	functionDefinition property: #lineNumber type: #String.

	import property: #asName type: #String.
	import property: #name type: #String.
	import property: #from type: #String.
	import property: #lineNumber type: #Number.

	inheritance property: #name type: #String.

	invocation property: #name type: #String.
	invocation property: #lineNumber type: #Number.

	methodDefinition property: #name type: #String.
	methodDefinition property: #lineNumber type: #Number.
	methodDefinition property: #isGetter type: #Boolean.
	methodDefinition property: #isSetter type: #Boolean.

	module property: #name type: #String.
	module property: #lineNumber type: #Number.

	parameter property: #name type: #String.
	parameter property: #defaultValue type: #String.
	parameter property: #positon type: #Number.

	return property: #lineNumber type: #Number.

	target property: #positon type: #Number.

	value property: #content type: #String.
	value property: #isTuple type: #Boolean.
	value property: #isDictionary type: #Boolean.
	value property: #isArray type: #Boolean.
	value property: #isUnWrap type: #Boolean.


	variable property: #name type: #String.
	variable property: #position type: #Number.
	variable property: #isTuple type: #Boolean
]
