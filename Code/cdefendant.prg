#INCLUDE APP.h

DEFINE CLASS Defendant AS AppSQLData OLEPUBLIC

	Name 						= "Defendant"
	PrimaryKeyFieldName			= "ID_tbldefendant"
	
	DIMENSION aGetListBy[3]
	aGetListBy[1]				= "DefName"
	aGetListBy[2]				= "At_Code"
	aGetListBy[3]				= "DefCode"
EndDef