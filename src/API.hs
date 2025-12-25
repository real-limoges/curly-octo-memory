{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module API where

import Servant
import Types

type MyAPI = "predict" :> ReqBody '[JSON] Payload :> Post '[JSON] TaskResult
