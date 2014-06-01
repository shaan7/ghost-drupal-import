{-# LANGUAGE DeriveDataTypeable #-}

module DrupalNodeTaxonomy
    where

import qualified Text.JSON.Generic as JSON

data DrupalNodeTaxonomy = DrupalNodeTaxonomy
    { tid :: String
    } deriving (Show, JSON.Data, JSON.Typeable)

data DrupalNodeTaxonomyRelation = DrupalNodeTaxonomyRelation
    { und :: [DrupalNodeTaxonomy]
    } deriving (Show, JSON.Data, JSON.Typeable)
