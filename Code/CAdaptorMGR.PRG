#INCLUDE APP.h

DEFINE CLASS AdaptorMGR AS Custom OLEPUBLIC

	Name 										= "AdaptorMGR"
	ConnectionHandle				= -1
	DIMENSION	Adaptors[1,1]	= .F.
	AdaptorCount						= 0
	SQLConnection						= NULL

*!*		HIDDEN									SQLConnection AS SQLConnection

	HIDDEN									AddObject
	HIDDEN									AddProperty
	HIDDEN									BaseClass
	HIDDEN									Class
	HIDDEN									ClassLibrary
	HIDDEN									ControlCount
	HIDDEN									Controls
	HIDDEN									Destroy
*!*		HIDDEN									Error
	HIDDEN									Height
	HIDDEN									HelpContextID
	HIDDEN									Init
	HIDDEN									NewObject
	HIDDEN									Objects
	HIDDEN									Parent
	HIDDEN									ParentClass
	HIDDEN									Picture
	HIDDEN									ReadExpression
	HIDDEN									ReadMethod
	HIDDEN									RemoveObject
	HIDDEN									ResetToDefault
	HIDDEN									SaveAsClass
	HIDDEN									ShowWhatsThis
	HIDDEN									Tag
	HIDDEN									WhatsThisHelpID
	HIDDEN									Width
	HIDDEN									WriteExpression	
	HIDDEN									WriteMethod

	PROCEDURE GetDataAdaptor

		LParameters tsAdaptor As String
		Local loDataAdaptor, loAdaptor, lbMatch, lnAdaptor
		
		*//Default values
		lbMatch = .F.
		
*!*			strtofile(tsAdaptor, "\temp\adaptors.txt", 1)
		
		*//Loop through existing adaptors
		For lnAdaptor = 1 To This.AdaptorCount
			If Upper(This.Adaptors[lnAdaptor, 1]) == Upper(tsAdaptor)
*!*					strtofile(" (reused)", "\temp\adaptors.txt", 1)
				loDataAdaptor = This.Adaptors[lnAdaptor, 2]
				lbMatch = .T.
				Exit
			Endif
		EndFor
		
		*//Did we find a match?
		If !lbMatch
		
			*//Instantiate an adaptor
			loDataAdaptor = CreateObject(tsAdaptor)
			
			*//Link it to the adaptor manager
			loDataAdaptor.oMgr = This
			
			*//Add it to our collection
			This.AdaptorCount = This.AdaptorCount + 1 			
			lnAdaptor = This.AdaptorCount
			Dimension This.Adaptors[lnAdaptor, 2]
			This.Adaptors[lnAdaptor, 1] = tsAdaptor
			This.Adaptors[lnAdaptor, 2] = loDataAdaptor
		
*!*				strtofile(" (new)", "\temp\adaptors.txt", 1)

		Endif

*!*			strtofile(CRLF, "\temp\adaptors.txt", 1)
		
		Return loDataAdaptor
		
	ENDPROC
	
	*________________________________________________________________________________
	*________________________________________________________________________________
	*--
	*--
	*-- Return connection Handle, If connection is not open then open it
	*--
	*--
	*________________________________________________________________________________
	Protected Procedure ConnectionHandle_Access
	LOCAL liConn AS Integer
	
		liConn = This.ConnectionHandle 
	
		If (liConn < 0) then

			If (TYPE('This.SQLConnection.ConnectionHandle') <> T_NUMERIC) Then

				SET PROCEDURE TO cSQLConnection ADDI
				This.SqlConnection = CREATEOBJECT("SQLConnection")

			Endif

			liConn = This.SQLConnection.ConnectionHandle
			
*!*				This.SQLConnection.Destroy
			This.SQLConnection = NULL
			This.ConnectionHandle = liConn

		EndIf

		Return liConn 
	EndProc

	*________________________________________________________________________________
	*________________________________________________________________________________
	*--
	*-- Disconnect the data adaptor manager shared connection.
	*--
	*-- This could arguably be moved to the SQLConnection class.
	*________________________________________________________________________________
	Procedure Disconnect
	LOCAL liConn AS Integer
	
	liConn = This.ConnectionHandle
	
	If (liConn > 0)
		= SQLDISCONNECT(liConn)
		This.ConnectionHandle = -1
	Endif

	EndProc
	
	*________________________________________________________________________________
	*________________________________________________________________________________
	*--
	*-- Clears the registered data adaptors
	*--
	*________________________________________________________________________________
	Procedure Clear
	LOCAL liAdaptor As Integer
	
	For liAdaptor = 1 To This.AdaptorCount
	
		This.Adaptors[liAdaptor, 1] = ""
		This.Adaptors[liAdaptor, 2] = .F.
	
	EndFor
	
	This.AdaptorCount = 0
	
	Dimension This.Adaptors[1, 1]
				

*!*			IF liConn >0
*!*				strtofile("Destroy - Disconnect - Pre" + CRLF, "\temp\adaptors.txt", 1)
*!*				=SQLDISCONNECT(liConn)
*!*				strtofile("Destroy - Disconnect - Post" + CRLF, "\temp\adaptors.txt", 1)
*!*			EndIF
		
	EndProc

	*________________________________________________________________________________
	*________________________________________________________________________________
	*--
	*--
	*--
	*________________________________________________________________________________
	Procedure Destroy
	LOCAL liConn AS Integer, ;
				liAdaptor As Integer
				
*!*			strtofile("Destroy - Start" + CRLF, "\temp\adaptors.txt", 1)
		
		liConn = This.ConnectionHandle

*!*			IF liConn >0
*!*				strtofile("Destroy - Disconnect - Pre" + CRLF, "\temp\adaptors.txt", 1)
*!*				=SQLDISCONNECT(liConn)
*!*				strtofile("Destroy - Disconnect - Post" + CRLF, "\temp\adaptors.txt", 1)
*!*			EndIF

		This.SQLConnection = .F.
		This.ConnectionHandle = -1
		
*!*			strtofile("Destroy - DoDefault - Pre" + CRLF, "\temp\adaptors.txt", 1)
		=DODEFAULT()
*!*			strtofile("Destroy - DoDefault - Post" + CRLF, "\temp\adaptors.txt", 1)
		
	EndProc

	*________________________________________________________________________________
	*________________________________________________________________________________
	*--
	*--
	*--
	*________________________________________________________________________________
	Procedure SQLGetProp
		LParameters tsSetting As String
		Local liConn AS Integer, lxResult As Variant
		
		liConn = This.ConnectionHandle

		If (liConn > 0)
			lxResult = SQLGetProp(liConn, tsSetting)
		Endif
		
		Return lxResult	
	
	EndProc

ENDDEFINE