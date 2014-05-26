{-# LANGUAGE DeriveDataTypeable #-}

import qualified Text.JSON.Generic as JSON
import DrupalNode
import GhostImport

mapDrupalToGhost :: [DrupalNode.DrupalNode] -> GhostImport.GhostImport
mapDrupalToGhost drupalNode = GhostImport.GhostImport

main = do
    jsonString <- readFile "/tmp/node.json"
    print (JSON.decodeJSON jsonString :: [DrupalNode.DrupalNode])

{- import System.IO
import Text.JSON

main = do
    src <- readFile "/tmp/export.json"
    decode src
-}
