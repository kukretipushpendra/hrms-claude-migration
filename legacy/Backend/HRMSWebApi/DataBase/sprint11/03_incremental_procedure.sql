CREATE OR ALTER PROCEDURE [dbo].[CreditMonthlyLeaveBalance] 
    @LeaveTypeId AS INT, 
    @CreditAmount AS DECIMAL (18, 2),
    @CarryOverLimit AS DECIMAL(5,2),
    @SelectedDate AS DATE,
    @CarryOverMonth AS INT,
    @Description VARCHAR(50) NULL = NULL,
    @CreatedBy NVARCHAR(120) = 'admin'
    
AS 
BEGIN
    DECLARE @updatedRows INT = 0
    DECLARE @id INT
    DECLARE @EmpId BIGINT
    DECLARE @balance DECIMAL (18, 2)
    DECLARE @cappedBalance DECIMAL(18,2)

DECLARE id_cursor CURSOR FOR
SELECT 
    ISNULL(EL.Id, 0) AS EmployeeLeaveId, 
    ED.Id AS EmployeeId, 
    COALESCE(
        (SELECT TOP 1 AUL.ClosingBalance 
         FROM [dbo].[AccrualUtilizedLeave] AUL 
         WHERE AUL.EmployeeId = ED.Id 
           AND AUL.LeaveId = @LeaveTypeId 
         ORDER BY AUL.Id DESC), 
        CAST(ISNULL(EL.OpeningBalance, 0) AS DECIMAL(18, 2))
    ) AS OpeningBalance
FROM EmployeeData ED
JOIN EmploymentDetail EMP ON EMP.EmployeeId = ED.Id
INNER JOIN EmployeeLeave EL 
    ON EL.EmployeeId = ED.Id AND EL.LeaveId = @LeaveTypeId
WHERE ED.IsDeleted = 0
  AND EMP.EmployeeStatus != 4;

    OPEN id_cursor
    FETCH NEXT FROM id_cursor INTO @id, @EmpId, @balance

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF NOT EXISTS (
            SELECT Id 
            FROM AccrualUtilizedLeave 
            WHERE EmployeeId = @EmpId 
              AND LeaveId = @LeaveTypeId 
              AND MONTH([Date]) = MONTH(@SelectedDate)
              AND YEAR([Date]) = YEAR(@SelectedDate)
        ) 
        BEGIN
            -- Carryover logic: limit the balance
            IF (MONTH(@SelectedDate) = @CarryOverMonth)
            BEGIN
                SET @cappedBalance = 
                    CASE 
                        WHEN @CarryOverLimit < @balance THEN @CarryOverLimit 
                        ELSE @balance 
                    END

                -- Persist the capped balance (Fix)
                UPDATE EmployeeLeave 
                SET OpeningBalance = @cappedBalance
                WHERE Id = @id

                SET @balance = @cappedBalance -- Update for next calculation
            END

            

			INSERT INTO [dbo].[AccrualUtilizedLeave]
				([EmployeeId],[LeaveId],[Date],[Description],[Accrued],[UtilizedOrRejected],[ClosingBalance],[CreatedOn],[CreatedBy]) VALUES 
				(@EmpId, @LeaveTypeId, @SelectedDate, @Description, @CreditAmount, 0, @balance + @CreditAmount, GETUTCDATE(), @CreatedBy)

			SET @updatedRows = @updatedRows + 1
		END

		FETCH NEXT FROM id_cursor INTO @id, @EmpId, @balance
	END

	CLOSE id_cursor
	DEALLOCATE id_cursor

	SELECT @updatedRows
END

GO

CREATE OR ALTER PROCEDURE [dbo].[GetNotificationTemplates]
@TemplateName AS VARCHAR(250)='',
@SenderName AS VARCHAR(250)='',
@SenderEmail AS VARCHAR(250)='',
@TemplateType AS INT=null,
@SortColumnName AS VARCHAR(50)='',
@SortColumnDirection AS VARCHAR(50)='',
@PageNumber AS INT=1,
@PageSize AS INT=10
AS
BEGIN
 DECLARE @Query AS VARCHAR(MAX)='',@TotalQuery AS VARCHAR(MAX)='',@OrderQuery AS VARCHAR(MAX)='',@Conditions AS VARCHAR(MAX)='',
 @Pagination AS VARCHAR(MAX)='', @StartIndex AS INT

 SELECT @StartIndex = (@PageNumber-1)*@PageSize  
 IF (@StartIndex < 0) BEGIN SET @StartIndex = 0 END
 SET @TotalQuery='SELECT COUNT(N.Id) FROM NotificationTemplate N WHERE N.IsDeleted = 0'
 
 SET @Query='SELECT N.Id, N.TemplateName, N.Subject, N.Content, N.[Type], N.[Status], N.[SenderName], N.[SenderEmail], N.[CCEmails],N.[ToEmail],N.[BCCEmails], N.[CreatedOn], N.[ModifiedOn] FROM NotificationTemplate N 
  WHERE N.IsDeleted = 0'

 IF(ISNULL(@TemplateName,'')<>'')
 BEGIN
  SET @Conditions +=' AND (N.TemplateName LIKE ''%'+@TemplateName+'%'') '
 END 

 IF(ISNULL(@SenderName,'')<>'')
 BEGIN
  SET @Conditions +=' AND (N.SenderName LIKE ''%'+@SenderName+'%'') '
 END 

 IF(ISNULL(@SenderEmail,'')<>'')
 BEGIN
  SET @Conditions +=' AND (N.SenderEmail LIKE ''%'+@SenderEmail+'%'') '
 END 

 IF(@TemplateType IS NOT NULL)
 BEGIN
  SET @Conditions += CONCAT(' AND (N.[Type] = ', @TemplateType,') ')
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

 IF(@Conditions<>'') SET @TotalQuery+= @Conditions
 
 EXEC(@TotalQuery)
 EXEC(@Query)
