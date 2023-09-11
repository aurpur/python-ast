Extension { #name : #CNNFamixLayer }

{ #category : #'*DL-Python' }
CNNFamixLayer >> hasDownSampling [

^ poolings isNotEmpty 
]
