{-# LANGUAGE ImportQualifiedPost #-}
{-# LANGUAGE OverloadedStrings #-}

module Database.Repository where

import Data.Text (Text)
import Database.PostgreSQL.Simple qualified as PG
import Database.PostgreSQL.Simple.Types (PGArray (..))
import Types

-- I lifted this inline SQL from the web
createJob :: Connection -> JobId -> IO (Maybe JobEntity)
createJob conn (JobId jid) = do
    let q = [sql| SELECT job_id, status, created_at FROM jobs where job_id = ? |]
    results <- query conn q [jid]
    case results of
        [x] -> return (Just x)
        _ -> return Nothing
