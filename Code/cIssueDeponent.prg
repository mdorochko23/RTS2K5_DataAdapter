#INCLUDE APP.h

DEFINE CLASS IssueDeponent AS AppSQLData OLEPUBLIC

	Name 										= "IssueDeponent"
	PrimaryKeyFieldName			= "id_tblrequests"

	DIMENSION aGetListBy[1]
	aGetListBy[1]				= "Name"
	
ENDDEFINE
