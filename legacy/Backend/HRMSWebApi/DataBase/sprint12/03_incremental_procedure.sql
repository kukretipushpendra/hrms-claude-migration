------------------GetKpiGoalsList--------------------
GO
CREATE OR ALTER PROCEDURE [dbo].[GetKpiGoalsList]
    @Title VARCHAR(250) = NULL,
    @DepartmentId BIGINT = NULL,
    @CreatedBy VARCHAR(250) = NULL,
    @CreatedOnFrom DATE = NULL,
    @CreatedOnTo DATE = NULL,
    @SortColumn VARCHAR(50) = NULL,
    @SortDesc BIT = 0,
    @StartIndex INT = NULL,
    @PageSize INT = NULL
AS
BEGIN
    /*
    EXEC GetKpiGoalsList @SortColumn = 'Title', @SortDesc = 1, @PageSize = 50
    */

    -- Count query
    SELECT COUNT(*) AS TotalCount
    FROM KPIGoals KG
    LEFT JOIN Department D ON KG.DepartmentId = D.Id
    WHERE
        KG.IsDeleted = 0 AND
        (@Title IS NULL OR CHARINDEX(@Title, KG.Title) > 0) AND
        (@DepartmentId IS NULL OR KG.DepartmentId = @DepartmentId) AND
        (@CreatedBy IS NULL OR CHARINDEX(@CreatedBy, KG.CreatedBy) > 0) AND
        (@CreatedOnFrom IS NULL OR @CreatedOnTo IS NULL OR CAST(KG.CreatedOn AS DATE) BETWEEN @CreatedOnFrom AND @CreatedOnTo)

    -- Data query
    SELECT
		KG.Id,
        KG.Title,
        KG.Description,
        KG.DepartmentId,
        D.Department,
        KG.CreatedBy,
        KG.CreatedOn
    FROM KPIGoals KG
    LEFT JOIN Department D ON KG.DepartmentId = D.Id
    WHERE
        KG.IsDeleted = 0 AND
        (@Title IS NULL OR CHARINDEX(@Title, KG.Title) > 0) AND
        (@DepartmentId IS NULL OR KG.DepartmentId = @DepartmentId) AND
        (@CreatedBy IS NULL OR CHARINDEX(@CreatedBy, KG.CreatedBy) > 0) AND
        (@CreatedOnFrom IS NULL OR @CreatedOnTo IS NULL OR CAST(KG.CreatedOn AS DATE) BETWEEN @CreatedOnFrom AND @CreatedOnTo)
    ORDER BY 
        CASE WHEN @SortColumn = 'Title' AND @SortDesc = 0 THEN KG.Title END ASC,
        CASE WHEN @SortColumn = 'Department' AND @SortDesc = 0 THEN D.Department END ASC,
        CASE WHEN @SortColumn = 'CreatedBy' AND @SortDesc = 0 THEN KG.CreatedBy END ASC,
        CASE WHEN @SortColumn = 'CreatedOn' AND @SortDesc = 0 THEN KG.CreatedOn END ASC,
        CASE WHEN @SortColumn = 'Title' AND @SortDesc = 1 THEN KG.Title END DESC,
        CASE WHEN @SortColumn = 'Department' AND @SortDesc = 1 THEN D.Department END DESC,
        CASE WHEN @SortColumn = 'CreatedBy' AND @SortDesc = 1 THEN KG.CreatedBy END DESC,
        CASE WHEN @SortColumn = 'CreatedOn' AND @SortDesc = 1 THEN KG.CreatedOn END DESC
    OFFSET COALESCE(NULLIF(@StartIndex, 0), 0) ROWS
    FETCH NEXT COALESCE(NULLIF(@PageSize, 0), 10) ROWS ONLY;
END
GO

--------------------GetEmployeesKPI-----------------------
GO
CREATE OR ALTER PROCEDURE [dbo].[GetEmployeesKPI]
    @SessionUserId BIGINT,
    @RoleId INT,
    @EmployeeName VARCHAR(100) = '',
    @EmployeeCode VARCHAR(MAX) = '',
    @AppraisalDateFrom DATE = NULL,
    @AppraisalDateTo DATE = NULL,
    @ReviewDateFrom DATE = NULL,
    @ReviewDateTo DATE = NULL,
    @SortColumnName VARCHAR(50) = '',
    @SortColumnDirection VARCHAR(50) = '',
    @PageNumber INT = 1,
    @PageSize INT = 10,
    @StatusFilter INT = NULL
