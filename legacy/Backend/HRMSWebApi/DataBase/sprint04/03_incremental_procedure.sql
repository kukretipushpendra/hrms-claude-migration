CREATE OR ALTER   PROCEDURE [dbo].[GetEmployees]
@EmployeeName AS VARCHAR(100)='',
@EmployeeId AS bigint,
@DepartmentId as bigint,
@Email AS VARCHAR(100)='',
@Designation AS VARCHAR(100)='',
@EmploymentStatus AS INT,
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
	
	SET @Query='select e1.Id,e1.FirstName, e1.MiddleName, e1.LastName, e2.DepartmentName, e2.Designation,e2.EmploymentStatus from EmployeeData e1
				join EmploymentDetail e2 on e1.Id = e2.EmployeeId'	
	-- SEARCH OPERATION
	BEGIN
	SET @WhereConditons=''
	END
	IF(ISNULL(@EmployeeName,'')<>'')
	BEGIN
		SET @WhereConditons = @wherejoin + ' (e1.FirstName LIKE ''%'+@EmployeeName+'%'' or e1.MiddleName like ''%'+@EmployeeName+'%'' or e1.LastName like ''%'+@EmployeeName+'%'')'
		SET @wherejoin = @Andjoin
	END
	IF(@EmployeeId <> 0)
	BEGIN
		SET @WhereConditons = @wherejoin + ' e1.Id ='+ CONVERT(VARCHAR(12), @EmployeeId)
		SET @wherejoin = @Andjoin
	END
	IF(@DepartmentId <> 0)
	BEGIN
		SET @WhereConditons = @wherejoin + ' e2.DepartmentId ='+ CONVERT(VARCHAR(12), @DepartmentId)
		SET @wherejoin = @Andjoin
	END
	IF(ISNULL(@Email,'')<>'')
	BEGIN
		SET @WhereConditons = @wherejoin + ' e2.Email LIKE ''%'+@Email+'%'''
		SET @wherejoin = @Andjoin
	END
	IF(ISNULL(@Designation,'')<>'')
	BEGIN
		SET @WhereConditons = @wherejoin + ' e2.Designation LIKE ''%'+@Designation+'%'''
		SET @wherejoin = @Andjoin
	END
	IF(@EmploymentStatus <> 0)
	BEGIN
		SET @WhereConditons = @wherejoin + ' e2.EmploymentStatus ='+ CONVERT(VARCHAR(12), @EmploymentStatus)
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
GO
------------------------------------------------------------------------------------------------------------
CREATE OR ALTER   PROCEDURE [dbo].[GetEducationDocuments]
@EmployeeId AS bigint,
@SortColumnName AS VARCHAR(50)='',
@SortColumnDirection AS VARCHAR(50)='',
@PageNumber AS INT=1,
@PageSize AS INT=10
AS
BEGIN
	DECLARE @Query AS VARCHAR(MAX)='',@OrderQuery AS VARCHAR(MAX)='',
	@Pagination AS VARCHAR(MAX)='', @StartIndex AS INT

	SELECT @StartIndex = (@PageNumber-1)*@PageSize  
	
	SET @Query='select uq.Id,uq.CollegeUniversity,uq.AggregatePercentage, uq.EndYear, uq.StartYear, uq.FileName, uq.FileOriginalName,
				uq.QualificationId, q.ShortName as QualificationName, uq.DegreeName
				from UserQualificationInfo uq
				inner join Qualification q on uq.QualificationId = q.Id
				where ISNULL(uq.IsDeleted,0) = 0 and uq.EmployeeId = ' + CONVERT(VARCHAR(100), @EmployeeId)
	
		-- SORT OPERATION
	IF(ISNULL(@SortColumnName,'')<>'' AND ISNULL(@SortColumnDirection,'')<>'')
	BEGIN
		SET @OrderQuery=' ORDER BY '+@SortColumnName+' '+@SortColumnDirection
	END
	ELSE SET @OrderQuery=' ORDER BY uq.Id DESC' 
	-- PAGINATION OPERATION
	
	IF(@PageSize>0)
	BEGIN
		SET @Pagination=' OFFSET '+(CAST(@StartIndex AS varchar(10)))+' ROWS
		FETCH NEXT '+(CAST(@PageSize AS varchar(10)))+' ROWS ONLY'
	END
	
	IF(@OrderQuery<>'') SET @Query+=@OrderQuery
	IF(@Pagination<>'') SET @Query+=@Pagination

	EXEC(@Query)
END
GO
---------------------------------------------------------------------

--GetEvents
CREATE OR ALTER PROCEDURE [dbo].[GetEvents]
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
				,EndDate,G.GroupName AS EmployeeGroup,S.StatusValue AS Status
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
CREATE OR ALTER PROCEDURE [dbo].[GetEmployeeCertificatesList]
@EmployeeId AS bigint,
@SortColumnName AS VARCHAR(50)='',
@SortColumnDirection AS VARCHAR(50)='',
@PageNumber AS INT=1,
@PageSize AS INT=10
AS
BEGIN
	DECLARE @Query AS VARCHAR(MAX)='',@OrderQuery AS VARCHAR(MAX)='',
	@Pagination AS VARCHAR(MAX)='', @StartIndex AS INT

	SELECT @StartIndex = (@PageNumber-1)*@PageSize  
	
	SET @Query='select uc.Id,uc.EmployeeId,uc.CertificateName,uc.FileName, uc.OriginalFileName
				from UserCertificate uc
				where ISNULL(uc.IsDeleted,0) = 0 and uc.EmployeeId = ' + CONVERT(VARCHAR(100), @EmployeeId)
	
		-- SORT OPERATION
	IF(ISNULL(@SortColumnName,'')<>'' AND ISNULL(@SortColumnDirection,'')<>'')
	BEGIN
		SET @OrderQuery=' ORDER BY '+@SortColumnName+' '+@SortColumnDirection
	END
	ELSE SET @OrderQuery=' ORDER BY uc.Id DESC' 
	-- PAGINATION OPERATION
	
	IF(@PageSize>0)
	BEGIN
		SET @Pagination=' OFFSET '+(CAST(@StartIndex AS varchar(10)))+' ROWS
		FETCH NEXT '+(CAST(@PageSize AS varchar(10)))+' ROWS ONLY'
	END
	
	IF(@OrderQuery<>'') SET @Query+=@OrderQuery
	IF(@Pagination<>'') SET @Query+=@Pagination

	EXEC(@Query)