END
-----------------
GO   
CREATE OR ALTER   PROCEDURE [dbo].[GetEmployeesList]
@EmployeeName AS VARCHAR(100)='',
@EmployeeCode AS VARCHAR(MAX)='',
@EmploymentStatus as INT =0,
@DepartmentId as bigint =0,
@DesignationId as bigint =0,
@RoleId AS BIGINT =0,
@EmployeeStatus as INT =0,
@SortColumnName AS VARCHAR(50)='',
@SortColumnDirection AS VARCHAR(50)='',
@PageNumber AS INT=1,
@PageSize AS INT=10,

@EmployeeEmail NVARCHAR(340) = NULL,
@BranchId INT = NULL,
@CountryId INT = NULL,
@DOJRangeFrom DATE = NULL,
@DOJRangeTo DATE = NULL
AS
BEGIN
	DECLARE @StartIndex AS INT
	 
	SELECT @StartIndex = (@PageNumber-1)*@PageSize  

	SELECT Count(*) as TotalCount FROM vw_EmployeeData
 WHERE
	(@DOJRangeFrom IS NULL OR @DOJRangeTo IS NULL OR JoiningDate BETWEEN @DOJRangeFrom AND @DOJRangeTo) AND
	(NULLIF(@EmployeeEmail, '') IS NULL OR CHARINDEX(@EmployeeEmail, OfficeEmail) > 0) AND
	(NULLIF(@CountryId, 0) IS NULL OR @CountryId = CountryId) AND
	(NULLIF(@BranchId, 0) IS NULL OR @BranchId = BranchId) AND
 (NULLIF(@EmployeeName, '') IS NULL OR CHARINDEX(@EmployeeName, EmployeeFullName) > 0) AND 
  (NULLIF(@EmployeeCode, '') IS NULL OR EmployeeCode IN (SELECT TRIM(value) FROM string_split(@EmployeeCode, ','))) AND
 (NULLIF(@EmploymentStatus, '') IS NULL OR  @EmploymentStatus= EmploymentStatus ) AND
 (NULLIF(@EmployeeStatus, '') IS NULL OR @EmployeeStatus= EmployeeStatus ) AND
 (NULLIF(@DesignationId, 0) IS NULL OR @DesignationId = DesignationId) AND
 (NULLIF(@DepartmentId, 0) IS NULL OR @DepartmentId = DepartmentId) AND
 --(NULLIF(@CountryId, 0) IS NULL OR @CountryId = CountryId) AND 
 (NULLIF(@RoleId, 0) IS NULL OR @RoleId = RoleId)  
 		 
 SELECT ved.EmployeeId as Id, ved.EmployeeCode ,ved.EmployeeFullname AS EmployeeName , ved.JoiningDate,ved.BranchId AS Branch,
	        ved.OfficeEmail as Email, ved.JobType, ved.PersonalEmail ,ved.Department As DepartmentName, ved.Designation As Designation,
            ved.Phone, ved.EmployeeStatus,ved.EmploymentStatus,ved.RoleName, ved.RoleId,ved.Country,ved.CountryId
			 FROM   vw_EmployeeData AS ved 

				--LEFT JOIN EmployeeData AS E ON E.Id =  ved.EmployeeId 
 WHERE
	(@DOJRangeFrom IS NULL OR @DOJRangeTo IS NULL OR JoiningDate BETWEEN @DOJRangeFrom AND @DOJRangeTo) AND
	(NULLIF(@EmployeeEmail, '') IS NULL OR CHARINDEX(@EmployeeEmail, OfficeEmail) > 0) AND
	(NULLIF(@CountryId, 0) IS NULL OR @CountryId = CountryId) AND
	(NULLIF(@BranchId, 0) IS NULL OR @BranchId = BranchId) AND
 (NULLIF(@EmployeeName, '') IS NULL OR CHARINDEX(@EmployeeName, EmployeeFullName) > 0) AND 
  (NULLIF(@EmployeeCode, '') IS NULL OR EmployeeCode IN (SELECT TRIM(value) FROM string_split(@EmployeeCode, ','))) AND
 (NULLIF(@EmploymentStatus, '') IS NULL OR  @EmploymentStatus= EmploymentStatus ) AND
 (NULLIF(@EmployeeStatus, '') IS NULL OR @EmployeeStatus= EmployeeStatus ) AND
 (NULLIF(@DesignationId, 0) IS NULL OR @DesignationId = DesignationId) AND
 (NULLIF(@DepartmentId, 0) IS NULL OR @DepartmentId = DepartmentId) AND
 --(NULLIF(@CountryId, 0) IS NULL OR @CountryId = CountryId) AND 
 (NULLIF(@RoleId, 0) IS NULL OR @RoleId = RoleId)  
 		 
	-- SORT OPERATION
  ORDER BY 
  CASE WHEN @SortColumnName = 'EmployeeId' AND @SortColumnDirection = 'ASC' THEN EmployeeId END ASC,
  CASE WHEN @SortColumnName = 'EmployeeCode' AND @SortColumnDirection = 'ASC' THEN EmployeeCode END ASC,
  CASE WHEN @SortColumnName = 'EmployeeName' AND @SortColumnDirection = 'ASC' THEN EmployeeFullName END ASC,
  CASE WHEN @SortColumnName = 'Email' AND @SortColumnDirection = 'ASC' THEN OfficeEmail END ASC, 
  CASE WHEN @SortColumnName = 'Designation' AND @SortColumnDirection = 'ASC' THEN Designation END ASC,
  CASE WHEN @SortColumnName = 'DepartmentName' AND @SortColumnDirection = 'ASC' THEN Department END ASC,
  CASE WHEN @SortColumnName = 'Status' AND @SortColumnDirection = 'ASC' THEN EmployeeStatus END ASC, 
  CASE WHEN @SortColumnName = 'EmploymentStatus' AND @SortColumnDirection = 'ASC' THEN EmploymentStatus END ASC, 
  CASE WHEN @SortColumnName = 'RoleName' AND @SortColumnDirection = 'ASC' THEN RoleName END ASC, 
  CASE WHEN @SortColumnName = 'JoiningDate' AND @SortColumnDirection = 'ASC' THEN JoiningDate END ASC, 
  CASE WHEN @SortColumnName = 'Branch' AND @SortColumnDirection = 'ASC' THEN BranchId END ASC, 
  
  CASE WHEN @SortColumnName = 'Branch' AND @SortColumnDirection = 'DESC' THEN BranchId END DESC,
  CASE WHEN @SortColumnName = 'EmployeeId' AND @SortColumnDirection = 'DESC' THEN EmployeeId END DESC,
  CASE WHEN @SortColumnName = 'EmployeeCode' AND @SortColumnDirection = 'DESC' THEN EmployeeCode END DESC,
  CASE WHEN @SortColumnName = 'EmployeeName' AND @SortColumnDirection = 'DESC' THEN EmployeeFullName END DESC,
  CASE WHEN @SortColumnName = 'Email' AND @SortColumnDirection = 'DESC' THEN OfficeEmail END DESC, 
  CASE WHEN @SortColumnName = 'Designation' AND @SortColumnDirection = 'DESC' THEN Designation END DESC,
  CASE WHEN @SortColumnName = 'DepartmentName' AND @SortColumnDirection = 'DESC' THEN Department END DESC,
  CASE WHEN @SortColumnName = 'Status' AND @SortColumnDirection = 'DESC' THEN EmployeeStatus END DESC, 
  CASE WHEN @SortColumnName = 'EmploymentStatus' AND @SortColumnDirection = 'DESC' THEN EmploymentStatus END DESC, 
  CASE WHEN @SortColumnName = 'RoleName' AND @SortColumnDirection = 'DESC' THEN RoleName END DESC, 
  CASE WHEN @SortColumnName = 'JoiningDate' AND @SortColumnDirection = 'DESC' THEN JoiningDate END DESC
   
	-- PAGINATION OPERATION
  OFFSET COALESCE(NULLIF(@StartIndex, 0), 0) ROWS
 FETCH NEXT COALESCE(NULLIF(@PageSize, 0), 10) ROWS ONLY;
	  
