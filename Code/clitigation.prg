#INCLUDE APP.h

DEFINE CLASS Litigation AS AppSQLData OLEPUBLIC

	Name 								= "Litigation"
	PrimaryKeyFieldName					= "Code"

	DIMENSION aGetItemBy[1]
	aGetItemBy[1]						= "Code"

	DIMENSION aGetListBy[2]
	aGetListBy[1]						= "Code"
	aGetListBy[2]						= "Desc"
	* Note: Method 2 does not fetch by description, just sorts by it

ENDDEFINE
