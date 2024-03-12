#INCLUDE APP.h

Define Class SQLData AS Session

	HIDDEN SQLConnection AS SQLConnection

	Name										= "SQLData"
	oHost										= NULL
	oMgr										= NULL
	ConnectionHandle				= -1
	
	*//The following properties control the default stored procedure naming conventions
	StoredProcDeletePrefix	= ""
	StoredProcDeleteSuffix	= "Delete"
	StoredProcGetPrefix			= ""
	StoredProcGetSuffix			= "Get"
	StoredProcPutPrefix			= ""
	StoredProcPutSuffix			= "Put"

	
	ReadMode								= READMODE_SINGLE

	PrimaryKeyFieldName			= ""

	PROTECTED ReadListDataSource
	PROTECTED ReadListDataSourceType
	ReadListDataSource			= ""
	ReadListDataSourceType	= DATASOURCE_TYPE_STOREDPROCEDURE

	PROTECTED ReadItemDataSource
	PROTECTED ReadItemDataSourceType
	ReadItemDataSource			= ""
	ReadItemDataSourceType	= DATASOURCE_TYPE_STOREDPROCEDURE

	PROTECTED ReadDataSource
	PROTECTED ReadDataSourceType
	ReadDataSource					= ""
	ReadDataSourceType			= DATASOURCE_TYPE_STOREDPROCEDURE

	PROTECTED WriteDataSource
	PROTECTED WriteDataSourceType
	WriteDataSource					= ""
	WriteDataSourceType			= DATASOURCE_TYPE_STOREDPROCEDURE

	PROTECTED DeleteDataSource
	PROTECTED DeleteDataSourceType
	DeleteDataSource				= ""
	DeleteDataSourceType		= DATASOURCE_TYPE_STOREDPROCEDURE

