#INCLUDE APP.h

DEFINE CLASS Court AS AppSQLData OLEPUBLIC

	Name 						= "court"
	PrimaryKeyFieldName			= "ID_tblcourt"

	DIMENSION aGetListBy[2]
	aGetListBy[1]				= "Court"
	aGetListBy[2]				= "Desc"
EndDef