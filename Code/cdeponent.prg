#INCLUDE APP.h

DEFINE CLASS Deponent AS AppSQLData OLEPUBLIC

	Name 						= "deponent"
	PrimaryKeyFieldName			= "ID_tbldeponents"

	DIMENSION aGetListBy[6]
	aGetListBy[1]				= "Name"
	aGetListBy[2]				= "Phone"
	aGetListBy[3]				= "MailID"
	aGetListBy[4]				= "Fax"
	aGetListBy[5]				= "TaxID"
	aGetListBy[6]				= "ServiceID"

EndDef