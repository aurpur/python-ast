Class {
	#name : #PyArgumentNode,
	#superclass : #PyRootNode,
	#instVars : [
		'equalToken',
		'test',
		'comp',
		'test2'
	],
	#category : #'SmaCC_Python'
}

{ #category : #generated }
PyArgumentNode >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitArgument: self
]

{ #category : #generated }
PyArgumentNode >> comp [
	^ comp
]

{ #category : #accessing }
PyArgumentNode >> comp1: anObject [

	comp := anObject
]

{ #category : #generated }
PyArgumentNode >> comp: aPyCompForNode [
	self comp notNil
		ifTrue: [ self comp parent: nil ].
	comp := aPyCompForNode.
	self comp notNil
		ifTrue: [ self comp parent: self ]
]

{ #category : #generated }
PyArgumentNode >> equalToken [
	^ equalToken
]

{ #category : #generated }
PyArgumentNode >> equalToken: aSmaCCToken [
	equalToken := aSmaCCToken
]

{ #category : #generated }
PyArgumentNode >> nodeVariables [
	^ #(#test #comp #test2)
]

{ #category : #generated }
PyArgumentNode >> test [
	^ test
]

{ #category : #accessing }
PyArgumentNode >> test1: anObject [

	test := anObject
]

{ #category : #generated }
PyArgumentNode >> test2 [
	^ test2
]

{ #category : #accessing }
PyArgumentNode >> test21: anObject [

	test2 := anObject
]

{ #category : #generated }
PyArgumentNode >> test2: aPyRootNode [
	self test2 notNil
		ifTrue: [ self test2 parent: nil ].
	test2 := aPyRootNode.
	self test2 notNil
		ifTrue: [ self test2 parent: self ]
]

{ #category : #generated }
PyArgumentNode >> test: aPyRootNode [
	self test notNil
		ifTrue: [ self test parent: nil ].
	test := aPyRootNode.
	self test notNil
		ifTrue: [ self test parent: self ]
]

{ #category : #generated }
PyArgumentNode >> tokenVariables [
	^ #(#equalToken)
]
