**Added by Ellen on 8/11/05- to execute GetCaseDeponentWaiverListByName

#INCLUDE APP.h

DEFINE CLASS CaseDeponentWaiver AS AppSQLData OLEPUBLIC

	Name 										= "CaseDeponentWaiver"
	PrimaryKeyFieldName			= "id_tblrequests"

	DIMENSION aGetListBy[1]
	aGetListBy[1]				= "Name"
	
ENDDEFINE
