{-# LANGUAGE OverloadedStrings #-}

module Repository
  ( fetchUserHistory,
  )
where

import Data.Vector.Storable qualified as V
import Database.PostgreSQL.Simple qualified as PG
import Database.PostgreSQL.Simple.Types (PGArray (..))
import Types (MathVector)

fetchUserHistory :: PG.Connection -> String -> IO [(String, MathVector)]
fetchUserHistory conn uid = do
  rows <- PG.query conn "SELECT feature_array FROM user_features WHERE user_id = ?" (PG.Only uid)

  let labeledRows = map (\(PG.Only (PGArray vec)) -> ("HistoryPoint", V.fromList vec)) rows

  return labeledRows
