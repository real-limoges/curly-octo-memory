{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module API (PredictAPI) where

import Servant
import Types

-- | POST /predict — classify a feature vector against a user's history.
type PredictAPI = "predict" :> ReqBody '[JSON] Payload :> Post '[JSON] TaskResult
