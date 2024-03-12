#INCLUDE APP.h

DEFINE CLASS FirmAddress AS AppSQLData OLEPUBLIC

	Name 						= "FirmAddress"
	PrimaryKeyFieldName			= "ID_tblfirm"

	DIMENSION aGetListBy[1]
	aGetListBy[1]				= "ID_TblFirm"
	
	DIMENSION aGetItemBy[1]
	aGetItemBy[1]				= "ID_TblFirm"
EndDef