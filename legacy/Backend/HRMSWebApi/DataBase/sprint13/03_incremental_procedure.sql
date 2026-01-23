
GO
CREATE OR ALTER PROCEDURE [dbo].[GetCompOffAndSwapHolidayDetails]
    @SessionUserId BIGINT = NULL,
    @RoleId INT = NULL,
    @EmployeeCode VARCHAR(50) = NULL,
    @WorkingDate DATE = NULL,
    @StatusFilter INT = NULL,
    @TypeFilter INT = NULL,
    @SortColumn VARCHAR(50) = NULL,
    @SortDesc BIT = 0,
    @StartIndex INT = 1,
    @PageSize INT = 10
AS
BEGIN
    -- Count query for total records
    SELECT COUNT(*) AS TotalCount
    FROM CompOffAndSwapHolidayDetail CSH
    LEFT JOIN EmployeeData ED ON ED.Id = CSH.EmployeeId
    LEFT JOIN EmploymentDetail EMP ON EMP.EmployeeId = CSH.EmployeeId
    WHERE CSH.IsDeleted = 0
        AND (@RoleId != 5 OR (EMP.ReportingMangerId = @SessionUserId OR EMP.ImmediateManager = @SessionUserId))
        AND (NULLIF(@EmployeeCode, '') IS NULL OR EXISTS (SELECT 1 FROM STRING_SPLIT(@EmployeeCode, ',') AS codes WHERE LTRIM(RTRIM(codes.value)) = ED.EmployeeCode))
        AND (@WorkingDate IS NULL OR CSH.WorkingDate = @WorkingDate)
        AND (@StatusFilter IS NULL OR CSH.Status = @StatusFilter)
        AND (@TypeFilter IS NULL OR CSH.RequestType = @TypeFilter)

    -- Data query with sorting and pagination
    SELECT 
        CSH.Id,
        ED.Id AS EmployeeId,
        ED.EmployeeCode,
        CONCAT(ED.FirstName, ' ', ED.LastName) AS EmployeeName,
        CSH.WorkingDate,
        CSH.LeaveDate,
        CSH.LeaveDateLabel,
        CSH.WorkingDateLabel,
        CSH.Reason,
        CSH.Status,
        CSH.RejectReason,
        CSH.NumberOfDays,
        CSH.RequestType,
        CSH.CreatedOn,
        CSH.CreatedBy
    FROM CompOffAndSwapHolidayDetail CSH
    LEFT JOIN EmployeeData ED ON ED.Id = CSH.EmployeeId
    LEFT JOIN EmploymentDetail EMP ON EMP.EmployeeId = CSH.EmployeeId
    WHERE CSH.IsDeleted = 0
        AND (@RoleId != 5 OR (EMP.ReportingMangerId = @SessionUserId OR EMP.ImmediateManager = @SessionUserId))
        AND (NULLIF(@EmployeeCode, '') IS NULL OR EXISTS (SELECT 1 FROM STRING_SPLIT(@EmployeeCode, ',') AS codes WHERE LTRIM(RTRIM(codes.value)) = ED.EmployeeCode))
        AND (@WorkingDate IS NULL OR CSH.WorkingDate = @WorkingDate)
        AND (@StatusFilter IS NULL OR CSH.Status = @StatusFilter)
        AND (@TypeFilter IS NULL OR CSH.RequestType = @TypeFilter)

    ORDER BY      
        CASE WHEN @SortColumn = 'EmployeeId' AND @SortDesc = 0 THEN ED.Id END ASC,
        CASE WHEN @SortColumn = 'EmployeeCode' AND @SortDesc = 0 THEN ED.EmployeeCode END ASC,
        CASE WHEN @SortColumn = 'EmployeeName' AND @SortDesc = 0 THEN CONCAT(ED.FirstName, ' ', ED.LastName) END ASC,
        CASE WHEN @SortColumn = 'WorkingDate' AND @SortDesc = 0 THEN CSH.WorkingDate END ASC,
        CASE WHEN @SortColumn = 'LeaveDate' AND @SortDesc = 0 THEN CSH.LeaveDate END ASC,
        CASE WHEN @SortColumn = 'Reason' AND @SortDesc = 0 THEN CSH.Reason END ASC,
        CASE WHEN @SortColumn = 'Status' AND @SortDesc = 0 THEN CSH.Status END ASC,
        CASE WHEN @SortColumn = 'RequestType' AND @SortDesc = 0 THEN CSH.RequestType END ASC,
        CASE WHEN @SortColumn = 'CreatedOn' AND @SortDesc = 0 THEN CSH.CreatedOn END ASC,
        CASE WHEN @SortColumn = 'EmployeeId' AND @SortDesc = 1 THEN ED.Id END DESC,
        CASE WHEN @SortColumn = 'EmployeeCode' AND @SortDesc = 1 THEN ED.EmployeeCode END DESC,
        CASE WHEN @SortColumn = 'EmployeeName' AND @SortDesc = 1 THEN CONCAT(ED.FirstName, ' ', ED.LastName) END DESC,
        CASE WHEN @SortColumn = 'WorkingDate' AND @SortDesc = 1 THEN CSH.WorkingDate END DESC,
        CASE WHEN @SortColumn = 'LeaveDate' AND @SortDesc = 1 THEN CSH.LeaveDate END DESC,
        CASE WHEN @SortColumn = 'Reason' AND @SortDesc = 1 THEN CSH.Reason END DESC,
        CASE WHEN @SortColumn = 'Status' AND @SortDesc = 1 THEN CSH.Status END DESC,
        CASE WHEN @SortColumn = 'RequestType' AND @SortDesc = 1 THEN CSH.RequestType END DESC,
        CASE WHEN @SortColumn = 'CreatedOn' AND @SortDesc = 1 THEN CSH.CreatedOn END DESC,
        CASE WHEN @SortColumn = '' THEN CSH.CreatedOn END DESC
   OFFSET COALESCE(NULLIF(@StartIndex, 0), 0) ROWS
   FETCH NEXT COALESCE(NULLIF(@PageSize, 0), 10) ROWS ONLY;
