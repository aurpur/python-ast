Class {
	#name : #PyIfTestNode,
	#superclass : #PyRootNode,
	#instVars : [
		'ifToken',
		'if',
		'elseToken',
		'else',
		'or'
	],
	#category : #'SmaCC_Python'
}

{ #category : #generated }
PyIfTestNode >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitIfTest: self
]

{ #category : #generated }
PyIfTestNode >> else [
	^ else
]

{ #category : #accessing }
PyIfTestNode >> else1: anObject [

	else := anObject
]

{ #category : #generated }
PyIfTestNode >> else: aPyRootNode [
	self else notNil
		ifTrue: [ self else parent: nil ].
	else := aPyRootNode.
	self else notNil
		ifTrue: [ self else parent: self ]
]

{ #category : #generated }
PyIfTestNode >> elseToken [
	^ elseToken
]

{ #category : #generated }
PyIfTestNode >> elseToken: aSmaCCToken [
	elseToken := aSmaCCToken
]

{ #category : #generated }
PyIfTestNode >> if [
	^ if
]

{ #category : #accessing }
PyIfTestNode >> if1: anObject [

	if := anObject
]

{ #category : #generated }
PyIfTestNode >> if: aPyRootNode [
	self if notNil
		ifTrue: [ self if parent: nil ].
	if := aPyRootNode.
	self if notNil
		ifTrue: [ self if parent: self ]
]

{ #category : #generated }
PyIfTestNode >> ifToken [
	^ ifToken
]

{ #category : #generated }
PyIfTestNode >> ifToken: aSmaCCToken [
	ifToken := aSmaCCToken
]

{ #category : #generated }
PyIfTestNode >> nodeVariables [
	^ #(#or #if #else)
]

{ #category : #generated }
PyIfTestNode >> or [
	^ or
]

{ #category : #accessing }
PyIfTestNode >> or1: anObject [

	or := anObject
]

{ #category : #generated }
PyIfTestNode >> or: aPyRootNode [
	self or notNil
		ifTrue: [ self or parent: nil ].
	or := aPyRootNode.
	self or notNil
		ifTrue: [ self or parent: self ]
]

{ #category : #generated }
PyIfTestNode >> tokenVariables [
	^ #(#ifToken #elseToken)
]