END
GO
CREATE OR ALTER PROC [dbo].[GetAttendanceConfigList]
	@EmployeeName VARCHAR(250) = null,
	@EmployeeEmail VARCHAR(250) = null,
	@TimeDoctorUserId VARCHAR(250) = null,
	@CountryId INT = null,
	@DepartmentId INT = null,
	@BranchId INT = null,
	@DesignationId INT = null,
	@EmployeeCode VARCHAR(50) = null,
	@IsManualAttendance BIT = null,
	@SortColumn VARCHAR(50) = null,
	@SortDesc BIT = 0,
	@StartIndex INT = null,
	@PageSize INT = null,
	@DOJRangeFrom DATE = null,
	@DOJRangeTo DATE = null,
	@ReportingManagerId INT =0
AS BEGIN
	/*
	EXEC GetAttendanceConfigList @SortColumn = 'EmployeeId', @SortDesc = 1, @PageSize = 50
	*/

	DECLARE @RoleId INT = (SELECT TOP 1 RoleId FROM UserRoleMapping WHERE EmployeeId = @ReportingManagerId)
	
	SELECT COUNT(*) AS TotalCount
	FROM vw_EmployeeData
	WHERE
	(@DOJRangeFrom IS NULL OR @DOJRangeTo IS NULL OR JoiningDate BETWEEN @DOJRangeFrom AND @DOJRangeTo) AND
	(NULLIF(@EmployeeName, '') IS NULL OR CHARINDEX(@EmployeeName, EmployeeFullName) > 0) AND
	(NULLIF(@TimeDoctorUserId, '') IS NULL OR CHARINDEX(@TimeDoctorUserId, TimeDoctorUserId) > 0) AND
	(NULLIF(@EmployeeEmail, '') IS NULL OR CHARINDEX(@EmployeeEmail, OfficeEmail) > 0) AND
	(NULLIF(@EmployeeCode, '') IS NULL OR CHARINDEX(@EmployeeCode, EmployeeCode) > 0) AND
	(NULLIF(@DesignationId, 0) IS NULL OR @DesignationId = DesignationId) AND
	(NULLIF(@DepartmentId, 0) IS NULL OR @DepartmentId = DepartmentId) AND
	(NULLIF(@CountryId, 0) IS NULL OR @CountryId = CountryId) AND
	(NULLIF(@BranchId, 0) IS NULL OR @BranchId = BranchId) AND
	((NULLIF(@ReportingManagerId, 0) IS NULL OR @ReportingManagerId = ReportingManagerId) OR (NULLIF(@ReportingManagerId, 0) IS NULL OR @ReportingManagerId = ImmediateManager)  OR @RoleId=1) AND
	EmployeeStatus != 4 AND --  Exclude Ex Employees
	(NULLIF(@IsManualAttendance, NULL) IS NULL OR @IsManualAttendance = IsManualAttendance)

	SELECT
		EmployeeId, 
		TimeDoctorUserId,
		EmployeeCode,
		EmployeeFullName AS EmployeeName,
		OfficeEmail AS EmployeeEmail,
		Designation,
		Department,
		Country, 
		BranchId AS Branch,
		IsManualAttendance,
		JoiningDate
	FROM vw_EmployeeData
	WHERE
	(@DOJRangeFrom IS NULL OR @DOJRangeTo IS NULL OR JoiningDate BETWEEN @DOJRangeFrom AND @DOJRangeTo) AND
	(NULLIF(@EmployeeName, '') IS NULL OR CHARINDEX(@EmployeeName, EmployeeFullName) > 0) AND
	(NULLIF(@TimeDoctorUserId, '') IS NULL OR CHARINDEX(@TimeDoctorUserId, TimeDoctorUserId) > 0) AND
	(NULLIF(@EmployeeEmail, '') IS NULL OR CHARINDEX(@EmployeeEmail, OfficeEmail) > 0) AND
	(NULLIF(@EmployeeCode, '') IS NULL OR CHARINDEX(@EmployeeCode, EmployeeCode) > 0) AND
	(NULLIF(@DesignationId, 0) IS NULL OR @DesignationId = DesignationId) AND
	(NULLIF(@DepartmentId, 0) IS NULL OR @DepartmentId = DepartmentId) AND
	(NULLIF(@CountryId, 0) IS NULL OR @CountryId = CountryId) AND
	(NULLIF(@BranchId, 0) IS NULL OR @BranchId = BranchId) AND
	((NULLIF(@ReportingManagerId, 0) IS NULL OR @ReportingManagerId = ReportingManagerId) OR (NULLIF(@ReportingManagerId, 0) IS NULL OR @ReportingManagerId = ImmediateManager)  OR @RoleId=1)  AND
	EmployeeStatus != 4 AND --  Exclude Ex Employees
	(NULLIF(@IsManualAttendance, NULL) IS NULL OR @IsManualAttendance = IsManualAttendance)
	ORDER BY 
		CASE WHEN @SortColumn = 'EmployeeId' AND @SortDesc = 0 THEN EmployeeId END ASC,
		CASE WHEN @SortColumn = 'EmployeeCode' AND @SortDesc = 0 THEN EmployeeCode END ASC,
		CASE WHEN @SortColumn = 'EmployeeName' AND @SortDesc = 0 THEN EmployeeFullName END ASC,
		CASE WHEN @SortColumn = 'EmployeeEmail' AND @SortDesc = 0 THEN OfficeEmail END ASC,
		CASE WHEN @SortColumn = 'Designation' AND @SortDesc = 0 THEN Designation END ASC,
		CASE WHEN @SortColumn = 'Department' AND @SortDesc = 0 THEN Department END ASC,
		CASE WHEN @SortColumn = 'Country' AND @SortDesc = 0 THEN Country END ASC,
		CASE WHEN @SortColumn = 'IsManualAttendance' AND @SortDesc = 0 THEN IsManualAttendance END ASC,
		CASE WHEN @SortColumn = 'JoiningDate' AND  @SortDesc = 0 THEN JoiningDate END ASC, 

  CASE WHEN @SortColumn = 'JoiningDate' AND  @SortDesc = 1 THEN JoiningDate END DESC,
  CASE WHEN @SortColumn = 'EmployeeId' AND @SortDesc = 1 THEN EmployeeId END DESC,
  CASE WHEN @SortColumn = 'EmployeeCode' AND @SortDesc = 1 THEN EmployeeCode END DESC,
  CASE WHEN @SortColumn = 'EmployeeName' AND @SortDesc = 1 THEN EmployeeFullName END DESC,
  CASE WHEN @SortColumn = 'EmployeeEmail' AND @SortDesc = 1 THEN OfficeEmail END DESC,
  CASE WHEN @SortColumn = 'Designation' AND @SortDesc = 1 THEN Designation END DESC,
  CASE WHEN @SortColumn = 'Department' AND @SortDesc = 1 THEN Department END DESC,
  CASE WHEN @SortColumn = 'Country' AND @SortDesc = 1 THEN Country END DESC, 
  CASE WHEN @SortColumn = 'IsManualAttendance' AND @SortDesc = 1 THEN IsManualAttendance END DESC
 OFFSET COALESCE(NULLIF(@StartIndex, 0), 0) ROWS
 FETCH NEXT COALESCE(NULLIF(@PageSize, 0), 10) ROWS ONLY;
