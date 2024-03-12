#INCLUDE APP.h

* DMA 09/22/05 Modified to properly handle the different TX court types
* using a separate SQL procedure for each court type
DEFINE CLASS TXCourt AS AppSQLData OLEPUBLIC

	Name 						= "txcourt"
	PrimaryKeyFieldName			= "ID_tbltxcourt"

	DIMENSION aGetItemBy[1]
	aGetItemBy[1]				= "crttype"

	DIMENSION aGetListBy[3]
	aGetListBy[1]				= "TXCCL"
	aGetListBy[2]				= "TXDistrict"
	aGetListBy[3]				= "Federal"
*	aGetListBy[1]				= "crttype"
*	aGetListBy[2]				= "county"

ENDDEFINE

