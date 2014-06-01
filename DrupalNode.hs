{-# LANGUAGE DeriveDataTypeable #-}

module DrupalNode
    where

import DrupalNodeTaxonomy
import qualified Text.JSON.Generic as JSON

data DrupalBodyContent = DrupalBodyContent 
    { value :: String
    } deriving (Show, JSON.Data, JSON.Typeable)
    
data DrupalBody = DrupalBody
    { und :: [DrupalBodyContent]
    } deriving (Show, JSON.Data, JSON.Typeable)

data DrupalNode = DrupalNode
    { body :: DrupalBody
    , changed :: String
    , created :: String
    , name :: String
    , nid :: String
    , revision_timestamp :: String
    , status :: String
    , title :: String
    , taxonomy_vocabulary_2 :: DrupalNodeTaxonomy.DrupalNodeTaxonomyRelation
    } deriving (Show, JSON.Data, JSON.Typeable)
