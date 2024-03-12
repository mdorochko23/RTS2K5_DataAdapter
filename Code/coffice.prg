#INCLUDE APP.h

DEFINE CLASS Office AS AppSQLData OLEPUBLIC

	Name 										= "Office"
	PrimaryKeyFieldName			= "ID_tblOffice"

	DIMENSION aGetItemBy[1]
	aGetItemBy[1]						= "Code"

	DIMENSION aGetListBy[2]
	aGetListBy[1]						= "Code"
	aGetListBy[2]						= "Desc"

ENDDEFINE
