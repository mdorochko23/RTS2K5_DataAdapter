#INCLUDE APP.h

DEFINE CLASS DepoCode30 AS AppSQLData OLEPUBLIC

	Name 										= "DepoCode30"
	PrimaryKeyFieldName			= "id_tblcode30"

	DIMENSION aGetListBy[1]
	aGetListBy[1]				= "Tag"
	
ENDDEFINE
