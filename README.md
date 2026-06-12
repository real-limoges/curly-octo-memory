# hs-prediction-service

A small k-nearest-neighbor prediction service over HTTP, written in Haskell.

It exposes a single endpoint that classifies an incoming feature vector against
a user's stored history, then enqueues the result for downstream processing.

- **API / Web** — [Servant](https://hackage.haskell.org/package/servant) + [Warp](https://hackage.haskell.org/package/warp)
- **History store** — Postgres (via `postgresql-simple`)
- **Result queue** — Redis (via `hedis`)
- **Core** — nearest-neighbor by Euclidean distance (`src/Core.hs`)

## Layout

| Path              | Purpose                                          |
| ----------------- | ------------------------------------------------ |
| `app/Main.hs`     | Entry point; starts the Warp server.             |
| `src/API.hs`      | `PredictAPI` route type.                         |
| `src/Server.hs`   | Request handler, DB/Redis wiring.                |
| `src/Repository.hs` | Postgres queries (user history).               |
| `src/Core.hs`     | Pure prediction logic.                           |
| `src/Types.hs`    | Request/response types.                          |
| `test/Spec.hs`    | Tests for the core prediction logic.             |

## Configuration

Connection settings are read from the environment (see `.env`):

| Variable  | Default     | Description           |
| --------- | ----------- | --------------------- |
| `DB_HOST` | `localhost` | Postgres host         |
| `DB_NAME` | `mydb`      | Postgres database     |
| `DB_USER` | `postgres`  | Postgres user         |
| `DB_PASS` | `password`  | Postgres password     |
| `PORT`    | `8080`      | HTTP port to listen on |

## Run

```sh
cabal build
cabal test
cabal run hs-prediction-service-exe
```

## Example

```sh
curl -X POST http://localhost:8080/predict \
  -H 'Content-Type: application/json' \
  -d '{"userId": "u123", "features": [1.0, 2.0, 3.0]}'
```
