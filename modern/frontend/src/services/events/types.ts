// Types matching .NET backend responses

export interface ApiResponse<T> {
  statusCode: number;
  message: string;
  modelErrors?: string[];
  result?: T;
  data?: T; // Some endpoints use 'data' instead of 'result'
}

// Event List
export interface EventSearchRequest {
  Filters?: {
    EventName?: string;
    EventCategory?: string;
    Status?: string;
    StartDate?: string;
    EndDate?: string;
  };
  PageSize: number;
  StartIndex: number; // 1-based indexing
  SortColumnName?: string;
  SortDirection?: 'asc' | 'desc';
}

export interface EventItem {
  eventId: number;
  eventName: string;
  eventDate: string;
  eventCategory: string;
  location: string;
  description: string;
  status: string;
}

export interface EventSearchResponse {
  eventList: EventItem[];
  totalRecords: number;
}

// Event Detail
export interface EventDetail {
  eventId: number;
  eventName: string;
  eventDate: string;
  eventCategoryId: number;
  eventCategory: string;
  location: string;
  description: string;
  status: string;
  documents: string[];
}

// Create/Update Request
export interface EventRequest {
  eventName: string;
  eventDate: string;
  eventCategoryId: number;
  location: string;
  description: string;
  documents?: File[];
}

export interface EventResponse {
  eventId: number;
  eventName: string;
  eventDate: string;
}

// Event Categories
export interface EventCategory {
  id: number;
  name: string;
}
