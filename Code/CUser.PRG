#INCLUDE APP.h
DEFINE CLASS User AS SQLData OLEPUBLIC
	Name 										= "User"
	SQLDataSource						= "[fn_GetUser]"
	DataSourceIsFunction		= .T.
	PrimaryKeyFieldName			= "[passkey]"

	*________________________________________________________________________________
	*________________________________________________________________________________
	FUNCTION LoginUser(	tsLogin AS String, ;
												tsPassword AS String) AS String
												
	*--
	*--
	*--
	*________________________________________________________________________________
		LOCAL lsRetval 	AS String, ;
					lsSQL 		AS String, ;
					lsAlias   AS String, ;
					lsUserId 	AS String, ;
					liConn 		AS Integer, ;
					liStatus 	AS Integer, ;
					loReturn  AS object

		lsUserId 		=	.Null.
		lsRetval 		= ""
		lsSQL 			= "EXEC [usp_LoginUser] ?tsLogin, ?tsPassword"
		
		WITH This
			
			lsAlias = "LoginUser" 
			
			.CloseAlias(lsAlias)
			liConn = .ConnectionHandle

			*-- use sqlexec instead of .executesql so that we can evaluate parameters
			*-- IF .ExecuteSQL(lsSQL,lsAlias)
			liStatus = SQLEXEC(liConn, lsSQL, lsAlias)

			IF liStatus > 0
				SELECT (lsAlias)
				SCATTER NAME loReturn Memo
				lsRetval = loReturn.passkey
				.CloseAlias(lsAlias)
			ELSE 
				.Error(liStatus, PROGRAM(), LINENO())
			ENDIF
			
		EndWith

		RETURN lsRetval

	EndFunc


	*________________________________________________________________________________
	*________________________________________________________________________________
	FUNCTION GetUserObjectRight(tsUserId AS String, ;
															tsObjectId AS String) AS String
												
	*--
	*--
	*--
	*________________________________________________________________________________
		LOCAL lsRetval 	AS String, ;
					lsSQL 		AS String, ;
					lsAlias   AS String, ;
					lsUserId 	AS String, ;
					liConn 		AS Integer, ;
					liStatus 	AS Integer, ;
					loReturn  AS object

		lsUserId 		=	.Null.
		lsRetval 		= ""
		lsSQL 			= "EXEC [usp_GetUserObjectRight] ?tsUserId, ?tsObjectId"
		
		WITH This
			
			lsAlias = "UserObjectRight" 
			
			.CloseAlias(lsAlias)
			liConn = .ConnectionHandle

			*-- use sqlexec instead of .executesql so that we can evaluate parameters
			*-- IF .ExecuteSQL(lsSQL,lsAlias)
			liStatus = SQLEXEC(liConn, lsSQL, lsAlias)

			IF liStatus > 0
				SELECT (lsAlias)
				SCATTER NAME loReturn Memo
				lsRetval = loReturn.RightName
				.CloseAlias(lsAlias)
			ELSE 
				.Error(liStatus, PROGRAM(), LINENO())
			ENDIF
			
		EndWith

		RETURN lsRetval

	EndFunc



	*________________________________________________________________________________
	*________________________________________________________________________________
	FUNCTION GetUserList(	tsLogin AS String, ;
												tsFirstName AS String, ;
												tsLastName AS String, ;
												tsRoleId AS String) ;
												AS string
	*--
	*--
	*--
	*________________________________________________________________________________
		LOCAL lsRetval 	AS String, ;
					lsSQL 		AS String, ;
					lsAlias 	AS String, ;
					liConn 		AS Integer, ;
					liStatus 	AS Integer
		
		lsRetval 		= ""
		lsSQL 			= "EXEC [usp_GetUserList] ?tsLogin, ?tsFirstName, ?tsLastName, ?tsRoleId"
		lsAlias  		= "UserList"
		
		WITH This
			
			.CloseAlias(lsAlias)
		
			liConn = .ConnectionHandle

			*-- use sqlexec instead of .executesql so that we can evaluate parameters
			*-- IF .ExecuteSQL(lsSQL,lsAlias)
			liStatus = SQLEXEC(liConn, lsSQL, lsAlias)

			IF liStatus > 0
				lsRetval = .GetXMLFromAlias(lsAlias)
				.CloseAlias(lsAlias)
			ELSE 
				.Error(liStatus, PROGRAM(), LINENO())
			ENDIF
			
		EndWith

		RETURN lsRetval

	EndFunc

	*________________________________________________________________________________
	*________________________________________________________________________________
	FUNCTION SaveUserRecord(	tsUserId		AS String, ;
														tsRoleId		AS String, ;
														tsLogin			AS String, ;
														tsPassword	AS String, ;
														tsFirstName AS String, ;
														tsLastName 	AS String) ;
												AS string
	*--
	*--
	*--
	*________________________________________________________________________________
		LOCAL lbRetval AS Boolean, lsSQL AS String, liConn AS Integer, liStatus As Integer
		
		lsSQL 			= "EXEC [usp_SaveUserRecord] ?tsUserId, ?tsRoleId, ?tsLogin, ?tsPassword, ?tsFirstName, ?tsLastName"
		
		WITH This
			liConn = .ConnectionHandle 
			
			*-- use sqlexec instead of .executesql so that we can evaluate parameters
			liStatus  = SQLEXEC(liConn, lsSQL)
			lbRetval = ( liStatus > 0)
			
			IF NOT lbRetval
				.Error(liStatus, PROGRAM(), LINENO())
			Endif
		EndWith

		RETURN lbRetval


	*________________________________________________________________________________
	*________________________________________________________________________________
	FUNCTION DeleteUser(	tsUserId		AS String) AS Boolean
	*--
	*--
	*--
	*________________________________________________________________________________
		LOCAL lbRetval AS Boolean, lsSQL AS String, liConn AS Integer, liStatus AS Integer
		
		lsSQL 			= "EXEC [usp_DeleteUser] ?tsUserId"
		
		WITH This
			liConn 		= .ConnectionHandle 
			liStatus 	= SQLEXEC(liConn, lsSQL) 
			
			*-- use sqlexec instead of .executesql so that we can evaluate parameters
			lbRetval = (liStatus  > 0)
			
			IF NOT lbRetval
				.Error(liStatus, PROGRAM(), LINENO())
			EndIf
			
		EndWith

		RETURN lbRetval


	EndFunc

ENDDEFINE
