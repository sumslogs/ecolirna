# Decorator to prevent running outside-container commands within container on accident.
_outsidecontainer:
	#!/bin/bash
	set -e
	if [ -f /.dockerenv ]; then
		echo "That command is only for running outside docker!";
		exit 1
	fi

# Decorator to prevent running inside-container commands outside on accident.
_insidecontainer:
	#!/bin/bash
	set -e
	if [ ! -f /.dockerenv ]; then
		echo "That command is only for running inside docker!";
		exit 1
	fi

###
### Dev container setup
###
# Docker-compose build
devdown: _outsidecontainer
	#!/bin/bash
	set -e
	source ./config/environment
	docker-compose rm

# Docker-compose up
devup: _outsidecontainer
	#!/bin/bash
	set -e
	source ./config/environment
	docker-compose up --remove-orphans

# Interactive bash shell in running container
devbash container='base': 
	#!/bin/bash
	set -e
	source ./config/environment
	if ! command -v docker-compose &> /dev/null; then
	  echo "?"
	  docker compose exec {{container}} bash
	else
	  docker-compose exec {{container}} bash
	fi
	
devcomponent container='base': 
	#!/bin/bash
	set -e
	source ./config/environment
	if ! command -v docker-compose &> /dev/null; then
	  echo "?"
	  docker compose run {{container}} bash
	else
	  docker-compose run {{container}} bash
	fi

# Docker-compose build
buildbase +params='': _outsidecontainer
	#!/bin/bash
	set -e
	source ./config/environment
	docker build  {{params}}

# Docker-compose build
devbuild +params='':
	#!/bin/bash
	set -e
	source ./config/environment
	if ! command -v docker-compose &> /dev/null; then
	  echo "?"
	  docker compose build {{params}}
	else
	  docker-compose build {{params}}
	fi

# Install python dev requirements
piprequirements: _insidecontainer
	#!/bin/bash
	set -e
	source ./config/environment
	pip install pip --upgrade
	pip install -r requirements.txt

##
## Misc
##

# Prints the docker-host IP
dockerhostip: _insidecontainer
	@/sbin/ip route | awk '/default/ { print $3 }'

# Prints python that lets you inject a remote breakpoint. You can pass port=<porthere>.
makebreakpoint port="port=133337": _insidecontainer
	#!/bin/bash
	HOSTIP=`just dockerhostip`
	echo "import pydevd; pydevd.settrace('"$HOSTIP"', {{port}}, stdoutToServer=True, stderrToServer=True)"


