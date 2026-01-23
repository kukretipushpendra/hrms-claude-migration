CREATE OR ALTER PROCEDURE [dbo].[GetRoleListWithUserCount]
@RoleName AS VARCHAR(100)='',
@SortColumnName AS VARCHAR(50)='',
@SortColumnDirection AS VARCHAR(50)='',
@PageNumber AS INT=1,
@PageSize AS INT=10
AS
BEGIN
	DECLARE @Query AS VARCHAR(MAX)='',@OrderQuery AS VARCHAR(MAX)='',@Conditions AS VARCHAR(MAX)='',
	@Pagination AS VARCHAR(MAX)='', @StartIndex AS INT

	SELECT @StartIndex = (@PageNumber-1)*@PageSize  
	SET @Query='SELECT R.Id AS RoleId, R.Name AS RoleName, COALESCE(COUNT(URM.EmployeeId), 0) AS UserCount
		FROM [Role] AS R
		LEFT JOIN [UserRoleMapping] AS URM ON R.Id = URM.RoleId
		WHERE (R.IsActive = 1 OR URM.EmployeeId IS NULL) '

	-- SEARCH OPERATION
	BEGIN
	SET @Conditions=''
	END
	IF(ISNULL(@RoleName,'')<>'')
	BEGIN
		SET @Conditions +=' and R.Name LIKE ''%'+@RoleName+'%'''
	END
	
	IF(ISNULL(@SortColumnName,'')<>'' AND ISNULL(@SortColumnDirection,'')<>'')
	BEGIN
		SET @OrderQuery=' ORDER BY '+@SortColumnName+' '+@SortColumnDirection
	END
	ELSE SET @OrderQuery=' ORDER BY  R.Id DESC'
	
	-- PAGINATION OPERATION
	IF(@PageSize>0)
	BEGIN
		SET @Pagination=' OFFSET '+(CAST(@StartIndex AS varchar(10)))+' ROWS
		FETCH NEXT '+(CAST(@PageSize AS varchar(10)))+' ROWS ONLY'
	END
	SET @Conditions += ' GROUP BY R.Id, R.Name ';
	IF(@Conditions<>'') SET @Query+=@Conditions
	IF(@OrderQuery<>'') SET @Query+=@OrderQuery
	IF(@Pagination<>'') SET @Query+=@Pagination

	EXEC(@Query)
END
GO

/****** Object:  StoredProcedure [dbo].[SaveRolePermissions]    Script Date: 08/12/2024 10:21:23 ******/ 

IF NOT EXISTS (SELECT * FROM sys.types WHERE is_table_type = 1 AND name = 'PermissionIdTableType')
BEGIN
	CREATE TYPE dbo.PermissionIdTableType AS TABLE
	(
		PermissionId INT
	);
END
GO

CREATE OR ALTER PROCEDURE SaveRolePermissions
    @RoleId INT
	,@PermissionIds dbo.PermissionIdTableType READONLY
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        DELETE FROM RolePermission WHERE RoleId = @RoleId;

        INSERT INTO RolePermission (RoleId, PermissionId, CreatedBy, CreatedOn, IsActive)
        SELECT @RoleId, PermissionId, 'admin', GETUTCDATE(),1 FROM @PermissionIds;

        COMMIT;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK;
        THROW;
    END CATCH
END;
GO
-- GET_EMPLOYEE_LIST 'E','first_name','DESC',0,20

CREATE OR ALTER   PROCEDURE [dbo].[GetCompanyPolicyDocuments]
@PolicyName AS VARCHAR(100)='',
@CategoryId AS bigint,
@EmpGroupId as bigint,
@SortColumnName AS VARCHAR(50)='',
@SortColumnDirection AS VARCHAR(50)='',
@PageNumber AS INT=1,
@PageSize AS INT=10
AS
BEGIN
	DECLARE @Query AS VARCHAR(MAX)='',@OrderQuery AS VARCHAR(MAX)='',@Conditions AS VARCHAR(MAX)='',
	@Pagination AS VARCHAR(MAX)='', @StartIndex AS INT

	SELECT @StartIndex = (@PageNumber-1)*@PageSize  
	
	SET @Query='SELECT cp.Id,Name, gp.GroupName AS EmployeeGroup,cdc.CategoryName AS DocumentCategory ,VersionNo,cp.ModifiedOn,cp.ModifiedBy,cp.CreatedOn,cp.CreatedBy
	 FROM CompanyPolicy cp
	Join dbo.CompanyPolicyDocCategory cdc ON cdc.Id = cp.DocumentCategoryId 
	Join dbo.[Group] gp ON gp.Id = cp.EmpGroupId WHERE ISNULL(cp.IsDeleted,0) = 0'
	
	-- SEARCH OPERATION
	BEGIN
	SET @Conditions=''
	END
	IF(ISNULL(@PolicyName,'')<>'')
	BEGIN
		SET @Conditions +=' and cp.Name LIKE ''%'+@PolicyName+'%'''
	END
	IF(@CategoryId <> 0)
	BEGIN
		SET @Conditions +=' and cp.DocumentCategoryId='+ CONVERT(VARCHAR(12), @CategoryId)
	END
	IF(@EmpGroupId <> 0)
	BEGIN
		SET @Conditions +=' and cp.EmpGroupId='+ CONVERT(VARCHAR(12), @EmpGroupId) +' '
		
	END
	-- SORT OPERATION
	IF(ISNULL(@SortColumnName,'')<>'' AND ISNULL(@SortColumnDirection,'')<>'')
	BEGIN
		SET @OrderQuery=' ORDER BY '+@SortColumnName+' '+@SortColumnDirection
	END
	ELSE SET @OrderQuery=' ORDER BY Id DESC' 
	-- PAGINATION OPERATION
	IF(@PageSize>0)
	BEGIN
		SET @Pagination=' OFFSET '+(CAST(@StartIndex AS varchar(10)))+' ROWS
		FETCH NEXT '+(CAST(@PageSize AS varchar(10)))+' ROWS ONLY'
	END
	IF(@Conditions<>'') SET @Query+= @Conditions
	IF(@OrderQuery<>'') SET @Query+=@OrderQuery
	IF(@Pagination<>'') SET @Query+=@Pagination

	EXEC(@Query)
END
GO