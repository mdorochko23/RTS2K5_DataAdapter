#INCLUDE APP.h

DEFINE CLASS DepoType AS AppSQLData OLEPUBLIC

	Name 										= "DepoType"
	PrimaryKeyFieldName			= "id_tbldepocodes"

	DIMENSION aGetItemBy[1]
	aGetItemBy[1]						= "Code"

	DIMENSION aGetListBy[1]
	aGetListBy[1]						= "Code"

ENDDEFINE
