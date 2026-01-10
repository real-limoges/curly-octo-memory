{-# LANGUAGE DeriveAnyClass #-}

{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module API.App where

import Data.Proxy (Proxy(..))
import Control.Monad.Reader (ReaderT(..), MonadReader(..), asks)
import Control.Monad.Except (ExceptT(..), MonadError(..), runExceptT)
import Control.Monad.IO.Class (MonadIO(..))
import Data.Pool (Pool, withResource)
import Data.Text (Text)
import Database.PostgreSQL.Simple qualified as PG
import Database.Redis (Connection)
import Servant (Handler, ServerError)
import Types

-- state management
data AppState = AppState
    { redisConn :: Connection
    , pgPool :: Pool PG.Connection
    , queueName :: Text
    }

-- this is the magic of Servant. It runs on a type.
-- it derives a bunch of stuff - this is the composition over inheritance
newtype AppM a = AppM {runAppM :: ReaderT AppState Handler a}
    deriving newtype
        ( Functor
        , Applicative
        , Monad
        , MonadIO
        , MonadReader AppState
        , MonadError ServerError
        )

runApp :: AppState -> AppM a -> Handler a
runApp config app = runReaderT (runAppM app) config

runDb :: (PG.Connection -> IO a) -> AppM a
runDb queryAction = do
    pool <- asks pgPool
    liftIO $ withResource pool queryAction
