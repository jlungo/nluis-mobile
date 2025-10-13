# Base

* **Base URL:** `http://144.91.125.106:8000/api/v1`
* **Auth:** `Authorization: Bearer <access_token>`
* **Pagination:** `?limit=20&offset=0`
* **Errors:**

  ```json
  {
    "code": "validation_error",
    "message": "One or more fields are invalid.",
    "errors": { "email": ["This field is required."] }
  }
  ```
---

# 6) POST save questionnaire data (submission)

**POST** `/questionnaire-responses/`

Supports **draft** and **final** saves, bulk field values, and attachments.

**Request**

```json
{
  "questionnaire_id": 2001,
  "locality_project": 101,
  "answers": [
    { "form_field": 154, "value": "string or number or JSON" },
    { "form_field": 151, "value": ["multiselect-1","multiselect-3"] },
    { "form_field": 148, "value": "file://local/path/or/upload-id" }
  ],
  "metadata": { "app_version": "1.4.2", "device_id": "abc-123" }
}
```

**Response 201**

```json
{
  "id": "5f2a7b4c-9f7a-4a2a-9c7b-3b8a1d2f77e1",
  "questionnaire_id": 2001,
  "locality_project": 101,
  "status": "draft",
  "submitted_by": {
    "id": "a2e1c6b8-4b5f-4a6c-9d8b-5c2cfe7d1a01",
    "name": "Jane Doe"
  },
  "submitted_at": null,
  "updated_at": "2025-10-03T12:00:00Z",
  "answers": [
    { "form_field": 154, "value": "string or number or JSON" },
    { "form_field": 151, "value": ["multiselect-1","multiselect-3"] },
    { "form_field": 148, "value": "upload:7c1e..." }
  ]
}
```

---

# 7) GET list filled questionnaires by user id

**GET** `/questionnaire-responses/?locality_id=501&type_id=2&status=submitted&limit=20&offset=0`

**Response 200**

```json
{
  "count": 3,
  "next": null,
  "previous": null,
  "results": [
    {
      "id": "5f2a7b4c-9f7a-4a2a-9c7b-3b8a1d2f77e1",
      "questionnaire": { "id": 2001, "name": "Zoning Field Sheet v2" },
      "locality_project": 101,
      "status": "submitted",
      "submitted_at": "2025-09-21T15:11:00Z",
      "updated_at": "2025-09-21T15:11:00Z"
    },
    {
      "id": "1a9c0a99-4e1e-45d7-9e12-6e3a3d7b0f21",
      "questionnaire": { "id": 2002, "name": "Taarifa za Kijiji" },
      "locality_project": 101,
      "status": "submitted",
      "submitted_at": null,
      "updated_at": "2025-09-19T09:44:00Z"
    }
  ]
}
```

---

# 8) GET view a filled questionnaire (single response)

**GET** `/questionnaire-responses/{response_id}/`

**Response 200**

```json
{
  "id": "5f2a7b4c-9f7a-4a2a-9c7b-3b8a1d2f77e1",
  "questionnaire": {
    "id": 2001,
    "name": "Zoning Field Sheet v2",
    "snapshot_version": "2.3.0"
  },
  "locality_project": 101,
  "status": "submitted",
  "submitted_by": { "id": "a2e1c6b8-4b5f-4a6c-9d8b-5c2cfe7d1a01", "name": "Jane Doe" },
  "submitted_at": "2025-09-21T15:11:00Z",
  "updated_at": "2025-09-21T15:11:00Z",
  "geo": { "lat": -6.792354, "lng": 39.208328, "accuracy_m": 8 },
  "answers": [
    {
      "form_field": 154,
      "label": "test",
      "type": "members",
      "value": [{ "name": "Member 1" }, { "name": "Member 2" }]
    },
    {
      "form_field": 151,
      "label": "Multiselect Test",
      "type": "multiselect",
      "value": ["multiselect-1","multiselect-3"],
      "display_value": ["Multiselect 1","Multiselect 3"]
    },
    {
      "form_field": 148,
      "label": "Final VLUP Document",
      "type": "file",
      "value": "upload:7c1e...",
      "file_url": "https://cdn.example.com/u/7c1e.../final.pdf"
    }
  ],
  "schema_snapshot": {
    "forms": [
      { "slug": "test", "name": "test", "form_fields": [/* ... as at submission time ... */] }
    ]
  }
}
```

---

# 9) Update filled questionnaire (edit/update)

**PATCH** `/questionnaire-responses/{response_id}/`

**Request**

```json
{
  "status": "submitted",
  "answers": [
    { "form_field": 151, "value": ["multiselect-2"] },
    { "form_field": 143, "value": "Updated text" }
  ]
}
```

**Response 200**

```json
{
  "id": "5f2a7b4c-9f7a-4a2a-9c7b-3b8a1d2f77e1",
  "status": "submitted",
  "updated_at": "2025-10-03T12:45:00Z",
  "answers": [
    { "form_field": 151, "value": ["multiselect-2"] },
    { "form_field": 143, "value": "Updated text" }
  ]
}
```

---