END

GO
CREATE OR ALTER PROC [dbo].[GetEmployeeAttendanceReport]
	@StartDate DATE,
	@EndDate DATE,
	@EmployeeCodes VARCHAR(MAX) = null,
	@EmployeeName VARCHAR(250) = null,
	@EmployeeEmail VARCHAR(250) = null,
	@CountryId INT = null,
	@DepartmentId INT = null,
	@BranchId INT = null,
	@DesignationId INT = null,
	@IsManualAttendance BIT = null,
	@SortColumn VARCHAR(50) = null,
	@SortDesc BIT = 0,
	@StartIndex INT = null,
	@PageSize INT = null,
	@DOJRangeFrom DATE = null,
	@DOJRangeTo DATE = null,
	@ReportingManagerId INT = null
AS BEGIN
	/* "2,3"
	EXEC GetEmployeeAttendanceReport @EmployeeCodes = null,  @StartDate='1-July-2025', @EndDate = '21-july-2025', @sortColumn = 'EmployeeName', @SortDesc = 0, @PageSize = 5, @IsManualAttendance = null, @StartIndex = 10
	*/

	DECLARE @RoleId INT = (SELECT TOP 1 RoleId FROM UserRoleMapping WHERE EmployeeId = @ReportingManagerId)
	
	SELECT COUNT(*) AS TotalCount
	FROM vw_EmployeeData
	WHERE
	(NULLIF(@EmployeeCodes, '') IS NULL OR EmployeeCode IN (
		SELECT value
		FROM STRING_SPLIT(@EmployeeCodes, ',')
	)) AND
	(@DOJRangeFrom IS NULL OR @DOJRangeTo IS NULL OR JoiningDate BETWEEN @DOJRangeFrom AND @DOJRangeTo) AND
	(NULLIF(@EmployeeName, '') IS NULL OR CHARINDEX(@EmployeeName, EmployeeFullName) > 0) AND
	(NULLIF(@EmployeeEmail, '') IS NULL OR CHARINDEX(@EmployeeEmail, OfficeEmail) > 0) AND
	(NULLIF(@DesignationId, 0) IS NULL OR @DesignationId = DesignationId) AND
	(NULLIF(@DepartmentId, 0) IS NULL OR @DepartmentId = DepartmentId) AND
	(NULLIF(@CountryId, 0) IS NULL OR @CountryId = CountryId) AND
	(NULLIF(@BranchId, 0) IS NULL OR @BranchId = BranchId) AND
	EmployeeStatus != 4 AND --  Exclude Ex Employees
	(NULLIF(@IsManualAttendance, '') IS NULL OR @IsManualAttendance = IsManualAttendance) AND
	((NULLIF(@ReportingManagerId, 0) IS NULL OR @ReportingManagerId = ReportingManagerId) OR (NULLIF(@ReportingManagerId, 0) IS NULL OR @ReportingManagerId = ImmediateManager) OR @RoleId=1 ) 
 DECLARE @SORTDIR VARCHAR(5) = CASE WHEN @SortDesc = 1 THEN 'DESC' ELSE 'ASC' END;

	SELECT 
		EmployeeId,
		EmployeeCode,
		EmployeeFullName AS EmployeeName,
		(SELECT 
			'{' + STRING_AGG(
				CONCAT('"', CONVERT(varchar(10), A.[Date], 120), '": ', '"', A.TotalHours, '"'), ', ' ) WITHIN GROUP (ORDER BY A.[Date]) + '}' 
				AS JsonDict
			FROM Attendance A WHERE A.EmployeeId = vwED.EmployeeId AND A.[Date] BETWEEN @StartDate AND @EndDate) AS WorkedHoursByDateJson,
		OfficeEmail AS EmployeeEmail,
		Designation,
		Department,
		Country, 
		BranchId AS Branch,
		IsManualAttendance,
		JoiningDate
	FROM vw_EmployeeData vwED
	WHERE
	(NULLIF(@EmployeeCodes, '') IS NULL OR EmployeeCode IN (
		SELECT value
		FROM STRING_SPLIT(@EmployeeCodes, ',')
	)) AND
	(@DOJRangeFrom IS NULL OR @DOJRangeTo IS NULL OR JoiningDate BETWEEN @DOJRangeFrom AND @DOJRangeTo) AND
	(NULLIF(@EmployeeName, '') IS NULL OR CHARINDEX(@EmployeeName, EmployeeFullName) > 0) AND
	(NULLIF(@EmployeeEmail, '') IS NULL OR CHARINDEX(@EmployeeEmail, OfficeEmail) > 0) AND
	(NULLIF(@DesignationId, 0) IS NULL OR @DesignationId = DesignationId) AND
	(NULLIF(@DepartmentId, 0) IS NULL OR @DepartmentId = DepartmentId) AND
	(NULLIF(@CountryId, 0) IS NULL OR @CountryId = CountryId) AND
	(NULLIF(@BranchId, 0) IS NULL OR @BranchId = BranchId) AND
	EmployeeStatus != 4 AND --  Exclude Ex Employees
	(NULLIF(@IsManualAttendance, '') IS NULL OR @IsManualAttendance = IsManualAttendance) AND
	((NULLIF(@ReportingManagerId, 0) IS NULL OR @ReportingManagerId = ReportingManagerId) OR (NULLIF(@ReportingManagerId, 0) IS NULL OR @ReportingManagerId = ImmediateManager) OR @RoleId=1) 
	ORDER BY 
		CASE WHEN @SortColumn = 'EmployeeId' AND @SortDesc = 0 THEN EmployeeId END ASC,
		CASE WHEN @SortColumn = 'EmployeeCode' AND @SortDesc = 0 THEN EmployeeCode END ASC,
		CASE WHEN @SortColumn = 'EmployeeName' AND @SortDesc = 0 THEN EmployeeFullName END ASC,
		CASE WHEN @SortColumn = 'EmployeeEmail' AND @SortDesc = 0 THEN OfficeEmail END ASC,
		CASE WHEN @SortColumn = 'Designation' AND @SortDesc = 0 THEN Designation END ASC,
		CASE WHEN @SortColumn = 'Department' AND @SortDesc = 0 THEN Department END ASC,
		CASE WHEN @SortColumn = 'Country' AND @SortDesc = 0 THEN Country END ASC,
		CASE WHEN @SortColumn = 'IsManualAttendance' AND @SortDesc = 0 THEN IsManualAttendance END ASC,
        CASE WHEN @SortColumn = 'BranchId' AND @SortDesc = 0 THEN BranchId END ASC,

		CASE WHEN @SortColumn = 'EmployeeId' AND @SortDesc = 1 THEN EmployeeId END DESC,
		CASE WHEN @SortColumn = 'EmployeeCode' AND @SortDesc = 1 THEN EmployeeCode END DESC,
		CASE WHEN @SortColumn = 'EmployeeName' AND @SortDesc = 1 THEN EmployeeFullName END DESC,
		CASE WHEN @SortColumn = 'EmployeeEmail' AND @SortDesc = 1 THEN OfficeEmail END DESC,
		CASE WHEN @SortColumn = 'Designation' AND @SortDesc = 1 THEN Designation END DESC,
		CASE WHEN @SortColumn = 'Department' AND @SortDesc = 1 THEN Department END DESC,
		CASE WHEN @SortColumn = 'Country' AND @SortDesc = 1 THEN Country END DESC,
		CASE WHEN @SortColumn = 'IsManualAttendance' AND @SortDesc = 1 THEN IsManualAttendance END DESC,
		CASE WHEN @SortColumn = 'BranchId' AND @SortDesc = 1 THEN BranchId END DESC
	OFFSET COALESCE(NULLIF(@StartIndex, 0), 0) ROWS
	FETCH NEXT COALESCE(NULLIF(@PageSize, 0), 10) ROWS ONLY;
