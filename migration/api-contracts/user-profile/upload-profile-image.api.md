# User Profile/Upload Profile Image API Contract

## POST /api/UserProfile/UploadUserProfileImage

**Description:** Upload user profile image
**Auth Required:** Yes (EditPersonalDetails permission)

### Request
- Method: POST
- Route Params: None
- Query Params: None
- Body: multipart/form-data
  - employeeId: long
  - file: IFormFile

### Response 200
```json
{
  "statusCode": 200,
  "message": "Profile image uploaded successfully",
  "data": {
    "imageUrl": "string"
  }
}
```

### Response 400
```json
{
  "statusCode": 400,
  "message": "Error in updating user profile",
  "data": null
}
```

### Response 404
```json
{
  "statusCode": 404,
  "message": "User profile not found",
  "data": null
}
```

### Response 500
```json
{
  "statusCode": 500,
  "message": "Error in updating/removing file name in database",
  "data": null
}
```

### TypeScript Types
```typescript
interface UploadFileRequest {
  employeeId: number;
  file: File;
}

interface UploadFileResponse {
  imageUrl: string;
}
```
