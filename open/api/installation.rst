Installation
============

This guide covers installing DBCalm from pre-built packages on supported Linux distributions.

Prerequisites
-------------

* MariaDB or MySQL server installed and running
* Root or sudo access
* Debian 12+
* Ubuntu 22.04+

Debian/Ubuntu Installation
---------------------------

Download and Install Package
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Download the latest Debian package:

.. code-block:: bash

   wget https://github.com/mschot/dbcalm-open-backend/releases/latest/download/dbcalm_amd64.deb

Install the package:

.. code-block:: bash

   sudo apt install ./dbcalm_amd64.deb 

RHEL/CentOS/Rocky/Fedora Installation
--------------------------------------

.. note::
   RPM packages will be available in a future release.

Download and Install Package
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Download the latest RPM package:

.. code-block:: bash

   wget https://github.com/mschot/dbcalm-open-backend/releases/latest/download/dbcalm.x86_64.rpm

Install on RHEL/CentOS 7:

.. code-block:: bash

   sudo yum install dbcalm.x86_64.rpm

Install on RHEL/CentOS 8+, Rocky Linux, or Fedora:

.. code-block:: bash

   sudo dnf install dbcalm.x86_64.rpm

What Gets Installed
-------------------

The package automatically sets up:

* **System User**: Creates ``dbcalm`` user and group
* **Binaries**: Installs to ``/usr/bin/``

  * ``dbcalm`` - Main CLI and API server
  * ``dbcalm-cmd`` - Generic command service
  * ``dbcalm-mariadb-cmd`` - MariaDB backup command service

* **Directories**:

  * ``/etc/dbcalm/`` - Configuration files
  * ``/var/lib/dbcalm/`` - Database and backup storage
  * ``/var/log/dbcalm/`` - Log files

* **Systemd Services**:

  * ``dbcalm-api`` - Main API server
  * ``dbcalm-cmd`` - Command service for crontab management (runs as root)
  * ``dbcalm-mariadb-cmd`` - MariaDB command service (runs as mysql user)

* **Security**:

  * Generates self-signed SSL certificate for development
  * Generates JWT secret key
  * Creates template credentials file

Post-Installation Setup
-----------------------

Step 1: Create MariaDB Backup User
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

DBCalm needs a MySQL user with backup privileges. Connect to MySQL with a user that has permissions to create other users:

.. code-block:: bash

   sudo mysql

Create the backup user:

.. code-block:: sql

   CREATE USER 'backupuser'@'localhost' IDENTIFIED BY 'your_secure_password';
   GRANT RELOAD, PROCESS, REPLICATION CLIENT ON *.* TO 'backupuser'@'localhost';
   FLUSH PRIVILEGES;
   EXIT;

.. warning::
   Replace ``your_secure_password`` with a strong, unique password!

Step 2: Configure Database Credentials
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Edit the credentials file:

.. code-block:: bash

   sudo nano /etc/dbcalm/credentials.cnf

Update the password (change ``changeme`` to your actual password):

.. code-block:: ini

   [client-dbcalm]
   user=backupuser
   password=your_secure_password
   host=localhost

Step 3: Create First Admin User
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Create an admin user for accessing the API:

.. code-block:: bash

   sudo dbcalm users add <username>

Replace ``<username>`` with your desired username. You will be prompted to set a password.

Step 4: Start Services
~~~~~~~~~~~~~~~~~~~~~~

Start the API server:

.. code-block:: bash

   sudo systemctl start dbcalm-api

The command services (``dbcalm-cmd`` and ``dbcalm-mariadb-cmd``) start automatically as dependencies.

Verify Installation
-------------------

Check Services Status
~~~~~~~~~~~~~~~~~~~~~

Verify all services are running:

.. code-block:: bash

   sudo systemctl status dbcalm-api
   sudo systemctl status dbcalm-cmd
   sudo systemctl status dbcalm-mariadb-cmd

Check Logs
~~~~~~~~~~

If services aren't running, check the logs:

.. code-block:: bash

   sudo journalctl -u dbcalm-api -n 50
   sudo tail -f /var/log/dbcalm/dbcalm.log

Accept SSL Certificate
~~~~~~~~~~~~~~~~~~~~~~

Before you can access the API, you must accept the self-signed SSL certificate in your browser.

Open your browser and navigate to:

.. code-block:: text

   https://dbcalm.localhost:8335

You'll see a certificate warning. This is expected because the API uses a self-signed certificate:

1. Click **"Advanced"** (or **"Show Details"** depending on your browser)
2. Click **"Proceed to dbcalm.localhost"** (or **"Accept the Risk and Continue"**)

.. important::
   This is a required one-time step for development setups. You must accept the certificate before you can use the API.
   For production use, configure valid SSL certificates to avoid this requirement. See the Configuration Guide for details.

Access API Documentation
~~~~~~~~~~~~~~~~~~~~~~~~

Now that you've accepted the certificate, you can access the API documentation:

.. code-block:: text

   https://dbcalm.localhost:8335/docs

Next Steps
----------

Your DBCalm installation is now complete!

* See :doc:`configuration` for production SSL setup, CORS configuration, and customization
* See :doc:`api-specification` for using the API
* See :doc:`developer-guide` if you want to contribute or build from source
