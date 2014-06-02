{-# LANGUAGE DeriveDataTypeable #-}

import           DrupalNode
import           GhostImport
import           DrupalTaxonomy
import qualified Text.JSON.Generic as JSON
import qualified Text.Pandoc as Pandoc

writerOptions = Pandoc.def
readerOptions = Pandoc.def
htmlToMarkdown :: String -> String
htmlToMarkdown = Pandoc.writeMarkdown writerOptions . Pandoc.readHtml readerOptions

mapDrupalNodeToGhostImportPost :: DrupalNode.DrupalNode -> GhostImport.GhostImportPost
mapDrupalNodeToGhostImportPost drupalNode =
    GhostImport.GhostImportPost
    { GhostImport.id = read (DrupalNode.nid drupalNode) :: Int
    , GhostImport.title = DrupalNode.title drupalNode
    , GhostImport.slug = DrupalNode.title drupalNode
    , GhostImport.markdown = htmlToMarkdown (filter (/='\r') ( DrupalNode.value ( head (DrupalNode.und ( DrupalNode.body (drupalNode) ) ) ) ) )
    , GhostImport.html = DrupalNode.value ( head (DrupalNode.und ( DrupalNode.body (drupalNode) ) ) )
    , GhostImport.image = ""
    , GhostImport.featured = True
    , GhostImport.page = False
    , GhostImport.status = "published"
    , GhostImport.language = "en_US"
    , GhostImport.meta_title = ""
    , GhostImport.meta_description = ""
    , GhostImport.author_id = 1
    , GhostImport.created_at = 1000 * read (DrupalNode.created drupalNode) :: Int
    , GhostImport.created_by = 1
    , GhostImport.updated_at = 1000 * read (DrupalNode.changed drupalNode) :: Int
    , GhostImport.updated_by = 1
    , GhostImport.published_at = 1000 * read (DrupalNode.created drupalNode) :: Int
    , GhostImport.published_by = 1
    }

mapDrupalNodesToGhostImportData :: [DrupalNode.DrupalNode] -> [DrupalTaxonomy.Tags] -> GhostImport.GhostImportData
mapDrupalNodesToGhostImportData drupalNodes drupalTags =
    GhostImport.GhostImportData
    { GhostImport.posts = map mapDrupalNodeToGhostImportPost drupalNodes
    , GhostImport.tags = drupalTags
    , GhostImport.posts_tags = GhostImport.constructPostsTag drupalNodes
    }

constructGhostImportFromGhostImportData :: GhostImport.GhostImportData -> GhostImport.GhostImport
constructGhostImportFromGhostImportData ghostImportData =
    GhostImport.GhostImport
    { GhostImport.meta = GhostImportMeta
        { exported_on = 0
        , version = "000"
        }
    , _data_hack = ghostImportData
    }

--convertDrupalNodeJsonToGhostImportDataJson :: String -> String
--convertDrupalNodeJsonToGhostImportDataJson jsonString = JSON.encodeJSON (constructGhostImportFromGhostImportData (mapDrupalNodesToGhostImportData (JSON.decodeJSON (jsonString) :: [DrupalNode.DrupalNode])))

parseDrupalNodeJson :: String -> DrupalNode
parseDrupalNodeJson drupalNodeJson = JSON.decodeJSON (drupalNodeJson) :: DrupalNode.DrupalNode

parseDrupalNodeJsonList :: [String] -> [DrupalNode.DrupalNode]
parseDrupalNodeJsonList nodesJsonList = map parseDrupalNodeJson nodesJsonList

main = do
    taxonomyString <- readFile "/tmp/data_export_import/taxonomy_terms/20140530_210113_taxonomy_terms.dataset"
    nodeJsonString <- readFile "/tmp/data_export_import/nodes/20140530_210456_nodes_story.dataset"
    --print (foo "{\"foo\": 123}")
    --print (lookupInValue "name" (lookupInValue "150"( lookupInValue "2" (getVocabulariesObject (foo jsonString)))))
    let nodesList = parseDrupalNodeJsonList(lines nodeJsonString)
    let tagsList = DrupalTaxonomy.tagsFromTagJson(taxonomyString)
    writeFile "/tmp/out.json" (JSON.encodeJSON(constructGhostImportFromGhostImportData(mapDrupalNodesToGhostImportData nodesList tagsList)))
