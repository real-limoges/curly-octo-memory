{-# LANGUAGE OverloadedStrings #-}

module Server (app) where

import Database.PostgreSQL.Simple.Types (PGArray(..))
import Data.Aeson (encode)
import Servant
import Control.Monad.IO.Class (liftIO)
import qualified Data.Vector.Storable as V
import Network.Wai (Application)

import qualified Database.Redis as R
import qualified Database.PostgreSQL.Simple as PG
import qualified Data.ByteString.Lazy as BL

import Types
import API
import Core

fetchUserHistory :: Int -> IO [(String, MathVector)]
fetchUserHistory uid = do
  conn <- PG.connectPostgreSQL "host=localhost dbname=mydb user=postgres password=password"

  rows <- PG.query conn "SELECT feature_array FROM user_features WHERE user_id = ?" (PG.Only uid)

  let labeledRows = map (\(PG.Only (PGArray vec)) -> ("HistoryPoint", V.fromList vec)) rows

  return labeledRows


predictHandler :: Payload -> Handler TaskResult
predictHandler payload = liftIO $ do
  history <- fetchUserHistory (userId payload)

  let inputVec = V.fromList (features payload)
  let result   = predict inputVec history

  redisConn <- R.connect R.defaultConnectInfo

  R.runRedis redisConn $ do
    R.rpush "tasks" [BL.toStrict (encode result)]

  return result


server :: Server MyAPI
server = predictHandler

api :: Proxy MyAPI
api = Proxy

app :: Application
app = serve api server
