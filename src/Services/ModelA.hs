module Services.ModelA where

import API.App (AppM)
import API.Dtos
import Core.Pipeline as Pipeline
import Database.Repository qualified as R
import Servant (ServerError (..), err400)
import Types

submitJob :: ModelARequest -> AppM JobId
submitJob req = do
    validatedPayload <- case Pipeline.prepareModelA req of
        Left _ -> throwError err400{errBody = "Validation Error"}
        Right v -> return v

    -- push to the Redis Queue/Worker
    jid <- Q.pushToQueue validatedPayload

    runDb $ \conn -> R.createJob conn jid Queued
