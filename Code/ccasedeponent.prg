#INCLUDE APP.h

DEFINE CLASS CaseDeponent AS AppSQLData OLEPUBLIC

	Name 										= "CaseDeponent"
	PrimaryKeyFieldName			= "id_tblrequests"

	DIMENSION aGetListBy[1]
	aGetListBy[1]				= "Name"
	
ENDDEFINE
