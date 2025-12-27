{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

module Types where

import Data.Aeson (FromJSON, ToJSON)
import Data.Text (Text)
import Data.Time (UTCTime)
import GHC.Generics (Generic)
import Database.PostgreSQL.Simple.FromRow (FromRow, fromRow, field)

newtype JobId = JobId { getJobId :: Text }
  deriving stock (Show, Generic)
  deriving anyclass (FromJSON, ToJSON)

data JobStatus
  = Queued
  | Processing
  | Completed
  | Failed Text
  deriving stock (Show, Generic)
  deriving anyclass (FromJSON, ToJSON)