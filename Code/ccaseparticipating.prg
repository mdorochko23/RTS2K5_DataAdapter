#INCLUDE APP.h

DEFINE CLASS CaseParticipating AS AppSQLData OLEPUBLIC

	Name 										= "CaseParticipating"
	PrimaryKeyFieldName			= "ID_tblbills"

	DIMENSION aGetListBy[1]
	aGetListBy[1]				= "ID"
	
ENDDEFINE
