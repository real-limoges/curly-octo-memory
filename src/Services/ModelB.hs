module Services.ModelB where

import API.App (AppM, runDb)
import API.Dtos (ModelBRequest)
import Core.Pipeline as Pipeline
import Database.Queue qualified as Q
import Database.Repository qualified as R
import Servant (ServerError (..), err400, throwError)
import Types

import Data.UUID (toText)
import Data.UUID.V4 (nextRandom)

submitJob :: ModelBRequest -> AppM JobId
submitJob req = do
    validatedPayload <- case Pipeline.prepareModelB req of
        Left _ -> throwError err400{errBody = "Validation Error"}
        Right v -> return v

    jid <- Q.enqueueJob validatedPayload
    return jid
