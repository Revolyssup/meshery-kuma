check:
	golangci-lint run

check-clean-cache:
	golangci-lint cache clean

docker: check
	docker build -t layer5/meshery-kuma .

docker-run:
	(docker rm -f meshery-kuma) || true
	docker run --name meshery-kuma -d \
	-p 10007:10007 \
	-e DEBUG=true \
	layer5/meshery-kuma

run: check
	go mod tidy; \
	DEBUG=true go run main.go

run-force-dynamic-reg:
	FORCE_DYNAMIC_REG=true DEBUG=true GOPROXY=direct GOSUMDB=off go run main.go

error:
	go run github.com/layer5io/meshkit/cmd/errorutil -d . analyze -i ./helpers -o ./helpers