END

 ------------------------GetAllITAsset---------------
 GO
 CREATE OR ALTER PROC [dbo].[GetAllITAsset]
    @DeviceName VARCHAR(250) = NULL,
    @DeviceCode VARCHAR(50) = NULL,
    @Manufacturer VARCHAR(250) = NULL,
    @Model VARCHAR(250) = NULL,
    @AssetType INT = NULL,
    @Status INT = NULL,
    @Branch INT = NULL,
    @EmployeeCodes VARCHAR(MAX) = NULL,
    @SortColumn VARCHAR(50) = NULL,
    @SortDesc BIT = 0,
    @StartIndex INT = 0,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    -- Default sorting
    DECLARE @SortColumnWithDefault VARCHAR(50) = COALESCE(@SortColumn, 'ModifiedOn');
    DECLARE @SortDescWithDefault BIT = COALESCE(@SortDesc, 1); -- Default to DESC

    -- Calculating total count (ensure single row)
    SELECT COUNT(*) AS TotalCount
    FROM ITAsset IT
    LEFT JOIN EmployeeAsset EA ON IT.Id = EA.AssetId AND EA.IsActive = 1
    LEFT JOIN EmploymentDetail ED ON EA.EmployeeId = ED.EmployeeId
    LEFT JOIN EmployeeData E ON E.Id = ED.EmployeeId
    WHERE 
        (@DeviceName IS NULL OR IT.DeviceName LIKE '%' + @DeviceName + '%') AND
        (@DeviceCode IS NULL OR IT.DeviceCode LIKE '%' + @DeviceCode + '%') AND
        (@Manufacturer IS NULL OR IT.Manufacturer LIKE '%' + @Manufacturer + '%') AND
        (@Model IS NULL OR IT.Model LIKE '%' + @Model + '%') AND
        (@AssetType IS NULL OR IT.AssetType = @AssetType) AND
        (@Branch IS NULL OR IT.Branch = @Branch) AND
        (@Status IS NULL OR IT.Status = @Status) AND
        (NULLIF(@EmployeeCodes, '') IS NULL OR E.EmployeeCode IN (
            SELECT value FROM STRING_SPLIT(@EmployeeCodes, ',')
        ));

    -- Fetching paginated data
    SELECT 
        IT.Id,
        IT.DeviceName,
        IT.DeviceCode,
        IT.SerialNumber,
        IT.Manufacturer,
        IT.Model,
        IT.AssetType,
        IT.Status AS AssetStatus,
        IT.Branch,
        CAST(IT.PurchaseDate AS DATE) AS PurchaseDate,
        CAST(IT.WarrantyExpires AS DATE) AS WarrantyExpires,
        IT.Comments,
        IT.ModifiedOn,
        IT.ModifiedBy AS AllocatedBy,
        ED.Email AS Custodian,
        CONCAT(E.FirstName, ' ', E.MiddleName, ' ', E.LastName) AS CustodianFullName
    FROM ITAsset IT
    LEFT JOIN EmployeeAsset EA ON IT.Id = EA.AssetId AND EA.IsActive = 1
    LEFT JOIN EmploymentDetail ED ON EA.EmployeeId = ED.EmployeeId
    LEFT JOIN EmployeeData E ON E.Id = ED.EmployeeId
    WHERE 
        (@DeviceName IS NULL OR IT.DeviceName LIKE '%' + @DeviceName + '%') AND
        (@DeviceCode IS NULL OR IT.DeviceCode LIKE '%' + @DeviceCode + '%') AND
        (@Manufacturer IS NULL OR IT.Manufacturer LIKE '%' + @Manufacturer + '%') AND
        (@Model IS NULL OR IT.Model LIKE '%' + @Model + '%') AND
        (@AssetType IS NULL OR IT.AssetType = @AssetType) AND
        (@Branch IS NULL OR IT.Branch = @Branch) AND
        (@Status IS NULL OR IT.Status = @Status) AND
        (NULLIF(@EmployeeCodes, '') IS NULL OR E.EmployeeCode IN (
            SELECT value FROM STRING_SPLIT(@EmployeeCodes, ',')
        ))
    ORDER BY 

        CASE WHEN @SortColumnWithDefault = 'Id' AND @SortDescWithDefault = 0 THEN IT.Id END ASC,
        CASE WHEN @SortColumnWithDefault = 'Id' AND @SortDescWithDefault = 1 THEN IT.Id END DESC,
        CASE WHEN @SortColumnWithDefault = 'DeviceName' AND @SortDescWithDefault = 0 THEN IT.DeviceName END ASC,
        CASE WHEN @SortColumnWithDefault = 'DeviceName' AND @SortDescWithDefault = 1 THEN IT.DeviceName END DESC,
        CASE WHEN @SortColumnWithDefault = 'DeviceCode' AND @SortDescWithDefault = 0 THEN IT.DeviceCode END ASC,
        CASE WHEN @SortColumnWithDefault = 'DeviceCode' AND @SortDescWithDefault = 1 THEN IT.DeviceCode END DESC,
        CASE WHEN @SortColumnWithDefault = 'SerialNumber' AND @SortDescWithDefault = 0 THEN IT.SerialNumber END ASC,
        CASE WHEN @SortColumnWithDefault = 'SerialNumber' AND @SortDescWithDefault = 1 THEN IT.SerialNumber END DESC,
        CASE WHEN @SortColumnWithDefault = 'Manufacturer' AND @SortDescWithDefault = 0 THEN IT.Manufacturer END ASC,
        CASE WHEN @SortColumnWithDefault = 'Manufacturer' AND @SortDescWithDefault = 1 THEN IT.Manufacturer END DESC,
        CASE WHEN @SortColumnWithDefault = 'Model' AND @SortDescWithDefault = 0 THEN IT.Model END ASC,
        CASE WHEN @SortColumnWithDefault = 'Model' AND @SortDescWithDefault = 1 THEN IT.Model END DESC,
        CASE WHEN @SortColumnWithDefault = 'AssetType' AND @SortDescWithDefault = 0 THEN IT.AssetType END ASC,
        CASE WHEN @SortColumnWithDefault = 'AssetType' AND @SortDescWithDefault = 1 THEN IT.AssetType END DESC,
        CASE WHEN @SortColumnWithDefault = 'Status' AND @SortDescWithDefault = 0 THEN IT.Status END ASC,
        CASE WHEN @SortColumnWithDefault = 'Status' AND @SortDescWithDefault = 1 THEN IT.Status END DESC,
        CASE WHEN @SortColumnWithDefault = 'Branch' AND @SortDescWithDefault = 0 THEN IT.Branch END ASC,
        CASE WHEN @SortColumnWithDefault = 'Branch' AND @SortDescWithDefault = 1 THEN IT.Branch END DESC,
        CASE WHEN @SortColumnWithDefault = 'PurchaseDate' AND @SortDescWithDefault = 0 THEN IT.PurchaseDate END ASC,
        CASE WHEN @SortColumnWithDefault = 'PurchaseDate' AND @SortDescWithDefault = 1 THEN IT.PurchaseDate END DESC,
        CASE WHEN @SortColumnWithDefault = 'WarrantyExpires' AND @SortDescWithDefault = 0 THEN IT.WarrantyExpires END ASC,
        CASE WHEN @SortColumnWithDefault = 'WarrantyExpires' AND @SortDescWithDefault = 1 THEN IT.WarrantyExpires END DESC,
        CASE WHEN @SortColumnWithDefault = 'ModifiedOn' AND @SortDescWithDefault = 0 THEN IT.ModifiedOn END ASC,
        CASE WHEN @SortColumnWithDefault = 'ModifiedOn' AND @SortDescWithDefault = 1 THEN IT.ModifiedOn END DESC
    OFFSET COALESCE(@StartIndex, 0) ROWS
    FETCH NEXT COALESCE(@PageSize, 10) ROWS ONLY;
