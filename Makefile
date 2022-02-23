DIR = $(shell pwd)
.PHONY: postgres createdb dropdb migrateup migratedown sqlc test server mock migrateup1 migratedown1

postgres:
	docker run --name postgres -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres

createdb:
	docker exec -i postgres createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -i postgres dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down -all 

migrateup1:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up 1

migratedown1:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down 1 


sqlc: 
	docker run --rm -v ${DIR}:/src -w /src kjconroy/sqlc generate

test:
	go test -v -cover ./...

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/maslow123/simplebank/db/sqlc Store

server:
	go run main.go

createsql:
	migrate create -ext sql -dir db/migration -seq $(FILENAME)