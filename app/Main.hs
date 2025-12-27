module Main where

import Data.Pool (Pool, createPool)
import Data.Proxy (Proxy (..))
import Data.Text (Text)

-- db imports
import Database.PostgreSQL.Simple (close, connectPostgreSQL)
import Database.PostgreSQL.Simple qualified as PG
import Database.Redis (Connection, connect, defaultConnectInfo)

-- service imports
import Network.Wai.Handler.Warp (run)
import Servant (Proxy (..), hoistServer, serve)

-- custom imports
import Api (MLServiceAPI)
import App (AppConfig (..), runApp)
import Handlers (server)

api :: Proxy MLServiceAPI
api = Proxy

main :: IO ()
main = do
    -- connect Redis
    redisConn <- connect defaultConnectInfo

    -- connect PostgreSQL
    let connStr = "hdost=localhost dbname=mldb user=postgres password=secret"
    pgPool <- createPool (PG.connectPostgreSQL connStr) PG.close 1 10 10

    -- create state for application
    let config =
            AppConfig
                { redisConn = redisConn
                , pgPool = pgPool
                , queueName = "default"
                }

    putStrLn "Starting ML Service on 9000..."
    run 9000 $ serve api (hoistServer api (runApp config) server)
