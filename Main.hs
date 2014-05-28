{-# LANGUAGE DeriveDataTypeable #-}

import           DrupalNode
import           GhostImport
import qualified Text.JSON.Generic as JSON
import qualified Text.Pandoc as Pandoc

writerOptions = Pandoc.def
readerOptions = Pandoc.def
htmlToMarkdown :: String -> String
htmlToMarkdown = Pandoc.writeMarkdown writerOptions . Pandoc.readHtml readerOptions

mapDrupalNodeToGhostImportPost :: DrupalNode.DrupalNode -> GhostImport.GhostImportPost
mapDrupalNodeToGhostImportPost drupalNode =
    GhostImport.GhostImportPost
    { GhostImport.id = DrupalNode.nid drupalNode
    , GhostImport.title = DrupalNode.title drupalNode
    , GhostImport.slug = DrupalNode.title drupalNode
    , GhostImport.markdown = htmlToMarkdown ( DrupalNode.value ( head (DrupalNode.und ( DrupalNode.body (drupalNode) ) ) ) )
    , GhostImport.html = DrupalNode.value ( head (DrupalNode.und ( DrupalNode.body (drupalNode) ) ) )
    , GhostImport.image = ""
    , GhostImport.featured = True
    , GhostImport.page = False
    , GhostImport.status = "published"
    , GhostImport.language = "en_US"
    , GhostImport.meta_title = ""
    , GhostImport.meta_description = ""
    , GhostImport.author_id = 1
    , GhostImport.created_at = 0
    , GhostImport.created_by = 1
    , GhostImport.updated_at = 0
    , GhostImport.updated_by = 1
    , GhostImport.published_at = 0
    , GhostImport.published_by = 1
    }

mapDrupalNodesToGhostImportData :: [DrupalNode.DrupalNode] -> GhostImport.GhostImportData
mapDrupalNodesToGhostImportData drupalNodes =
    GhostImport.GhostImportData
    { GhostImport.posts = map mapDrupalNodeToGhostImportPost drupalNodes }

constructGhostImportFromGhostImportData :: GhostImport.GhostImportData -> GhostImport.GhostImport
constructGhostImportFromGhostImportData ghostImportData =
    GhostImport.GhostImport
    { GhostImport.meta = GhostImportMeta
        { exported_on = 0
        , version = "000"
        }
    , _data_hack = ghostImportData
    }



main = do
    jsonString <- readFile "/tmp/node.json"
    putStrLn (JSON.encodeJSON (constructGhostImportFromGhostImportData (mapDrupalNodesToGhostImportData (JSON.decodeJSON (jsonString) :: [DrupalNode.DrupalNode]))))