AS
BEGIN
    DECLARE @StartIndex INT
    SELECT @StartIndex = (@PageNumber - 1) * @PageSize

    -- Count query for total records
    SELECT COUNT(*) AS TotalCount
    FROM EmployeeData ED
    LEFT JOIN EmploymentDetail EMP ON EMP.EmployeeId = ED.Id
    LEFT JOIN KPIPlan KP ON KP.Id = (Select MAX(KPL.Id) from KPIPlan KPL where KPL.EmployeeId = ED.Id)
    WHERE 1 = 1
        AND (@RoleId != 5 OR (EMP.ReportingMangerId = @SessionUserId OR EMP.ImmediateManager = @SessionUserId))
        AND (NULLIF(@EmployeeName, '') IS NULL OR CONCAT(ED.FirstName, ' ', ED.LastName) LIKE '%' + @EmployeeName + '%')
        AND (NULLIF(@EmployeeCode, '') IS NULL OR ED.EmployeeCode IN (SELECT TRIM(value) FROM STRING_SPLIT(@EmployeeCode, ',')))
        AND (@AppraisalDateFrom IS NULL OR KP.AppraisalDate >= @AppraisalDateFrom)
        AND (@AppraisalDateTo IS NULL OR KP.AppraisalDate <= @AppraisalDateTo)
        AND (@ReviewDateFrom IS NULL OR KP.ReviewDate >= @ReviewDateFrom)
        AND (@ReviewDateTo IS NULL OR KP.ReviewDate <= @ReviewDateTo)
        AND (
            @StatusFilter IS NULL OR @StatusFilter = 0 
            OR (@StatusFilter = 1 AND KP.Id IS NULL) -- NOT CREATED
            OR (@StatusFilter = 2 AND KP.Id IS NOT NULL AND KP.IsReviewed IS NULL) -- ASSIGNED
            OR (@StatusFilter = 3 AND KP.Id IS NOT NULL AND KP.IsReviewed = 0) -- SUBMITTED
            OR (@StatusFilter = 4 AND KP.Id IS NOT NULL AND KP.IsReviewed = 1) -- REVIEWED
        )

    -- CTE to map numeric status to text for alphabetical sorting
    ;WITH EmployeeKPI AS (
        SELECT 
            ED.Id AS EmployeeId,
            ED.EmployeeCode,
            EMP.Email,
            EMP.JoiningDate,
            CONCAT(ED.FirstName, ' ', ED.LastName) AS EmployeeName,
            KP.AppraisalDate AS NextAppraisalDate,
            (SELECT TOP 1 KPL.ReviewDate 
			 FROM KPIPlan KPL 
			 WHERE KPL.EmployeeId = ED.Id 
			 AND KPL.IsReviewed = 1 
			 ORDER BY KPL.ReviewDate DESC, KPL.Id DESC) AS LastReviewDate,
            KP.IsReviewed,
            KP.ReviewDate,
            KP.Id AS PlanId,
            CASE 
                WHEN KP.Id IS NULL THEN 1 -- NOT CREATED
                WHEN KP.Id IS NOT NULL AND KP.IsReviewed IS NULL THEN 2 -- ASSIGNED
                WHEN KP.Id IS NOT NULL AND KP.IsReviewed = 0 THEN 3 -- SUBMITTED
                WHEN KP.Id IS NOT NULL AND KP.IsReviewed = 1 THEN 4 -- REVIEWED
                ELSE 0 -- Default (no specific status)
            END AS Status,
            CASE 
                WHEN KP.Id IS NULL THEN 'NOT CREATED'
                WHEN KP.Id IS NOT NULL AND KP.IsReviewed IS NULL THEN 'ASSIGNED'
                WHEN KP.Id IS NOT NULL AND KP.IsReviewed = 0 THEN 'SUBMITTED'
                WHEN KP.Id IS NOT NULL AND KP.IsReviewed = 1 THEN 'REVIEWED'
                ELSE 'UNKNOWN'
            END AS StatusText
        FROM EmployeeData ED
        LEFT JOIN EmploymentDetail EMP ON EMP.EmployeeId = ED.Id
        LEFT JOIN KPIPlan KP ON KP.Id = (Select MAX(KPL.Id) from KPIPlan KPL where KPL.EmployeeId = ED.Id)
        WHERE 1 = 1 
            AND (@RoleId != 5 OR (EMP.ReportingMangerId = @SessionUserId OR EMP.ImmediateManager = @SessionUserId))
            AND (NULLIF(@EmployeeName, '') IS NULL OR CONCAT(ED.FirstName, ' ', ED.LastName) LIKE '%' + @EmployeeName + '%')
            AND (NULLIF(@EmployeeCode, '') IS NULL OR ED.EmployeeCode IN (SELECT TRIM(value) FROM STRING_SPLIT(@EmployeeCode, ',')))
            AND (@AppraisalDateFrom IS NULL OR KP.AppraisalDate >= @AppraisalDateFrom)
            AND (@AppraisalDateTo IS NULL OR KP.AppraisalDate <= @AppraisalDateTo)
            AND (@ReviewDateFrom IS NULL OR KP.ReviewDate >= @ReviewDateFrom)
            AND (@ReviewDateTo IS NULL OR KP.ReviewDate <= @ReviewDateTo)
            AND (
                @StatusFilter IS NULL OR @StatusFilter = 0 
                OR (@StatusFilter = 1 AND KP.Id IS NULL) -- NOT CREATED
                OR (@StatusFilter = 2 AND KP.Id IS NOT NULL AND KP.IsReviewed IS NULL) -- ASSIGNED
                OR (@StatusFilter = 3 AND KP.Id IS NOT NULL AND KP.IsReviewed = 0) -- SUBMITTED
                OR (@StatusFilter = 4 AND KP.Id IS NOT NULL AND KP.IsReviewed = 1) -- REVIEWED
            )
			
    )
    -- Data query with sorting and pagination
    SELECT 
        EmployeeId,
        EmployeeCode,
        Email,
        JoiningDate,
        EmployeeName,
        NextAppraisalDate,
        LastReviewDate,
        IsReviewed,
        ReviewDate,
        PlanId,
        Status
    FROM EmployeeKPI
    ORDER BY 
        CASE WHEN @SortColumnName = 'employeeName' AND @SortColumnDirection = 'ASC' THEN EmployeeName END ASC,
        CASE WHEN @SortColumnName = 'employeeCode' AND @SortColumnDirection = 'ASC' THEN EmployeeCode END ASC,
        CASE WHEN @SortColumnName = 'nextAppraisalDate' AND @SortColumnDirection = 'ASC' THEN NextAppraisalDate END ASC,
        CASE WHEN @SortColumnName = 'lastReviewDate' AND @SortColumnDirection = 'ASC' THEN LastReviewDate END ASC,
        CASE WHEN @SortColumnName = 'status' AND @SortColumnDirection = 'ASC' THEN StatusText END ASC,
        CASE WHEN @SortColumnName = 'employeeName' AND @SortColumnDirection = 'DESC' THEN EmployeeName END DESC,
        CASE WHEN @SortColumnName = 'employeeCode' AND @SortColumnDirection = 'DESC' THEN EmployeeCode END DESC,
        CASE WHEN @SortColumnName = 'nextAppraisalDate' AND @SortColumnDirection = 'DESC' THEN NextAppraisalDate END DESC,
        CASE WHEN @SortColumnName = 'lastReviewDate' AND @SortColumnDirection = 'DESC' THEN LastReviewDate END DESC,
        CASE WHEN @SortColumnName = 'status' AND @SortColumnDirection = 'DESC' THEN StatusText END DESC,
        CASE WHEN @SortColumnName = '' THEN EmployeeName END ASC
    OFFSET COALESCE(NULLIF(@StartIndex, 0), 0) ROWS
    FETCH NEXT COALESCE(NULLIF(@PageSize, 0), 10) ROWS ONLY;
