package main

import (
	"database/sql"
	"log"

	_ "github.com/lib/pq"
	"github.com/maslow123/simplebank/api"
	db "github.com/maslow123/simplebank/db/sqlc"
	"github.com/maslow123/simplebank/util"
)

func main() {
	config, err := util.LoadConfig(".")
	if err != nil {
		log.Fatal("cannot load config", err)
	}

	conn, err := sql.Open(config.DBDriver, config.DBSource)
	if err != nil {
		log.Fatal("Cannot connect to db: ", err)
	}

	store := db.NewStore(conn)
	server, err := api.NewServer(config, store)
	if err != nil {
		log.Fatalf("cannot create server: ", err)
	}

	log.Println(config.ServerAddress)
	err = server.Start(config.ServerAddress)
	if err != nil {
		log.Fatal("Cannot start server: ", err)
	}
}
