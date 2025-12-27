{-# LANGUAGE ImportQualifiedPost #-}
{-# LANGUAGE QuasiQuotes #-}

module Database.Repository where

import Data.Text (Text)
import Database.PostgreSQL.Simple qualified as PG
import Database.PostgreSQL.Simple.SqlQQ (sql)
import Database.PostgreSQL.Simple.Types (PGArray (..))
import Types

-- I lifted this inline SQL from the web
createJob :: PG.Connection -> JobId -> IO (Maybe JobStatusTicket)
createJob conn (JobId jid) = do
    let q = [sql| SELECT job_id, status, created_at FROM jobs WHERE job_id = ? |]
    results <- PG.query conn q [jid]
    case results of
        [x] -> return (Just x)
        _ -> return Nothing