*	Add Object Hidden SQLConnection AS SQLConnection && WITH oHost = This


	*________________________________________________________________________________
	*________________________________________________________________________________
	*--
	*--
	*--
	*________________________________________________________________________________
	FUNCTION ReadListDataSource_Access() AS String
		LOCAL lsListDataSource AS String
	
		lsListDataSource = This.ReadListDataSource
		
		IF TYPE('This.ReadListDataSource') <> T_Character  ;
			OR IsNull(lsListDataSource) ;
			OR EMPTY(lsListDataSource) ;
			Then
			
			lsListDataSource = "usp_List" + This.Name
			
			This.ReadListDataSource = lsListDataSource 
			
		Endif
	
		RETURN lsListDataSource

	EndFunc


	*________________________________________________________________________________
	*________________________________________________________________________________
	*--
	*--
	*--
	*________________________________________________________________________________
	FUNCTION ReadItemDataSource_Access() AS String
		LOCAL lsItemDataSource AS String
	
		lsItemDataSource = This.ReadItemDataSource
		
		IF TYPE('This.ReadItemDataSource') <> T_Character  ;
			OR IsNull(lsItemDataSource) ;
			OR EMPTY(lsItemDataSource) ;
			Then
			
			lsItemDataSource = This.StoredProcGetPrefix + This.Name + This.StoredProcGetSuffix
			
			This.ReadItemDataSource = lsItemDataSource 
			
		Endif
	
		RETURN lsItemDataSource

	EndFunc


	*________________________________________________________________________________
	*________________________________________________________________________________
	*--
	*--
	*--
	*________________________________________________________________________________
	FUNCTION ReadDataSource_Access() AS String
		LOCAL lsReadDataSource AS String
	
		DO CASE 
			CASE (This.ReadMode = READMODE_SINGLE) 
				lsReadDataSource = This.ReadItemDataSource
			CASE (This.ReadMode = READMODE_LIST) 
				lsReadDataSource = This.ReadListDataSource
			OTHERWISE
				.Error(ERROR(), PROGRAM(),LINENO(1))
		EndCase
		
		This.ReadDataSource = lsReadDataSource  
	
		RETURN lsReadDataSource

	EndFunc



	*________________________________________________________________________________
	*________________________________________________________________________________
	*--
	*--
	*--
	*________________________________________________________________________________
	FUNCTION WriteDataSource_Access() AS String
		LOCAL lsReadDataSource AS String
	
		lsWriteDataSource = This.WriteDataSource
		
		IF TYPE('This.WriteDataSource') <> T_Character  ;
			OR IsNull(lsWriteDataSource) ;
			OR EMPTY(lsWriteDataSource) ;
			Then
			
			lsWriteDataSource = This.StoredProcPutPrefix + This.Name + This.StoredProcPutSuffix
			
			This.WriteDataSource = lsWriteDataSource
			
		Endif
		
		RETURN lsWriteDataSource

	EndFunc


	*________________________________________________________________________________
	*________________________________________________________________________________
	*--
	*--
	*--
	*________________________________________________________________________________
	FUNCTION DeleteDataSource_Access() AS String
		LOCAL lsDeleteDataSource AS String
	
		lsDeleteDataSource = This.DeleteDataSource
		
		IF TYPE('This.DeleteDataSource') <> T_Character  ;
			OR IsNull(lsDeleteDataSource) ;
			OR EMPTY(lsDeleteDataSource) ;
			Then
			
			lsDeleteDataSource = This.StoredProcDeletePrefix + This.Name + This.StoredProcDeleteSuffix
			
			This.DeleteDataSource = lsDeleteDataSource
			
		Endif
		
		RETURN lsDeleteDataSource

	EndFunc




	*________________________________________________________________________________
	*________________________________________________________________________________
	*--
	*--
	*--
	*________________________________________________________________________________
	Protected Procedure GetXMLFromAlias(tsAlias)
			Local lsXML
			lsXML = ""

			If !Empty(tsAlias) AND Used(tsAlias)
				CursorToXML(tsAlias, "lsXML", 1, 0+2+4+8+16, 0, "1", "", tsAlias)

				*//Eliminate bad characters found in RecordTrak data.
				FOR i = 0 TO 8 STEP 1
				lsXML = STRTRAN(lsXML, chr(i), "")
				ENDFOR
				lsXML = STRTRAN(lsXML, chr(11), "")
				lsXML = STRTRAN(lsXML, chr(12), "")
				FOR i = 14 TO 31 STEP 1
				lsXML = STRTRAN(lsXML, chr(i), "")
				ENDFOR
			EndIf

			Return lsXML
		
	EndProc


	*________________________________________________________________________________
	*________________________________________________________________________________
	*--
	*--
	*-- Custom Sql Exec
	*--
	*--
	*________________________________________________________________________________
	Protected Procedure ExecuteSQL(tsSQL AS String, ;
																	tsAlias AS String) AS Boolean
		Local liExec 		AS Integer, ;
					liConn 		AS Integer, ;
					lbRetval 	AS Boolean
					
		liConn = this.oHost.ConnectionHandle

		If Pcount() > 1 and Vartype(tsAlias) = T_CHARACTER
			liExec = SQLExec(liConn, tsSQl, tsAlias)
		Else
			liExec = SQLExec(liConn, tsSQl)
		endif
		IF liConn >0
		   =SQLDISCONNECT(liConn)
		EndIF
		lbRetval = (liExec > 0)


		IF NOT lbRetval Then
			*-- Throw the error
			This.Error(ERROR(), PROGRAM(), LINENO(1))
		EndIf

		Return lbRetval
	EndProc



	*________________________________________________________________________________
	*________________________________________________________________________________
	*--
	*-- Default Generic method for returning a data as xml 
	*-- based on a xml filter string
	*--
	*-- Returns xml string
	*--
	*________________________________________________________________________________
	FUNCTION GetXMLData(tsFilter AS String) AS String
	LOCAL lsRetval 					AS String, ;
				lsSQL 						AS String, ;
				liConn 						As Integer, ;
				liResultSetCount	AS Integer, ;
				liDataSourceType 	AS Integer

				
	STORE "" TO lsRetval				
	
	WITH This
		liConn 						= .ConnectionHandle
		liDataSourceType 	= .ReadDataSourceType
		
		*-- 
		IF PCOUNT() = 1 Then
			DO Case
					CASE (liDataSourceType = DATASOURCE_TYPE_STOREDPROCEDURE)
						lsSQL = "EXECUTE " + .ReadDataSource + " ?tsFilter "
					CASE (liDataSourceType = DATASOURCE_TYPE_TABLE)
						lsSQL = "SELECT * FROM " + .ReadDataSource + " WHERE ("  + .PrimaryKeyFieldName + " = ?tsFilter )"
					CASE (liDataSourceType = DATASOURCE_TYPE_VIEW)
						lsSQL = "SELECT * FROM " + .ReadDataSource  + " WHERE ("  + .PrimaryKeyFieldName + " = ?tsFilter )"
					CASE (liDataSourceType = DATASOURCE_TYPE_FUNCTION)
						lsSQL = "SELECT * FROM " + .ReadDataSource  + " (?tsFilter )"
					OTHERWISE
						.Error(ERROR(), PROGRAM(), LINENO(1))
					
			EndCase
		ELSE
			DO Case
					CASE (liDataSourceType = DATASOURCE_TYPE_STOREDPROCEDURE)
						lsSQL = "EXECUTE " + .ReadDataSource 
					CASE (liDataSourceType = DATASOURCE_TYPE_TABLE)
						lsSQL = "SELECT * FROM " + .ReadDataSource 
					CASE (liDataSourceType = DATASOURCE_TYPE_VIEW)
						lsSQL = "SELECT * FROM " + .ReadDataSource 
					CASE (liDataSourceType = DATASOURCE_TYPE_FUNCTION)
						lsSQL = "SELECT * FROM " + .ReadDataSource 
					OTHERWISE
						.Error(ERROR(), PROGRAM(), LINENO(1))
					
			EndCase
		
		EndIF

		*-- Execute the SQL AND get a count of 
		*-- the number of result sets returned
 		liResultSetCount = SQLEXEC(liConn, lsSQL)
		IF liConn >0
		   =SQLDISCONNECT(liConn)
		EndIF
		IF  (liResultSetCount >= 0)
			*-- Convert the Data Returned from SQL
			*-- into an xml string to returned to the client
			lsRetval = .SQLResultsToXML(liResultSetCount)
		Else
			.Error(ERROR(), PROGRAM(), LINENO(1))
		ENDIF
		
	EndWith
		
	RETURN lsRetval
		
	EndFunc


	*________________________________________________________________________________
	*________________________________________________________________________________
	*--
	*-- Default Generic method for returning a single record as xml 
	*-- based on a single primary Key
	*--
	*-- returns all rows if no key is passed 
	*-- 
	*-- Returns xml string
	*--
	*________________________________________________________________________________
	FUNCTION PutXMLData(tsXML AS String) AS String
											
	LOCAL lsRetval 					AS String, ;
				lsSQL 						AS String, ;
				liConn 						As Integer, ;
				liResultSetCount	AS Integer, ;
				liDataSourceType 	AS Integer
				
	STORE "" TO lsAlias, lsRetval				
	
	WITH This
		liConn 						= .ConnectionHandle
		liDataSourceType 	= .WriteDataSourceType
		
		IF ((PCOUNT() >= 1) AND (TYPE('tsXML') == T_CHARACTER)) Then
			DO Case
					CASE (liDataSourceType = DATASOURCE_TYPE_STOREDPROCEDURE)
						lsSQL = "EXECUTE " + .WriteDataSource  + " ?tsXML"
						lsSQL = lsSQL 
						
					OTHERWISE
						.Error(ERROR(), PROGRAM(), LINENO(1))
			EndCase
		ELSE
			.Error(ERROR(), PROGRAM(), LINENO(1))
		EndIF


		*-- Execute the SQL AND get a count of 
		*-- the number of result sets returned
		liResultSetCount = SQLEXEC(liConn, lsSQL)
		IF liConn >0
		   =SQLDISCONNECT(liConn)
		EndIF
		IF  (liResultSetCount >= 0)
			*-- Convert the Data Returned from SQL
			*-- into an xml string to returned to the client
			lsRetval = .SQLResultsToXML(liResultSetCount)
		Else
			.Error(ERROR(), PROGRAM(), LINENO(1))
		ENDIF
		
	EndWith
		
	RETURN lsRetval
		
	EndFunc


	*________________________________________________________________________________
	*________________________________________________________________________________
	*--
	*-- Default Generic method for deleting a single record based on a single 
	*-- primary key.
	*--
	*-- Returns xml string
	*--
	*________________________________________________________________________________
	FUNCTION DeleteXMLData(tsPrimaryKey As String, tsXML As String) AS String
											
	LOCAL lsRetval 					AS String, ;
				lsSQL 						AS String, ;
				liConn 						As Integer, ;
				liResultSetCount	AS Integer, ;
				liDataSourceType 	AS Integer
				
	STORE "" TO lsAlias, lsRetval				
	
	WITH This
		liConn 						= .ConnectionHandle
		
		IF ((PCOUNT() >= 1) AND (TYPE('tsPrimaryKey') == T_CHARACTER)) Then
				lsSQL = "EXECUTE " + .DeleteDataSource  + " ?tsPrimaryKey"
				
				*//Did we receive any XML?
				If (Type("tsXML") == T_CHARACTER) And !Empty(tsXML)
				
					*//Add to our SQL
					lsSQL = (lsSQL + ", ?tsXML")
				
				Endif
				
		ELSE
			.Error(ERROR(), PROGRAM(), LINENO(1))
		EndIF

		*-- Execute the SQL AND get a count of 
		*-- the number of result sets returned
		liResultSetCount = SQLEXEC(liConn, lsSQL)
		IF liConn >0
		   =SQLDISCONNECT(liConn)
		EndIF
		IF  (liResultSetCount >= 0)
			*-- Convert the Data Returned from SQL
			*-- into an xml string to returned to the client
			lsRetval = .SQLResultsToXML(liResultSetCount)
		Else
			.Error(ERROR(), PROGRAM(), LINENO(1))
		ENDIF
		
	EndWith
		
	RETURN lsRetval
		
	EndFunc

	*________________________________________________________________________________
	*________________________________________________________________________________
	FUNCTION GetItemBy(tiMode As Integer, txSearch As Variant) As String
	*--
	*--
	*--
	*________________________________________________________________________________
		LOCAL lsRetval 	AS String, ;
					lsSQL 		AS String, ;
					lsAlias 	AS String, ;
					liConn 		AS Integer, ;
					liStatus 	AS Integer
		
		lsRetval 		= ""
		lsSQL 			= "EXEC dbo." + This.StoredProcGetPrefix + This.Name + This.StoredProcGetSuffix + "By" + This.aGetItemBy[tiMode] + " ?txSearch"
		lsAlias  		= This.Name + "Item" 
		
		WITH This
			
			.CloseAlias(lsAlias)
		
			liConn = .ConnectionHandle

			liStatus = SQLEXEC(liConn, lsSQL, lsAlias)
			IF liConn >0
		       =SQLDISCONNECT(liConn)
		    EndIF
			IF liStatus > 0
				lsRetval = .GetXMLFromAlias(lsAlias)
				.CloseAlias(lsAlias)
			ELSE 
				.Error(liStatus, PROGRAM(), LINENO())
			ENDIF
			
		EndWith

		RETURN lsRetval

	EndFunc

	*________________________________________________________________________________
	*________________________________________________________________________________
	FUNCTION GetListBy(tiMode As Integer, txSearch As Variant, tsXML As String) AS String
	*--
	*--
	*--
	*________________________________________________________________________________
		LOCAL lsRetval 	AS String, ;
					lsSQL 		AS String, ;
					lsAlias 	AS String, ;
					liConn 		AS Integer, ;
					liStatus 	AS Integer
		
