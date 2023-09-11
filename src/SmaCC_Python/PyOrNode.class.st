Class {
	#name : #PyOrNode,
	#superclass : #PyRootNode,
	#instVars : [
		'one',
		'orToken',
		'two'
	],
	#category : #'SmaCC_Python'
}

{ #category : #generated }
PyOrNode >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitOr: self
]

{ #category : #generated }
PyOrNode >> nodeVariables [
	^ #(#one #two)
]

{ #category : #generated }
PyOrNode >> one [
	^ one
]

{ #category : #accessing }
PyOrNode >> one1: anObject [

	one := anObject
]

{ #category : #generated }
PyOrNode >> one: aPyRootNode [
	self one notNil
		ifTrue: [ self one parent: nil ].
	one := aPyRootNode.
	self one notNil
		ifTrue: [ self one parent: self ]
]

{ #category : #generated }
PyOrNode >> orToken [
	^ orToken
]

{ #category : #generated }
PyOrNode >> orToken: aSmaCCToken [
	orToken := aSmaCCToken
]

{ #category : #generated }
PyOrNode >> tokenVariables [
	^ #(#orToken)
]

{ #category : #generated }
PyOrNode >> two [
	^ two
]

{ #category : #accessing }
PyOrNode >> two1: anObject [

	two := anObject
]

{ #category : #generated }
PyOrNode >> two: aPyRootNode [
	self two notNil
		ifTrue: [ self two parent: nil ].
	two := aPyRootNode.
	self two notNil
		ifTrue: [ self two parent: self ]
]
