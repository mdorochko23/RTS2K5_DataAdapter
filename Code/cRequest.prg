#INCLUDE APP.h

DEFINE CLASS Request AS AppSQLData OLEPUBLIC

	Name 										= "Request"
	PrimaryKeyFieldName			= "id_tblrequests"

	DIMENSION aGetListBy[1]
	aGetListBy[1]				= "id_tblMaster"
	
ENDDEFINE
