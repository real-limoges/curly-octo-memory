{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Api where

import Data.Text (Text)
import Servant
import Types

type MLServiceAPI =
    "api" :> "v1" :> "modelA" :> ReqBody '[JSON] ModelARequewst :> Post '[JSON] JobId
        :<|> "api" :> "v1" :> "modelB" :> ReqBody '[JSON] ModelBRequewst :> Post '[JSON] JobId
