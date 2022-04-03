start:
	docker-compose up -d && docker-compose exec app bash 

debug:
	iex -S mix phx.server

run:
	mix phx.server

	