{-# LANGUAGE DeriveDataTypeable #-}

import           DrupalNode
import           GhostImport
import qualified Text.JSON.Generic as JSON

mapDrupalNodeToGhostImportPost :: DrupalNode.DrupalNode -> GhostImport.GhostImportPost
mapDrupalNodeToGhostImportPost drupalNode =
    GhostImport.GhostImportPost
    { GhostImport.id = DrupalNode.nid drupalNode
    , GhostImport.title = DrupalNode.title drupalNode
    , GhostImport.slug = ""
    , GhostImport.markdown = ""
    , GhostImport.html = DrupalNode.value ( head (DrupalNode.und ( DrupalNode.body (drupalNode) ) ) )
    , GhostImport.image = ""
    , GhostImport.featured = True
    , GhostImport.page = True
    , GhostImport.status = ""
    , GhostImport.language = ""
    , GhostImport.meta_title = ""
    , GhostImport.meta_description = ""
    , GhostImport.author_id = 0
    , GhostImport.created_at = 0
    , GhostImport.created_by = 0
    , GhostImport.updated_at = 0
    , GhostImport.updated_by = 0
    , GhostImport.published_at = 0
    , GhostImport.published_by = 0
    }

main = do
    jsonString <- readFile "/tmp/node.json"
    print (mapDrupalNodeToGhostImportPost ( head (JSON.decodeJSON (jsonString) :: [DrupalNode.DrupalNode])))

{- import System.IO
import Text.JSON

main = do
    src <- readFile "/tmp/export.json"
    decode src
-}
