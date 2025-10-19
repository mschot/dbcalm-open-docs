Developer Guide
===============

This guide helps developers set up DBCalm for local development and contribute to the project.

.. note::
   This guide is for developers who want to contribute to DBCalm or build from source.
   If you just want to install and use DBCalm, see :doc:`installation` instead.

Development vs Production
-------------------------

**Development Setup**:
- Runs from source code with auto-reload
- Uses sudo to run command services as different users
- Requires manual setup with ``make dev-install``
- Python 3.11+ required

**Production Setup (Package Installation)**:
- Runs from compiled binaries
- Systemd handles privilege separation (no sudo needed)
- Automated setup via .deb/.rpm package
- Python bundled in package

Development Setup
-----------------

Prerequisites
~~~~~~~~~~~~~

* Debian 12+ / Ubuntu 22.04+
* Python 3.11+ (for development only)
* MariaDB or MySQL server
* Git
* Root or sudo access

Quick Start
~~~~~~~~~~~

1. **Clone Repository**

   .. code-block:: bash

      git clone https://github.com/mschot/dbcalm-open-backend.git
      cd dbcalm-open-backend

2. **Automated Setup**

   .. code-block:: bash

      make dev-install

   This script (``dev/install.sh``) automatically:

   * Creates ``dbcalm`` system user and group
   * Creates required directories (``/etc/dbcalm``, ``/var/lib/dbcalm``, ``/var/log/dbcalm``, ``/var/run/dbcalm``)
   * Sets up file permissions
   * Configures sudo access for your user (only for development)
   * Generates self-signed SSL certificates

3. **Python Environment**

   .. code-block:: bash

      python3.11 -m venv .venv
      source .venv/bin/activate
      pip install -e ".[dev]"

4. **Database Setup**

   Create MariaDB backup user:

   .. code-block:: sql

      CREATE USER 'backupuser'@'localhost' IDENTIFIED BY 's0m3p455w0rd';
      GRANT RELOAD, PROCESS, REPLICATION CLIENT ON *.* TO 'backupuser'@'localhost';
      FLUSH PRIVILEGES;

   Configure credentials:

   .. code-block:: bash

      sudo nano /etc/dbcalm/credentials.cnf

   .. code-block:: ini

      [client-dbcalm]
      user=backupuser
      password=s0m3p455w0rd

   Set permissions:

   .. code-block:: bash

      sudo chown mysql:dbcalm /etc/dbcalm/credentials.cnf
      sudo chmod 640 /etc/dbcalm/credentials.cnf

5. **Create First User**

   .. code-block:: bash

      python dbcalm.py users add

SSL Certificates (Development)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use mkcert for local development:

