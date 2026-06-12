module Main (main) where

import Control.Monad (unless)
import Core (predict)
import System.Exit (exitFailure)
import Types (TaskResult (..), toMathVector)

main :: IO ()
main = do
  let known =
        [ ("cat", toMathVector [0, 0]),
          ("dog", toMathVector [10, 10])
        ]
      result = predict (toMathVector [1, 1]) known

  check "nearest neighbor wins" (classification result == "cat")
  check "distance is non-negative" (distance result >= 0)
  check "confidence is in (0, 1]" (confidence result > 0 && confidence result <= 1)

  putStrLn "All tests passed."

check :: String -> Bool -> IO ()
check name ok =
  unless ok $ do
    putStrLn ("FAILED: " <> name)
    exitFailure