END
GO
----Comp Off Expire---
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[ExpireCompOffLeave]
AS
BEGIN
DECLARE @oldCLosing decimal(10,2)
DECLARE @newClosing decimal(10,2)
DECLARE @EmpId BIGINT
DECLARE @Difference decimal(10,2)
DECLARE @LastExpiredId BIGINT

DECLARE id_cursor CURSOR FOR  
SELECT EmployeeId FROM EmployeeLeave WHERE LeaveId = 10
  
    OPEN id_cursor
    FETCH NEXT FROM id_cursor INTO  @EmpId 

    WHILE @@FETCH_STATUS = 0
    BEGIN
        
				SELECT top 1 @LastExpiredId = id FROM AccrualUtilizedLeave WHERE Description = 'CompOff Expired' AND EmployeeId = @EmpId order by CreatedOn desc
				SELECT top 1 @oldCLosing = ClosingBalance  FROM AccrualUtilizedLeave WHERE Id>COALESCE(@LastExpiredId,0)  AND EmployeeId = @EmpId AND LeaveId = 10 AND CAST([Date] as date) <  DATEADD(MONTH, -3, CAST(GETUTCDATE() as date)) order by date desc

				SELECT top 1 @newClosing = ClosingBalance FROM AccrualUtilizedLeave WHERE  Id>COALESCE(@LastExpiredId,0) AND EmployeeId = @EmpId AND LeaveId = 10   order by date desc
				 
				SELECT @oldCLosing,@newClosing

				SET @Difference = COALESCE(@newClosing,0) - COALESCE(@oldCLosing,0)
                IF  @oldCLosing > 0 AND @newClosing > 0
                BEGIN	
				SELECT @Difference
	 
                    INSERT INTO AccrualUtilizedLeave
                    (EmployeeId, LeaveId, [Date], Description, Accrued, UtilizedOrRejected, ClosingBalance, CreatedOn, CreatedBy)
                    VALUES
                    (@EmpId, 10, GETUTCDATE(), 'CompOff Expired', 0, @oldCLosing, @Difference, GETUTCDATE(), 'Admin')
                END;

		FETCH NEXT FROM id_cursor INTO  @EmpId 
	END

	CLOSE id_cursor
	DEALLOCATE id_cursor
 END
 GO
 ------------------------GetExitEmployeesListWithDetail-----------------------------
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

	-- TOTAL COUNT
	SELECT Count(*) as TotalCount 
	FROM vw_ResignationDetail r 
        LEFT JOIN vw_EmployeeData vEd ON r.EmployeeId = vEd.EmployeeId
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
 		 
	-- PAGINATED DATA
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
		LEFT JOIN vw_EmployeeData vEd ON r.EmployeeId = vEd.EmployeeId
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
	(NULLIF(@ITNoDue, 0) IS NULL OR @ITNoDue = ITNoDue)    AND
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
	CASE WHEN @SortColumnName = 'EmployeeStatus' AND @SortColumnDirection = 'ASC' THEN vEd.EmployeeStatus END ASC,
  
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
	CASE WHEN @SortColumnName = 'ResignationStatus' AND @SortColumnDirection = 'DESC' THEN ResignationStatus END DESC,
	CASE WHEN @SortColumnName = 'EmployeeStatus' AND @SortColumnDirection = 'DESC' THEN vEd.EmployeeStatus END DESC
   
	-- PAGINATION OPERATION
	OFFSET COALESCE(NULLIF(@StartIndex, 0), 0) ROWS
	FETCH NEXT COALESCE(NULLIF(@PageSize, 0), 10) ROWS ONLY; 
