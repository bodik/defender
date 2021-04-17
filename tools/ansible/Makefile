all: lint

install-deps:
	apt-get -y install git make python3-venv shellcheck

venv:
	python3 -m venv venv
	(. venv/bin/activate; pip install -r requirements.txt)

lint: lint-yaml lint-ansible

lint-yaml:
	yamllint --strict .

lint-ansible:
	ansible-lint -v playbooks/*
	ansible-lint -v roles/*

lint-sh:
	find . -name '*.sh' -exec shellcheck {} \;

lint-py:
	find . -name '*.py' ! -path '*/venv/*' ! -path '*/data/*' -exec python3 -m flake8 {} \;
	find . -name '*.py' ! -path '*/venv/*' ! -path '*/data/*' -exec python3 -m pylint {} \;

ping:
	ansible -m ping all
