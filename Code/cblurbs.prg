#INCLUDE APP.h

DEFINE CLASS Blurbs AS AppSQLData OLEPUBLIC

	Name 										= "Blurbs"
	PrimaryKeyFieldName			= "id_tblSpec1"

	DIMENSION aGetListBy[1]
	aGetListBy[1]				= "Office"
	
ENDDEFINE