.. code-block:: bash

   # Install mkcert
   sudo apt install mkcert
   mkcert -install

   # Generate certificates
   sudo mkdir -p /etc/dbcalm/ssl
   mkcert -cert-file /tmp/fullchain-cert.pem \
          -key-file /tmp/private-key.pem \
          localhost 127.0.0.1

   sudo mv /tmp/fullchain-cert.pem /etc/dbcalm/ssl/
   sudo mv /tmp/private-key.pem /etc/dbcalm/ssl/
   sudo chown dbcalm:dbcalm /etc/dbcalm/ssl/*

Configure MariaDB Backup User
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: sql

   CREATE USER 'backupuser'@'localhost' IDENTIFIED BY 's0m3p455w0rd';
   GRANT RELOAD, PROCESS, REPLICATION CLIENT ON *.* TO 'backupuser'@'localhost';
   FLUSH PRIVILEGES;

Create ``/etc/dbcalm/credentials.cnf``:

.. code-block:: ini

   [client-dbcalm]
   user=backupuser
   password=s0m3p455w0rd

.. code-block:: bash

   sudo chown dbcalm:dbcalm /etc/dbcalm/credentials.cnf
   sudo chmod 600 /etc/dbcalm/credentials.cnf

Running the Development Server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The development environment runs two command services and the API server with auto-reload:

.. code-block:: bash

   make dev

This starts:

1. MariaDB command service (as mysql user)
2. Generic command service (as root)
3. API server with auto-reload (as dbcalm user)

Accept SSL Certificate
~~~~~~~~~~~~~~~~~~~~~~

Before you can access the API, you must accept the self-signed SSL certificate in your browser.

Open your browser and navigate to:

.. code-block:: text

   https://dbcalm.localhost:8335

You'll see a certificate warning:

1. Click **"Advanced"** (or **"Show Details"**)
2. Click **"Proceed to dbcalm.localhost"** (or **"Accept the Risk and Continue"**)

This is a required one-time step before you can use the API.

Access the API
~~~~~~~~~~~~~~

Now that you've accepted the certificate, access the API at: https://dbcalm.localhost:8335/docs

Project Structure
-----------------

.. code-block:: text

   backend/
   ├── dbcalm/                      # Main application package
   │   ├── api/                     # API models (request/response)
   │   ├── cli/                     # CLI commands (server, users, clients)
   │   ├── config/                  # Configuration management
   │   ├── domain/                  # Domain models and logic
   │   ├── errors/                  # Custom exceptions
   │   ├── logger/                  # Logging configuration
   │   ├── repository/              # Data access layer
   │   └── routes/                  # FastAPI route handlers
   ├── dbcalm_cmd/                  # Generic command service
   │   ├── adapter/                 # System command adapters
   │   ├── command/                 # Command validator
   │   └── process/                 # Process runner
   ├── dbcalm_cmd_client/           # Client library for cmd service
   ├── dbcalm_mariadb_cmd/          # MariaDB command service
   │   ├── adapter/                 # MariaDB-specific adapters
   │   ├── builder/                 # Command builders
   │   └── command/                 # Backup/restore validator
   ├── dbcalm_mariadb_cmd_client/   # Client library for MariaDB service
   ├── tests/                       # Test suite
   │   ├── unit/                    # Unit tests
   │   └── e2e/                     # End-to-end tests
   ├── dbcalm.py                    # Main CLI entry point
   ├── dbcalm-cmd.py                # Generic command service entry
   └── dbcalm-mariadb-cmd.py        # MariaDB command service entry

Architecture
------------

Components
~~~~~~~~~~

DBCalm consists of three separate programs:

* **dbcalm** - Main CLI and API server

  * Entry point: ``dbcalm.py``
  * Runs as: ``dbcalm`` user
  * Handles: HTTP requests, authentication, business logic
  * Communicates: Via Unix sockets to command services

* **dbcalm-mariadb-cmd** - MariaDB backup command service

  * Entry point: ``dbcalm-mariadb-cmd.py``
  * Runs as: ``mysql`` user
  * Handles: Mariabackup operations with MySQL data file access
  * Socket: ``/var/run/dbcalm/mariadb-cmd.sock``

* **dbcalm-cmd** - Generic system command service

  * Entry point: ``dbcalm-cmd.py``
  * Runs as: ``root`` user
  * Handles: Crontab management for backup schedules
  * Socket: ``/var/run/dbcalm/cmd.sock``

Privilege Separation
~~~~~~~~~~~~~~~~~~~~

The three programs communicate via Unix domain sockets with whitelist-based command validation.

Each service runs with the minimum privileges needed for its specific tasks:

* The API server runs as ``dbcalm`` and delegates privileged operations to the command services
* The MariaDB service runs as ``mysql`` to access database files
* The generic command service runs as ``root`` for crontab management

This separation ensures that even if the API server is compromised, attackers cannot directly execute system commands or access database files.

Repository Pattern
~~~~~~~~~~~~~~~~~~

The codebase follows the repository pattern:

* **Domain Models**: Business entities (Client, Backup, Schedule)
* **Repositories**: Data access abstraction (SQLModel/SQLite)
* **Adapters**: External system interfaces (mariabackup, systemctl)
* **Routes**: FastAPI endpoints connecting everything together

Development Commands
--------------------

Build & Run
~~~~~~~~~~~

.. code-block:: bash

   # Run API server
   python dbcalm.py server

   # Or use development mode with auto-reload
   make dev

User Management
~~~~~~~~~~~~~~~

.. code-block:: bash

   # Add user
   ./dbcalm.py users add

   # List users
   ./dbcalm.py users list

   # Delete user
   ./dbcalm.py users delete

   # Update password
   ./dbcalm.py users update-password

Client Management
~~~~~~~~~~~~~~~~~

.. code-block:: bash

   # Add client
   ./dbcalm.py clients add

   # List clients
   ./dbcalm.py clients list

   # Update client
   ./dbcalm.py clients update

   # Delete client
   ./dbcalm.py clients delete

Testing
~~~~~~~

.. code-block:: bash

   # Run all tests
   .venv/bin/python -m pytest tests/

   # Run unit tests only
   .venv/bin/python -m pytest tests/unit/

   # Run e2e tests only
   .venv/bin/python -m pytest tests/e2e/

Linting
~~~~~~~

.. code-block:: bash

   # Check for issues
   ruff check .

   # Auto-fix issues
   ruff check . --fix

Pre-commit Hook
~~~~~~~~~~~~~~~

The pre-commit hook automatically runs linting and tests. Install it:

.. code-block:: bash

   cp hooks/pre-commit .git/hooks/
   chmod +x .git/hooks/pre-commit

Building Binaries
~~~~~~~~~~~~~~~~~

.. code-block:: bash

   # Build all binaries
   pyinstaller dbcalm.py
   pyinstaller dbcalm-mariadb-cmd.py
   pyinstaller dbcalm-cmd.py

Code Style Guidelines
---------------------

General Principles
~~~~~~~~~~~~~~~~~~

* Python 3.11+ required
* Follow FastAPI framework conventions
* Use type hints throughout
* Domain-driven design with modular components

Imports
~~~~~~~

Group imports in this order:

1. Standard library
2. Third-party packages
3. Local modules

.. code-block:: python

   import os
   from pathlib import Path

   from fastapi import FastAPI
   from sqlmodel import Session

   from dbcalm.domain.client import Client

Naming Conventions
~~~~~~~~~~~~~~~~~~

* ``snake_case`` for functions and variables
* ``PascalCase`` for classes
* ``UPPER_CASE`` for constants

.. code-block:: python

   # Good
   def create_backup(client_id: int) -> Backup:
       pass

   class BackupRepository:
       pass

   MAX_RETRIES = 3

String Formatting
~~~~~~~~~~~~~~~~~

Use f-strings for string formatting and double quotes:

.. code-block:: python

   # Good
   message = f"Backup created for client {client_id}"

   # Avoid
   message = "Backup created for client %s" % client_id

Path Handling
~~~~~~~~~~~~~

Use ``pathlib.Path`` instead of ``os`` operations:

.. code-block:: python

   from pathlib import Path

   # Good
   config_path = Path("/etc/dbcalm/config.json")
   if config_path.exists():
       content = config_path.read_text()

   # Avoid
   import os
   if os.path.exists("/etc/dbcalm/config.json"):
       with open("/etc/dbcalm/config.json") as f:
           content = f.read()

Error Handling
~~~~~~~~~~~~~~

Use appropriate exceptions with descriptive messages:

.. code-block:: python

   from dbcalm.errors.validation_error import ValidationError

   if not client_id:
       raise ValidationError("Client ID is required")

Documentation
~~~~~~~~~~~~~

Use docstrings for public interfaces:

.. code-block:: python

   def create_backup(client_id: int, full: bool = True) -> Backup:
       """Create a new backup for the specified client.

       Args:
           client_id: The ID of the client to backup
           full: Whether to create a full backup (default: True)

       Returns:
           The created backup instance

       Raises:
           ValidationError: If client_id is invalid
       """
       pass

TODOs
~~~~~

Mark TODOs with ``noqa: FIX002``:

.. code-block:: python

   # TODO: Add support for incremental backups  # noqa: FIX002

Multiline Collections
~~~~~~~~~~~~~~~~~~~~~

Add comma after last item in multiline collections:

.. code-block:: python

   # Good
   dependencies = [
       "fastapi",
       "sqlmodel",
       "uvicorn",
   ]

Contributing
------------

Workflow
~~~~~~~~

1. Fork the repository
2. Create a feature branch: ``git checkout -b feature/my-feature``
3. Make your changes following code style guidelines
4. Run linter: ``ruff check . --fix``
5. Run tests: ``pytest tests/``
6. Commit your changes: ``git commit -m "Add my feature"``
7. Push to your fork: ``git push origin feature/my-feature``
8. Create a pull request

Pull Request Guidelines
~~~~~~~~~~~~~~~~~~~~~~~

* Write clear, descriptive commit messages
* Include tests for new features
* Update documentation as needed
* Ensure all tests pass and linter is clean
* Keep PRs focused on a single feature/fix

Getting Help
~~~~~~~~~~~~

* GitHub Issues: https://github.com/mschot/dbcalm-open-backend/issues
* Documentation: https://dbcalm.com/docs

