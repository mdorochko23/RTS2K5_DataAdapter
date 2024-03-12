#INCLUDE APP.h

DEFINE CLASS Access AS AppSQLData OLEPUBLIC

	Name 						= "Access"
	PrimaryKeyFieldName			= "ID_tblaccess"
	
		DIMENSION aGetListBy[1]
		aGetListBy[1]				= "at_code"

EndDef