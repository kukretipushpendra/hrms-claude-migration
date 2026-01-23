GO
--GetEvents
CREATE OR ALTER   PROCEDURE [dbo].[GetEvents]
@EventName AS VARCHAR(100)='',
@StatusId AS int,
@SortColumnName AS VARCHAR(50)='',
@SortColumnDirection AS VARCHAR(50)='',
@PageNumber AS INT=1,
@PageSize AS INT=10
AS
BEGIN
	DECLARE @Query AS VARCHAR(MAX)='',@OrderQuery AS VARCHAR(MAX)='',@Conditions AS VARCHAR(MAX)='',
	@Pagination AS VARCHAR(MAX)='', @StartIndex AS INT

	SELECT @StartIndex = (@PageNumber-1)*@PageSize  
	
	SET @Query='SELECT E.Id,Title as EventName,StartDate
				,EndDate,G.GroupName AS EmployeeGroup,S.StatusValue AS Status,E.Venue,E.BannerFileName
				FROM DBO.Events E
				INNER JOIN dbo.[Group] G ON E.EmpGroupId = G.Id
				INNER JOIN [dbo].[Status] S ON E.StatusId = S.Id
				WHERE E.IsDeleted = 0'
	
	-- SEARCH OPERATION
	BEGIN
	SET @Conditions=''
	END
	IF(ISNULL(@EventName,'')<>'')
	BEGIN
		SET @Conditions +=' and E.Title LIKE ''%'+@EventName+'%'''
	END
	IF(@StatusId <> 0)
	BEGIN
		SET @Conditions +=' and E.StatusId='+ CONVERT(VARCHAR(12), @StatusId)
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
---------------------------------

CREATE OR ALTER   PROCEDURE [dbo].[GetCompanyPolicyDocuments]
@PolicyName AS VARCHAR(100)='',
@CategoryId AS bigint,
@SortColumnName AS VARCHAR(50)='',
@SortColumnDirection AS VARCHAR(50)='',
@PageNumber AS INT=1,
@PageSize AS INT=10
AS
BEGIN
	DECLARE @Query AS VARCHAR(MAX)='',@OrderQuery AS VARCHAR(MAX)='',@Conditions AS VARCHAR(MAX)='',
	@Pagination AS VARCHAR(MAX)='', @StartIndex AS INT

	SELECT @StartIndex = (@PageNumber-1)*@PageSize  
	
	SET @Query='SELECT cp.Id,
				Name,EffectiveDate,
				cp.DocumentCategoryId,
				cdc.CategoryName as DocumentCategory ,
				VersionNo,cp.ModifiedOn,
				cp.ModifiedBy,
				cp.CreatedOn,
				cp.CreatedBy,
				CASE WHEN cp.StatusId = 1 THEN ''Draft''
					WHEN cp.StatusId = 2 THEN ''Active'' 
					WHEN cp.StatusId = 3 THEN ''Inactive'' END Status
				FROM CompanyPolicy cp
				Join dbo.CompanyPolicyDocCategory cdc on cdc.Id = cp.DocumentCategoryId 
				WHERE ISNull(cp.IsDeleted,0) = 0'
	
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

---------------------GetHistoryListByPolicyId-------------------

CREATE OR ALTER   PROCEDURE [dbo].[GetHistoryListByPolicyId]  
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
	
	SET @Query='SELECT [PolicyId],[Name], [VersionNo], [ModifiedOn],[ModifiedBy] ,[Description],[CreatedOn] FROM CompanyPolicyHistory WHERE IsDeleted =0  '

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

---------------------GetCompanyPolicyDocuments-------------------

CREATE OR ALTER     PROCEDURE [dbo].[GetCompanyPolicyDocuments]
@PolicyName AS VARCHAR(100)='',
@CategoryId AS bigint,
@SortColumnName AS VARCHAR(50)='',
@SortColumnDirection AS VARCHAR(50)='',
@PageNumber AS INT=1,
@PageSize AS INT=10
AS
BEGIN
	DECLARE @Query AS VARCHAR(MAX)='',@OrderQuery AS VARCHAR(MAX)='',@Conditions AS VARCHAR(MAX)='',
	@Pagination AS VARCHAR(MAX)='', @StartIndex AS INT

	SELECT @StartIndex = (@PageNumber-1)*@PageSize  
	
	SET @Query='SELECT cp.Id,
				Name,EffectiveDate,
				cp.DocumentCategoryId,
				cdc.CategoryName as DocumentCategory ,
				VersionNo,cp.ModifiedOn,
				cp.ModifiedBy,
				cp.CreatedOn,
				cp.CreatedBy,
				cp.StatusId,
				CASE WHEN cp.StatusId = 1 THEN ''Draft''
					WHEN cp.StatusId = 2 THEN ''Active'' 
					WHEN cp.StatusId = 3 THEN ''Inactive'' END Status
				FROM CompanyPolicy cp
				Join dbo.CompanyPolicyDocCategory cdc on cdc.Id = cp.DocumentCategoryId 
				WHERE ISNull(cp.IsDeleted,0) = 0'
	
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
---------------------GetHistoryListByPolicyId-------------------

