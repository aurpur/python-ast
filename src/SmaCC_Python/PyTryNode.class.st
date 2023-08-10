Class {
	#name : #PyTryNode,
	#superclass : #PyRootNode,
	#instVars : [
		'tryToken',
		'colonTokens',
		'finallyToken',
		'else',
		'clauses',
		'finally',
		'statements',
		'nEWLINETokens',
		'iNDENTTokens',
		'dEDENTTokens'
	],
	#category : #'SmaCC_Python'
}

{ #category : #generated }
PyTryNode >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitTry: self
]

{ #category : #generated }
PyTryNode >> clauses [
	^ clauses
]

{ #category : #accessing }
PyTryNode >> clauses1: anObject [

	clauses := anObject
]

{ #category : #generated }
PyTryNode >> clauses: anOrderedCollection [
	self setParents: self clauses to: nil.
	clauses := anOrderedCollection.
	self setParents: self clauses to: self
]

{ #category : #generated }
PyTryNode >> colonTokens [
	^ colonTokens
]

{ #category : #generated }
PyTryNode >> colonTokens: anOrderedCollection [
	colonTokens := anOrderedCollection
]

{ #category : #generated }
PyTryNode >> compositeNodeVariables [
	^ #(#statements #clauses)
]

{ #category : #generated }
PyTryNode >> compositeTokenVariables [
	^ #(#colonTokens #nEWLINETokens #iNDENTTokens #dEDENTTokens)
]

{ #category : #generated }
PyTryNode >> dEDENTTokens [
	^ dEDENTTokens
]

{ #category : #generated }
PyTryNode >> dEDENTTokens: anOrderedCollection [
	dEDENTTokens := anOrderedCollection
]

{ #category : #generated }
PyTryNode >> else [
	^ else
]

{ #category : #accessing }
PyTryNode >> else1: anObject [

	else := anObject
]

{ #category : #generated }
PyTryNode >> else: aPyElseNode [
	self else notNil
		ifTrue: [ self else parent: nil ].
	else := aPyElseNode.
	self else notNil
		ifTrue: [ self else parent: self ]
]

{ #category : #generated }
PyTryNode >> finally [
	^ finally
]

{ #category : #accessing }
PyTryNode >> finally1: anObject [

	finally := anObject
]

{ #category : #generated }
PyTryNode >> finally: aPyFinallyNode [
	self finally notNil
		ifTrue: [ self finally parent: nil ].
	finally := aPyFinallyNode.
	self finally notNil
		ifTrue: [ self finally parent: self ]
]

{ #category : #generated }
PyTryNode >> finallyToken [
	^ finallyToken
]

{ #category : #generated }
PyTryNode >> finallyToken: aSmaCCToken [
	finallyToken := aSmaCCToken
]

{ #category : #generated }
PyTryNode >> iNDENTTokens [
	^ iNDENTTokens
]

{ #category : #generated }
PyTryNode >> iNDENTTokens: anOrderedCollection [
	iNDENTTokens := anOrderedCollection
]

{ #category : #'generated-initialize-release' }
PyTryNode >> initialize [
	super initialize.
	colonTokens := OrderedCollection new: 2.
	statements := OrderedCollection new: 2.
	nEWLINETokens := OrderedCollection new: 2.
	iNDENTTokens := OrderedCollection new: 2.
	dEDENTTokens := OrderedCollection new: 2.
	clauses := OrderedCollection new: 2.
]

{ #category : #generated }
PyTryNode >> nEWLINETokens [
	^ nEWLINETokens
]

{ #category : #generated }
PyTryNode >> nEWLINETokens: anOrderedCollection [
	nEWLINETokens := anOrderedCollection
]

{ #category : #generated }
PyTryNode >> nodeVariables [
	^ #(#else #finally)
]

{ #category : #generated }
PyTryNode >> statements [
	^ statements
]

{ #category : #accessing }
PyTryNode >> statements1: anObject [

	statements := anObject
]

{ #category : #generated }
PyTryNode >> statements: anOrderedCollection [
	self setParents: self statements to: nil.
	statements := anOrderedCollection.
	self setParents: self statements to: self
]

{ #category : #generated }
PyTryNode >> tokenVariables [
	^ #(#tryToken #finallyToken)
]

{ #category : #generated }
PyTryNode >> tryToken [
	^ tryToken
]

{ #category : #generated }
PyTryNode >> tryToken: aSmaCCToken [
	tryToken := aSmaCCToken
]
