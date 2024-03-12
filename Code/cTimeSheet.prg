#INCLUDE APP.h

DEFINE CLASS TimeSheet AS AppSQLData OLEPUBLIC

	Name 						= "TimeSheet"
	PrimaryKeyFieldName			= "id_tblTimeSheet"

	DIMENSION aGetListBy[1]
	aGetListBy[1]				= "Name"
	
ENDDEFINE
