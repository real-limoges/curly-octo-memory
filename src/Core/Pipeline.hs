module Core.Pipeline where

import Dtos
import Types

data PipelineError = InvalidDataset | InvalidParams

randomFunc :: IO ()
randomFunc = do
    putStrLn "Pipeline code"

prepareModelA :: ModelARequest -> Either PipelineError ValidatedMLPayload
prepareModelA req
    | null req.dataset = Left InvalidDataset
    | otherwise =
        Right $
            ValidatedMLPayload
                { vJobType = "modelA"
                , vModelParams = req.modelParams
                }

prepareModelB :: ModelARequest -> Either PipelineError ValidatedMLPayload
prepareModelB req
    | null req.dataset = Left InvalidDataset
    | otherwise =
        Right $
            ValidatedMLPayload
                { vJobType = "modelB"
                , vModelParams = req.modelParams
                }
