.PHONY: run run-rehearsal deploy
run:
	ansible-playbook -i hosts site.yml

run-rehearsal:
	ansible-playbook -i hosts rehearsal.yml

deploy:
	ansible-playbook -i hosts deployment.yml

stop-monitoring:
	ansible-playbook -i hosts stop-monitoring.yml
