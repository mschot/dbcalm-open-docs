API Reference
=============

DBCalm provides a RESTful API for managing database backups, restores, clients, and schedules.

Base URL
--------

The API is available at: ``https://your-server:8335``

Interactive documentation is also available at: ``https://your-server:8335/docs`` (Swagger UI)

Authentication
--------------

DBCalm uses OAuth2 with JWT tokens for authentication.

Quick Start
~~~~~~~~~~~

1. Request an authorization code with your username/password
2. Exchange the code for an access token
3. Use the token in the ``Authorization: Bearer <token>`` header for all API requests

See the ``/auth/authorize`` and ``/auth/token`` endpoints below for details.

API Endpoints
-------------

The following interactive documentation shows all available endpoints, request/response schemas, and error codes.
