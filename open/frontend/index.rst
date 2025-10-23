Frontend Documentation
======================

The DBCalm frontend is a modern web application for managing database backups, built with React, TypeScript, and Vite.

Overview
--------

The frontend provides a web-based interface for:

* **Dashboard**: Monitor backup status across all your database servers
* **Client Management**: Add and configure database clients
* **Backup Scheduling**: Create and manage backup schedules with cron expressions
* **Restore Operations**: Point-in-time restore functionality
* **Process Monitoring**: Real-time tracking of backup and restore operations
* **User Authentication**: Secure login and session management

Technology Stack
----------------

* **React 19**: Modern UI library
* **TypeScript**: Type-safe development
* **Vite**: Fast build tool with Hot Module Replacement (HMR)
* **React Router**: Client-side routing
* **Tailwind CSS 4**: Utility-first styling framework
* **DaisyUI**: Component library for Tailwind
* **date-fns**: Date manipulation and formatting

Prerequisites
-------------

* Node.js 18 or higher
* npm (comes with Node.js)
* Running DBCalm backend API

Installation
------------

1. Clone the repository:

.. code-block:: bash

   cd frontend
   npm install

2. Create a ``.env`` file in the frontend directory:

.. code-block:: bash

   VITE_API_URL=https://dbcalm.localhost:8335

   # For production, use your actual API URL:
   # VITE_API_URL=https://api.yourdomain.com

Local Development
-----------------

Start the development server:

.. code-block:: bash

   npm run dev

   # Or using Make:
   make dev

The application will be available at ``http://localhost:5173`` with hot module replacement enabled.

Development Features:

* **Hot Module Replacement**: Changes reflect instantly without full page reload
* **TypeScript**: Type checking and IntelliSense support
* **ESLint**: Code quality checking with ``npm run lint``
* **Fast Refresh**: React components reload while preserving state

Project Structure
-----------------

.. code-block:: text

   frontend/
   ├── src/
   │   ├── pages/              # Page components
   │   │   ├── Dashboard.tsx   # Main dashboard
   │   │   ├── Clients.tsx     # Client list
   │   │   ├── AddClient.tsx   # Add new client
   │   │   ├── Schedules.tsx   # Backup schedules
   │   │   ├── ScheduleForm.tsx # Create/edit schedule
   │   │   ├── Restores.tsx    # Restore operations
   │   │   ├── Processes.tsx   # Process monitoring
   │   │   └── Login.tsx       # Authentication
   │   ├── components/         # Reusable components
   │   │   ├── Header.tsx
   │   │   ├── Pagination.tsx
   │   │   ├── Toast.tsx
   │   │   └── ...
   │   ├── hooks/              # Custom React hooks
   │   ├── contexts/           # React context providers
   │   ├── actions/            # API integration layer
   │   ├── types/              # TypeScript type definitions
   │   └── utils/              # Utility functions
   ├── public/                 # Static assets
   ├── .env                    # Environment configuration
   ├── package.json            # Dependencies
   ├── vite.config.ts          # Vite configuration
   ├── tailwind.config.js      # Tailwind configuration
   └── tsconfig.json           # TypeScript configuration

Building for Production
-----------------------

Build the application:

.. code-block:: bash

   npm run build

This creates an optimized production build in the ``dist/`` directory:

* Minified JavaScript and CSS
* Code splitting for optimal loading
* Optimized assets and images
* Source maps for debugging

Preview the production build locally:

.. code-block:: bash

   npm run preview

The preview server runs at ``http://localhost:4173``.

Build Output
~~~~~~~~~~~~

The ``dist/`` directory contains:

* ``index.html`` - Main HTML file
* ``assets/`` - JavaScript, CSS, and other assets
  * ``*.js`` - Bundled JavaScript with content hashes
  * ``*.css`` - Compiled Tailwind CSS
  * Images and fonts

Deployment
----------

Static File Hosting
~~~~~~~~~~~~~~~~~~~