*//When TempUseGetListBy logic is complete:
*//	1) Uncomment the commented line of code.
*//	2) Remove the line of code following the commented code.
*!*			tsXML = IIf(!Empty(tsXML), tsXML, "")
		tsXML = IIf(!Empty(tsXML), tsXML, NULL)

		lsRetval 		= ""
		lsSQL 			= "EXEC dbo." + This.StoredProcGetPrefix + This.Name + This.StoredProcGetSuffix + ;
									"ListBy" + This.aGetListBy[tiMode] + " ?txSearch, ?tsXML"
		lsAlias  		= This.Name + "List" 
		
		WITH This
			
			.CloseAlias(lsAlias)
		
			liConn = .ConnectionHandle

			*-- use sqlexec instead of .executesql so that we can evaluate parameters
			*-- IF .ExecuteSQL(lsSQL,lsAlias)
			liStatus = SQLEXEC(liConn, lsSQL, lsAlias)

			IF liStatus > 0
				lsRetval = .GetXMLFromAlias(lsAlias)
				.CloseAlias(lsAlias)
			ELSE 
				.Error(liStatus, PROGRAM(), LINENO())
			ENDIF
			IF liConn >0
		   		=SQLDISCONNECT(liConn)
			EndIF
		EndWith

		RETURN lsRetval

	EndFunc

	*________________________________________________________________________________
	*________________________________________________________________________________
	*--
	*-- Default Generic method for returning a single record as xml 
	*-- based on a single primary Key
	*--
	*-- returns all rows if no key is passed 
	*-- 
	*-- Returns xml string
	*--
	*________________________________________________________________________________
