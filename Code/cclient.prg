#INCLUDE APP.h

DEFINE CLASS Client AS AppSQLData OLEPUBLIC

	Name 						= "Client"
	PrimaryKeyFieldName			= "ID_tblclient"

	*/ 08/19/05 DMA Add Defendant Name to list /*
	DIMENSION aGetListBy[5]
	aGetListBy[1]				= "Name"
	aGetListBy[2]				= "AttyCode"
	aGetListBy[3]				= "Firm"
	aGetListBy[4]				= "FirmCode"
	aGetListBy[5]				= "DefName"
	
	DIMENSION aGetItemBy[1]
	aGetItemBy[1]				= "At_Code"
EndDef