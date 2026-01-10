{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DuplicateRecordFields #-}

module API.Dtos where

import Data.Aeson (FromJSON, ToJSON)
import GHC.Generics (Generic)

data ModelARequest = ModelARequest
    { modelParams :: [String]
    , dataset :: [[Double]]
    }
    deriving stock (Show, Eq, Generic)
    deriving anyclass (FromJSON, ToJSON)

data ModelBRequest = ModelBRequest
    { modelParams :: [String]
    , dataset :: [[Double]]
    }
    deriving stock (Show, Eq, Generic)
    deriving anyclass (FromJSON, ToJSON)
