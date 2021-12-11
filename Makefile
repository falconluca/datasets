.PHONY: init
init:
	#jq

.PHONY: clean
clean:
	#jq

.PHONY: local-deploy
local-deploy:
	#./main.sh

.PHONY: docker-build
docker-build:
	docker build -t shaohsiung/OwDataset:latest -f .

.PHONY: docker-push
docker-push:
	docker push shaohsiung/OwDataset:latest

.PHONY: docker-run
docker-deploy:
	#docker run ...
