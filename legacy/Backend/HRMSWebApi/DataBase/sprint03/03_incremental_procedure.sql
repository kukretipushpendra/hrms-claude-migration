
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
					   n.ModifiedOn
					   FROM [UserNomineeInfo] n
                       INNER JOIN [dbo].[Relationship] r ON n.Relationship=r.Id and r.IsDeleted=0
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
GO 

CREATE OR ALTER   PROCEDURE [dbo].[GetEducationDocuments]
@Name AS VARCHAR(100)='',
@EmployeeId AS bigint,
@SortColumnName AS VARCHAR(50)='',
@SortColumnDirection AS VARCHAR(50)='',
@PageNumber AS INT=1,
@PageSize AS INT=10
AS
BEGIN
	DECLARE @Query AS VARCHAR(MAX)='',@OrderQuery AS VARCHAR(MAX)='',@Conditions AS VARCHAR(MAX)='',
	@Pagination AS VARCHAR(MAX)='', @StartIndex AS INT

	SELECT @StartIndex = (@PageNumber-1)*@PageSize  
	
	SET @Query='select uq.Id,uq.CollegeUniversity,uq.AggregatePercentage, uq.EndYear, uq.StartYear, uq.FileName, uq.FileOriginalName,
				uq.QualificationId, q.ShortName as QualificationName
				from UserQualificationInfo uq
				inner join Qualification q on uq.QualificationId = q.Id
				where ISNULL(uq.IsDeleted,0) = 0 and uq.EmployeeId = ' + CONVERT(VARCHAR(100), @EmployeeId)
	
	-- SEARCH OPERATION
	BEGIN
	SET @Conditions=''
	END
	IF(ISNULL(@Name,'')<>'')
	BEGIN
		SET @Conditions +=' and uq.ShortName LIKE ''%'+@Name+'%'''
	END
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
	
	print(@Pagination)
	IF(@Conditions<>'') SET @Query+= @Conditions
	IF(@OrderQuery<>'') SET @Query+=@OrderQuery
	IF(@Pagination<>'') SET @Query+=@Pagination

	EXEC(@Query)
END
GO
CREATE OR ALTER   PROCEDURE [dbo].[GetPreviousEmployerList]
@EmployerName AS VARCHAR(100)=NULL,
@DocumentName AS VARCHAR(100)=NULL,
@EmployeeId AS bigint,
@SortColumnName AS VARCHAR(50)='ID',
@SortColumnDirection AS VARCHAR(50)='ASC',
@PageNumber AS INT=1,
@PageSize AS INT=10
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE  @offset AS INT, @SQL NVARCHAR(MAX),
	  @EffectiveSortColumnName NVARCHAR(50) = COALESCE(NULLIF(@SortColumnName,''),'Id'),
      @EffectiveSortColumnDirection NVARCHAR(4) = COALESCE(NULLIF(@SortColumnDirection,''),'ASC')
	 
	SELECT @offset = (@PageNumber-1)*@PageSize  

	SET @SQL ='
	SELECT pe.ID ,
	    pe.EmployerName,
        pe.StartDate,
		pe.EndDate,
		( SELECT 
		  ped.Id ,
		  edt.DocumentName,
		  ped.FileName,
		  ped.FileOriginalName
		  FROM PreviousEmployerDocument ped
		  INNER JOIN EmployerDocumentType edt ON ped.EmployerDocumentTypeId = edt.Id AND edt.IsDeleted =0
		  WHERE ped.PreviousEmployerId = pe.Id AND ped.IsDeleted =0
		  FOR JSON PATH
		)As DocumentsJson
		FROM [PreviousEmployer] pe
		LEFT JOIN PreviousEmployerDocument ped ON pe.Id =ped.PreviousEmployerId
		LEFT JOIN EmployerDocumentType edt ON ped.EmployerDocumentTypeId = edt.Id
		WHERE EmployeeId = @EmployeeId
		AND  (@EmployerName IS NULL OR pe.EmployerName LIKE ''%''+ @EmployerName +''%'')
		AND (@DocumentName IS NULL OR edt.DocumentName LIKE ''%''+ @DocumentName +''%'')
		AND pe.IsDeleted =0
		Group BY pe.EmployerName,pe.StartDate, pe.EndDate, pe.Id
		ORDER BY '+ @EffectiveSortColumnName + ' ' +@EffectiveSortColumnDirection + ' 
		OFFSET '+ CAST (@offset AS NVARCHAR(10)) + ' ROWS
        FETCH NEXT '+ CAST(@PageSize AS NVARCHAR(10))+ ' ROWS ONLY;'
		
		EXEC sp_executesql @SQL,
		N'@EmployerName AS VARCHAR(100)=NULL,
          @DocumentName AS VARCHAR(100),
          @EmployeeId AS bigint,
          @SortColumnName NVARCHAR(50),
          @SortColumnDirection NVARCHAR(4),
          @StartIndex int ,
          @PageSize int', 
		  @EmployerName, @DocumentName, @EmployeeId, @SortColumnName, @SortColumnDirection, @offset, @PageSize;
END
GO


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
	
	SET @Query='SELECT cp.Id,Name,EffectiveDate,cp.DocumentCategoryId,cdc.CategoryName as DocumentCategory ,VersionNo,cp.ModifiedOn,cp.ModifiedBy,cp.CreatedOn,cp.CreatedBy
	,(select count(id) from CompanyPolicy) as TotalRecords FROM CompanyPolicy cp
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
----