#INCLUDE APP.h

DEFINE CLASS Checks AS AppSQLData OLEPUBLIC

	Name 										= "Checks"
	PrimaryKeyFieldName			= "id_tblchecks"

	DIMENSION aGetListBy[1]
	aGetListBy[1]						= "check"

ENDDEFINE
