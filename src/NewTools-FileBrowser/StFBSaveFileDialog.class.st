"
My responsibility is to provide dialog for SAVING files.
"
Class {
	#name : #StFBSaveFileDialog,
	#superclass : #StFBFileDialogPresenter,
	#instVars : [
		'extensionMather',
		'currentDirectory',
		'nameText',
		'confirmButton'
	],
	#classVars : [
		'Matcher'
	],
	#category : #'NewTools-FileBrowser-UI'
}

{ #category : #examples }
StFBSaveFileDialog class >> example [ 	
	<example>
		^ self new openDialogWithSpec
]

{ #category : #'as yet unclassified' }
StFBSaveFileDialog class >> exampleExtension [
	<example>
	^ self extension: '*.jpg'
]

{ #category : #accessing }
StFBSaveFileDialog class >> extension: aExtensionMatcher [
	"example 
		you want to save png File 
			FDSaveFileDialog extension: 'jpg'
	"

	^ self new
		extension: aExtensionMatcher;
		openDialogWithSpec;
		yourself
]

{ #category : #'class initialization' }
StFBSaveFileDialog class >> initialize [ 
	Matcher := '*'
]

{ #category : #'accessing - ui' }
StFBSaveFileDialog >> confirmLabel [

	^ 'Save'
]

{ #category : #initialization }
StFBSaveFileDialog >> connectPresenters [
	| ec |

	super connectPresenters.
	(ec := EntryCompletion new)
		dataSourceBlock: [ :text | fileNavigationSystem currentDirectory children collect: #basename ];
		filterBlock: [ :opt :text |opt beginsWith: text ].
	fileNavigationSystem nameText entryCompletion: ec
]

{ #category : #'api-customization' }
StFBSaveFileDialog >> extension: anExtensionMatcher [
	extensionMather := anExtensionMatcher
]

{ #category : #'accessing - ui' }
StFBSaveFileDialog >> initialTitle [
	^ 'Save As'
]

{ #category : #initialization }
StFBSaveFileDialog >> initialize [
	super initialize.
	extensionMather := Matcher
]

{ #category : #accessing }
StFBSaveFileDialog >> selectedEntry [
	| entry proceed |
	entry := fileNavigationSystem currentDirectory /fileNavigationSystem nameText text.
	(fileNavigationSystem nameText text includes: extensionMather)
		ifFalse: [ entry := entry
				, ((extensionMather copyReplaceAll: '*' with: '') ) ].
	proceed := false.
	entry exists
		ifTrue: [ proceed := UIManager default
				proceed:
					('File named "{1}" already exists. Do you want to overwrite it?'
						format: {entry printString}) ].
	^ proceed
		ifTrue: [ entry ]
		ifFalse: [ nil ]
]
