Class {
	#name : #PyVBarExprNode,
	#superclass : #PyRootNode,
	#instVars : [
		'one',
		'orToken',
		'two'
	],
	#category : #'SmaCC_Python'
}

{ #category : #generated }
PyVBarExprNode >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitVBarExpr: self
]

{ #category : #generated }
PyVBarExprNode >> nodeVariables [
	^ #(#one #two)
]

{ #category : #generated }
PyVBarExprNode >> one [
	^ one
]

{ #category : #accessing }
PyVBarExprNode >> one1: anObject [

	one := anObject
]

{ #category : #generated }
PyVBarExprNode >> one: aPyRootNode [
	self one notNil
		ifTrue: [ self one parent: nil ].
	one := aPyRootNode.
	self one notNil
		ifTrue: [ self one parent: self ]
]

{ #category : #generated }
PyVBarExprNode >> orToken [
	^ orToken
]

{ #category : #generated }
PyVBarExprNode >> orToken: aSmaCCToken [
	orToken := aSmaCCToken
]

{ #category : #generated }
PyVBarExprNode >> tokenVariables [
	^ #(#orToken)
]

{ #category : #generated }
PyVBarExprNode >> two [
	^ two
]

{ #category : #accessing }
PyVBarExprNode >> two1: anObject [

	two := anObject
]

{ #category : #generated }
PyVBarExprNode >> two: aPyRootNode [
	self two notNil
		ifTrue: [ self two parent: nil ].
	two := aPyRootNode.
	self two notNil
		ifTrue: [ self two parent: self ]
]
