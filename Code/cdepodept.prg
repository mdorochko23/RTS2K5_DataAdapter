#INCLUDE APP.h

DEFINE CLASS DepoDept AS AppSQLData OLEPUBLIC

	Name 										= "DepoDept"
	PrimaryKeyFieldName			= "Code"

	DIMENSION aGetItemBy[1]
	aGetItemBy[1]						= "Code"

	DIMENSION aGetListBy[1]
	aGetListBy[1]						= "Code"

ENDDEFINE