END
GO

GO
CREATE OR ALTER PROCEDURE [dbo].[GetLogs]
@SortColumnName AS VARCHAR(50)='',
@SortColumnDirection AS VARCHAR(50)='',
@PageNumber AS INT=1,
@PageSize AS INT=10,
@DateFrom DATETIME = NULL,
@DateTo DATETIME = NULL,

@Message VARCHAR(256) = NULL,
@Level VARCHAR(15) = NULL,
@RequestId VARCHAR(256) = NULL,
@Id BIGINT = NULL
AS
BEGIN 
		DECLARE @StartIndex AS INT
	 
		SELECT @StartIndex = (@PageNumber-1)*@PageSize  

		SELECT Count(*) as TotalCount FROM Logging
		WHERE
		(@DateFrom IS NULL OR @DateTo IS NULL OR [TimeStamp] BETWEEN @DateFrom AND @DateTo) AND
		(NULLIF(@Message, '') IS NULL OR CHARINDEX(@Message, [Message]) > 0) AND
		(NULLIF(@RequestId, '') IS NULL OR CHARINDEX(@RequestId, RequestId) > 0) AND
		(NULLIF(@Level, '') IS NULL OR @Level = [Level]) AND
		(@Id IS NULL OR @Id = Id)
 		 
		SELECT Id, [Message], MessageTemplate, [Level], [TimeStamp], Exception, RequestId, LogEvent
		FROM Logging
		WHERE
		(@DateFrom IS NULL OR @DateTo IS NULL OR [TimeStamp] BETWEEN @DateFrom AND @DateTo) AND
		(NULLIF(@Message, '') IS NULL OR CHARINDEX(@Message, [Message]) > 0) AND
		(NULLIF(@RequestId, '') IS NULL OR CHARINDEX(@RequestId, RequestId) > 0) AND
		(NULLIF(@Level, '') IS NULL OR @Level = [Level]) AND
		(@Id IS NULL OR @Id = Id)
 		 
		-- SORT OPERATION
		ORDER BY 
		CASE WHEN LOWER(@SortColumnName) = 'timestamp' AND @SortColumnDirection = 'ASC' THEN [TimeStamp] END ASC,
		CASE WHEN LOWER(@SortColumnName) = 'id' AND @SortColumnDirection = 'ASC' THEN Id END ASC,
		CASE WHEN LOWER(@SortColumnName) = 'level' AND @SortColumnDirection = 'ASC' THEN [Level] END ASC,
		
		CASE WHEN LOWER(@SortColumnName) = 'timestamp' AND @SortColumnDirection = 'DESC' THEN [TimeStamp] END DESC,
		CASE WHEN LOWER(@SortColumnName) = 'id' AND @SortColumnDirection = 'DESC' THEN Id END DESC,
		CASE WHEN LOWER(@SortColumnName) = 'level' AND @SortColumnDirection = 'DESC' THEN [Level] END DESC
   
		-- PAGINATION OPERATION
		OFFSET COALESCE(NULLIF(@StartIndex, 0), 0) ROWS
		FETCH NEXT COALESCE(NULLIF(@PageSize, 0), 10) ROWS ONLY;
	  
