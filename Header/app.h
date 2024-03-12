#INCLUDE ApplicationSpecific.h
#Include FoxPro.h


*-- Developer Defines
#DEFINE CRLF		CHR(13) + CHR(10)

*--Application Generic Messages
#DEFINE APP_ASK_EXIT					"Are you sure you want to Exit?"
#DEFINE APP_LOADING						"Loading, Please wait..."
#DEFINE APP_ERROR_CRITICAL				"Critical Application Error!"
#DEFINE APP_NOTAVAILFORMS				"Function not available until ALL Active Forms are Closed!"
#DEFINE APP_BADPARAMS					"Invalid Parameter Passed!"


#DEFINE INI_ACTION_READ					"R"
#DEFINE INI_ACTION_WRITE				"W"


#DEFINE INI_SECTION_APP					"APP"
#DEFINE INI_SECTION_SQL					"SQL"


#DEFINE INI_KEY_UID						"uid"
#DEFINE INI_KEY_PWD						"pwd"
#DEFINE INI_KEY_SERVER					"Server"
#DEFINE INI_KEY_DATABASE				"Database"


#Define DATASOURCE_TYPE_STOREDPROCEDURE		1
#Define DATASOURCE_TYPE_TABLE				2
#Define DATASOURCE_TYPE_VIEW				3
#Define DATASOURCE_TYPE_Function			4


#Define READMODE_SINGLE					1
#Define READMODE_LIST					2
