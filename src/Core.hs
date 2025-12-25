module Core
    ( predict
    , train
    ) where

import Types
import qualified Data.Vector.Storable as V
import Data.List (minimumBy)
import Data.Ord (comparing)

euclideanDist :: MathVector -> MathVector -> Double
euclideanDist v1 v2 = sqrt $ V.sum $ V.zipWith (\x y -> (x - y) ** 2) v1 v2

predict :: MathVector -> [(String, MathVector)] -> TaskResult
predict input knownVectors =
  let
    scored :: [(String, Double)]
    scored = map (\(label, vec) -> (label, euclideanDist input vec)) knownVectors

    -- this finds min dist (Nearest Neighbor)
    (bestLabel, bestDist) = minimumBy (comparing snd) scored

    -- placeholder for later
    calcConfidence d = 1.0 / (1.0 + d)
  in
    TaskResult
    { classification = bestLabel
    , confidence     = calcConfidence bestDist
    , distance       = bestDist
    }

train :: [Double] -> MathVector
train = V.fromList
