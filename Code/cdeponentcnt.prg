#INCLUDE APP.h

DEFINE CLASS Deponentcnt AS AppSQLData OLEPUBLIC

	Name 						= "deponentcnt"
	PrimaryKeyFieldName			= "ID_tbldeponents"

	DIMENSION aGetItemBy[1]
	aGetItemBy[1]				= "MailID"
EndDef