Class {
	#name : #FamixPythonGenerator,
	#superclass : #FamixBasicInfrastructureGenerator,
	#instVars : [
		'package',
		'containerEntity',
		'class',
		'type',
		'attribute',
		'method',
		'parameter',
		'primitiveType',
		'reference',
		'invocation',
		'localVariable',
		'access',
		'implicitVariable',
		'import',
		'inheritance',
		'function',
		'module'
	],
	#category : #'Famix-Python-Generator'
}

{ #category : #accessing }
FamixPythonGenerator class >> packageName [

	^ #'Famix-Python-Entities'
]

{ #category : #accessing }
FamixPythonGenerator class >> prefix [

	^ #FamixPython
]

{ #category : #definition }
FamixPythonGenerator >> defineClasses [

	super defineClasses.
	access := builder newClassNamed: #Access.
	attribute := builder newClassNamed: #Attribute.
	class := builder newClassNamed: #Class.
	containerEntity := builder newAbstractClassNamed: #ContainerEntity.
	function := builder newClassNamed: #Function.
	implicitVariable := builder newClassNamed: #ImplicitVariable.
	import := builder newClassNamed: #Import.
	inheritance := builder newClassNamed: #Inheritance.
	invocation := builder newClassNamed: #Invocation.
	localVariable := builder newClassNamed: #LocalVariable.
	method := builder newClassNamed: #Method.
	module := builder newClassNamed: #Module.
	package := builder newClassNamed: #Package.
	parameter := builder newClassNamed: #Parameter.
	primitiveType := builder newClassNamed: #PrimitiveType.
	reference := builder newClassNamed: #Reference.
	type := builder newClassNamed: #Type
]

{ #category : #definition }
FamixPythonGenerator >> defineHierarchy [

	super defineHierarchy.
	access --|> #TAccess.
	
	attribute --|> namedEntity.
	attribute --|> #TAttribute.
	attribute --|> #TInvocationsReceiver.
	attribute --|> #TWithComments.

	class --|> type.
	class --|> #TClass.
	class --|> #TWithImports.
	class --|> #TImportable.

	containerEntity --|> namedEntity.
	containerEntity --|> #TWithClasses.
	
	function --|> containerEntity.
	function --|> #TFunction.
	function --|> #TWithComments.
	function --|> #TInvocable.
	function --|> #TImportable.
	function --|> #TWithImplicitVariables.
	
	implicitVariable --|> namedEntity.
	implicitVariable --|> #TImplicitVariable.
	implicitVariable --|> #TInvocationsReceiver.

	import --|> #TImport.
	
	inheritance --|> #TInheritance.

	invocation --|> #TInvocation.

	localVariable --|> namedEntity.
	localVariable --|> #TLocalVariable.
	localVariable --|> #TCanBeFinal.
	localVariable --|> #TInvocationsReceiver.
	localVariable --|> #TWithComments.

	method --|> containerEntity.
	method --|> #TMethod.
	method --|> #TWithComments.
	method --|> #TImportable.
	
	module --|> containerEntity.
	module --|> #TPackageable.
	module --|> #TWithComments.
	module --|> #TImportable.
	module --|> #TWithFunctions.

	namedEntity --|> #TInvocationsReceiver.
	namedEntity --|> #TWithAnnotationInstances.
	namedEntity --|> #TEntityMetaLevelDependency.
	namedEntity --|> sourcedEntity.

	package --|> containerEntity.
	package --|> #TPackage.
	package --|> #TPackageable.
	package --|> #TWithComments.
	package --|> #TImportable.

	parameter --|> namedEntity.
	parameter --|> #TParameter.
	parameter --|> #TWithComments.

	primitiveType --|> type.
	primitiveType --|> #TPrimitiveType.

	reference --|> #TReference.

	type --|> containerEntity.
	type --|> #TType.
	type --|> #TWithMethods
]

{ #category : #definition }
FamixPythonGenerator >> defineProperties [

	super defineProperties.
	(import property: #fromName type: #String) comment: 'from a import b
	fromName is a'.

	(import property: #entityName type: #String) comment:
		'from a import b
	entityName is b'.

	(import property: #asName type: #String) comment: 'import b as c
	asName is c'.
]
