module Types where

import Data.Aeson (FromJSON, ToJSON)
import Data.ByteString.Char8 qualified as B
import Data.Text qualified as T
import Data.Time (UTCTime)
import Database.PostgreSQL.Simple.FromField (FromField (..), fromField, returnError)
import Database.PostgreSQL.Simple.FromRow (FromRow (..), field)
import Database.PostgreSQL.Simple.ToField (Action (Escape), ToField (..))
import GHC.Generics (Generic)

newtype JobId = JobId {getJobId :: T.Text}
    deriving stock (Show, Eq, Generic)
    deriving newtype (FromJSON, ToJSON, ToField, FromField)

data JobStatus
    = Queued
    | Processing
    | Completed
    | Failed !T.Text
    deriving stock (Show, Eq, Generic)
    deriving anyclass (FromJSON, ToJSON)

instance FromField JobStatus where
    fromField f mdata = do
        status <- fromField f mdata
        case status :: T.Text of
            "Queued" -> return Queued
            "Processing" -> return Processing
            "Completed" -> return Completed
            other ->
                return (Failed other)

instance ToField JobStatus where
    toField Queued = Escape "Queued"
    toField Processing = Escape "Processing"
    toField Completed = Escape "Completed"
    toField (Failed msg) = Escape (B.pack $ T.unpack msg)

data JobType = ModelAType | ModelBType
    deriving stock (Show, Eq, Generic)
    deriving anyclass (FromJSON, ToJSON)

-- This is for sending stuff over to a Redis Queue
data ValidatedMLPayload = ValidatedMLPayload
    { vJobType :: JobType
    , vModelParams :: [String]
    }
    deriving stock (Show, Eq, Generic)
    deriving anyclass (FromJSON, ToJSON)

data JobStatusTicket = JobStatusTicket
    { dbJobId :: T.Text
    , dbStatus :: T.Text
    , dbCreatedAt :: UTCTime
    }
    deriving stock (Show, Generic)

instance FromRow JobStatusTicket where
    fromRow = JobStatusTicket <$> field <*> field <*> field
