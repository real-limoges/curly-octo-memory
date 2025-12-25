{-# LANGUAGE DeriveGeneric #-}

module Types where

import GHC.Generics (Generic)
import Data.Aeson (FromJSON, ToJSON)
import qualified Data.Vector.Storable as V

data Payload = Payload
    { userId   :: Int
    , features :: [Double]
    } deriving (Show, Generic)

instance FromJSON Payload

data TaskResult = TaskResult
  { classification :: String
  , confidence     :: Double
  , distance       :: Double
  } deriving (Show, Generic)

instance ToJSON TaskResult

type MathVector = V.Vector Double

toMathVector :: [Double] -> MathVector
toMathVector = V.fromList
