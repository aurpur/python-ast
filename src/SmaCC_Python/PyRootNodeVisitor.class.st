Class {
	#name : #PyRootNodeVisitor,
	#superclass : #Object,
	#traits : 'TPyRootNodeVisitor',
	#classTraits : 'TPyRootNodeVisitor classTrait',
	#category : #'SmaCC_Python'
}

{ #category : #generated }
PyRootNodeVisitor >> visitSmaCCParseNode: aSmaCCParseNode [
	^ self acceptNodes: aSmaCCParseNode sortedChildren.
	
]
