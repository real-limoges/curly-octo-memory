{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module API.Api where

import API.App (AppM)
import API.Dtos (ModelARequest, ModelBRequest)
import API.Handlers (modelAHandler, modelBHandler)
import Data.Csv (FromRecord, HasHeader (..), decode)
import Data.Proxy (Proxy (..))
import Data.Text (Text)
import Data.Vector (Vector)
import Network.HTTP.Media ((//))
import Servant
import Servant.API
import Types

data CSV

instance Accept CSV where
    contentType _ = "text" // "csv"

instance (FromRecord a) => MimeUnrender CSV (Vector a) where
    mimeUnrender _ rawData =
        case decode HasHeader rawData of
            Left err -> Left $ "CSV Parsing Failed... Error: " ++ err
            Right v -> Right v

type ModelAEndpoint =
    "model_a"
        :> ReqBody '[JSON] ModelARequest
        :> Post '[JSON] JobId

type ModelBEndpoint =
    "model_b"
        :> ReqBody '[JSON] ModelBRequest
        :> Post '[JSON] JobId

type MLServiceAPI =
    ModelAEndpoint
        :<|> ModelBEndpoint

apiProxy :: Proxy MLServiceAPI
apiProxy = Proxy

server :: ServerT MLServiceAPI AppM
server =
    modelAHandler
        :<|> modelBHandler
