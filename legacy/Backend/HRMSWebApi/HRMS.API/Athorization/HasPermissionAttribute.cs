/*
 * HasPermission Attribute
 * 
 * Custom authorization attribute for permission-based access control.
 * Extends the base AuthorizeAttribute to implement fine-grained
 * permission checking for API endpoints.
 * 
 * Usage:
 * [HasPermission(Permissions.ReadEmployees)]
 * public class EmployeeController : ControllerBase
 * 
 * Features:
 * - Permission-based authorization
 * - Integrates with ASP.NET Core authorization pipeline
 * - Supports role-based access control
 * 
 * Version: 1.0
 * Last Updated: 2025-10-28
 */

using Microsoft.AspNetCore.Authorization;  // Base authorization functionality

namespace HRMS.API.Athorization
{
    public class HasPermissionAttribute : AuthorizeAttribute
    {
        public HasPermissionAttribute(string permission) : base(policy: permission)
        {
           
        }
    }   
}