CREATE OR ALTER     PROCEDURE [dbo].[GetHistoryListByPolicyId]  
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
	
	SET @Query='SELECT [PolicyId],[Name], [VersionNo], [ModifiedOn],[ModifiedBy] ,[Description],[CreatedOn],[FileName],[FileOriginalName] FROM CompanyPolicyHistory WHERE IsDeleted =0'

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
---------------------GetCompanyPolicyDocuments-------------------

CREATE OR ALTER     PROCEDURE [dbo].[GetCompanyPolicyDocuments]
@StatusId AS bigint,
@PolicyName AS VARCHAR(100)='',
@CategoryId AS bigint,
@SortColumnName AS VARCHAR(50)='',
@SortColumnDirection AS VARCHAR(50)='',
@PageNumber AS INT=1,
@PageSize AS INT=10
AS
BEGIN
	DECLARE @Query AS VARCHAR(MAX)='',@OrderQuery AS VARCHAR(MAX)='',@Conditions AS VARCHAR(MAX)='',
	@Pagination AS VARCHAR(MAX)='', @StartIndex AS INT

	SELECT @StartIndex = (@PageNumber-1)*@PageSize  
	
	SET @Query='SELECT cp.Id,
				Name,EffectiveDate,
				cp.DocumentCategoryId,
				cdc.CategoryName as DocumentCategory ,
				VersionNo,cp.ModifiedOn,
				cp.ModifiedBy,
				cp.CreatedOn,
				cp.CreatedBy,
				cp.StatusId,
				CASE WHEN cp.StatusId = 1 THEN ''Draft''
					WHEN cp.StatusId = 2 THEN ''Active'' 
					WHEN cp.StatusId = 3 THEN ''Inactive'' END Status
				FROM CompanyPolicy cp
				Join dbo.CompanyPolicyDocCategory cdc on cdc.Id = cp.DocumentCategoryId 
				WHERE ISNull(cp.IsDeleted,0) = 0'
	
	-- SEARCH OPERATION
	BEGIN
	SET @Conditions=''
	END
	IF(ISNULL(@PolicyName,'')<>'')
	BEGIN
		SET @Conditions +=' and cp.Name LIKE ''%'+@PolicyName+'%'''
	END
	IF(@StatusId <> 0)
	BEGIN
		SET @Conditions +=' and cp.StatusId='+ CONVERT(VARCHAR(12), @StatusId)
	END
	IF(@CategoryId <> 0)
	BEGIN
		SET @Conditions +=' and cp.DocumentCategoryId='+ CONVERT(VARCHAR(12), @CategoryId)
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
---------------------GetEmployees-------------------
 

