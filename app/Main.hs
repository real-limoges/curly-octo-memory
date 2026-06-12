module Main (main) where

import Network.Wai.Handler.Warp (run)
import Server (app)
import System.Environment (lookupEnv)
import Text.Read (readMaybe)

-- | Start the HTTP service. The listen port is read from the PORT
-- environment variable, defaulting to 8080.
main :: IO ()
main = do
  port <- maybe 8080 id . (>>= readMaybe) <$> lookupEnv "PORT"
  putStrLn $ "prediction-service listening on http://localhost:" <> show port
  run port app
