import httpClient from '@/services/api/http-client';
import type {
  ApiResponse,
  EventSearchRequest,
  EventSearchResponse,
  EventDetail,
  EventRequest,
  EventResponse,
  EventCategory,
} from './types';

const baseRoute = '/Event';

/**
 * Get paginated and filtered list of events
 * POST /Event/GetEvents
 * Requires: Read.Events permission
 */
export async function getEvents(
  params: EventSearchRequest
): Promise<ApiResponse<EventSearchResponse>> {
  const response = await httpClient.post<ApiResponse<EventSearchResponse>>(
    `${baseRoute}/GetEvents`,
    params
  );
  return response.data;
}

/**
 * Get event by ID
 * GET /Event/{id}
 * Requires: Read.Events permission
 */
export async function getEventById(id: number): Promise<ApiResponse<EventDetail>> {
  const response = await httpClient.get<ApiResponse<EventDetail>>(`${baseRoute}/${id}`);
  return response.data;
}

/**
 * Create new event
 * POST /Event/CreateEvent
 * Requires: Create.Events permission
 */
export async function createEvent(data: EventRequest): Promise<ApiResponse<EventResponse>> {
  const formData = new FormData();
  formData.append('eventName', data.eventName);
  formData.append('eventDate', data.eventDate);
  formData.append('eventCategoryId', data.eventCategoryId.toString());
  formData.append('location', data.location);
  formData.append('description', data.description);

  if (data.documents && data.documents.length > 0) {
    data.documents.forEach((file) => {
      formData.append('documents', file);
    });
  }

  const response = await httpClient.post<ApiResponse<EventResponse>>(
    `${baseRoute}/CreateEvent`,
    formData,
    {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    }
  );
  return response.data;
}

/**
 * Update existing event
 * PUT /Event/UpdateEvent
 * Requires: Edit.Events permission
 */
export async function updateEvent(
  id: number,
  data: EventRequest
): Promise<ApiResponse<EventResponse>> {
  const formData = new FormData();
  formData.append('eventId', id.toString());
  formData.append('eventName', data.eventName);
  formData.append('eventDate', data.eventDate);
  formData.append('eventCategoryId', data.eventCategoryId.toString());
  formData.append('location', data.location);
  formData.append('description', data.description);

  if (data.documents && data.documents.length > 0) {
    data.documents.forEach((file) => {
      formData.append('documents', file);
    });
  }

  const response = await httpClient.put<ApiResponse<EventResponse>>(
    `${baseRoute}/UpdateEvent`,
    formData,
    {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    }
  );
  return response.data;
}

/**
 * Delete event
 * DELETE /Event/{id}
 * Requires: Delete.Events permission
 */
export async function deleteEvent(id: number): Promise<ApiResponse<null>> {
  const response = await httpClient.delete<ApiResponse<null>>(`${baseRoute}/${id}`);
  return response.data;
}

/**
 * Get event categories
 * GET /Event/GetEventCategoryList
 */
export async function getEventCategories(): Promise<ApiResponse<EventCategory[]>> {
  const response = await httpClient.get<ApiResponse<EventCategory[]>>(
    `${baseRoute}/GetEventCategoryList`
  );
  return response.data;
}