*!*		Function SQLExecute(tsSQL As String) AS String
	Function SQLExecute(tsSQL As String, tsOutputXML As String) AS String
	Local lsRetval As String, ;
				liConn As Integer

	With This
	
		*//Hold onto the connection handle
		liConn = .ConnectionHandle
		
*!*			*//Execute the SQL AND get a count of the number of result sets returned
*!*			liResultSetCount = SQLExec(liConn, tsSQL)

		*//Execute the SQL AND get a count of the number of result sets returned
		*= SQLSetProp(liConn, "Asynchronous", .T.)
		
		liResultSetCount = SQLExec(liConn, tsSQL)
		

		If  (liResultSetCount >= 0)
		
			*//Convert the Data Returned from SQL into an xml string to returned to the client
*!*				lsRetval = .SQLResultsToXML(liResultSetCount)
			tsOutputXML = .SQLResultsToXML(liResultSetCount)
			*= SQLSetProp(liConn, "Asynchronous", .F.)
		
		Else
*!*				.Error(ERROR(), PROGRAM(), LINENO(1))
			If (liResultSetCount < 0)
				.Error(ERROR(), PROGRAM(), LINENO(1))
			Endif
		Endif
		IF liConn >0
		   =SQLDISCONNECT(liConn)
		EndIF
	EndWith

