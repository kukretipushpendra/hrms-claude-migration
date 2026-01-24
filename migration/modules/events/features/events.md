# Events Management

## Status
CURRENT: ready-for-dev
TYPE: feature
FRONTEND: pending
FRONTEND_QA: pending
INTEGRATION_QA: pending

## Description
Company events management:
- List all events with filters
- View event details
- Create new event with banner image
- Edit/delete events
- Event calendar view

## Dependencies
DEPENDS_ON: [foundation/frontend-auth]

## Attempts
FRONTEND_ATTEMPT_COUNT: 0
INTEGRATION_ATTEMPT_COUNT: 0

## API Contracts
- migration/api-contracts/event/get-events.api.md
- migration/api-contracts/event/create-event.api.md
- migration/api-contracts/event/get-event-by-id.api.md

## Legacy Reference
LEGACY_FILES:
- legacy/Frontend/HRMS-Frontend/source/src/pages/Events/
- legacy/Backend/HRMSWebApi/HRMS.API/Controllers/EventController.cs

## Modern Implementation
MODERN_FILES:
- modern/frontend/src/views/events/EventsListView.vue
- modern/frontend/src/views/events/EventDetailView.vue
- modern/frontend/src/views/events/EventCreateView.vue
- modern/frontend/src/services/events/eventsService.ts

## Acceptance Criteria
1. List events with pagination
2. Filter by date range, type
3. View event details with banner
4. Create event with image upload
5. Edit event details
6. Delete event (with confirmation)
7. Match legacy UI exactly
