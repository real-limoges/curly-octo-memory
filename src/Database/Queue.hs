module Database.Queue where

import API.App (AppM, AppState (..), runRedis)
import Control.Monad (void)
import Control.Monad.Reader (asks, liftIO)
import Data.Aeson (FromJSON, ToJSON, encode)
import Data.ByteString.Lazy qualified as LBS
import Data.Text.Encoding (encodeUtf8)
import Data.UUID (toText)
import Data.UUID.V4 (nextRandom)
import Database.Redis qualified as R
import GHC.Generics (Generic)
import Types

data JobEnvelope = JobEnvelope
    { jeJobId :: JobId
    , jePayload :: ValidatedMLPayload
    }
    deriving stock (Show, Generic)
    deriving anyclass (FromJSON, ToJSON)

enqueueJob :: ValidatedMLPayload -> AppM JobId
enqueueJob payload = do
    uuid <- liftIO nextRandom
    let jid = JobId (toText uuid)

    let envelope =
            JobEnvelope
                { jeJobId = jid
                , jePayload = payload
                }

    qName <- Control.Monad.Reader.asks queueName
    let jsonPayload = LBS.toStrict $ encode payload

    runRedis $ do
        void $ R.rpush (encodeUtf8 qName) [jsonPayload]

    return jid