END
GO


CREATE OR ALTER PROCEDURE [dbo].[GetCronJobLogs]
@SortColumnName AS VARCHAR(50)='',
@SortColumnDirection AS VARCHAR(50)='',
@PageNumber AS INT=1,
@PageSize AS INT=10,
@DateFrom DATETIME = NULL,
@DateTo DATETIME = NULL,

@Id BIGINT = NULL,
@TypeId INT = NULL
AS
BEGIN 
		DECLARE @StartIndex AS INT
	 
		SELECT @StartIndex = (@PageNumber-1)*@PageSize  

		SELECT Count(*) as TotalCount FROM CronJobLog
		WHERE
		(@DateFrom IS NULL OR @DateTo IS NULL OR StartedAt BETWEEN @DateFrom AND @DateTo) AND
		(NULLIF(@TypeId, '') IS NULL OR @TypeId = TypeId) AND
		(@Id IS NULL OR @Id = Id)
 		 
		SELECT CL.Id, CL.TypeId, CL.RequestId, CL.StartedAt, CL.CompletedAt, CL.Payload, L.Id AS LogId
		FROM CronJobLog CL
		LEFT JOIN Logging L ON L.RequestId = CL.RequestId
		WHERE
		(@DateFrom IS NULL OR @DateTo IS NULL OR CL.StartedAt BETWEEN @DateFrom AND @DateTo) AND
		(NULLIF(@TypeId, '') IS NULL OR @TypeId = CL.TypeId) AND
		(@Id IS NULL OR @Id = CL.Id)
 		 
		-- SORT OPERATION
		ORDER BY 
		CASE WHEN LOWER(@SortColumnName) = 'StartedAt' AND @SortColumnDirection = 'ASC' THEN CL.StartedAt END ASC,
		CASE WHEN LOWER(@SortColumnName) = 'id' AND @SortColumnDirection = 'ASC' THEN CL.Id END ASC,
		CASE WHEN LOWER(@SortColumnName) = 'TypeId' AND @SortColumnDirection = 'ASC' THEN CL.TypeId END ASC,
		
		CASE WHEN LOWER(@SortColumnName) = 'StartedAt' AND @SortColumnDirection = 'DESC' THEN CL.StartedAt END DESC,
		CASE WHEN LOWER(@SortColumnName) = 'id' AND @SortColumnDirection = 'DESC' THEN CL.Id END DESC,
		CASE WHEN LOWER(@SortColumnName) = 'TypeId' AND @SortColumnDirection = 'DESC' THEN CL.TypeId END DESC
   
		-- PAGINATION OPERATION
		OFFSET COALESCE(NULLIF(@StartIndex, 0), 0) ROWS
		FETCH NEXT COALESCE(NULLIF(@PageSize, 0), 10) ROWS ONLY;
	  
