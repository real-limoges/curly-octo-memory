-- {-# LANGUAGE OverloadedStrings #-}

module Handlers (
    server,
)
where

import Api
import App
import Data.Text (Text)
import Dtos
import Servant

import Infrastructure.Repository qualified as Repo
import Services.ModelA qualified as ModelAService
import Services.ModelB qualified as ModelBService

server :: ServerT MLServiceAPI AppM
server = postModelA :<|> postModelB

postModelA :: ModelARequest -> AppM JobId
postModelA = ModelAService.submitJob

postModelB :: ModelBRequest -> AppM JobId
postModelB = ModelBService.submitJob
