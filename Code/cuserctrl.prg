#INCLUDE APP.h

DEFINE CLASS UserCtrl AS AppSQLData OLEPUBLIC

	Name 						= "UserCtrl"
	PrimaryKeyFieldName			= "Login"

	DIMENSION aGetListBy[1]
	aGetListBy[1]				= "Login"

	DIMENSION aGetItemBy[1]
	aGetItemBy[1]						= "Login"

ENDDEFINE
