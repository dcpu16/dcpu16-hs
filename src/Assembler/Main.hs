module Main where

import System.Environment (getArgs, getProgName)
import System.Exit (exitFailure)

import qualified Blaze.ByteString.Builder as B
import qualified Data.ByteString.Lazy as BL

import Assembler

main :: IO ()
main = do
    progName <- getProgName
    args     <- getArgs
    case args of
        [x] -> do
            source <- readFile x
            let instrs = parse x source
                labels = calculateLabels instrs
                w16s   = assemble labels $ map snd instrs
            BL.writeFile "a.out" $ B.toLazyByteString $ B.fromWord16sbe w16s
        _   -> do
            putStr $ "Usage: " ++ progName ++ " <assembler file>"
            exitFailure
