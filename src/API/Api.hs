{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module API.Api where

import API.Dtos (ModelARequest, ModelBRequest)
import Data.Csv (FromRecord, HasHeader (NoHeader), decode)
import Data.Text (Text)
import Data.Vector (Vector)
import Network.HTTP.Media ((//))
import Servant.API

data CSV

instance Accept CSV where
    contentType _ = "text" // "csv"

instance (FromRecord a) => MimeUnrender CSV (Vector a) where
    mimeUnrender _ rawData =
        case decode HasHeader rawData of
            Left err -> Left $ "CSV Parsing Failed... Error: " ++ err
            Right v -> Right v

type HealthEndpoint =
    "health"
        :> Get '[JSON] String

type ModelAEndpoint =
    "model_a"
        :> QueryParam' '[Required, Strict] "sub" String
        :> QueryParam' '[Required, String] "lon" Double
        :> QueryParam' '[Required, String] "lat" Double
        :> Post '[JSON] NoContent

type BulkUploadEndpoint =
    "bulk_upload"
        :> ReqBody '[JSON, CSV] (Vector Double)
        :> Post '[JSON] [Double]

type HSAPI =
    HealthEndpoint
        :<|> ModelAEndpoint
        :<|> BulkUploadEndpoint

apiProxy :: Proxy HSAPI
apiProxy = Proxy