END
GO

 --------GetCompanyPolicyDocuments----------
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
		ELSE 
		BEGIN
			SET @OrderQuery=' ORDER BY cp.CreatedOn DESC'
		END
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
-------------
CREATE OR ALTER PROCEDURE [dbo].[GetEmployeeListGrievances]
    @SessionUserId INT = NULL,
    @RoleId INT,
    @GrievanceTypeId INT = NULL,
    @Status INT = NULL,
    @TatStatus INT = NULL,
    @CreatedOnFrom DATE = NULL,
    @CreatedOnTo DATE = NULL,
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
        FROM GrievanceOwner go
        WHERE go.GrievanceTypeId = eg.GrievanceTypeId
    ) go
    OUTER APPLY (
        SELECT TOP 1 *
        FROM EmploymentDetail Emp
        WHERE Emp.Email = eg.CreatedBy
    ) Emp
    LEFT JOIN EmployeeData ED ON ED.Id = Emp.EmployeeId
    WHERE 1 = 1
    AND (@RoleId = 1 OR go.OwnerID = @SessionUserId)  -- RoleId 1 = SuperAdmin
    AND (@GrievanceTypeId IS NULL OR eg.GrievanceTypeId = @GrievanceTypeId)
    AND (@Status IS NULL OR eg.Status = @Status)
    AND (@TatStatus IS NULL OR eg.TatStatus = @TatStatus)
    AND (@ResolvedDate IS NULL OR CAST(eg.ResolvedDate AS DATE) = @ResolvedDate)
    AND (@ResolvedBy IS NULL OR eg.ResolvedBy = @ResolvedBy)
    AND (
        NOT EXISTS (SELECT 1 FROM @CreatedByCodes) 
        OR ED.EmployeeCode IN (SELECT Code FROM @CreatedByCodes)
    )
    AND (@Level IS NULL OR eg.Level = @Level)
    AND (
        (@CreatedOnFrom IS NULL OR CAST(eg.CreatedOn AS DATE) >= @CreatedOnFrom)
        AND (@CreatedOnTo IS NULL OR CAST(eg.CreatedOn AS DATE) <= @CreatedOnTo)
    );

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
    OUTER APPLY (
        SELECT TOP 1 *
        FROM GrievanceOwner go
        WHERE go.GrievanceTypeId = eg.GrievanceTypeId
    ) go
    WHERE 1 = 1
    AND (@RoleId = 1 OR go.OwnerID = @SessionUserId)
    AND (@GrievanceTypeId IS NULL OR eg.GrievanceTypeId = @GrievanceTypeId)
    AND (@Status IS NULL OR eg.Status = @Status)
    AND (@TatStatus IS NULL OR eg.TatStatus = @TatStatus)
    AND (@ResolvedDate IS NULL OR CAST(eg.ResolvedDate AS DATE) = @ResolvedDate)
    AND (@ResolvedBy IS NULL OR eg.ResolvedBy = @ResolvedBy)
    AND (
        NOT EXISTS (SELECT 1 FROM @CreatedByCodes) 
        OR ED.EmployeeCode IN (SELECT Code FROM @CreatedByCodes)
    )
    AND (@Level IS NULL OR eg.Level = @Level)
    AND (
        (@CreatedOnFrom IS NULL OR CAST(eg.CreatedOn AS DATE) >= @CreatedOnFrom)
        AND (@CreatedOnTo IS NULL OR CAST(eg.CreatedOn AS DATE) <= @CreatedOnTo)
    )
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

 