The built application is a static site that can be hosted on any web server or CDN:

1. **Build the application**:

   .. code-block:: bash

      npm run build

2. **Deploy the** ``dist/`` **directory** to your hosting provider:

   * **Nginx**: Serve from ``dist/`` directory
   * **Apache**: Serve from ``dist/`` directory
   * **CDN**: Upload ``dist/`` contents (Cloudflare, AWS S3 + CloudFront, etc.)

3. **Configure environment variables** for production by updating ``.env`` before building:

   .. code-block:: bash

      VITE_API_URL=https://api.yourdomain.com

Single Page Application Routing
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The application uses client-side routing. Configure your web server to redirect all requests to ``index.html``:

**Nginx**:

.. code-block:: nginx

   location / {
       try_files $uri $uri/ /index.html;
   }

**Apache** (``.htaccess``):

.. code-block:: apache

   RewriteEngine On
   RewriteBase /
   RewriteRule ^index\.html$ - [L]
   RewriteCond %{REQUEST_FILENAME} !-f
   RewriteCond %{REQUEST_FILENAME} !-d
   RewriteRule . /index.html [L]

API Configuration
~~~~~~~~~~~~~~~~~

The frontend requires a running DBCalm backend API. Ensure:

1. Backend API is accessible at the URL specified in ``VITE_API_URL``
2. CORS is properly configured on the backend to accept requests from your frontend domain
3. SSL certificate is valid if using HTTPS (recommended)

Development Guidelines
----------------------

Adding New Pages
~~~~~~~~~~~~~~~~

1. Create a new component in ``src/pages/``
2. Add routing in ``src/App.tsx``
3. Add navigation links in ``src/components/Header.tsx``

TypeScript Types
~~~~~~~~~~~~~~~~

Define types in ``src/types/`` for:

* API request/response models
* Component props
* State management interfaces

API Integration
~~~~~~~~~~~~~~~

Use the actions pattern in ``src/actions/``:

.. code-block:: typescript

   // src/actions/clients.ts
   export async function fetchClients() {
       const response = await fetch(`${import.meta.env.VITE_API_URL}/clients`);
       return response.json();
   }

Styling
~~~~~~~

Use Tailwind CSS utility classes:

.. code-block:: tsx

   <div className="bg-white p-4 rounded-lg shadow">
       <h1 className="text-2xl font-bold">Title</h1>
   </div>

DaisyUI provides pre-styled components:

.. code-block:: tsx

   <button className="btn btn-primary">Click me</button>

Theme Support
~~~~~~~~~~~~~

The application supports light and dark themes via DaisyUI. Themes are configured in ``tailwind.config.js``.

Troubleshooting
---------------

Build Errors
~~~~~~~~~~~~

If TypeScript errors occur during build:

.. code-block:: bash

   # Check TypeScript errors
   npx tsc --noEmit

   # Fix linting issues
   npm run lint -- --fix

API Connection Issues
~~~~~~~~~~~~~~~~~~~~~

If the frontend can't connect to the backend:

1. Verify ``VITE_API_URL`` in ``.env``
2. Check backend API is running
3. Verify CORS configuration on backend
4. Check browser console for errors

SSL Certificate Errors
~~~~~~~~~~~~~~~~~~~~~~

For local development with HTTPS backend:

1. Accept the self-signed certificate in your browser
2. Or configure backend with trusted certificates using mkcert

Port Conflicts
~~~~~~~~~~~~~~

If port 5173 is in use:

.. code-block:: bash

   # Vite will automatically try the next available port
   npm run dev

   # Or specify a port in vite.config.ts:
   server: { port: 3000 }

Dependencies
~~~~~~~~~~~~

Update dependencies:

.. code-block:: bash

   npm update

   # Check for outdated packages
   npm outdated

Related Documentation
---------------------

* :doc:`../api/index` - Backend API documentation
* :doc:`../api/installation` - Backend installation guide
* :doc:`../api/configuration` - Backend configuration
