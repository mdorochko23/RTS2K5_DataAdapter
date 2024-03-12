#INCLUDE APP.h

DEFINE CLASS Code30 AS AppSQLData OLEPUBLIC

	Name 										= "Code30"
	PrimaryKeyFieldName			= "id_tblmaster"

	DIMENSION aGetListBy[1]
	aGetListBy[1]				= "Name"
	
ENDDEFINE