END
GO
----------------Grievances SP--------------------
CREATE OR ALTER PROCEDURE [dbo].[GetEmployeeListGrievances]
    @SessionUserId INT = NULL,
    @RoleId INT,
    @GrievanceTypeId INT = NULL,
    @Status INT = NULL,
    @TatStatus INT = NULL,
    @CreatedOn DATE = NULL,
    @ResolvedDate DATE = NULL,
    @ResolvedBy INT = NULL,
    @CreatedBy NVARCHAR(MAX) = NULL,  -- comma-separated list of employee codes
    @Level INT = NULL,
    @SortColumnName VARCHAR(50) = NULL,
    @SortDirection VARCHAR(4) = 'DESC',
    @StartIndex INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Offset INT = (@StartIndex - 1) * @PageSize;

    
    DECLARE @CreatedByCodes TABLE (Code NVARCHAR(100));

    IF (@CreatedBy IS NOT NULL AND LTRIM(RTRIM(@CreatedBy)) <> '')
    BEGIN
        INSERT INTO @CreatedByCodes(Code)
        SELECT TRIM(value) FROM STRING_SPLIT(@CreatedBy, ',');
    END

    -- Count query
    SELECT COUNT(*) AS TotalCount
    FROM EmployeeGrievance eg
    INNER JOIN GrievanceType gt ON eg.GrievanceTypeId = gt.Id
    OUTER APPLY (
        SELECT TOP 1 *
        FROM EmploymentDetail Emp
        WHERE Emp.Email = eg.CreatedBy
    ) Emp
    LEFT JOIN EmployeeData ED ON ED.Id = Emp.EmployeeId
    WHERE 1 = 1
    AND (
        @RoleId = 1
        OR EXISTS (
            SELECT 1
            FROM GrievanceOwner go
            WHERE go.GrievanceTypeId = eg.GrievanceTypeId
              AND go.OwnerID = @SessionUserId
              AND go.IsDeleted = 0
        )
    )
    AND (@GrievanceTypeId IS NULL OR eg.GrievanceTypeId = @GrievanceTypeId)
    AND (@Status IS NULL OR eg.Status = @Status)
    AND (@TatStatus IS NULL OR eg.TatStatus = @TatStatus)
    AND (@CreatedOn IS NULL OR CAST(eg.CreatedOn AS DATE) = @CreatedOn)
    AND (@ResolvedDate IS NULL OR CAST(eg.ResolvedDate AS DATE) = @ResolvedDate)
    AND (@ResolvedBy IS NULL OR eg.ResolvedBy = @ResolvedBy)
    AND (
        NOT EXISTS (SELECT 1 FROM @CreatedByCodes) 
        OR ED.EmployeeCode IN (SELECT Code FROM @CreatedByCodes)
    )
    AND (@Level IS NULL OR eg.Level = @Level);

    -- Data query
    SELECT 
        eg.Id,
        eg.TicketNo,
        eg.GrievanceTypeId,
        gt.GrievanceName AS GrievanceTypeName,
        eg.Status,
        eg.CreatedOn,
        eg.CreatedBy,
        CASE
            WHEN resolver.Id IS NOT NULL THEN CONCAT(resolver.FirstName, ' ', ISNULL(NULLIF(resolver.MiddleName, '') + ' ', ''), resolver.LastName)
            ELSE NULL
        END AS ResolvedBy,
        eg.ResolvedDate,
        eg.Level,
        eg.TatStatus
    FROM EmployeeGrievance eg
    INNER JOIN GrievanceType gt ON eg.GrievanceTypeId = gt.Id
    LEFT JOIN EmployeeData resolver ON resolver.Id = eg.ResolvedBy
    OUTER APPLY (
        SELECT TOP 1 *
        FROM EmploymentDetail Emp
        WHERE Emp.Email = eg.CreatedBy
    ) Emp
    LEFT JOIN EmployeeData ED ON ED.Id = Emp.EmployeeId
    WHERE 1 = 1
    AND (
        @RoleId = 1
        OR EXISTS (
            SELECT 1
            FROM GrievanceOwner go
            WHERE go.GrievanceTypeId = eg.GrievanceTypeId
              AND go.OwnerID = @SessionUserId
              AND go.IsDeleted = 0
        )
    )
    AND (@GrievanceTypeId IS NULL OR eg.GrievanceTypeId = @GrievanceTypeId)
    AND (@Status IS NULL OR eg.Status = @Status)
    AND (@TatStatus IS NULL OR eg.TatStatus = @TatStatus)
    AND (@CreatedOn IS NULL OR CAST(eg.CreatedOn AS DATE) = @CreatedOn)
    AND (@ResolvedDate IS NULL OR CAST(eg.ResolvedDate AS DATE) = @ResolvedDate)
    AND (@ResolvedBy IS NULL OR eg.ResolvedBy = @ResolvedBy)
    AND (
        NOT EXISTS (SELECT 1 FROM @CreatedByCodes) 
        OR ED.EmployeeCode IN (SELECT Code FROM @CreatedByCodes)
    )
    AND (@Level IS NULL OR eg.Level = @Level)
    ORDER BY
        CASE WHEN @SortColumnName = 'TicketNo' AND @SortDirection = 'ASC' THEN eg.TicketNo END ASC,
        CASE WHEN @SortColumnName = 'TicketNo' AND @SortDirection = 'DESC' THEN eg.TicketNo END DESC,
        CASE WHEN @SortColumnName = 'GrievanceTypeName' AND @SortDirection = 'ASC' THEN gt.GrievanceName END ASC,
        CASE WHEN @SortColumnName = 'GrievanceTypeName' AND @SortDirection = 'DESC' THEN gt.GrievanceName END DESC,
        CASE WHEN @SortColumnName = 'Status' AND @SortDirection = 'ASC' THEN eg.Status END ASC,
        CASE WHEN @SortColumnName = 'Status' AND @SortDirection = 'DESC' THEN eg.Status END DESC,
        CASE WHEN @SortColumnName = 'CreatedOn' AND @SortDirection = 'ASC' THEN eg.CreatedOn END ASC,
        CASE WHEN @SortColumnName = 'CreatedOn' AND @SortDirection = 'DESC' THEN eg.CreatedOn END DESC,
        CASE WHEN @SortColumnName = 'Level' AND @SortDirection = 'ASC' THEN eg.Level END ASC,
        CASE WHEN @SortColumnName = 'Level' AND @SortDirection = 'DESC' THEN eg.Level END DESC,
        CASE WHEN @SortColumnName = 'TatStatus' AND @SortDirection = 'ASC' THEN eg.TatStatus END ASC,
        CASE WHEN @SortColumnName = 'TatStatus' AND @SortDirection = 'DESC' THEN eg.TatStatus END DESC,
        CASE WHEN @SortColumnName = 'ResolvedDate' AND @SortDirection = 'ASC' THEN eg.ResolvedDate END ASC,
        CASE WHEN @SortColumnName = 'ResolvedDate' AND @SortDirection = 'DESC' THEN eg.ResolvedDate END DESC,
        CASE 
            WHEN @SortColumnName = 'ResolvedBy' AND @SortDirection = 'ASC' 
            THEN CONCAT(resolver.FirstName, ' ', ISNULL(NULLIF(resolver.MiddleName, '') + ' ', ''), resolver.LastName) 
        END ASC,
        CASE 
            WHEN @SortColumnName = 'ResolvedBy' AND @SortDirection = 'DESC' 
            THEN CONCAT(resolver.FirstName, ' ', ISNULL(NULLIF(resolver.MiddleName, '') + ' ', ''), resolver.LastName) 
        END DESC,
        CASE WHEN @SortColumnName = 'CreatedBy' AND @SortDirection = 'ASC' THEN eg.CreatedBy END ASC,
        CASE WHEN @SortColumnName = 'CreatedBy' AND @SortDirection = 'DESC' THEN eg.CreatedBy END DESC,
        eg.CreatedOn DESC -- Default fallback sort
    OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;
