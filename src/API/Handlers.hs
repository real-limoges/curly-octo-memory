module API.Handlers (
    server,
)
where

import API.Api
import API.App
import API.Dtos
import Data.Text (Text)
import Servant

import Infrastructure.Repository qualified as Repo
import Services.ModelA qualified as ModelAService
import Services.ModelB qualified as ModelBService

-- this is the server object that's running
server :: ServerT MLServiceAPI AppM
server = postModelA :<|> postModelB

-- these are all the routes
postModelA :: ModelARequest -> AppM JobId
postModelA = ModelAService.submitJob

-- postModelB :: ModelBRequest -> AppM JobId
-- postModelB = ModelBService.submitJob
