module Services.ModelA where

import Core.Pipeline as Pipeline
import Dtos
import Servant (ServerError (..), err400)
import Database.Repository qualified as R
import Types
import App (AppM)
import Database.Queue qualified as Q

submitJob :: ModelARequest -> AppM JobId
submitJob req = do
    validatedPayload <- case Pipeline.prepareModelA req of
        Left _ -> throwError err400{errBody = "Validation Error"}
        Right v -> return v

    -- push to the Redis Queue/Worker
    jid <- Q.pushToQueue validatedPayload

    runDb $ \conn -> R.createJob conn jid Queued
