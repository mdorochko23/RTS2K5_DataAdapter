#INCLUDE APP.h

DEFINE CLASS Plan AS AppSQLData OLEPUBLIC

	Name 						= "Plan"
	PrimaryKeyFieldName			= "id_tblPlan"

	DIMENSION aGetListBy[1]
	aGetListBy[1]				= "Plan"

ENDDEFINE