-------------------------------------------------
GO
CREATE OR ALTER PROC [dbo].[GetAllFeedback]
    @EmployeeCodes VARCHAR(500) = null,
    @CreatedOnFrom DATE = null,
    @CreatedOnTo DATE = null,
    @FeedbackType INT = null,
    @TicketStatus INT = null,
    @SearchQuery VARCHAR(250) = null,
    @SortColumn VARCHAR(50) = null,
    @SortDesc BIT = 0,
    @StartIndex INT = null,
    @PageSize INT = null
AS BEGIN
    /*
    EXEC GetAllFeedback @SortColumn = 'Id', @SortDesc = 1, @PageSize = 50
    */

    SELECT COUNT(*) AS TotalCount
    FROM [dbo].[Feedback] f
    LEFT JOIN [dbo].[EmployeeData] e ON f.[EmployeeId] = e.[Id]
    WHERE
    (@CreatedOnFrom IS NULL OR @CreatedOnTo IS NULL OR f.CreatedOn BETWEEN @CreatedOnFrom AND @CreatedOnTo) AND
    (NULLIF(@EmployeeCodes, '') IS NULL OR e.EmployeeCode IN (SELECT TRIM(value) FROM string_split(@EmployeeCodes, ','))) AND
    (NULLIF(@FeedbackType, 0) IS NULL OR f.FeedbackType = @FeedbackType) AND
    (NULLIF(@TicketStatus, 0) IS NULL OR f.TicketStatus = @TicketStatus) AND
    (NULLIF(@SearchQuery, '') IS NULL OR CHARINDEX(@SearchQuery, f.Subject) > 0 OR CHARINDEX(@SearchQuery, f.Description) > 0);

    SELECT 
        f.[Id],
        f.[EmployeeId],
        CONCAT(e.[FirstName], ' ', 
               CASE WHEN e.[MiddleName] IS NOT NULL THEN e.[MiddleName] + ' ' ELSE '' END, 
               e.[LastName]) AS EmployeeName,
        f.[CreatedBy] AS EmployeeEmail,
        f.[TicketStatus],
        f.[FeedbackType],
        f.[Subject],
        f.[Description],
        f.[AdminComment],
        f.[CreatedOn],
		f.[ModifiedOn]
    FROM [dbo].[Feedback] f
    LEFT JOIN [dbo].[EmployeeData] e ON f.[EmployeeId] = e.[Id]
    WHERE
    (@CreatedOnFrom IS NULL OR @CreatedOnTo IS NULL OR f.CreatedOn BETWEEN @CreatedOnFrom AND @CreatedOnTo) AND
    (NULLIF(@EmployeeCodes, '') IS NULL OR e.EmployeeCode IN (SELECT TRIM(value) FROM string_split(@EmployeeCodes, ','))) AND
    (NULLIF(@FeedbackType, 0) IS NULL OR f.FeedbackType = @FeedbackType) AND
    (NULLIF(@TicketStatus, 0) IS NULL OR f.TicketStatus = @TicketStatus) AND
    (NULLIF(@SearchQuery, '') IS NULL OR CHARINDEX(@SearchQuery, f.Subject) > 0 OR CHARINDEX(@SearchQuery, f.Description) > 0)
    ORDER BY 
        CASE WHEN @SortColumn = 'Id' AND @SortDesc = 0 THEN f.[Id] END ASC,
        CASE WHEN @SortColumn = 'EmployeeId' AND @SortDesc = 0 THEN f.[EmployeeId] END ASC,
		CASE WHEN @SortColumn = 'EmployeeName' AND @SortDesc = 0 THEN CONCAT(e.[FirstName], ' ', ISNULL(e.[MiddleName] + ' ', ''), e.[LastName]) END ASC,
        CASE WHEN @SortColumn = 'EmployeeEmail' AND @SortDesc = 0 THEN f.[CreatedBy] END ASC,
        CASE WHEN @SortColumn = 'TicketStatus' AND @SortDesc = 0 THEN f.[TicketStatus] END ASC,
        CASE WHEN @SortColumn = 'FeedbackType' AND @SortDesc = 0 THEN f.[FeedbackType] END ASC,
        CASE WHEN @SortColumn = 'Subject' AND @SortDesc = 0 THEN f.[Subject] END ASC,
        CASE WHEN @SortColumn = 'Description' AND @SortDesc = 0 THEN f.[Description] END ASC,
        CASE WHEN @SortColumn = 'AdminComment' AND @SortDesc = 0 THEN f.[AdminComment] END ASC,
        CASE WHEN @SortColumn = 'CreatedOn' AND @SortDesc = 0 THEN f.[CreatedOn] END ASC,

        CASE WHEN @SortColumn = 'Id' AND @SortDesc = 1 THEN f.[Id] END DESC,
        CASE WHEN @SortColumn = 'EmployeeId' AND @SortDesc = 1 THEN f.[EmployeeId] END DESC,
        CASE WHEN @SortColumn = 'EmployeeName' AND @SortDesc = 1 THEN CONCAT(e.[FirstName], ' ', ISNULL(e.[MiddleName] + ' ', ''), e.[LastName]) END DESC,
        CASE WHEN @SortColumn = 'EmployeeEmail' AND @SortDesc = 1 THEN f.[CreatedBy] END DESC,
        CASE WHEN @SortColumn = 'TicketStatus' AND @SortDesc = 1 THEN f.[TicketStatus] END DESC,
        CASE WHEN @SortColumn = 'FeedbackType' AND @SortDesc = 1 THEN f.[FeedbackType] END DESC,
        CASE WHEN @SortColumn = 'Subject' AND @SortDesc = 1 THEN f.[Subject] END DESC,
        CASE WHEN @SortColumn = 'Description' AND @SortDesc = 1 THEN f.[Description] END DESC,
        CASE WHEN @SortColumn = 'AdminComment' AND @SortDesc = 1 THEN f.[AdminComment] END DESC,
        CASE WHEN @SortColumn = 'CreatedOn' AND @SortDesc = 1 THEN f.[CreatedOn] END DESC,
		CASE WHEN NULLIF(@SortColumn, '') IS NULL THEN f.[CreatedOn] END DESC
    OFFSET COALESCE(NULLIF(@StartIndex, 0), 0) ROWS
    FETCH NEXT COALESCE(NULLIF(@PageSize, 0), 10) ROWS ONLY;
