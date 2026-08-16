# API_GUIDELINES.md

# API Guidelines

## Purpose

This document defines the standards and conventions for designing and implementing REST APIs in the Invest Game V2 backend.

Every endpoint should follow these guidelines to ensure consistency, maintainability, and a predictable developer experience.

---

# API Style

The backend exposes a REST API.

General principles:

- Stateless
- JSON only
- Resource-oriented
- Predictable
- Consistent

All endpoints should follow REST conventions unless there is a strong technical reason not to.

---

# Base URL

## Target

```
/api/v1
```

Target namespaces, aligned to `PRODUCT_VISION.md`'s learning-first priority order:

```
/api/v1/auth
/api/v1/learning
/api/v1/portfolio
/api/v1/assets
/api/v1/gamification
/api/v1/pets
/api/v1/missions
/api/v1/mentor
/api/v1/users
```

## Current

**Gap:** no version prefix exists today, and `auth` isn't even under `/api`. Actual routes in use:

```
/auth                          (no /api prefix — inconsistent with every other controller)
/api/settings
/api/pets
/api/mentor
/api/onboarding
/api/investments               (target name: /api/v1/portfolio + /api/v1/assets)
```

There is no `/learning`, `/gamification`, or `/missions` namespace yet — Academy progress, XP, missions, and
achievements are entirely client-local (see `FEATURES.md`). New endpoints should be added under `/api/v1/...`
going forward rather than extending the unversioned style, so the codebase migrates toward the target
incrementally instead of needing a single breaking rewrite.

---

# Resource Naming

Use nouns.

Good:

```
/users
/assets
/portfolio
/missions
```

Avoid verbs.

Avoid:

```
/getUsers
/createUser
/deleteMission
```

HTTP methods already describe the action.

---

# HTTP Methods

Use standard HTTP methods.

GET

Retrieve resources.

POST

Create resources.

PUT

Replace existing resources.

PATCH

Partially update resources.

DELETE

Remove resources.

---

# HTTP Status Codes

Use appropriate status codes.

Success:

```
200 OK
201 Created
202 Accepted
204 No Content
```

Client Errors:

```
400 Bad Request
401 Unauthorized
403 Forbidden
404 Not Found
409 Conflict
422 Unprocessable Entity
```

Server Errors:

```
500 Internal Server Error
503 Service Unavailable
```

Do not always return HTTP 200.

Status codes should accurately represent the outcome.

---

# Request Body

Use JSON.

Example:

```json
{
  "email": "user@example.com",
  "password": "********"
}
```

Keep request bodies focused.

Avoid unnecessary fields.

---

# Response Body

Responses should be predictable.

Example:

```json
{
  "id": 15,
  "username": "john",
  "level": 8
}
```

Do not expose internal database details.

---

# Error Responses

Errors should follow a consistent structure.

Example:

```json
{
  "timestamp": "2026-01-15T14:10:25Z",
  "status": 400,
  "error": "Validation Error",
  "message": "Email is required.",
  "path": "/api/v1/auth/register"
}
```

Error messages should help clients understand what went wrong.

Never expose stack traces.

---

# Validation

Validate every request.

Examples:

- Required fields
- String length
- Email format
- Numeric ranges
- Enum values
- Business constraints

Validation must occur on the backend even if the frontend also validates inputs.

---

# Authentication

JWT is the official authentication mechanism.

Protected endpoints require:

```
Authorization: Bearer <token>
```

Never send tokens through query parameters.

---

# Authorization

Authentication identifies the user.

Authorization determines what the user is allowed to do.

Always verify resource ownership before returning or modifying protected resources.

---

# DTOs

Always use DTOs.

Do not expose JPA entities directly.

Separate:

- Request DTOs
- Response DTOs
- Domain models
- Database entities

DTOs represent the API contract.

---

# Pagination

Large collections should support pagination.

Example:

```
GET /assets?page=0&size=20
```

Response example:

```json
{
  "content": [],
  "page": 0,
  "size": 20,
  "totalElements": 150,
  "totalPages": 8
}
```

Avoid returning excessively large datasets.

---

# Sorting

Allow sorting when appropriate.

Example:

```
GET /assets?sort=name,asc
```

---

# Filtering

Use query parameters.

Example:

```
GET /assets?category=stocks
```

Avoid creating separate endpoints for simple filters.

---

# Searching

Search should use query parameters.

Example:

```
GET /assets?search=apple
```

---

# Versioning

Version APIs through the URL (`/api/v1`, future `/api/v2`). This is the target convention — see the Base URL
section above for the current unversioned gap. New endpoints should adopt `/api/v1/...` immediately rather
than perpetuating the unversioned style.

Avoid breaking existing clients whenever possible.

---

# Idempotency

Methods should respect HTTP semantics.

GET

Safe and idempotent.

PUT

Idempotent.

DELETE

Idempotent.

POST

Not necessarily idempotent.

---

# Naming Conventions

JSON fields should use camelCase.

Example:

```json
{
  "firstName": "",
  "lastName": "",
  "totalBalance": 0
}
```

Avoid snake_case.

---

# Date Format

Use ISO-8601.

Example:

```
2026-07-28T15:30:00Z
```

Store timestamps in UTC whenever possible.

---

# Financial Values

Never use floating-point types for monetary calculations.

Use:

```
BigDecimal
```

The backend is responsible for maintaining financial precision.

---

# Transactions

Operations that modify multiple entities should be transactional.

Database consistency takes priority over performance.

---

# Business Rules

Business rules belong inside the service layer.

Controllers should not contain business logic.

Repositories should not contain business logic.

---

# Logging

Log:

- Authentication attempts
- Business failures
- External service failures
- Unexpected exceptions

Do not log:

- Passwords
- JWT tokens
- Sensitive user information

---

# Security

Always validate:

- Authentication
- Authorization
- Input
- Resource ownership

Never trust client input.

---

# Documentation

Every public endpoint should include:

- Purpose
- Parameters
- Authentication requirements
- Request example
- Response example
- Possible errors

API documentation should evolve together with the code.

---

# Performance

Optimize database queries before introducing infrastructure complexity.

Avoid:

- N+1 queries
- Unnecessary eager loading
- Duplicate queries

Measure performance before optimizing.

---

# Consistency

Consistency is more important than individual preferences.

New endpoints should match the style of existing endpoints.

Clients should be able to predict how an endpoint behaves based on previous endpoints.

---

# Future Considerations

Possible future improvements include:

- OpenAPI / Swagger documentation
- Rate limiting
- Request tracing
- Response caching
- Background processing
- API monitoring

These should be implemented only when there is a clear product need.

---

# Guiding Principle

An API should be easy to understand, predictable to consume, secure by default, and simple to maintain.

Every endpoint should feel like it belongs to the same system.