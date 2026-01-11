module Core.Pipeline where

import API.Dtos
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
                { vJobType = ModelAType
                , vModelParams = req.modelParams
                }

prepareModelB :: ModelBRequest -> Either PipelineError ValidatedMLPayload
prepareModelB req
    | null req.dataset = Left InvalidDataset
    | otherwise =
        Right $
            ValidatedMLPayload
                { vJobType = ModelBType
                , vModelParams = req.modelParams
                }
