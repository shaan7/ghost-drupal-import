{-# LANGUAGE DeriveDataTypeable #-}

module GhostImport
    where

import DrupalTaxonomy
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
    { id :: String
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
    } deriving (Show, JSON.Data, JSON.Typeable)
