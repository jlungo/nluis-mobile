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


# 4) GET list of questionnaires by locality id & questionnaire type id

**GET** `/collect/questionnaire/list/?limit=20&offset=0&keyword=&module=&category=`

**Response 200**

```json
{
    "count": 1,
    "next": null,
    "previous": null,
    "results": [
        {
            "slug": "a-taarifa-za-msingi-za-kijiji",
            "name": "A. Taarifa za Msingi za Kijiji",
            "category": 6,
            "description": "Taarifa za Msingi za Kijiji",
            "version": 1,
            "is_active": true,
            "module_slug": "land-uses",
            "module_name": "Land Uses",
            "questionnaire_sections_count": 1,
        }
    ]
}
```

---

# 5) GET questionnaire (section forms + fields) by questionnaire slug

**GET** `/collect/questionnaire/{questionnaire_slug}`

**Response 200**

```json
{
    "slug": "a-taarifa-za-msingi-za-kijiji",
    "name": "A. Taarifa za Msingi za Kijiji",
    "category": 6,
    "description": "Taarifa za Msingi za Kijiji",
    "module_slug": "land-uses",
    "module_name": "Land Uses",
    "version": 1,
    "questionnaire_sections": [
        {
            "slug": "taarifa-za-msingi-za-kijiji",
            "name": "Taarifa za Msingi za Kijiji",
            "description": "Taarifa za Msingi za Kijiji",
            "position": 1,
            "is_active": true,
            "questionnaire_slug": "a-taarifa-za-msingi-za-kijiji",
            "questionnaire_name": "A. Taarifa za Msingi za Kijiji",
            "module_slug": "land-uses",
            "module_name": "Land Uses",
            "questionnaire_section_forms": [
                {
                    "slug": "b-historia-ya-kijiji",
                    "name": "(b) Historia ya kijiji",
                    "description": "(b) Historia ya kijiji",
                    "is_active": true,
                    "questionnaire_section_slug": "taarifa-za-msingi-za-kijiji",
                    "questionnaire_section_name": "Taarifa za Msingi za Kijiji",
                    "questionnaire_slug": "a-taarifa-za-msingi-za-kijiji",
                    "questionnaire_name": "A. Taarifa za Msingi za Kijiji",
                    "module_slug": "land-uses",
                    "module_name": "Land Uses",
                    "position": 2,
                    "custom_form_fields": [
                        {
                            "id": 41,
                            "label": "Kijiji kimepimwa?",
                            "type": "select",
                            "type_display": "DropDown",
                            "placeholder": "Kijiji kimepimwa?",
                            "name": "kijiji-kimepimwa",
                            "required": true,
                            "position": 4,
                            "is_active": true,
                            "custom_form_slug": "b-historia-ya-kijiji",
                            "custom_form_name": "(b) Historia ya kijiji",
                            "questionnaire_section_slug": "taarifa-za-msingi-za-kijiji",
                            "questionnaire_section_name": "Taarifa za Msingi za Kijiji",
                            "questionnaire_slug": "a-taarifa-za-msingi-za-kijiji",
                            "questionnaire_name": "A. Taarifa za Msingi za Kijiji",
                            "module_slug": "land-uses",
                            "module_name": "Land Uses",
                            "questionnaire_select_options": [
                                {
                                    "text_label": "Hapana",
                                    "value": "hapana",
                                    "position": 2
                                },
                                {
                                    "text_label": "Ndio",
                                    "value": "ndio",
                                    "position": 1
                                }
                            ]
                        },
                        {
                            "id": 38,
                            "label": "Maana ya jina la Kijiji",
                            "type": "textarea",
                            "type_display": "Text Area",
                            "placeholder": "Maana ya jina la Kijiji",
                            "name": "maana-ya-jina-la-kijiji",
                            "required": true,
                            "position": 1,
                            "is_active": true,
                            "custom_form_slug": "b-historia-ya-kijiji",
                            "custom_form_name": "(b) Historia ya kijiji",
                            "questionnaire_section_slug": "taarifa-za-msingi-za-kijiji",
                            "questionnaire_section_name": "Taarifa za Msingi za Kijiji",
                            "questionnaire_slug": "a-taarifa-za-msingi-za-kijiji",
                            "questionnaire_name": "A. Taarifa za Msingi za Kijiji",
                            "module_slug": "land-uses",
                            "module_name": "Land Uses",
                            "questionnaire_select_options": []
                        }
                    ]
                },
                {
                    "slug": "a-mahali-kijiji-kilipo",
                    "name": "(a) Mahali Kijiji Kilipo",
                    "description": "(a) Mahali Kijiji Kilipo",
                    "is_active": true,
                    "questionnaire_section_slug": "taarifa-za-msingi-za-kijiji",
                    "questionnaire_section_name": "Taarifa za Msingi za Kijiji",
                    "questionnaire_slug": "a-taarifa-za-msingi-za-kijiji",
                    "questionnaire_name": "A. Taarifa za Msingi za Kijiji",
                    "module_slug": "land-uses",
                    "module_name": "Land Uses",
                    "position": 1,
                    "custom_form_fields": [
                        {
                            "id": 37,
                            "label": "Mkoa",
                            "type": "text",
                            "type_display": "Text",
                            "placeholder": "Mkoa",
                            "name": "mkoa",
                            "required": true,
                            "position": 5,
                            "is_active": true,
                            "custom_form_slug": "a-mahali-kijiji-kilipo",
                            "custom_form_name": "(a) Mahali Kijiji Kilipo",
                            "questionnaire_section_slug": "taarifa-za-msingi-za-kijiji",
                            "questionnaire_section_name": "Taarifa za Msingi za Kijiji",
                            "questionnaire_slug": "a-taarifa-za-msingi-za-kijiji",
                            "questionnaire_name": "A. Taarifa za Msingi za Kijiji",
                            "module_slug": "land-uses",
                            "module_name": "Land Uses",
                            "questionnaire_select_options": []
                        },
                    ]
                }
            ]
        }
    ]
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
