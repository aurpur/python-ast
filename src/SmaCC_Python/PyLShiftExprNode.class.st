Class {
	#name : #PyLShiftExprNode,
	#superclass : #PyRootNode,
	#instVars : [
		'one',
		'lessThanLessThanToken',
		'two'
	],
	#category : #'SmaCC_Python'
}

{ #category : #generated }
PyLShiftExprNode >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitLShiftExpr: self
]

{ #category : #generated }
PyLShiftExprNode >> lessThanLessThanToken [
	^ lessThanLessThanToken
]

{ #category : #generated }
PyLShiftExprNode >> lessThanLessThanToken: aSmaCCToken [
	lessThanLessThanToken := aSmaCCToken
]

{ #category : #generated }
PyLShiftExprNode >> nodeVariables [
	^ #(#one #two)
]

{ #category : #generated }
PyLShiftExprNode >> one [
	^ one
]

{ #category : #accessing }
PyLShiftExprNode >> one1: anObject [

	one := anObject
]

{ #category : #generated }
PyLShiftExprNode >> one: aPyRootNode [
	self one notNil
		ifTrue: [ self one parent: nil ].
	one := aPyRootNode.
	self one notNil
		ifTrue: [ self one parent: self ]
]

{ #category : #generated }
PyLShiftExprNode >> tokenVariables [
	^ #(#lessThanLessThanToken)
]

{ #category : #generated }
PyLShiftExprNode >> two [
	^ two
]

{ #category : #accessing }
PyLShiftExprNode >> two1: anObject [

	two := anObject
]

{ #category : #generated }
PyLShiftExprNode >> two: aPyRootNode [
	self two notNil
		ifTrue: [ self two parent: nil ].
	two := aPyRootNode.
	self two notNil
		ifTrue: [ self two parent: self ]
]
