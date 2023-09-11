Class {
	#name : #PyDotoptDottedNameNode,
	#superclass : #PyRootNode,
	#instVars : [
		'dots',
		'name'
	],
	#category : #'SmaCC_Python'
}

{ #category : #generated }
PyDotoptDottedNameNode >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitDotoptDottedName: self
]

{ #category : #generated }
PyDotoptDottedNameNode >> dots [
	^ dots
]

{ #category : #accessing }
PyDotoptDottedNameNode >> dots1: anObject [

	dots := anObject
]

{ #category : #generated }
PyDotoptDottedNameNode >> dots: aPyDotsNode [
	self dots notNil
		ifTrue: [ self dots parent: nil ].
	dots := aPyDotsNode.
	self dots notNil
		ifTrue: [ self dots parent: self ]
]

{ #category : #generated }
PyDotoptDottedNameNode >> name [
	^ name
]

{ #category : #accessing }
PyDotoptDottedNameNode >> name1: anObject [

	name := anObject
]

{ #category : #generated }
PyDotoptDottedNameNode >> name: aPyDottedNameNode [
	self name notNil
		ifTrue: [ self name parent: nil ].
	name := aPyDottedNameNode.
	self name notNil
		ifTrue: [ self name parent: self ]
]

{ #category : #generated }
PyDotoptDottedNameNode >> nodeVariables [
	^ #(#name #dots)
]
