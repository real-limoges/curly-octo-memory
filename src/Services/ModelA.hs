module Services.ModelA where

import App (AppM)
import Core.Pipeline as Pipeline
import Database.Queue qualified as Q
import Database.Repository qualified as R
import Dtos
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
