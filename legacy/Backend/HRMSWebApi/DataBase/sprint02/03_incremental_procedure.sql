
CREATE
	OR

ALTER PROCEDURE SaveEmployeeGroup 
     @Id BIGINT= 0
	,@GroupName VARCHAR(100)
	,@Description TEXT
	,@Status BIT
	,@CreatedBy NVARCHAR(100)
	,@employeeIds NVARCHAR(MAX) 
AS
BEGIN
	BEGIN TRY		
	BEGIN TRANSACTION;   
	IF EXISTS(
		   SELECT VALUE AS EmployeeId
		   FROM OPENJSON(@employeeIds)
		   WHERE value NOT IN(SELECT ID FROM [dbo].[EmployeeData])
		   )
		   BEGIN
		   ;THROW 50001, 'Invalid EmployeeId found.',1;
		   END;		
    
	IF @Id > 0
		BEGIN		

			UPDATE [dbo].[Group]
			SET GroupName = @GroupName
				,Description = @Description
				,STATUS = @Status
				,ModifiedOn = GETUTCDATE()
				,ModifiedBy = @CreatedBy
			WHERE ID = @Id

			DELETE [dbo].[UserGroupMapping]
			WHERE GroupId = @Id

			INSERT INTO [dbo].[UserGroupMapping] (
				EmployeeId
				,GroupId
				,CreatedBy
				,CreatedOn
				,IsDeleted
				)
			SELECT ID
				,@Id
				,@CreatedBy
				,GETUTCDATE()
				,0
			FROM EmployeeData
			WHERE ID IN (
					SELECT CAST(value AS BIGINT) FROM OPENJSON(@employeeIds) WITH (VALUE BIGINT '$')
					)
		END
		ELSE
		BEGIN
		
			INSERT INTO [dbo].[Group] (
				GroupName
				,Description
				,CreatedBy
				,CreatedOn
				,STATUS
				,IsDeleted
				)
			VALUES (
				@GroupName
				,@Description
				,@CreatedBy
				,GETUTCDATE()
				,@Status
				,0
				)
				Declare @GroupId BIGINT
				SET @GroupId=SCOPE_IDENTITY();

			INSERT INTO [dbo].[UserGroupMapping] (
				EmployeeId
				,GroupId
				,CreatedBy
				,CreatedOn
				,IsDeleted
				)
			SELECT ID
				,@GroupId
				,@CreatedBy
				,GETUTCDATE()
				,0
			FROM EmployeeData
			WHERE ID IN (
					SELECT CAST(value AS BIGINT) FROM OPENJSON(@employeeIds) WITH (VALUE BIGINT '$')
					)
		END
		
	COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH		
	 IF @@TRANCOUNT >0
		ROLLBACK;

		THROW;
	END CATCH;
END;
GO

CREATE
	OR
ALTER PROCEDURE GetEmployeeGroupList 
   @GroupName NVARCHAR(100)=NULL,
   @Status bit =NULL,
   @SortColumnName NVARCHAR(50)=NULL,
   @SortDirection NVARCHAR(4)='ASC',
   @PageNumber int=1 ,
   @PageSize int=10
AS
BEGIN
	BEGIN TRY		
	SET NOCOUNT ON;
    DECLARE  @SQL NVARCHAR(MAX),
             @EffectiveSortColumnName NVARCHAR(50) = COALESCE(NULLIF(@SortColumnName,''),'ID'),
             @EffectiveSortColumnDirection NVARCHAR(4) = COALESCE(NULLIF(@SortDirection,''),'ASC'),
		     @StartIndex INT;

  SET @StartIndex=(@PageNumber - 1) * @PageSize;

  SET @SQL = N' 
   SELECT ID,
          GroupName,
          Description,
          CASE WHEN Status = 1 THEN ''Active'' ELSE ''InActive'' END AS Status,
          ModifiedBy ,
          ModifiedOn
   FROM [Group]
   WHERE (@GroupName IS NULL OR GroupName LIKE ''%''+ @GroupName +''%'')
         AND (@Status IS NULL OR Status = @Status) AND IsDeleted=0
   ORDER BY ' + QUOTENAME(@EffectiveSortColumnName) +' '+ @EffectiveSortColumnDirection +'
   OFFSET @StartIndex ROWS
   FETCH NEXT @PageSize ROWS ONLY;';


EXEC sp_executesql @SQL,
 N'@GroupName NVARCHAR(100),
   @Status bit ,
   @SortColumnName NVARCHAR(50),
   @SortDirection NVARCHAR(4),
   @StartIndex int ,
   @PageSize int',  
   @GroupName, @Status,@SortColumnName,@SortDirection,@StartIndex,@PageSize;
   
	END TRY
	BEGIN CATCH		
		THROW;
	END CATCH;
END;
GO 
----
GO

CREATE OR ALTER PROCEDURE [dbo].[GetHistoryListByPolicyId]  
@PolicyId AS BIGINT ,
@SortColumnName AS VARCHAR(50)='',
@SortColumnDirection AS VARCHAR(50)='',
@PageNumber AS INT=1,
@PageSize AS INT=10

AS
BEGIN
	DECLARE @Query AS VARCHAR(MAX)='',@OrderQuery AS VARCHAR(MAX)='',@Conditions AS VARCHAR(MAX)='',
	@Pagination AS VARCHAR(MAX)='', @StartIndex AS INT

	SELECT @StartIndex = (@PageNumber-1)*@PageSize  
	
	SET @Query='SELECT [PolicyId],[Name], [VersionNo], [ModifiedOn],[ModifiedBy] ,[Description] FROM CompanyPolicyHistory WHERE IsDeleted =0  '

	-- SEARCH OPERATION

	BEGIN
	SET @Conditions=''
	END
	IF(ISNULL(@PolicyId,'')<>'')
	BEGIN
		SET @Conditions +=' And PolicyId = '+CONVERT(VARCHAR(12), @PolicyId)  
	END
	
	IF(ISNULL(@SortColumnName,'')<>'' AND ISNULL(@SortColumnDirection,'')<>'')
	BEGIN
		SET @OrderQuery=' ORDER BY '+@SortColumnName+' '+@SortColumnDirection
	END

	ELSE SET @OrderQuery=' ORDER BY VersionNo DESC'
	
	-- PAGINATION OPERATION
	IF(@PageSize>0)
	BEGIN
		SET @Pagination=' OFFSET '+(CAST(@StartIndex AS varchar(10)))+' ROWS
		FETCH NEXT '+(CAST(@PageSize AS varchar(10)))+' ROWS ONLY'
	END 
	IF(@Conditions<>'') SET @Query+=@Conditions
	IF(@OrderQuery<>'') SET @Query+=@OrderQuery
	IF(@Pagination<>'') SET @Query+=@Pagination

	EXEC(@Query)
END
GO
 
 ---
 GO
CREATE OR ALTER  PROCEDURE [dbo].[GetCompanyPolicyDocuments]
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
	
	SET @Query='SELECT cp.Id,Name,EffectiveDate, gp.GroupName as EmployeeGroup,cp.EmpGroupId,cp.DocumentCategoryId,cdc.CategoryName as DocumentCategory ,VersionNo,cp.ModifiedOn,cp.ModifiedBy,cp.CreatedOn,cp.CreatedBy
	,(select count(id) from CompanyPolicy) as TotalRecords FROM CompanyPolicy cp
	Join dbo.CompanyPolicyDocCategory cdc on cdc.Id = cp.DocumentCategoryId 
	Join dbo.[Group] gp on gp.Id = cp.EmpGroupId WHERE ISNull(cp.IsDeleted,0) = 0'
	
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
