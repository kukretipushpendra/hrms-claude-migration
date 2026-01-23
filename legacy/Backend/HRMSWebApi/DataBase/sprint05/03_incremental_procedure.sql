CREATE OR ALTER PROCEDURE [dbo].[GetPreviousEmployerList]
@EmployerName AS VARCHAR(100) = NULL,
@DocumentName AS VARCHAR(100) = NULL,
@EmployeeId AS BIGINT,
@SortColumnName AS VARCHAR(50) = 'ID',
@SortColumnDirection AS VARCHAR(50) = 'ASC',
@PageNumber AS INT = 1,
@PageSize AS INT = 10
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @StartIndex AS INT, @Query AS NVARCHAR(MAX) = '', @OrderQuery AS VARCHAR(MAX) = '', @Pagination AS VARCHAR(MAX)='';
	SET @SortColumnName = COALESCE(NULLIF(@SortColumnName,''),'Id');
	SET @SortColumnDirection = COALESCE(NULLIF(@SortColumnDirection,''),'ASC');
	SET @StartIndex = (@PageNumber - 1) * @PageSize;

	SET @Query = 'SELECT pe.ID, pe.EmployerName, pe.StartDate, pe.EndDate, pe.Designation,
				 (
					SELECT ped.Id, edt.DocumentName, ped.FileName, ped.FileOriginalName,edt.Id as EmployerDocumentTypeId
					FROM PreviousEmployerDocument ped
					INNER JOIN EmployerDocumentType edt ON ped.EmployerDocumentTypeId = edt.Id AND edt.IsDeleted = 0
					WHERE ped.PreviousEmployerId = pe.Id AND ped.IsDeleted = 0
					FOR JSON PATH
				 ) As DocumentsJson,
				 (
					SELECT pr.Id, pr.FullName, pr.Designation, pr.Email, pr.ContactNumber
					FROM ProfessionalReference pr
					WHERE pr.PreviousEmployerId = pe.Id AND pr.IsDeleted = 0
					FOR JSON PATH
				 ) As ProfessionalReferencesJson
				 FROM [PreviousEmployer] pe
				 LEFT JOIN PreviousEmployerDocument ped ON pe.Id = ped.PreviousEmployerId
				 LEFT JOIN EmployerDocumentType edt ON ped.EmployerDocumentTypeId = edt.Id
				 WHERE EmployeeId = @EmployeeId
				 AND (@EmployerName IS NULL OR pe.EmployerName LIKE ''%''+ @EmployerName +''%'')
		  		 AND (@DocumentName IS NULL OR edt.DocumentName LIKE ''%''+ @DocumentName +''%'')
				 AND pe.IsDeleted = 0
				 Group BY pe.EmployerName, pe.StartDate, pe.EndDate, pe.Id, pe.Designation';

		IF(ISNULL(@SortColumnName,'') <> '' AND ISNULL(@SortColumnDirection,'') <> '')
		BEGIN
			SET @OrderQuery = ' ORDER BY ' + @SortColumnName + ' ' + @SortColumnDirection
		END
		ELSE SET @OrderQuery = ' ORDER BY pe.Id DESC'

		-- PAGINATION OPERATION
		IF(@PageSize > 0)
		BEGIN
			SET @Pagination = ' OFFSET ' + (CAST(@StartIndex AS VARCHAR(10))) + ' ROWS
			FETCH NEXT ' + (CAST(@PageSize AS varchar(10))) + ' ROWS ONLY'
		END
	
		IF(@OrderQuery <> '')
			SET @Query += @OrderQuery;

		IF(@Pagination <> '')
			SET @Query += @Pagination;

		--SELECT @Query

		EXEC sp_executesql @Query,
		N'@EmployerName AS VARCHAR(100)=NULL,
          @DocumentName AS VARCHAR(100),
          @EmployeeId AS BIGINT,
          @SortColumnName NVARCHAR(50),
          @SortColumnDirection NVARCHAR(4),
          @StartIndex INT,
          @PageSize INT', 
		  @EmployerName, @DocumentName, @EmployeeId, @SortColumnName, @SortColumnDirection, @StartIndex, @PageSize;
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
	
	SET @Query='SELECT N.Id, N.TemplateName,N.Subject,N.Description, N.Content,
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
--------------------------------------------------------------------
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
					   INNER JOIN [dbo].[DocumentType] d ON n.IdProofDocType =d.Id and d.IsDeleted=0
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
-------------------------------------------------------------------------------------------------
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
		SET @WhereConditons += @wherejoin + ' (e1.FirstName LIKE ''%'+@EmployeeName+'%'' or e1.MiddleName like ''%'+@EmployeeName+'%'' or e1.LastName like ''%'+@EmployeeName+'%'')'
		SET @wherejoin = @Andjoin
	END
	IF(@EmployeeId <> 0)
	BEGIN
		SET @WhereConditons += @wherejoin + ' e1.Id ='+ CONVERT(VARCHAR(12), @EmployeeId)
		SET @wherejoin = @Andjoin
	END
	IF(@DepartmentId <> 0)
	BEGIN
		SET @WhereConditons += @wherejoin + ' e2.DepartmentId ='+ CONVERT(VARCHAR(12), @DepartmentId)
		SET @wherejoin = @Andjoin
	END
	IF(ISNULL(@Email,'')<>'')
	BEGIN
		SET @WhereConditons += @wherejoin + ' e2.Email LIKE ''%'+@Email+'%'''
		SET @wherejoin = @Andjoin
	END
	IF(ISNULL(@Designation,'')<>'')
	BEGIN
		SET @WhereConditons += @wherejoin + ' e2.Designation LIKE ''%'+@Designation+'%'''
		SET @wherejoin = @Andjoin
	END
	IF(@EmploymentStatus <> 0)
	BEGIN
		SET @WhereConditons += @wherejoin + ' e2.EmploymentStatus ='+ CONVERT(VARCHAR(12), @EmploymentStatus)
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
				,EndDate,G.GroupName AS EmployeeGroup,S.StatusValue AS Status,E.Venue
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
-------------------------------------------------
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
	
	SET @Query='select uc.Id,uc.EmployeeId,uc.CertificateName,uc.FileName, uc.OriginalFileName,uc.CertificateExpiry
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
-------Get My Survey List----------
CREATE OR ALTER PROCEDURE [dbo].[GetSurveyList]
@Title AS VARCHAR(250)= '',
@StatusId AS bigint,
@EmpGroupId AS bigint,
@SortColumnName AS VARCHAR(50)='',
@SortColumnDirection AS VARCHAR(50)='',
@PageNumber AS INT=1,
@PageSize AS INT=10
AS
BEGIN
	DECLARE @Query AS VARCHAR(MAX)='',@OrderQuery AS VARCHAR(MAX)='',@Conditions AS VARCHAR(MAX)='',
	@Pagination AS VARCHAR(MAX)='', @StartIndex AS INT

	SELECT @StartIndex = (@PageNumber-1)*@PageSize  
	
	SET @Query='SELECT sm.SurveyId,sm.EmpGroupId,s.PublishDate,s.DeadLine,s.StatusId,eg.GroupName,sm.EmpGroupId,s.Title,st.StatusValue
		         FROM SurveyEmpGroupMapping sm
		INNER JOIN [dbo].[Surveys] s ON s.Id= sm.SurveyId 
		INNER JOIN [dbo].[Group] eg ON eg.Id= sm.EmpGroupId
		INNER JOIN [dbo].[Status] st ON st.Id= s.StatusId WHERE s.IsDeleted =0'
	
	BEGIN
	SET @Conditions=''
	END
	IF(ISNULL(@Title,'')<>'')
	BEGIN
		SET @Conditions +=' and (s.Title LIKE ''%'+@Title+'%'') '
	END	
	IF(@StatusId <> 0)
	BEGIN
		SET @Conditions +=' and s.StatusId='+ CONVERT(VARCHAR(12), @StatusId)
	END	
	IF(@EmpGroupId <> 0)
	BEGIN
		SET @Conditions +=' and sm.EmpGroupId='+ CONVERT(VARCHAR(12), @EmpGroupId)
	END	
		-- SORT OPERATION
	IF(ISNULL(@SortColumnName,'')<>'' AND ISNULL(@SortColumnDirection,'')<>'')
	BEGIN
		SET @OrderQuery=' ORDER BY '+@SortColumnName+' '+@SortColumnDirection
	END
	ELSE SET @OrderQuery=' ORDER BY sm.SurveyId DESC ' 
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
Go
