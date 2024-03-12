#INCLUDE APP.h

DEFINE CLASS Order AS AppSQLData OLEPUBLIC

	Name 						= "Order"
	PrimaryKeyFieldName			= "ID_tblorder"

	DIMENSION aGetListBy[4]
	aGetListBy[1]				= "Tag"
	
EndDef