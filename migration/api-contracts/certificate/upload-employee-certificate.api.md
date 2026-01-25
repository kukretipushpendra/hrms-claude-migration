# Certificate/Upload Employee Certificate API Contract

## POST /api/UserProfile/UploadEmployeeCertificate

**Description:** Upload employee certificate
**Auth Required:** Yes (CreateCertificate permission)

### Request
- Method: POST
- Route Params: None
- Query Params: None
- Body: multipart/form-data (UserCertificateRequestDto)

### Response 200
```json
{
  "statusCode": 200,
  "message": "Certificate uploaded successfully",
  "data": {
    "certificateId": 0,
    "certificateName": "string",
    "certificateUrl": "string"
  }
}
```

### Response 400
```json
{
  "statusCode": 400,
  "message": "Error in saving certificate",
  "data": null,
  "errors": ["validation errors"]
}
```

### TypeScript Types
```typescript
interface UserCertificateRequest {
  employeeId: number;
  certificateName: string;
  issuedBy: string;
  issuedDate: string;
  expiryDate?: string;
  certificateFile: File;
}
```
