#INCLUDE APP.h

DEFINE CLASS SQLConnection AS Custom OLEPUBLIC

	Name					= "SQLConnection"
	ConnectionString	= ""
	ConnectionHandle	= -1
	Driver				= "{SQL Server}"
	Server				= ""
	Database			= ""
	UID						= ""
	PWD						= ""
	App						= ""

	DIMENSION ConnectionString_COMATTRIB[4]
   ConnectionString_COMATTRIB[1] = COMATTRIB_READONLY
   ConnectionString_COMATTRIB[2] = "Helptext displayed in object browser"
   ConnectionString_COMATTRIB[3] =  "ConnectionString"&& Proper capitalization.
   ConnectionString_COMATTRIB[4] = "String"&& Data type

	DIMENSION ConnectionHandle_COMATTRIB[4]
   ConnectionHandle_COMATTRIB[1] = COMATTRIB_READONLY
   ConnectionHandle_COMATTRIB[2] = "Connection Handle Integer"
   ConnectionHandle_COMATTRIB[3] =  "ConnectionHandle"&& Proper capitalization.
   ConnectionHandle_COMATTRIB[4] = "Integer"&& Data type

	HIDDEN									AddObject
	HIDDEN									AddProperty
	HIDDEN									BaseClass
	HIDDEN									Class
	HIDDEN									ClassLibrary
	HIDDEN									ControlCount
	HIDDEN									Controls
*!*		HIDDEN									Destroy
	HIDDEN									Error
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

	*________________________________________________________________________
	*________________________________________________________________________
	*--Return connection Handle, If connection is not open then open it
	*--
	*________________________________________________________________________
	Protected Function UID_Access AS String
		LOCAL lsRetval AS String
		
		lsRetval = mlPriPro(INI_ACTION_READ, ;
												APP_INI, ;
												INI_SECTION_SQL, ;
												INI_KEY_UID, ;
												"")
												
		this.UID = lsRetval

		Return lsRetval
	EndPRoc

	*________________________________________________________________________
	*________________________________________________________________________
	*--Return connection Handle, If connection is not open then open it
	*--
	*________________________________________________________________________
	Protected Function PWD_Access AS String
		LOCAL lsRetval AS String
		
		lsRetval = mlPriPro(INI_ACTION_READ, ;
												APP_INI, ;
												INI_SECTION_SQL, ;
												INI_KEY_PWD, "")

		This.PWD = lsRetval

		Return lsRetval
	EndPRoc


	*________________________________________________________________________
	*________________________________________________________________________
	*--
	*--Return connection Handle, If connection is not open then open it
	*--
	*________________________________________________________________________
	Protected Function DATABASE_Access AS String
		LOCAL lsRetval AS String
		
		If Empty(This.Database)
		
			lsRetval = mlPriPro(INI_ACTION_READ, ;
													APP_INI, ;
													INI_SECTION_SQL, ;
													INI_KEY_DATABASE, ;
													"VFPMODEL")
		

			This.Database = lsRetval
		
		Else

			lsRetval = This.Database

		Endif

		Return lsRetval
	EndPRoc


	*________________________________________________________________________
	*________________________________________________________________________
	*--Return connection Handle, If connection is not open then open it
	*--
	*________________________________________________________________________
	Protected Function SERVER_Access AS String
		LOCAL lsRetval AS String
		
		lsRetval = mlPriPro(INI_ACTION_READ, ;
												APP_INI, ;
												INI_SECTION_SQL, ;
												INI_KEY_SERVER, ;
												"(Local)")
												
		This.Server = lsRetval

		Return lsRetval
	EndPRoc


	*________________________________________________________________________
	*________________________________________________________________________
	*--
	*--Return App name.
	*--
	*________________________________________________________________________
	Protected Function APP_Access AS String
		LOCAL lsRetval AS String
		
		lsRetval = APP_NAME
		This.App = lsRetval

		Return lsRetval
	EndPRoc

	*________________________________________________________________________
	*________________________________________________________________________
	*--Return connection Handle, If connection is not open then open it
	*--
	*________________________________________________________________________
	Protected Procedure ConnectionHandle_Access
	LOCAL liConn AS Integer, lsConnectionString AS String
	
		liConn = This.ConnectionHandle
		
		If (liConn < 0)
			lsConnectionString = this.ConnectionString
			liConn = SQLStringConnect(lsConnectionString)
			this.ConnectionHandle = liConn
		EndIf

		Return liConn
	EndPRoc

	*________________________________________________________________________
	*________________________________________________________________________
	*--Return connection string
	*--
	*________________________________________________________________________
	Protected Procedure ConnectionString_Access
	LOCAL lsConnectionString AS String
	
	lsConnectionString = this.ConnectionString

		If Empty(lsConnectionString)

			lsConnectionString = ;
				"DRIVER=" 		+ This.Driver 	+ "; " + ; 
				"SERVER=" 		+ This.Server 	+ "; " + ;
				"UID=" 				+ This.UID 			+ "; " + ;
				"PWD=" 				+ This.PWD 			+ "; " + ;
				"DATABASE=" 	+ This.Database + "; " + ;
				"APP="				+ This.App			+ "; " + ;
				"WSID=" 			+ Sys(0)	 			+ ";"
				
			this.ConnectionString = lsConnectionString
		EndIf 


		Return this.ConnectionString
	EndPRoc
	
	*________________________________________________________________________
	*________________________________________________________________________
	*--Return connection Handle, If connection is not open then open it
	*--
	*________________________________________________________________________
	Protected Procedure DropConnection
		LOCAL liConn AS Integer, liRetval AS Integer
				
		liConn 		= This.ConnectionHandle
		liRetval  = SQLDisConnect(liConn)
		This.ConnectionHandle = -1

		Return liRetval  
		
	EndPRoc

	*________________________________________________________________________
	*________________________________________________________________________
	*--Close Connection before class is destroyed
	*--
	*________________________________________________________________________
	Procedure Destroy
	
		*-- Disconnect			
	*	This.DropConnection()
	
		DODEFAULT()
	
	EndPRoc

EndDefine