*!*		Return lsRetval
	Return liResultSetCount
	EndFunc
	
	*________________________________________________________________________________
	*________________________________________________________________________________
	*--
	*--
	*--
	*--
	*________________________________________________________________________________
	HIDDEN FUNCTION SQLResultsToXML(tiResultSetCount AS Integer) AS String
	LOCAL loXMLAdapter AS XMLAdapter, ;
				liAlias AS Integer, ;
				lsAlias as String, ;
				lsRetval AS String, ;
				lbHasDataToReturn AS Boolean
				

			STORE "" TO lsRetval, lsAlias
			STORE .F. TO lbHasDataToReturn 
		
			*-- Get an xml adapter
			loXMlAdapter = NEWOBJECT("xmlAdapter")
			
			*-- Add each resultset returned from sql to the xml adapter
			FOR liAlias = 1 TO tiResultSetCount 
				lsAlias = "SQLResult" + IIF(liAlias = 1, "", ALLTRIM(STR(liAlias- 1)))
				IF USED(lsAlias) Then
					lbHasDataToReturn = .T.
					loXMlAdapter.AddTableSchema(lsAlias,.T.)
				ENDIF
			EndFor

			*-- need to release so we can fire the toXML method
			*-- pass false to avoid losing the schema
			loXMLAdapter.ReleaseXML(.F.)

			*-- Put all the data returned from SQL into an xml string to return
			IF lbHasDataToReturn Then
				loXMlAdapter.ToXML("lsRetval","",.F.)
			ENDIF
			
			*-- Close the Aliases now that we are through with them
			FOR liAlias = 1 TO tiResultSetCount 
				lsAlias = "SQLResult" + IIF(liAlias = 1, "", ALLTRIM(STR(liAlias- 1)))
				This.CloseAlias(lsAlias)
			EndFor

			RELEASE loXMLAdapter
			

		RETURN lsRetval

	ENDFUNC


	*________________________________________________________________________________
	*________________________________________________________________________________
	*--
	*--
	*--
	*________________________________________________________________________________
	PROCEDURE CloseAlias (tsAlias AS String)
		IF USED(tsAlias)
			USE IN (tsAlias)
		EndIf
	EndProc
	

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
	
		*//Check to see if there is an adaptor manager object linked to the data adaptor
*!*			If !IsNull(This.oMgr)
*!*			
*!*				*//Grab the connection handle from the adaptor manager
*!*				liConn = This.oMgr.ConnectionHandle
*!*			
*!*			Else
			
*!*				liConn = This.ConnectionHandle
		
*!*				If (liConn) < 0) then

*!*					If (TYPE('This.SQLConnection.ConnectionHandle') <> T_NUMERIC) Then

*!*						SET PROCEDURE TO cSQLConnection ADDI
					This.SqlConnection = CREATEOBJECT("SQLConnection")

*!*					Endif

				liConn = This.SQLConnection.ConnectionHandle
				
				This.SQLConnection.Destroy
				This.SQLConnection = .Null.
				this.ConnectionHandle = liConn

*!*				EndIf
		
