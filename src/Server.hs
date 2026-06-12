{-# LANGUAGE OverloadedStrings #-}

module Server (app) where

import API
import Configuration.Dotenv (defaultConfig, loadFile)
import Control.Monad.IO.Class (liftIO)
import Core
import Data.Aeson (encode)
import Data.ByteString.Lazy qualified as BL
import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Vector.Storable qualified as V
import Database.PostgreSQL.Simple qualified as PG
import Database.Redis qualified as R
import Repository (fetchUserHistory)
import Servant
import System.Environment (getEnv)
import Types

getConn :: IO PG.Connection
getConn = do
  loadFile defaultConfig
  host <- getEnv "DB_HOST"
  db <- getEnv "DB_NAME"
  user <- getEnv "DB_USER"
  pass <- getEnv "DB_PASS"

  let connInfo =
        PG.defaultConnectInfo
          { PG.connectHost = host,
            PG.connectDatabase = db,
            PG.connectUser = user,
            PG.connectPassword = pass
          }
  PG.connect connInfo

predictHandler :: Payload -> Handler TaskResult
predictHandler payload = liftIO $ do
  conn <- getConn
  history <- fetchUserHistory conn (userId payload)

  let inputVec = V.fromList (features payload)
  let result = predict inputVec history

  redisConn <- R.connect R.defaultConnectInfo

  _ <- R.runRedis redisConn $ do
    R.rpush "tasks" (BL.toStrict (encode result) :| [])

  return result

server :: Server PredictAPI
server = predictHandler

api :: Proxy PredictAPI
api = Proxy

app :: Application
app = serve api server