END
GO
------------------
CREATE OR ALTER PROCEDURE [dbo].[GetEmployeeGrievances]
    @EmployeeId BIGINT,
    @GrievanceTypeId INT = NULL,
    @Status INT = NULL,
    @SortColumnName VARCHAR(50) = NULL,
    @SortDirection VARCHAR(4) = 'DESC',  -- 'ASC' or 'DESC'
    @StartIndex INT = 0,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @OffsetValue INT = CASE WHEN @StartIndex > 0 THEN @StartIndex - 1 ELSE 0 END;

    -- Count query
    SELECT COUNT(1) AS TotalCount
    FROM EmployeeGrievance eg
    WHERE eg.EmployeeId = @EmployeeId
      AND (@GrievanceTypeId IS NULL OR eg.GrievanceTypeId = @GrievanceTypeId)
      AND (@Status IS NULL OR eg.Status = @Status)
      AND EXISTS (
          SELECT 1 FROM GrievanceOwner go 
          WHERE go.GrievanceTypeId = eg.GrievanceTypeId 
            AND go.Level = eg.Level 
            AND go.IsDeleted = 0
      );

    -- Data query
    SELECT 
        eg.Id,
        eg.GrievanceTypeId,
        gt.GrievanceName AS GrievanceTypeName,
        eg.Title,
        eg.Description,
        eg.CreatedOn,
        eg.TicketNo,
        eg.Level,
        eg.Status,
        eg.TatStatus,
        STRING_AGG(
            LTRIM(RTRIM(
                ISNULL(ed.FirstName, '') + ' ' +
                ISNULL(ed.MiddleName + ' ', '') +
                ISNULL(ed.LastName, '')
            )), ', ') AS ManageBy
    FROM EmployeeGrievance eg
    INNER JOIN GrievanceType gt ON eg.GrievanceTypeId = gt.Id
    LEFT JOIN GrievanceOwner go ON eg.GrievanceTypeId = go.GrievanceTypeId AND eg.Level = go.Level
    LEFT JOIN EmployeeData ed ON go.OwnerID = ed.Id
    WHERE eg.EmployeeId = @EmployeeId
      AND (@GrievanceTypeId IS NULL OR eg.GrievanceTypeId = @GrievanceTypeId)
      AND (@Status IS NULL OR eg.Status = @Status)
      AND go.IsDeleted = 0
    GROUP BY eg.Id, eg.GrievanceTypeId, gt.GrievanceName, eg.Title, eg.Description,
             eg.CreatedOn, eg.TicketNo, eg.Level, eg.Status, eg.TatStatus
    ORDER BY 
        CASE WHEN @SortColumnName = 'Id' AND @SortDirection = 'ASC' THEN eg.Id END ASC,
        CASE WHEN @SortColumnName = 'Id' AND @SortDirection = 'DESC' THEN eg.Id END DESC,
        CASE WHEN @SortColumnName = 'GrievanceTypeName' AND @SortDirection = 'ASC' THEN gt.GrievanceName END ASC,
        CASE WHEN @SortColumnName = 'GrievanceTypeName' AND @SortDirection = 'DESC' THEN gt.GrievanceName END DESC,
        CASE WHEN @SortColumnName = 'Title' AND @SortDirection = 'ASC' THEN eg.Title END ASC,
        CASE WHEN @SortColumnName = 'Title' AND @SortDirection = 'DESC' THEN eg.Title END DESC,
        CASE WHEN @SortColumnName = 'CreatedOn' AND @SortDirection = 'ASC' THEN eg.CreatedOn END ASC,
        CASE WHEN @SortColumnName = 'CreatedOn' AND @SortDirection = 'DESC' THEN eg.CreatedOn END DESC,
        -- Default order
        eg.CreatedOn DESC
    OFFSET @OffsetValue ROWS FETCH NEXT @PageSize ROWS ONLY;
END
GO
