Class {
	#name : #PyPowerNode,
	#superclass : #PyRootNode,
	#instVars : [
		'atom',
		'trailers',
		'timesTimesToken',
		'factor'
	],
	#category : #'SmaCC_Python'
}

{ #category : #generated }
PyPowerNode >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitPower: self
]

{ #category : #generated }
PyPowerNode >> atom [
	^ atom
]

{ #category : #accessing }
PyPowerNode >> atom1: anObject [

	atom := anObject
]

{ #category : #generated }
PyPowerNode >> atom: aPyRootNode [
	self atom notNil
		ifTrue: [ self atom parent: nil ].
	atom := aPyRootNode.
	self atom notNil
		ifTrue: [ self atom parent: self ]
]

{ #category : #generated }
PyPowerNode >> compositeNodeVariables [
	^ #(#trailers)
]

{ #category : #generated }
PyPowerNode >> factor [
	^ factor
]

{ #category : #accessing }
PyPowerNode >> factor1: anObject [

	factor := anObject
]

{ #category : #generated }
PyPowerNode >> factor: aPyRootNode [
	self factor notNil
		ifTrue: [ self factor parent: nil ].
	factor := aPyRootNode.
	self factor notNil
		ifTrue: [ self factor parent: self ]
]

{ #category : #'generated-initialize-release' }
PyPowerNode >> initialize [
	super initialize.
	trailers := OrderedCollection new: 2.
]

{ #category : #generated }
PyPowerNode >> nodeVariables [
	^ #(#atom #factor)
]

{ #category : #generated }
PyPowerNode >> timesTimesToken [
	^ timesTimesToken
]

{ #category : #generated }
PyPowerNode >> timesTimesToken: aSmaCCToken [
	timesTimesToken := aSmaCCToken
]

{ #category : #generated }
PyPowerNode >> tokenVariables [
	^ #(#timesTimesToken)
]

{ #category : #generated }
PyPowerNode >> trailers [
	^ trailers
]

{ #category : #accessing }
PyPowerNode >> trailers1: anObject [

	trailers := anObject
]

{ #category : #generated }
PyPowerNode >> trailers: anOrderedCollection [
	self setParents: self trailers to: nil.
	trailers := anOrderedCollection.
	self setParents: self trailers to: self
]
