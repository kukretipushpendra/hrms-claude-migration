
Create OR ALTER     PROCEDURE [dbo].[GetEmployees]
@EmployeeName AS VARCHAR(100)='',
@DepartmentId as bigint,
@DesignationId as bigint,
@RoleId AS BIGINT,
@Status as INT,
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
	            e1.DOB,e2.Email,(e6.Line1 + '' '' + ISNULL(e6.Line2, '''')) AS Address, e11.CityName,e12.StateName, e10.Pincode,e15.CountryName As Country,
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
                e13.Department As DepartmentName, e14.Designation As Designation
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
				Left JOIN Department e13 on e13.Id = e2.DepartmentId
				Left JOIN Designation e14 on e14.Id = e2.DesignationId
				Left JOIN Country e15 on e15.Id = e10.CountryId'

			
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
	 IF(ISNULL(@DesignationId,0)<>0)
	BEGIN
		SET @WhereConditons += @wherejoin + ' e2.DesignationId ='+ CONVERT(VARCHAR(12), @DesignationId)
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

--Exec GetEmployees '',0,0,0,0,'','','',1,10

----------Teams-------------------

GO
 ALTER   PROCEDURE [dbo].[GetTeams]
@TeamName AS VARCHAR(100)='',
@Status AS int,
@SortColumnName AS VARCHAR(50)='',
@SortColumnDirection AS VARCHAR(50)='',
@PageNumber AS INT=1,
@PageSize AS INT=10
AS
BEGIN
	DECLARE @Query AS VARCHAR(MAX)='',@OrderQuery AS VARCHAR(MAX)='',@Conditions AS VARCHAR(MAX)='',
	@Pagination AS VARCHAR(MAX)='', @StartIndex AS INT

	SELECT @StartIndex = (@PageNumber-1)*@PageSize  
	
	SET @Query='SELECT Id,TeamName As Name, IsDeleted As Status
				FROM DBO.Team  WHERE 1=1'
	
	-- SEARCH OPERATION
	BEGIN
	SET @Conditions=''
	END
	IF(ISNULL(@TeamName,'')<>'')
	BEGIN
		SET @Conditions +=' and TeamName LIKE ''%'+@TeamName+'%'''
	END
		IF(@Status IS NULL)
	BEGIN
		SET @Conditions += ' AND (IsDeleted = 0 OR IsDeleted = 1)' -- Include all records
	END
	ELSE
	BEGIN
		SET @Conditions += ' AND IsDeleted = ' + CAST(@Status AS VARCHAR(10))
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
--exec [dbo].[GetTeams] '',0,'','',1,100

-------------GetDepartments--------------
 ALTER   PROCEDURE [dbo].[GetDepartments]
@Department AS VARCHAR(100)='',
@Status AS int,
@SortColumnName AS VARCHAR(50)='',
@SortColumnDirection AS VARCHAR(50)='',
@PageNumber AS INT=1,
@PageSize AS INT=100
AS
BEGIN
	DECLARE @Query AS VARCHAR(MAX)='',@OrderQuery AS VARCHAR(MAX)='',@Conditions AS VARCHAR(MAX)='',
	@Pagination AS VARCHAR(MAX)='', @StartIndex AS INT

	SELECT @StartIndex = (@PageNumber-1)*@PageSize  
	
	SET @Query='SELECT Id,Department As Name, IsDeleted As Status
				FROM DBO.Department WHERE 1=1'
	
	-- SEARCH OPERATION
	BEGIN
	SET @Conditions=''
	END
	IF(ISNULL(@Department,'')<>'')
	BEGIN
		SET @Conditions +=' and Department LIKE ''%'+@Department+'%'''
	END
		IF(@Status IS NULL)
	BEGIN
		SET @Conditions += ' AND (IsDeleted = 0 OR IsDeleted = 1)' -- Include all records
	END
	ELSE
	BEGIN
		SET @Conditions += ' AND IsDeleted = ' + CAST(@Status AS VARCHAR(10))
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


---exec [GetDepartments] '',null,'','',1,100
GO
Create or ALTER   PROCEDURE [dbo].[GetDesignation]
@Designation AS VARCHAR(100)='',
@Status AS int,
@SortColumnName AS VARCHAR(50)='',
@SortColumnDirection AS VARCHAR(50)='',
@PageNumber AS INT=1,
@PageSize AS INT=100
AS
BEGIN
	DECLARE @Query AS VARCHAR(MAX)='',@OrderQuery AS VARCHAR(MAX)='',@Conditions AS VARCHAR(MAX)='',
	@Pagination AS VARCHAR(MAX)='', @StartIndex AS INT

	SELECT @StartIndex = (@PageNumber-1)*@PageSize  
	
	SET @Query='SELECT Id,Designation As Name, IsDeleted As Status
				FROM DBO.Designation WHERE 1=1'
	
	-- SEARCH OPERATION
	BEGIN
	SET @Conditions=''
	END
	IF(ISNULL(@Designation,'')<>'')
	BEGIN
		SET @Conditions +=' and Designation LIKE ''%'+@Designation+'%'''
	END
		IF(@Status IS NULL)
	BEGIN
		SET @Conditions += ' AND (IsDeleted = 0 OR IsDeleted = 1)' -- Include all records
	END
	ELSE
	BEGIN
		SET @Conditions += ' AND IsDeleted = ' + CAST(@Status AS VARCHAR(10))
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
--exec [GetDesignation] '',null,'','',1,100
/****** Object:  StoredProcedure [dbo].[GetAttendanceConfiguration]    Script Date: 5/30/2025 3:49:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create Or ALTER   PROCEDURE [dbo].[GetAttendanceConfiguration]
    @EmployeeName AS VARCHAR(100) = NULL,
	@EmployeeCode AS VARCHAR(20)=Null,
    @PageNumber AS INT = 1,
    @PageSize AS INT = 10
	
AS
BEGIN
    DECLARE @Query AS VARCHAR(MAX) = '',
            @Pagination AS VARCHAR(MAX) = '',
            @StartIndex AS INT

    SELECT @StartIndex = (@PageNumber -1) * @PageSize  

    SET @Query = 'SELECT  ed.EmployeeId,
							emp.EmployeeCode,
                         CONCAT(emp.FirstName, 
                                CASE 
                                    WHEN emp.MiddleName IS NOT NULL AND emp.MiddleName <> '' '' 
                                    THEN CONCAT('' '', emp.MiddleName) 
                                    ELSE '''' 
                                END,
                                '' '', 
                                emp.LastName) AS EmployeeName,
                         Designation,
                         d.Department AS Department,
                         c.CountryName AS Country, 
                         IsManualAttendance
                  FROM EmployeeData emp
                  INNER JOIN EmploymentDetail ed ON ed.EmployeeId = emp.Id  
                  LEFT JOIN Department d ON ed.DepartmentId = d.Id
                  LEFT JOIN Address a ON ed.EmployeeId = a.EmployeeId  
                  LEFT JOIN Country c ON a.CountryId = c.Id
                  WHERE 1=1'  -- This allows for easy appending of conditions

    IF @EmployeeName IS NOT NULL AND @EmployeeName <> ''
    BEGIN
        SET @Query += ' AND (CONCAT(emp.FirstName, '' '', 
                                ISNULL(emp.MiddleName, ''''), '' '', 
                                emp.LastName) LIKE ''%' + @EmployeeName + '%'')'
    END
	
	IF @EmployeeCode IS NOT NULL 
	BEGIN
		SET @Query += ' AND emp.EmployeeCode = ''' + @EmployeeCode + ''''
	END


    SET @Query += ' ORDER BY ed.EmployeeId ' 

    IF (@PageSize > 0)
    BEGIN
        SET @Pagination = ' OFFSET ' + CAST(@StartIndex AS VARCHAR(10)) + ' ROWS
                           FETCH NEXT ' + CAST(@PageSize AS VARCHAR(10)) + ' ROWS ONLY'
    END

    IF (@Pagination <> '') SET @Query += @Pagination

    EXEC(@Query)
END
