Class {
	#name : #PyDecoratedNode,
	#superclass : #PyRootNode,
	#instVars : [
		'decorators',
		'classdef',
		'funcdef'
	],
	#category : #'SmaCC_Python'
}

{ #category : #generated }
PyDecoratedNode >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitDecorated: self
]

{ #category : #generated }
PyDecoratedNode >> classdef [
	^ classdef
]

{ #category : #accessing }
PyDecoratedNode >> classdef1: anObject [

	classdef := anObject
]

{ #category : #generated }
PyDecoratedNode >> classdef: aPyClassdefNode [
	self classdef notNil
		ifTrue: [ self classdef parent: nil ].
	classdef := aPyClassdefNode.
	self classdef notNil
		ifTrue: [ self classdef parent: self ]
]

{ #category : #generated }
PyDecoratedNode >> decorators [
	^ decorators
]

{ #category : #accessing }
PyDecoratedNode >> decorators1: anObject [

	decorators := anObject
]

{ #category : #generated }
PyDecoratedNode >> decorators: aPyDecoratorsNode [
	self decorators notNil
		ifTrue: [ self decorators parent: nil ].
	decorators := aPyDecoratorsNode.
	self decorators notNil
		ifTrue: [ self decorators parent: self ]
]

{ #category : #generated }
PyDecoratedNode >> funcdef [
	^ funcdef
]

{ #category : #accessing }
PyDecoratedNode >> funcdef1: anObject [

	funcdef := anObject
]

{ #category : #generated }
PyDecoratedNode >> funcdef: aPyFuncdefNode [
	self funcdef notNil
		ifTrue: [ self funcdef parent: nil ].
	funcdef := aPyFuncdefNode.
	self funcdef notNil
		ifTrue: [ self funcdef parent: self ]
]

{ #category : #generated }
PyDecoratedNode >> nodeVariables [
	^ #(#decorators #classdef #funcdef)
]
