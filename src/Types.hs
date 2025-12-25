{-# LANGUAGE DeriveGeneric #-}

module Types where

import Data.Aeson (FromJSON, ToJSON)
import Data.Vector.Storable qualified as V
import GHC.Generics (Generic)

data Payload = Payload
  { userId :: String,
    features :: [Double]
  }
  deriving (Show, Generic)

instance FromJSON Payload

data TaskResult = TaskResult
  { classification :: String,
    confidence :: Double,
    distance :: Double
  }
  deriving (Show, Generic)

instance ToJSON TaskResult

type MathVector = V.Vector Double

toMathVector :: [Double] -> MathVector
toMathVector = V.fromList