Create Or ALTER PROCEDURE [dbo].[GetEmployees]
@EmployeeName AS VARCHAR(100)='',
@DepartmentId as bigint,
@RoleId AS BIGINT,
@Status as INT,
@Designation AS VARCHAR(100)='',
@SortColumnName AS VARCHAR(50)='',
@SortColumnDirection AS VARCHAR(50)='',
@PageNumber AS INT=1,
@PageSize AS INT=10
AS
BEGIN
	DECLARE @Query AS VARCHAR(MAX)='',@OrderQuery AS VARCHAR(MAX)='',
	@Pagination AS VARCHAR(MAX)='', @StartIndex AS INT, @WhereConditons NVARCHAR(MAX), @wherejoin NVARCHAR(1000) = ' WHERE ',
	@Andjoin NVARCHAR(1000) = ' AND '

	SELECT @StartIndex = (@PageNumber-1)*@PageSize  
	
	SET @Query='SELECT e1.Id, e1.EmployeeCode ,(e1.FirstName + '' '' + ISNULL(e1.MiddleName, '''') + '' '' + e1.LastName) AS EmployeeName,e1.FatherName,e1.Gender,
	            e1.DOB,e2.Email,(e6.Line1 + '' '' + ISNULL(e6.Line2, '''')) AS Address,e7.CityName,e8.StateName,e6.Pincode,
				(e10.Line1 + '' '' + ISNULL(e10.Line2, '''') + '' '' + e11.CityName + '' '' + e12.StateName + '' '' + e10.Pincode) AS PermanentAddress,
				e1.EmergencyContactNo,e2.ConfirmationDate,e2.JobType,
				e1.PFNumber,e1.PFDate,e9.BankName,e9.AccountNo,e1.PANNumber,e1.ESINo,e2.ReportingManagerName,e1.PassportNo,e1.PassportExpiry,e1.AlternatePhone,
				e1.PersonalEmail,e1.BloodGroup,e1.MaritalStatus,e1.UANNo,e1.HasPF,e1.HasESI,e1.AdharNumber,
                e1.Phone, e2.JoiningDate,e5.Name AS Branch,
                CASE
                    WHEN e2.EmployeeStatus = 1 THEN ''Active''
                    WHEN e2.EmployeeStatus = 2 THEN ''F&F Pending''
                    WHEN e2.EmployeeStatus = 3 THEN ''On Notice''
                    WHEN e2.EmployeeStatus = 4 THEN ''Ex Employee''
                    ELSE ''''
                END AS Status,
                e13.Department As DepartmentName, e2.Designation
                FROM EmployeeData e1
				INNER JOIN EmploymentDetail e2 on e1.Id = e2.EmployeeId
				Left JOIN UserRoleMapping e3 ON e1.Id = e3.EmployeeId
				Left JOIN Role e4 ON e4.Id = e3.RoleId
			    Left JOIN Branch e5 on e5.Id = e2.BranchId
				Left JOIN Address e6 on e6.EmployeeId = e1.Id
				Left JOIN City e7 on e7.Id = e6.CityId
				Left JOIN State e8 on e8.Id = e6.StateId
				Left JOIN BankDetails e9 on e1.Id = e9.EmployeeId
				Left JOIN PermanentAddress e10 on e10.EmployeeId = e1.Id
				Left JOIN City e11 on e11.Id = e10.CityId
				Left JOIN State e12 on e12.Id = e10.StateId
				Left JOIN Department e13 on e13.Id = e2.DepartmentId'

	-- SEARCH OPERATION
	BEGIN
	SET @WhereConditons=''
	END
   IF(ISNULL(@EmployeeName,'')<>'')
    BEGIN
        SET @WhereConditons += @WhereJoin + ' (e1.FirstName LIKE ''%'+@EmployeeName+'%'' OR e1.MiddleName LIKE ''%'+@EmployeeName+'%'' OR e1.LastName LIKE ''%'+@EmployeeName+'%'' OR (e1.FirstName + '' '' + ISNULL(e1.MiddleName, '''') + '' '' + e1.LastName) LIKE ''%'+REPLACE(@EmployeeName, ' ', '%')+'%'')'
        SET @WhereJoin = @AndJoin
    END
	 IF(ISNULL(@DepartmentId,0)<>0)
	BEGIN
		SET @WhereConditons += @wherejoin + ' e2.DepartmentId ='+ CONVERT(VARCHAR(12), @DepartmentId)
		SET @wherejoin = @Andjoin
	END
	 IF(ISNULL(@RoleId,0)<>0)
    BEGIN
        SET @WhereConditons += @WhereJoin + ' e3.RoleId ='+ CONVERT(VARCHAR(12), @RoleId)
        SET @WhereJoin = @AndJoin
    END
	IF(@Status <> 0)
	BEGIN
		SET @WhereConditons += @wherejoin + ' e2.EmployeeStatus ='+ CONVERT(VARCHAR(12), @Status)
		SET @wherejoin = @Andjoin
	END
	IF(ISNULL(@Designation,'')<>'')
	BEGIN
		SET @WhereConditons += @wherejoin + ' e2.Designation LIKE ''%'+@Designation+'%'''
		SET @wherejoin = @Andjoin
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
	IF(@WhereConditons<>'') SET @Query+= @WhereConditons
	IF(@OrderQuery<>'') SET @Query+=@OrderQuery
	IF(@Pagination<>'') SET @Query+=@Pagination
	EXEC(@Query)
END



