{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Api where

import Data.Text (Text)
import Dtos (ModelARequest, ModelBRequest)
import Servant
import Types (JobId)

type MLServiceAPI =
    "api" :> "v1" :> "modelA" :> ReqBody '[JSON] ModelARequest :> Post '[JSON] JobId
        :<|> "api" :> "v1" :> "modelB" :> ReqBody '[JSON] ModelBRequest :> Post '[JSON] JobId
