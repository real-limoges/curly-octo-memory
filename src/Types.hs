{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}

module Types where

import Data.Aeson (FromJSON, ToJSON)
import Data.Text (Text)
import Data.Time (UTCTime)
import Database.PostgreSQL.Simple.FromRow (FromRow, field, fromRow)
import GHC.Generics (Generic)

newtype JobId = JobId {getJobId :: Text}
    deriving stock (Show, Generic)
    deriving anyclass (FromJSON, ToJSON)

data JobStatus
    = Queued
    | Processing
    | Completed
    | Failed Text
    deriving stock (Show, Generic)
    deriving anyclass (FromJSON, ToJSON)
