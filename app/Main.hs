{-# LANGUAGE OverloadedStrings #-}

module Main (
    main,
) where

import Data.Pool (defaultPoolConfig, newPool)
import Data.Proxy (Proxy (..))
import Data.Text ()

-- db imports
import Database.PostgreSQL.Simple (close, connectPostgreSQL)
import Database.Redis qualified as R

-- service imports
import Network.Wai.Handler.Warp (run)
import Servant (hoistServer, serve)

-- custom imports
import API.Api (MLServiceAPI, server)
import API.App (AppState (..), runApp)

api :: Proxy MLServiceAPI
api = Proxy

main :: IO ()
main = do
    -- connect Redis
    redisConn <- R.checkedConnect R.defaultConnectInfo

    -- connect PostgreSQL
    let connStr = "host=localhost dbname=mldb user=postgres password=secret"
    let poolConfig = defaultPoolConfig (connectPostgreSQL connStr) close 10 10
    pgPool <- newPool poolConfig

    -- create state for application
    let config =
            AppState
                { redisConn = redisConn
                , pgPool = pgPool
                , queueName = "default"
                }

    putStrLn "Starting ML Service on 9000..."
    run 9000 $ serve api (hoistServer api (runApp config) server)