*!*			Endif

		Return liConn
		
	EndProc


	*________________________________________________________________________________
	*________________________________________________________________________________
	*-- 
	*-- 
	*-- Return Error to calling program
	*-- 
	*-- 
	*________________________________________________________________________________
	Protected Procedure Error
		LPARAMETERS nError, cMethod, nLine
		Local lsError
		lsError = " Error No: " 			+ ALLTRIM(STR(nError)) + ;
							CRLF + " Method: " 	+ cMethod  + ;
							CRLF + " Line: " 		+ ALLTRIM(STR(nLine))  + ;
							CRLF + " Error: " 	+ Message() + ;
							CRLF + " Code: " 		+ Message(1)

*!*			strtofile(lsError + CRLF, "\temp\COMError.txt", 1)

		If Version(2) = 0
			COMReturnError(This.Name, lsError)
		Else
			MessageBox(lsError)
			debug
			susp
		EndIf
	endproc

	*________________________________________________________________________________
	*________________________________________________________________________________
	*--
	*--
	*--
	*________________________________________________________________________________
	Procedure Destroy
	LOCAL liConn AS Integer
	
		*//Check to see if there is an adaptor manager object linked to the data adaptor
		If !IsNull(This.oMgr)
			
			*//Allow adaptor manager to handle connection cleanup

		Else

			liConn = This.ConnectionHandle

			IF liConn >0
				=SQLDISCONNECT(liConn)
			EndIF

			This.SQLConnection = .Null.
			This.ConnectionHandle = -1
		
		Endif
		
		This.oMgr = NULL

		=DODEFAULT()
		
	endproc

	*________________________________________________________________________________
	*________________________________________________________________________________
	*--
	*--
	*-- Load settings
	*--
	*--
	*________________________________________________________________________________
	Protected Procedure Init
		Local lbInit
		lbInit = .F.
		this.ConnectionHandle = -1

		DoDefault()

		If .T.
			lbInit = This.SetEnvironment()
		Endif
		Return lbInit
	Endproc

	*________________________________________________________________________________
	*________________________________________________________________________________
	*--
	*--
	*-- Standard Environment Settings.
	*--
	*--
	*________________________________________________________________________________
	Protected Function SetEnvironment
	LOCAL lbRetval as Boolean
	
		Set Escape Off
		Set Talk Off
		Set Help ON
		Set Ansi Off
		Set Autosave On
		Set Carry Off
		Set Century On
		Set Century To 19 rollover 70
		Set Deleted On
		Set Exclusive Off
		Set Hours To 12
		Set Seconds Off
		Set Confirm Off
		Set Safety Off
		Set Multilocks On
		Set Carry Off
		Set Exact Off
		Set Near Off
		Set Bell Off
		Set StrictDate To 0
		Set NullDisplay To '(none)'
		Set Reprocess To 5 Seconds
		_Asciicols = 500

*		This.SQLConnection = CreateObject("SQLConnection")

*		lbRetval = MlValOBJ(This.SQLConnection)
		lbRetval = .T.

		Return lbRetval
	EndFunc


	*________________________________________________________________________________
	*________________________________________________________________________________
	*--
	*--
	*--
	*-- Get oHost Property Value
	*--
	*--
	*________________________________________________________________________________
	Protected Procedure oHost_Access
		IF ISNULL(this.ohost)
			this.oHost = This
		Endif

		Return This.oHost

	Endproc


	*________________________________________________________________________________
	*________________________________________________________________________________
	*-- 
	*-- 
	*-- Set oHost Property Value
	*-- 
	*-- 
	*________________________________________________________________________________
*---		Protected Procedure oHost_Assign
*---			Lparameters toHost
*---			Local loHost

*---			If MLValObj(toHost)
*---				loHost = This.oHost

*---				If NOT MLValObj(loHost) ;
*---					Or (toHost <> loHost)
*---					This.oHost = toHost
*---				Endif

*---			Endif

*---		Endproc


	*________________________________________________________________________________
	*________________________________________________________________________________
	*-- 
	*-- 
	*-- Find Parent Object
	*-- 
	*-- 
	*________________________________________________________________________________
	Protected Procedure FindParent
		Lparameters toObject AS Object
		Local loParent AS Object
		
		If MLValObj(toObject) and MLValObj(toObject, "Parent")
			loParent = This.FindParent(toObject.Parent)
		Else
			loParent = toObject
		Endif


		Return loParent
	Endproc


	*________________________________________________________________________________
	*________________________________________________________________________________
	*-- 
	*-- Set oHost Value
	*-- 
	*-- 
	*________________________________________________________________________________
	Protected Procedure SetHost
		Local loHost

		loHost = This.FindParent(This)
		This.oHost = loHost

	Endproc

EndDefine