END
GO

---------------------------------GetFeedbackByEmployee-------------------------------------
GO
CREATE OR ALTER   PROC [dbo].[GetFeedbackByEmployee]
    @UserSessionId INT,
    @EmployeeCodes VARCHAR(500) = NULL,
    @CreatedOnFrom DATE = NULL,
    @CreatedOnTo DATE = NULL,
    @FeedbackType INT = NULL,
    @TicketStatus INT = NULL,
    @SearchQuery VARCHAR(250) = NULL,
    @EmployeeName VARCHAR(250) = NULL,
    @SortColumn VARCHAR(50) = NULL,
    @SortDesc BIT = 0,
    @StartIndex INT = NULL,
    @PageSize INT = NULL
AS BEGIN
    /*
    EXEC GetFeedbackByEmployee @UserSessionId = 101, @SortColumn = 'Id', @SortDesc = 1, @PageSize = 50
    */

    -- Count total records
    SELECT COUNT(*) AS TotalCount
    FROM [dbo].[Feedback] f
    LEFT JOIN [dbo].[EmployeeData] e ON f.[EmployeeId] = e.[Id]
    WHERE
        f.[EmployeeId] = @UserSessionId AND
        (@CreatedOnFrom IS NULL OR @CreatedOnTo IS NULL OR f.CreatedOn BETWEEN @CreatedOnFrom AND @CreatedOnTo) AND
        (NULLIF(@EmployeeCodes, '') IS NULL OR e.EmployeeCode IN (SELECT TRIM(value) FROM string_split(@EmployeeCodes, ','))) AND
        (NULLIF(@FeedbackType, 0) IS NULL OR f.FeedbackType = @FeedbackType) AND
        (NULLIF(@TicketStatus, 0) IS NULL OR f.TicketStatus = @TicketStatus) AND
        (NULLIF(@SearchQuery, '') IS NULL OR CHARINDEX(@SearchQuery, f.Subject) > 0 OR CHARINDEX(@SearchQuery, f.Description) > 0) AND
        (NULLIF(@EmployeeName, '') IS NULL OR CHARINDEX(@EmployeeName, CONCAT(e.[FirstName], ' ', 
            CASE WHEN e.[MiddleName] IS NOT NULL THEN e.[MiddleName] + ' ' ELSE '' END, 
            e.[LastName])) > 0);

    -- Select feedback records
    SELECT 
        f.[Id],
        f.[EmployeeId],
        f.[TicketStatus],
        f.[FeedbackType],
        f.[Subject],
        f.[Description],
        f.[AdminComment],
        f.[CreatedOn],
		f.[ModifiedOn]
    FROM [dbo].[Feedback] f
    LEFT JOIN [dbo].[EmployeeData] e ON f.[EmployeeId] = e.[Id]
    WHERE
        f.[EmployeeId] = @UserSessionId AND
        (@CreatedOnFrom IS NULL OR @CreatedOnTo IS NULL OR f.CreatedOn BETWEEN @CreatedOnFrom AND @CreatedOnTo) AND
        (NULLIF(@EmployeeCodes, '') IS NULL OR e.EmployeeCode IN (SELECT TRIM(value) FROM string_split(@EmployeeCodes, ','))) AND
        (NULLIF(@FeedbackType, 0) IS NULL OR f.FeedbackType = @FeedbackType) AND
        (NULLIF(@TicketStatus, 0) IS NULL OR f.TicketStatus = @TicketStatus) AND
        (NULLIF(@SearchQuery, '') IS NULL OR CHARINDEX(@SearchQuery, f.Subject) > 0 OR CHARINDEX(@SearchQuery, f.Description) > 0) AND
        (NULLIF(@EmployeeName, '') IS NULL OR CHARINDEX(@EmployeeName, CONCAT(e.[FirstName], ' ', 
            CASE WHEN e.[MiddleName] IS NOT NULL THEN e.[MiddleName] + ' ' ELSE '' END, 
            e.[LastName])) > 0)
    ORDER BY 
        CASE WHEN @SortColumn = 'Id' AND @SortDesc = 0 THEN f.[Id] END ASC,
        CASE WHEN @SortColumn = 'EmployeeId' AND @SortDesc = 0 THEN f.[EmployeeId] END ASC,
        CASE WHEN @SortColumn = 'TicketStatus' AND @SortDesc = 0 THEN f.[TicketStatus] END ASC,
        CASE WHEN @SortColumn = 'FeedbackType' AND @SortDesc = 0 THEN f.[FeedbackType] END ASC,
        CASE WHEN @SortColumn = 'Subject' AND @SortDesc = 0 THEN f.[Subject] END ASC,
        CASE WHEN @SortColumn = 'Description' AND @SortDesc = 0 THEN f.[Description] END ASC,
        CASE WHEN @SortColumn = 'AdminComment' AND @SortDesc = 0 THEN f.[AdminComment] END ASC,
        CASE WHEN @SortColumn = 'CreatedOn' AND @SortDesc = 0 THEN f.[CreatedOn] END ASC,
        CASE WHEN @SortColumn = 'Id' AND @SortDesc = 1 THEN f.[Id] END DESC,
        CASE WHEN @SortColumn = 'EmployeeId' AND @SortDesc = 1 THEN f.[EmployeeId] END DESC,
        CASE WHEN @SortColumn = 'TicketStatus' AND @SortDesc = 1 THEN f.[TicketStatus] END DESC,
        CASE WHEN @SortColumn = 'FeedbackType' AND @SortDesc = 1 THEN f.[FeedbackType] END DESC,
        CASE WHEN @SortColumn = 'Subject' AND @SortDesc = 1 THEN f.[Subject] END DESC,
        CASE WHEN @SortColumn = 'Description' AND @SortDesc = 1 THEN f.[Description] END DESC,
        CASE WHEN @SortColumn = 'AdminComment' AND @SortDesc = 1 THEN f.[AdminComment] END DESC,
        CASE WHEN @SortColumn = 'CreatedOn' AND @SortDesc = 1 THEN f.[CreatedOn] END DESC,
		CASE WHEN NULLIF(@SortColumn, '') IS NULL THEN f.[CreatedOn] END DESC
    OFFSET COALESCE(NULLIF(@StartIndex, 0), 0) ROWS
    FETCH NEXT COALESCE(NULLIF(@PageSize, 0), 10) ROWS ONLY;
END