SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 
CREATE OR ALTER   PROCEDURE [dbo].[GetAttendanceConfiguration] --'','',1,100
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
 
    SET @Query = 'SELECT  ed.EmployeeId, ed.TimeDoctorUserId,
							emp.EmployeeCode,
                         CONCAT(emp.FirstName, 
                                CASE 
                                    WHEN emp.MiddleName IS NOT NULL AND emp.MiddleName <> '' '' 
                                    THEN CONCAT('' '', emp.MiddleName) 
                                    ELSE '''' 
                                END,
                                '' '', 
                                emp.LastName) AS EmployeeName,
                          ds.Designation,
                         d.Department AS Department,
                         c.CountryName AS Country, 
                         IsManualAttendance
                  FROM EmployeeData emp
                  INNER JOIN EmploymentDetail ed ON ed.EmployeeId = emp.Id  
                  LEFT JOIN Department d ON ed.DepartmentId = d.Id
                  LEFT JOIN Address a ON ed.EmployeeId = a.EmployeeId  
                  LEFT JOIN Country c ON a.CountryId = c.Id
				  LEFT JOIN Designation ds ON ds.Id = ed.DesignationId
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
	--Print(@Query)
    EXEC(@Query)
END