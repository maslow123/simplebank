DIR = $(shell pwd)
.PHONY: postgres createdb dropdb migrateup migratedown sqlc test

postgres:
	docker run --name postgres -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres

createdb:
	docker exec -i postgres createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -i postgres dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

sqlc: 
	docker run --rm -v ${DIR}:/src -w /src kjconroy/sqlc generate

test:
	go test -v -cover ./...