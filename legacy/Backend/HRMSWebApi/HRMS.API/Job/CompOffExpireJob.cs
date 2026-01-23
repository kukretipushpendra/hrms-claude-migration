/*
 * CompOff Expire Job
 * 
 * Scheduled background job that handles the expiration of compensatory off days.
 * This job automatically processes and updates the status of comp-off leave
 * requests that have reached their expiration date.
 * 
 * Features:
 * - Automatic comp-off expiration processing
 * - Logging with trace ID for debugging
 * - Error handling and reporting
 * - Integration with leave management system
 * 
 * Schedule: Runs daily at midnight
 * 
 * Version: 1.0
 * Last Updated: 2025-10-28
 */

using HRMS.Application.Services.Interfaces;  // Service layer interfaces
using HRMS.Domain;                          // Domain models
using HRMS.Domain.Entities;                 // Entity definitions
using HRMS.Domain.Enums;                    // Enumeration types
using HRMS.Infrastructure;                  // Data access layer
using Microsoft.Extensions.Options;         // Configuration options
using Quartz;                              // Job scheduling

namespace HRMS.API.Job
{
    public class CompOffExpireJob(IUnitOfWork unitOfWork, Serilog.ILogger logger) : IJob
    {
        public async Task Execute(IJobExecutionContext context)
        { 
            var traceId = Guid.NewGuid().ToString();
              
            try
            {
                  await unitOfWork.LeaveManagementRepository.CompOffExpire();
                logger.ForContext("RequestId", traceId).Information("Successfully ran for Comp off expire", nameof(CompOffExpireJob));
            }
            catch (Exception e)
            {
                logger.ForContext("RequestId", traceId).Error(e, "{0}", e.Message);
            }
        }
    }
}
