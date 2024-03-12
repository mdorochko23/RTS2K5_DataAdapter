#INCLUDE APP.h

DEFINE CLASS Master AS AppSQLData OLEPUBLIC

	Name 						= "Master"
	PrimaryKeyFieldName			= "ID_tblmaster"

	DIMENSION aGetListBy[8]
	aGetListBy[1]				= "Plaintiff"
	aGetListBy[2]				= "lrs_no"
	aGetListBy[3]				= "Soc_Sec"
	aGetListBy[4]				= "brth_date"
	aGetListBy[5]				= "AKA"
	aGetListBy[6]				= "group"
	aGetListBy[7]				= "docket"
	aGetListBy[8]				= "asb_case"

EndDef