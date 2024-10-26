.PHONY: run run-rehearsal deploy
run:
	ansible-playbook -i hosts site.yml

run-rehearsal:
	ansible-playbook -i hosts rehearsal.yml

B ?= main
deploy:
	ansible-playbook -i hosts deployment.yml --extra-vars "branch=$(B)"

stop-monitoring:
	ansible-playbook -i hosts stop-monitoring.yml

start-monitoring:
	ansible-playbook -i hosts start-monitoring.yml
