module Main where

import System.Environment
import Data.List
import Data.Char
import qualified Data.ByteString
import qualified Alfred as AL
import System.Process
import System.Directory
import Text.XML.Plist.Read

main = do
	info <- readPlistFromFile "info.plist"
