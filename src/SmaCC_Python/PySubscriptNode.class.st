Class {
	#name : #PySubscriptNode,
	#superclass : #PyRootNode,
	#instVars : [
		'periodTokens',
		'test',
		'colonToken',
		'test2',
		'slice'
	],
	#category : #'SmaCC_Python'
}

{ #category : #generated }
PySubscriptNode >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitSubscript: self
]

{ #category : #generated }
PySubscriptNode >> colonToken [
	^ colonToken
]

{ #category : #generated }
PySubscriptNode >> colonToken: aSmaCCToken [
	colonToken := aSmaCCToken
]

{ #category : #generated }
PySubscriptNode >> compositeTokenVariables [
	^ #(#periodTokens)
]

{ #category : #'generated-initialize-release' }
PySubscriptNode >> initialize [
	super initialize.
	periodTokens := OrderedCollection new: 2.
]

{ #category : #generated }
PySubscriptNode >> nodeVariables [
	^ #(#test #test2 #slice)
]

{ #category : #generated }
PySubscriptNode >> periodTokens [
	^ periodTokens
]

{ #category : #generated }
PySubscriptNode >> periodTokens: anOrderedCollection [
	periodTokens := anOrderedCollection
]

{ #category : #generated }
PySubscriptNode >> slice [
	^ slice
]

{ #category : #accessing }
PySubscriptNode >> slice1: anObject [

	slice := anObject
]

{ #category : #generated }
PySubscriptNode >> slice: aPySliceopNode [
	self slice notNil
		ifTrue: [ self slice parent: nil ].
	slice := aPySliceopNode.
	self slice notNil
		ifTrue: [ self slice parent: self ]
]

{ #category : #generated }
PySubscriptNode >> test [
	^ test
]

{ #category : #accessing }
PySubscriptNode >> test1: anObject [

	test := anObject
]

{ #category : #generated }
PySubscriptNode >> test2 [
	^ test2
]

{ #category : #accessing }
PySubscriptNode >> test21: anObject [

	test2 := anObject
]

{ #category : #generated }
PySubscriptNode >> test2: aPyRootNode [
	self test2 notNil
		ifTrue: [ self test2 parent: nil ].
	test2 := aPyRootNode.
	self test2 notNil
		ifTrue: [ self test2 parent: self ]
]

{ #category : #generated }
PySubscriptNode >> test: aPyRootNode [
	self test notNil
		ifTrue: [ self test parent: nil ].
	test := aPyRootNode.
	self test notNil
		ifTrue: [ self test parent: self ]
]

{ #category : #generated }
PySubscriptNode >> tokenVariables [
	^ #(#colonToken)
]
