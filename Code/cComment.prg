#INCLUDE APP.h

DEFINE CLASS Comment AS AppSQLData OLEPUBLIC

	Name 						= "Comment"
	PrimaryKeyFieldName			= "id_tblComment"

*	DIMENSION aGetListBy[1]
*	aGetListBy[1]				= "Name"
	
ENDDEFINE
