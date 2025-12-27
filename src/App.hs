module API where

import Control.Monad.Reader
import Control.Monad.Except
import Data.Text (Text)
import Database.Redis (Connection)
import qualified Database.PostgreSQL.Simple as PG
import Data.Pool (Pool, withResource)
import Servant (Handler, ServerError)

-- state management
data AppConfig = AppConfig
  { redisConn :: Connection
  , pgPool :: Pool PG.Connection
  , queueName :: Text
  }

-- this is the magic of Servant. It runs on a type.
-- it derives a bunch of stuff - this is the composition over inheritance
newtype AppM = AppM { runAppM :: ReaderT AppConfig Handler a }
deriving stock (Functor, Applicative, Monad, MonadIO, MonadReader
               , AppConfig, MonadError, ServerError
               )

runApp :: AppConfig -> AppM a -> Handler a
runApp config app = runReaderT (runAppM) config

runDb :: (PG.Connection -> IO a) -> AppM a
runDb queryAction = do
  pool <- asks pgPool
  liftIO $ withResource pool queryAction