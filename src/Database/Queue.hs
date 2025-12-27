module Database.Queue where

import App
import Control.Monad.IO.Class (liftIO)
import Control.Monad.Reader (ask)
import Data.Aeson (encode)
import Data.ByteString.Lazy qualified as BL
import Data.Text.Encoding qualified as TE
import Data.UUID qualified as UUID
import Data.UUID.V4 qualified as UUID
import Database.Redis (rpush, runRedis)
import Types

pushToQueue :: ValidatedMLPayload
pushToQueue payload = do
