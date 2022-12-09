FROM ubuntu:18.04

CMD ["bash", "c"]

ENV PYENV_ROOT="/root/.pyenv" \
	PATH="/root/.pyenv/shims:/root/.pyenv/bin:${PATH}" \
	PIPENV_YES=1 \
	PIPENV_DONT_LOAD_ENV=1 \
	LC_ALL="C.UTF-8" \
	LANG="en_US.UTF-8"
RUN apt-get update && apt-get install -yq \
  build-essential git libreadline-dev zlib1g-dev libssl-dev libbz2-dev libsqlite3-dev libffi-dev jq curl \
  && curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash \
  && pyenv install 3.11.0 && pyenv global 3.11.0 && pyenv rehash && pip install --upgrade pip

# Embedded docker
RUN apt-get update && apt-get install -yq curl \
  apt-transport-https ca-certificates software-properties-common \
  && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
  && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" \
  && apt update && apt-cache policy docker-ce \
  && apt install -yq --no-install-recommends docker-ce \
  && apt-get install docker-compose-plugin && echo 'alias docker-compose="docker compose"' >> ~/.bashrc

RUN apt-get update && apt-get install -yq net-tools netcat iputils-ping

# An editor
RUN apt-get update && apt-get install -yq vim

# Just
RUN curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/bin

# Sys-wide python libs
ADD requirements.txt /tmp/requirements.txt
RUN cd /tmp && pip install -r requirements.txt
#RUN cd /tmp && if [ ! -f /tmp/.venv ]; then pip install -r requirements.txt; else eval "$(pyenv init -)" && pyenv activate $(cat /tmp/.venv) && pip install -r requirements.txt; fi

env COMPOSE_COMPATIBILITY=true

RUN mkdir /project
WORKDIR /project
