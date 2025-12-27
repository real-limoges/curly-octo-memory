{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

module DTOs where

import Data.Aeson (FromJSON, ToJSON)
import GHC.Generics (Generic)

data ModelARequest = ModelARequest
  { params :: [String]
  }
  deriving stock (Show, Eq, Generic)
  deriving anyclass (FromJSON, ToJSON)

data ModelBRequest = ModelBRequest
  { params :: [String]
  }
  deriving stock (Show, Eq, Generic)
  deriving anyclass (FromJSON, ToJSON)