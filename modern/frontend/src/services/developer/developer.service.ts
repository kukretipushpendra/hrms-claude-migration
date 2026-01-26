import httpClient from '@/services/api/http-client';
import type {
  DeveloperLogsPaginationRequest,
  DeveloperLogsResponse,
  CronTypeOption,
  CronLogsPaginationRequest,
  CronLogsResponse,
  RunCronRequest,
  RunCronResponse,
  DeveloperLog,
} from '@/types/developer.types';

const BASE_URL = '/DevTool';

/**
 * Get paginated list of developer logs with filters
 * POST /api/DevTool/GetLogs
 */
export async function getDeveloperLogs(
  request: DeveloperLogsPaginationRequest
): Promise<DeveloperLogsResponse> {
  const response = await httpClient.post<{
    data: DeveloperLogsResponse;
    isSuccess: boolean;
    message: string;
  }>(`${BASE_URL}/GetLogs`, request);

  return response.data.data;
}

/**
 * Get single developer log by ID
 * GET /api/DevTool/GetLogs/{id}
 */
export async function getDeveloperLogById(id: number): Promise<DeveloperLog> {
  const response = await httpClient.get<{
    data: DeveloperLog;
    isSuccess: boolean;
    message: string;
  }>(`${BASE_URL}/GetLogs/${id}`);

  return response.data.data;
}

/**
 * Get list of available cron job types
 * GET /api/DevTool/GetCrons
 */
export async function getCronTypes(): Promise<CronTypeOption[]> {
  const response = await httpClient.get<{
    data: CronTypeOption[];
    isSuccess: boolean;
    message: string;
  }>(`${BASE_URL}/GetCrons`);

  return response.data.data;
}

/**
 * Get paginated cron execution history
 * POST /api/DevTool/GetCronLogs
 */
export async function getCronLogs(request: CronLogsPaginationRequest): Promise<CronLogsResponse> {
  const response = await httpClient.post<{
    data: CronLogsResponse;
    isSuccess: boolean;
    message: string;
  }>(`${BASE_URL}/GetCronLogs`, request);

  return response.data.data;
}

/**
 * Execute a cron job manually
 * POST /api/DevTool/RunCron
 */
export async function runCron(request: RunCronRequest): Promise<RunCronResponse> {
  const response = await httpClient.post<{
    data: RunCronResponse;
    isSuccess: boolean;
    message: string;
  }>(`${BASE_URL}/RunCron`, request);

  return response.data.data;
}
