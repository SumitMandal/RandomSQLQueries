CREATE DATABASE Testing;
GO
USE Testing;
GO
CREATE TABLE Users(
	Username nvarchar(60) NOT NULL,
	[Password] nvarchar(60) NOT NULL,
	Retries smallint NOT NULL
);
GO
INSERT INTO Users VALUES ('Sumit', 'sumit', 3);
GO
SELECT * FROM Users;
GO
CREATE PROCEDURE spAuthenticateUser
	@Username nvarchar(50),
	@Password nvarchar(50)
AS
	DECLARE @Retries smallint, @ValidUser int, @ValidPassword int;

	BEGIN
		SELECT @ValidUser = COUNT([Username]) FROM Users WHERE [Username] = @Username;
		IF(@ValidUser = 0)
		BEGIN
			RAISERROR ('Not a valid user', 0, 1) WITH NOWAIT;
		END
		ELSE
		BEGIN
			SELECT @Retries = Retries FROM Users WHERE Username = @Username;
			IF(@Retries = 0)
			BEGIN
				RAISERROR ('User is locked', 0, 1) WITH NOWAIT;
			END
			ELSE
			BEGIN
				SELECT @ValidPassword = COUNT([Password]) FROM Users WHERE [Password] = @Password;
				IF(@ValidPassword = 0)
				BEGIN
					RAISERROR ('Password is wrong', 0, 1) WITH NOWAIT;
					UPDATE [Users] SET Retries = @Retries - 1 WHERE Username = @Username;
				END
				ELSE
				BEGIN
					RAISERROR ('Welcome %s', 0, 1, @Username) WITH NOWAIT;
				END
			END
		END

		
	END
GO

EXEC spAuthenticateUser 'Sumit', 'sumita';
GO

DROP PROCEDURE spAuthenticateUser;
GO

CREATE PROCEDURE spAuthenticateUserOptimized
	@Username nvarchar(50),
	@Password nvarchar(50)
AS
	DECLARE @Retries smallint, @ValidUser int, @ValidPassword int;

	BEGIN
		SELECT @ValidUser = COUNT([Username]) FROM Users WHERE [Username] = @Username;
		IF(@ValidUser = 0)
		BEGIN
			RAISERROR ('Not a valid user', 0, 1) WITH NOWAIT;
		END
		ELSE
		BEGIN
			SELECT @Retries = Retries FROM Users WHERE Username = @Username;
			IF(@Retries = 0)
			BEGIN
				RAISERROR ('User is locked', 0, 1) WITH NOWAIT;
			END
			ELSE
			BEGIN
				SELECT @ValidPassword = COUNT([Password]) FROM Users WHERE [Password] = @Password;
				IF(@ValidPassword = 0)
				BEGIN
					RAISERROR ('Password is wrong', 0, 1) WITH NOWAIT;
					UPDATE [Users] SET Retries = @Retries - 1 WHERE Username = @Username;
				END
				ELSE
				BEGIN
					RAISERROR ('Welcome %s', 0, 1, @Username) WITH NOWAIT;
				END
			END
		END

		
	END
GO

EXEC spAuthenticateUserOptimized'Sumit', 'sumit';
GO

DROP PROCEDURE spAuthenticateUserOptimized;
GO