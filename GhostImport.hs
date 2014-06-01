{-# LANGUAGE DeriveDataTypeable #-}

module GhostImport
    where

import DrupalNode
import DrupalTaxonomy
import DrupalNodeTaxonomy
import qualified Text.JSON.Generic as JSON

data GhostImport = GhostImport
    { meta :: GhostImportMeta
    , _data_hack :: GhostImportData
    } deriving (Show, JSON.Data, JSON.Typeable)

data GhostImportMeta = GhostImportMeta
    { exported_on :: Int
    , version :: String
    } deriving (Show, JSON.Data, JSON.Typeable)

data GhostImportPost = GhostImportPost
    { id :: Int
    , title :: String
    , slug :: String
    , markdown :: String
    , html :: String
    , image :: String
    , featured :: Bool
    , page :: Bool
    , status :: String
    , language :: String
    , meta_title :: String
    , meta_description :: String
    , author_id :: Int
    , created_at :: Int
    , created_by :: Int
    , updated_at :: Int
    , updated_by :: Int
    , published_at :: Int
    , published_by :: Int
    } deriving (Show, JSON.Data, JSON.Typeable)

data GhostImportData = GhostImportData
    { posts :: [GhostImportPost]
    , tags :: [DrupalTaxonomy.Tags]
    , posts_tags :: [GhostImportPostsTag]
    } deriving (Show, JSON.Data, JSON.Typeable)

data GhostImportPostsTag = GhostImportPostsTag
    { tag_id :: Int
    , post_id :: Int
    } deriving (Show, JSON.Data, JSON.Typeable)

drupalNodeTaxonomyToGhostImportPost :: String -> DrupalNodeTaxonomy.DrupalNodeTaxonomy -> GhostImportPostsTag
drupalNodeTaxonomyToGhostImportPost nid drupalNodeTaxonomy = GhostImportPostsTag
    { tag_id = read (DrupalNodeTaxonomy.tid drupalNodeTaxonomy) :: Int
    , post_id = read nid :: Int
    }

postsTagFromDrupalNodeTaxonomy :: String -> [DrupalNodeTaxonomy.DrupalNodeTaxonomy] -> [GhostImportPostsTag]
postsTagFromDrupalNodeTaxonomy nid drupalNodeTaxonomies = map (drupalNodeTaxonomyToGhostImportPost nid) drupalNodeTaxonomies

postsTagFromDrupalNode :: DrupalNode.DrupalNode -> [GhostImportPostsTag]
postsTagFromDrupalNode drupalNode = postsTagFromDrupalNodeTaxonomy (DrupalNode.nid drupalNode) (DrupalNodeTaxonomy.und(DrupalNode.taxonomy_vocabulary_2 drupalNode))

constructPostsTag :: [DrupalNode.DrupalNode] -> [GhostImportPostsTag]
constructPostsTag drupalNodes = concatMap postsTagFromDrupalNode drupalNodes
