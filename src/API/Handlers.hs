module API.Handlers (
    modelAHandler,
    modelBHandler,
)
where

import API.App
import API.Dtos
import Data.Text (Text)
import Servant
import Types

import Services.ModelA qualified as ModelAService
import Services.ModelB qualified as ModelBService

-- these are all the routes
modelAHandler :: ModelARequest -> AppM JobId
modelAHandler = ModelAService.submitJob

modelBHandler :: ModelBRequest -> AppM JobId
modelBHandler = ModelBService.submitJob
