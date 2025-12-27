{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Api where

import Servant
import Data.Text (Text)
import Types

type MLServiceAPI =
       "api" :> "v1" :> "modelA" :> ReqBody '[JSON] ModelARequewst :> Post '[JSON] JobId
  :<|> "api" :> "v1" :> "modelB" :> ReqBody '[JSON] ModelBRequewst :> Post '[JSON] JobId