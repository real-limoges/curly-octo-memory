module Services.ModelA where

import API.App (AppM, runDb)
import API.Dtos (ModelARequest)
import Core.Pipeline (prepareModelA)
import Database.Queue qualified as Q
import Database.Repository qualified as R
import Servant (ServerError (..), err400, throwError)
import Types

submitJob :: ModelARequest -> AppM JobId
submitJob req = do
    validatedPayload <- case prepareModelA req of
        Left _ -> throwError err400{errBody = "Validation Error"}
        Right v -> return v

    jid <- Q.enqueueJob validatedPayload
    return jid