END
GO
------------This SP is Utilized in Export Employee Functionality-----------
CREATE OR ALTER   PROCEDURE [dbo].[GetEmployees]

    @EmployeeName AS VARCHAR(100) = '',

    @EmployeeCode AS VARCHAR(MAX) = '',

    @EmploymentStatus AS INT,

    @DepartmentId AS BIGINT,

    @DesignationId AS BIGINT,

    @RoleId AS BIGINT,

    @Status AS INT,

    @SortColumnName AS VARCHAR(50) = '',

    @SortColumnDirection AS VARCHAR(50) = '',

    @EmployeeEmail NVARCHAR(340) = NULL,

    @BranchId INT = NULL,

    @CountryId INT = NULL,

    @DOJRangeFrom DATE = NULL,

    @DOJRangeTo DATE = NULL,

    @PageNumber INT = 1,

    @PageSize INT = 10,
 
    

    @TotalRecords INT OUTPUT

AS

BEGIN

    SET NOCOUNT ON;
 
    DECLARE 

        @Query NVARCHAR(MAX) = '',

        @CountQuery NVARCHAR(MAX) = '',

        @JoinQuery NVARCHAR(MAX) = '',

        @OrderQuery NVARCHAR(MAX) = '',

        @Pagination NVARCHAR(MAX) = '',

        @StartIndex INT,

        @WhereConditions NVARCHAR(MAX),

        @WhereJoin NVARCHAR(1000) = ' WHERE ',

        @AndJoin NVARCHAR(1000) = ' AND '
 
    SET @StartIndex = (@PageNumber - 1) * @PageSize
 
    SET @CountQuery = 'SELECT @TotalRecords = COUNT(e1.Id)'

    SET @Query = '

        SELECT e1.Id, e1.EmployeeCode,

            (e1.FirstName + '' '' + ISNULL(e1.MiddleName, '''') + '' '' + e1.LastName) AS EmployeeName,

            e1.FatherName, e1.Gender, e1.DOB, e2.Email,

            (e6.Line1 + '' '' + ISNULL(e6.Line2, '''')) AS Address,

            e11.CityName, e12.StateName, e10.Pincode, e15.CountryName AS Country,

            (e10.Line1 + '' '' + ISNULL(e10.Line2, '''') + '' '' + e11.CityName + '' '' + e12.StateName + '' '' + e10.Pincode) AS PermanentAddress,

            e1.EmergencyContactNo, e2.ConfirmationDate, e2.JobType,

            e1.PFNumber, e1.PFDate, e9.BankName, e9.AccountNo, e1.PANNumber,

            e1.ESINo, e2.ReportingManagerName, e1.PassportNo, e1.PassportExpiry, e1.AlternatePhone,

            e1.PersonalEmail, e1.BloodGroup, e1.MaritalStatus, e1.UANNo, e1.HasPF, e1.HasESI, e1.AdharNumber,

            e1.Phone, e2.JoiningDate, e2.BranchId AS Branch,

            CASE

                WHEN e2.EmployeeStatus = 1 THEN ''Active''

                WHEN e2.EmployeeStatus = 2 THEN ''F&F Pending''

                WHEN e2.EmployeeStatus = 3 THEN ''On Notice''

                WHEN e2.EmployeeStatus = 4 THEN ''Ex Employee''

                ELSE ''''

            END AS Status,

            e13.Department AS DepartmentName, e14.Designation AS Designation'
 
    SET @JoinQuery = '

        FROM EmployeeData e1

        INNER JOIN EmploymentDetail e2 ON e1.Id = e2.EmployeeId

        LEFT JOIN UserRoleMapping e3 ON e1.Id = e3.EmployeeId

        LEFT JOIN Role e4 ON e4.Id = e3.RoleId

        LEFT JOIN Address e6 ON e6.EmployeeId = e1.Id

        LEFT JOIN City e7 ON e7.Id = e6.CityId

        LEFT JOIN State e8 ON e8.Id = e6.StateId

        LEFT JOIN BankDetails e9 ON e1.Id = e9.EmployeeId

        LEFT JOIN PermanentAddress e10 ON e10.EmployeeId = e1.Id

        LEFT JOIN City e11 ON e11.Id = e10.CityId

        LEFT JOIN State e12 ON e12.Id = e10.StateId

        LEFT JOIN Department e13 ON e13.Id = e2.DepartmentId

        LEFT JOIN Designation e14 ON e14.Id = e2.DesignationId

        LEFT JOIN Country e15 ON e15.Id = e10.CountryId'
 
    SET @WhereConditions = ' ' + @WhereJoin + '1 = 1'
 
    -- Filters

    IF (@DOJRangeFrom IS NOT NULL AND @DOJRangeTo IS NOT NULL)

        SET @WhereConditions += @AndJoin + ' e2.JoiningDate BETWEEN ''' + CONVERT(NVARCHAR(10), @DOJRangeFrom, 120) + ''' AND ''' + CONVERT(NVARCHAR(10), @DOJRangeTo, 120) + ''''
 
    IF (NULLIF(@EmployeeEmail, '') IS NOT NULL)

        SET @WhereConditions += @AndJoin + ' e2.Email LIKE ''%' + CONVERT(VARCHAR(340), @EmployeeEmail) + '%'''
 
    IF (NULLIF(@CountryId, 0) IS NOT NULL)

        SET @WhereConditions += @AndJoin + ' e10.CountryId = ' + CONVERT(VARCHAR, @CountryId)
 
    IF (NULLIF(@BranchId, 0) IS NOT NULL)

        SET @WhereConditions += @AndJoin + ' e2.BranchId = ' + CONVERT(VARCHAR, @BranchId)
 
    IF (ISNULL(@EmployeeName, '') <> '')

        SET @WhereConditions += @AndJoin + ' (e1.FirstName LIKE ''%' + @EmployeeName + '%'' OR e1.MiddleName LIKE ''%' + @EmployeeName + '%'' OR e1.LastName LIKE ''%' + @EmployeeName + '%'' OR (e1.FirstName + '' '' + ISNULL(e1.MiddleName, '''') + '' '' + e1.LastName) LIKE ''%' + REPLACE(@EmployeeName, ' ', '%') + '%'')'
 
    IF (ISNULL(@DepartmentId, 0) <> 0)

        SET @WhereConditions += @AndJoin + ' e2.DepartmentId = ' + CONVERT(VARCHAR, @DepartmentId)
 
    IF (ISNULL(@RoleId, 0) <> 0)

        SET @WhereConditions += @AndJoin + ' e3.RoleId = ' + CONVERT(VARCHAR, @RoleId)
 
    IF (@Status <> 0)

        SET @WhereConditions += @AndJoin + ' e2.EmployeeStatus = ' + CONVERT(VARCHAR, @Status)
 
    IF (ISNULL(@DesignationId, 0) <> 0)

        SET @WhereConditions += @AndJoin + ' e2.DesignationId = ' + CONVERT(VARCHAR, @DesignationId)
 
    IF (ISNULL(@EmployeeCode, '') <> '')

        SET @WhereConditions += @AndJoin + ' e1.EmployeeCode IN (SELECT TRIM(value) FROM string_split(''' + @EmployeeCode + ''', '',''))'
 
    IF (ISNULL(@EmploymentStatus, 0) <> 0)

        SET @WhereConditions += @AndJoin + ' e2.EmploymentStatus = ' + CONVERT(VARCHAR, @EmploymentStatus)
 
    -- Sorting

    IF (ISNULL(@SortColumnName, '') <> '' AND ISNULL(@SortColumnDirection, '') <> '')

        SET @OrderQuery = ' ORDER BY ' + QUOTENAME(@SortColumnName) + ' ' + @SortColumnDirection

    ELSE

        SET @OrderQuery = ' ORDER BY e1.Id ASC'
 
    -- Pagination

   -- SET @Pagination = ' OFFSET ' + CAST(@StartIndex AS NVARCHAR) + ' ROWS FETCH NEXT ' + CAST(@PageSize AS NVARCHAR) + ' ROWS ONLY'
 
    -- Final Query Assembly

    SET @Query += @JoinQuery

    SET @CountQuery += @JoinQuery
 
    IF (@WhereConditions <> '') BEGIN

        SET @Query += @WhereConditions

        SET @CountQuery += @WhereConditions

    END
 
    SET @Query += @OrderQuery

    --SET @Query += @Pagination
 
    

    EXEC sp_executesql @CountQuery, N'@TotalRecords INT OUTPUT', @TotalRecords = @TotalRecords OUTPUT
 
    

    EXEC(@Query)

END



GO
CREATE OR ALTER PROCEDURE [dbo].[GetExitEmployeesListWithDetail]
@ResignationId as INT =0,
@EmployeeName AS VARCHAR(100)='',
@ResignationStatus as int =0,
@SortColumnName AS VARCHAR(50)='',
@SortColumnDirection AS VARCHAR(50)='',
@PageNumber AS INT=1,
@PageSize AS INT=10,
@ReportingManagerName AS VARCHAR(100)='',
@EmployeeCode AS VARCHAR(MAX)='',
@AccountsNoDue as BIT =0,
@JobType as BIT =0,
@ITNoDue as BIT =0,
@EmploymentStatus as INT =0,
@DepartmentId as bigint =0, 
@RoleId AS BIGINT =0,
@KTStatus as INT =0,
@LastWorkingDay as Date = null,
@ResignationDate as Datetime = null,
@EarlyReleaseStatus as int = 0,
@LastWorkingDayFrom DATE = NULL,
@LastWorkingDayTo DATE = NULL,
@BranchId INT = NULL,
@EmployeeStatus INT = NULL

AS
BEGIN
	DECLARE @StartIndex AS INT
	 
	SELECT @StartIndex = (@PageNumber-1)*@PageSize  
	SELECT Count(*) as TotalCount FROM vw_ResignationDetail r 
        LEFT JOIN  
		   vw_EmployeeData vEd ON r.EmployeeId = vEd.EmployeeId
 WHERE
(@LastWorkingDayFrom IS NULL OR @LastWorkingDayTo IS NULL OR LastWorkingDay BETWEEN @LastWorkingDayFrom AND @LastWorkingDayTo) AND
 (NULLIF(@ResignationId, 0) IS NULL OR @ResignationId = ResignationId) And
 (NULLIF(@EmployeeName, '') IS NULL OR CHARINDEX(@EmployeeName, EmployeeFullName) > 0) AND 
  (NULLIF(@ReportingManagerName, '') IS NULL OR CHARINDEX(@ReportingManagerName, ReportingManagerName) > 0) AND 
(NULLIF(@EmployeeCode, '') IS NULL OR EmployeeCode IN (SELECT TRIM(value) FROM string_split(@EmployeeCode, ','))) AND
 (NULLIF(@EmploymentStatus, '') IS NULL OR  @EmploymentStatus= EmploymentStatus ) AND
 (NULLIF(@DepartmentId, 0) IS NULL OR @DepartmentId = DepartmentId) AND
(NULLIF(@LastWorkingDay, null) IS NULL OR @LastWorkingDay = LastWorkingDay) AND 
(NULLIF(@ResignationDate, NULL) IS NULL OR CAST(ResignationDate AS DATE) = CAST(@ResignationDate AS DATE)) AND
(NULLIF(@EarlyReleaseStatus, 0) IS NULL OR @EarlyReleaseStatus = EarlyReleaseStatus) AND 
(NULLIF(@ResignationStatus, 0) IS NULL OR @ResignationStatus = ResignationStatus) AND 
(NULLIF(@KTStatus, 0) IS NULL OR @KTStatus = KTStatus) AND 
(NULLIF(@AccountsNoDue, 0) IS NULL OR @AccountsNoDue = AccountsNoDue) AND  
(NULLIF(@JobType, 0) IS NULL OR @JobType = JobType) AND
(NULLIF(@ITNoDue, 0) IS NULL OR @ITNoDue = ITNoDue)  AND
(NULLIF(@BranchId, 0) IS NULL OR @BranchId = BranchId)  AND
(NULLIF(@EmployeeStatus, 0) IS NULL OR @EmployeeStatus = EmployeeStatus) 
 SELECT 
 r.ResignationId,
 r.DepartmentName,
            r.LastWorkingDay,
            r.ResignationDate,
            r.EarlyReleaseDate,
            r.EarlyReleaseStatus,
            r.ResignationStatus,
            r.KTStatus,
            r.ExitInterviewStatus,
            r.ITNoDue,
            r.AccountsNoDue,
            r.FnFStatus, 
			r.ResignationId,
			r.Reason,
			 vEd.EmployeeCode, 
           vEd.EmployeeFullname AS EmployeeName,
            vEd.EmployeeStatus AS EmployeeStatus,
            vEd.EmploymentStatus AS EmploymentStatus,
               vEd.ReportingManagerName AS ReportingManagerName,			   
			   vEd.JobType,
			   vEd.BranchId

        FROM 
            vw_ResignationDetail r 
        LEFT JOIN  
		   vw_EmployeeData vEd ON r.EmployeeId = vEd.EmployeeId
		    
 WHERE
(@LastWorkingDayFrom IS NULL OR @LastWorkingDayTo IS NULL OR LastWorkingDay BETWEEN @LastWorkingDayFrom AND @LastWorkingDayTo) AND
 (NULLIF(@ResignationId, 0) IS NULL OR @ResignationId = ResignationId) And
 (NULLIF(@EmployeeName, '') IS NULL OR CHARINDEX(@EmployeeName, EmployeeFullName) > 0) AND 
  (NULLIF(@ReportingManagerName, '') IS NULL OR CHARINDEX(@ReportingManagerName, ReportingManagerName) > 0) AND 
(NULLIF(@EmployeeCode, '') IS NULL OR EmployeeCode IN (SELECT TRIM(value) FROM string_split(@EmployeeCode, ','))) AND
 (NULLIF(@EmploymentStatus, '') IS NULL OR  @EmploymentStatus= EmploymentStatus ) AND
 (NULLIF(@DepartmentId, 0) IS NULL OR @DepartmentId = DepartmentId) AND
(NULLIF(@LastWorkingDay, null) IS NULL OR @LastWorkingDay = LastWorkingDay) AND 
(NULLIF(@ResignationDate, NULL) IS NULL OR CAST(ResignationDate AS DATE) = CAST(@ResignationDate AS DATE)) AND 
(NULLIF(@EarlyReleaseStatus, 0) IS NULL OR @EarlyReleaseStatus = EarlyReleaseStatus) AND 
(NULLIF(@ResignationStatus, 0) IS NULL OR @ResignationStatus = ResignationStatus) AND 
(NULLIF(@KTStatus, 0) IS NULL OR @KTStatus = KTStatus) AND 
(NULLIF(@AccountsNoDue, 0) IS NULL OR @AccountsNoDue = AccountsNoDue) AND  
(NULLIF(@JobType, 0) IS NULL OR @JobType = JobType) AND
(NULLIF(@ITNoDue, 0) IS NULL OR @ITNoDue = ITNoDue)   AND
(NULLIF(@BranchId, 0) IS NULL OR @BranchId = BranchId)  AND
(NULLIF(@EmployeeStatus, 0) IS NULL OR @EmployeeStatus = EmployeeStatus) 

-- SORT OPERATION
  ORDER BY  
  
  CASE WHEN @SortColumnName = 'LastWorkingDay' AND @SortColumnDirection = 'ASC' THEN LastWorkingDay END ASC,
  CASE WHEN @SortColumnName = 'ResignationId' AND @SortColumnDirection = 'ASC' THEN r.ResignationId END ASC,
  CASE WHEN @SortColumnName = 'EmployeeCode' AND @SortColumnDirection = 'ASC' THEN EmployeeCode END ASC,
  CASE WHEN @SortColumnName = 'EmployeeName' AND @SortColumnDirection = 'ASC' THEN EmployeeFullName END ASC,
  CASE WHEN @SortColumnName = 'ReportingManagerName' AND @SortColumnDirection = 'ASC' THEN ReportingManagerName END ASC, 
  CASE WHEN @SortColumnName = 'Designation' AND @SortColumnDirection = 'ASC' THEN Designation END ASC,
  CASE WHEN @SortColumnName = 'DepartmentName' AND @SortColumnDirection = 'ASC' THEN DepartmentName END ASC, 
  CASE WHEN @SortColumnName = 'ResignationDate' AND @SortColumnDirection = 'ASC' THEN ResignationDate END ASC, 
  CASE WHEN @SortColumnName = 'KTStatus' AND @SortColumnDirection = 'ASC' THEN KTStatus END ASC,  
  CASE WHEN @SortColumnName = 'AccountsNoDue' AND @SortColumnDirection = 'ASC' THEN AccountsNoDue END ASC, 
  CASE WHEN @SortColumnName = 'JobType' AND @SortColumnDirection = 'ASC' THEN JobType END ASC,
  CASE WHEN @SortColumnName = 'ITNoDue' AND @SortColumnDirection = 'ASC' THEN ITNoDue END ASC, 
  CASE WHEN @SortColumnName = 'ResignationStatus' AND @SortColumnDirection = 'ASC' THEN ResignationStatus END ASC, 
  CASE WHEN @SortColumnName = 'Branch' AND @SortColumnDirection = 'ASC' THEN BranchId END ASC, 
  
  CASE WHEN @SortColumnName = 'Branch' AND @SortColumnDirection = 'DESC' THEN BranchId END DESC,
  CASE WHEN @SortColumnName = 'LastWorkingDay' AND @SortColumnDirection = 'DESC' THEN LastWorkingDay END DESC,
  CASE WHEN @SortColumnName = 'ResignationId' AND @SortColumnDirection = 'DESC' THEN r.ResignationId END DESC,
  CASE WHEN @SortColumnName = 'EmployeeCode' AND @SortColumnDirection = 'DESC' THEN EmployeeCode END DESC,
  CASE WHEN @SortColumnName = 'EmployeeName' AND @SortColumnDirection = 'DESC' THEN EmployeeFullName END DESC,
  CASE WHEN @SortColumnName = 'ReportingManagerName' AND @SortColumnDirection = 'DESC' THEN ReportingManagerName END DESC, 
  CASE WHEN @SortColumnName = 'Designation' AND @SortColumnDirection = 'DESC' THEN Designation END DESC,
  CASE WHEN @SortColumnName = 'DepartmentName' AND @SortColumnDirection = 'DESC' THEN DepartmentName END DESC, 
  CASE WHEN @SortColumnName = 'ResignationDate' AND @SortColumnDirection = 'DESC' THEN ResignationDate END DESC, 
  CASE WHEN @SortColumnName = 'KTStatus' AND @SortColumnDirection = 'DESC' THEN KTStatus END DESC,  
  CASE WHEN @SortColumnName = 'AccountsNoDue' AND @SortColumnDirection = 'DESC' THEN AccountsNoDue END DESC, 
  CASE WHEN @SortColumnName = 'JobType' AND @SortColumnDirection = 'DESC' THEN JobType END DESC,
  CASE WHEN @SortColumnName = 'ITNoDue' AND @SortColumnDirection = 'DESC' THEN ITNoDue END DESC, 
  CASE WHEN @SortColumnName = 'ResignationStatus' AND @SortColumnDirection = 'DESC' THEN ResignationStatus END DESC
   
	-- PAGINATION OPERATION
  OFFSET COALESCE(NULLIF(@StartIndex, 0), 0) ROWS
 FETCH NEXT COALESCE(NULLIF(@PageSize, 0), 10) ROWS ONLY; 
END
GO
