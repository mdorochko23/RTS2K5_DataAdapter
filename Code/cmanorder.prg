#INCLUDE APP.h

DEFINE CLASS ManOrder AS AppSQLData OLEPUBLIC

	Name 						= "ManOrder"
	PrimaryKeyFieldName			= "ID_tblmanorder"

	DIMENSION aGetListBy[4]
	aGetListBy[1]				= "Tag"
	
EndDef