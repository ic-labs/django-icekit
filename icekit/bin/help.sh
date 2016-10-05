#!/bin/bash

set -e

cat <<EOF

Here is a list of frequently used commands you might want to run:

	bower-install.sh <DIR>
		Change to <DIR> and execute 'bower install', *if* 'bower.json' has been
		updated since the last time it was run.

	celery.sh
		Start Celery. This is normally managed by Docker or Supervisord, and is
		not normally used interactively.

	celerybeat.sh
		Start Celery Beat. This is normally managed by Docker or Supervisord,
		and is not normally used interactively.

	celeryflower.sh
		Start Celery Flower. This is normally managed by Docker or Supervisord,
		and is not normally used interactively.

	gunicorn.sh
		Start Gunicorn. This is normally managed by Docker or Supervisord, and
		is not normally used interactively.

	manage.py [COMMAND [ARGS]]
		Run a Django management command.

	migrate.sh
		Apply Django migrations, *if* the migrations on disk have been updated
		since the last time it was run.

	nginx.sh
		Start Nginx. This is normally managed by Docker or Supervisord, and is
		not normally used interactively.

	npm-install.sh <DIR>
		Change to <DIR> and execute 'npm install', *if* 'package.json' has been
		updated since the last time it was run.

	pip-install.sh <DIR>
		Change to <DIR> and execute 'pip install', *if* 'requirements.txt' or
		'requirements-local.txt' have been updated since the last time it was
		run.

	runserver.sh [ARGS]
		Start the Django development server.

	runtests.sh [ARGS]
		Configure the environment and run the Django 'test' management command.

		This will drop and recreate the test database and re-run the Django
		'collectstatic' and 'compress' management commands for consistency.

		Set 'QUICK=1' to reuse the test database and collected static and
		compressed files.

			# QUICK=1 runtests.sh

	setup-django.sh [COMMAND]
		Install Node modules, Bower components and Python requirements, create
		a database, apply Django migrations, and execute a command.

	setup-git-secret.sh [COMMAND]
		Initialise git-secret, generate a GPG encryption key, configure
		git-secret, decrypt all known secrets, and execute a command.

		Quick start:

			$ git secret add file  # Add 'file' as a secret to be encrypted
			$ git secret hide      # Encrypt all secrets
			$ git secret reveal    # Decrypt all secrets

		It is recommended to add 'git secret hide' to your pre-commit hook, so
		you won't miss any changes.

		For more information, see: http://sobolevn.github.io/git-secret/

	setup-postgres.sh
		Create a PostgreSQL database with a name derived from the current Git
		branch and project directory.

		Seed the new database it with data from the 'SRC_PG*' environment
		variables, if defined.

		Drop and recreate the database if 'SETUP_POSTGRES_FORCE' is defined.

	supervisorctl.sh [OPTIONS] [ACTION [ARGS]]
		Run 'supervisorctl'. When using Docker, use this to manage Gunicorn and
		Nginx. When not using Docker, it also manages Celery, Celery Beat and
		Celery Flower.

	supervisord.sh [ARGS]
		Start Supervisord. This is normally managed by Docker, and is usually
		only used interactively when not using Docker.

	transfer.sh
		Encrypt and upload a file to https://transfer.sh

EOF
