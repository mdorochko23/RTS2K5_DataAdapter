#INCLUDE APP.h

DEFINE CLASS Area AS AppSQLData OLEPUBLIC

	Name 										= "Area"
	PrimaryKeyFieldName			= "ID_tblArea"

	DIMENSION aGetItemBy[1]
	aGetItemBy[1]						= "area"

	DIMENSION aGetListBy[1]
	aGetListBy[1]						= "area"

ENDDEFINE
