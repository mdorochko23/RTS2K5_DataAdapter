#INCLUDE APP.h

DEFINE CLASS Firm AS AppSQLData OLEPUBLIC

	Name 						= "Firm"
	PrimaryKeyFieldName			= "ID_tblfirm"

	DIMENSION aGetListBy[2]
	aGetListBy[1]				= "Firm_Name"
	aGetListBy[2]				= "Firm_Code"
	
	DIMENSION aGetItemBy[1]
	aGetItemBy[1]				= "Firm_Code"
EndDef