END

GO
--GetNotificationTemplates
CREATE OR ALTER  PROCEDURE [dbo].[GetNotificationTemplates]
@TemplateName AS VARCHAR(250),
@SortColumnName AS VARCHAR(50)='',
@SortColumnDirection AS VARCHAR(50)='',
@PageNumber AS INT=1,
@PageSize AS INT=10
AS
BEGIN
	DECLARE @Query AS VARCHAR(MAX)='',@OrderQuery AS VARCHAR(MAX)='',@Conditions AS VARCHAR(MAX)='',
	@Pagination AS VARCHAR(MAX)='', @StartIndex AS INT

	SELECT @StartIndex = (@PageNumber-1)*@PageSize  
	
	SET @Query='SELECT N.Id, N.TemplateName, N.Description, N.Content,
		T.TemplateType FROM NotificationTemplate N 
		INNER JOIN [dbo].[NotificationTemplateType] T ON N.NotificationTemplateTypeId = T.Id 
		WHERE N.IsDeleted =0'
	
	BEGIN
	SET @Conditions=''
	END

	IF(ISNULL(@TemplateName,'')<>'')
	BEGIN
		SET @Conditions +=' and (N.TemplateName LIKE ''%'+@TemplateName+'%'') '
	END	
		-- SORT OPERATION
	IF(ISNULL(@SortColumnName,'')<>'' AND ISNULL(@SortColumnDirection,'')<>'')
	BEGIN
		SET @OrderQuery=' ORDER BY '+@SortColumnName+' '+@SortColumnDirection
	END
	ELSE SET @OrderQuery=' ORDER BY Id DESC ' 
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
--------------------------------------------------------------------------------------------------------------------------------------
GO
CREATE OR ALTER  PROCEDURE [dbo].[GetNomineeList]
@EmployeeId BIGINT,
@NomineeName  VARCHAR(150)=NULL,
@RelationshipId As INT,
@Others VARCHAR(100)=NULL,
@SortColumnName AS VARCHAR(50)=NULL,
@SortDirection AS VARCHAR(50)=NULL,
@PageNumber AS INT=1,
@PageSize AS INT=10
AS
BEGIN
BEGIN TRY		
	SET NOCOUNT ON;

	DECLARE  @Query NVARCHAR(MAX), @StartIndex AS INT,
	  @EffectiveSortColumnName NVARCHAR(50) = COALESCE(NULLIF(@SortColumnName,''),'Id'),
      @EffectiveSortColumnDirection NVARCHAR(4) = COALESCE(NULLIF(@SortDirection,''),'ASC'),
	  @WhereQuery NVARCHAR(250)

	BEGIN
	SET @WhereQuery=''
	END
	IF(@RelationshipId = 6)
	BEGIN
		SET @WhereQuery =' and n.Others LIKE ''%'+@Others+'%'''
	END
	ELSE IF(@RelationshipId < 6 and @RelationshipId > 0)
		SET @WhereQuery =' and n.Relationship='+ CONVERT(VARCHAR(12), @RelationshipId)
	
	SELECT @StartIndex = (@PageNumber-1)*@PageSize  
	
	SET @Query='SELECT n.Id,
	                   NomineeName,
					   DOB,
					   Age,
					   CareOf,
					   r.Name RelationshipName, 
					   r.Id RelationshipId,
					   Others, 
					   Percentage,
					   IsNomineeMinor,
					   n.CreatedBy,
					   n.CreatedOn,
					   n.ModifiedBy,
					   n.ModifiedOn,
					   n.FileName,
					   n.IdProofDocType,
					   n.FileOriginalName,
					   d.Name
					   FROM [UserNomineeInfo] n
                       INNER JOIN [dbo].[Relationship] r ON n.Relationship=r.Id and r.IsDeleted=0
					   INNER JOIN [dbo].[DocumentType] d ON n.IdProofDocType =d.IdProofFor and d.IsDeleted=0
                       WHERE EmployeeId= @EmployeeId AND (@NomineeName IS NULL OR NomineeName LIKE ''%''+ @NomineeName +''%'')                              
                             '+ @WhereQuery +'
                             AND n.IsDeleted=0
							 ORDER BY ' + QUOTENAME(@EffectiveSortColumnName) +' '+ @EffectiveSortColumnDirection +'
                             OFFSET @StartIndex ROWS
                             FETCH NEXT @PageSize ROWS ONLY;';
	
    EXEC sp_executesql @Query,
 N'@EmployeeId BIGINT,
   @NomineeName  VARCHAR(150),   
   @RelationshipId As INT,  
   @Others VARCHAR(100),
   @SortColumnName NVARCHAR(50),
   @SortDirection NVARCHAR(4),
   @StartIndex int ,
   @PageSize int',  
   @EmployeeId,@NomineeName,@RelationshipId,@Others,@SortColumnName,@SortDirection,@StartIndex,@PageSize;

END TRY
	BEGIN CATCH		
		THROW;
	END CATCH;
END;
