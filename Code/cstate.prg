#INCLUDE APP.h

DEFINE CLASS State AS AppSQLData OLEPUBLIC

	Name 										= "State"
	PrimaryKeyFieldName			= "Code"

	DIMENSION aGetItemBy[1]
	aGetItemBy[1]						= "Code"

	DIMENSION aGetListBy[1]
	aGetListBy[1]						= "Code"

ENDDEFINE
