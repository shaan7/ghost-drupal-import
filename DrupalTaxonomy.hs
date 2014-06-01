{-# LANGUAGE OverloadedStrings,DeriveDataTypeable #-}

module DrupalTaxonomy
    where

import qualified Text.JSON.Generic as Json
import qualified Text.JSON.Types as JsonTypes
import qualified Data.Maybe as Maybe
import qualified Data.Aeson as Aeson
import qualified Data.ByteString.Lazy as L
import qualified Data.ByteString.Lazy.Char8 as C
import qualified Data.Set as DS
import qualified Data.HashMap.Strict as DHMS
import qualified Data.Text as DT

data Tags = Tags
    { id :: String
    , name :: String
    , slug :: String
    , description :: String
    } deriving (Show, Json.Data, Json.Typeable)

parseOuterJson :: String -> Aeson.Object
parseOuterJson jsonString = Maybe.fromJust(Aeson.decode (C.pack(jsonString)) :: Maybe Aeson.Object )

getVocabulariesObject :: Aeson.Object -> Aeson.Value
getVocabulariesObject vocabularies = Maybe.fromJust(DHMS.lookup "vocabulary_terms" vocabularies)

getObjectFromResult result = case result of 
    Aeson.Success object -> object

convertValueToObject :: Aeson.Value -> Aeson.Object
convertValueToObject value = getObjectFromResult(Aeson.fromJSON value :: Aeson.Result Aeson.Object)

lookupInValue :: DT.Text -> Aeson.Value -> Aeson.Value
lookupInValue key value = Maybe.fromJust(DHMS.lookup key (convertValueToObject value))

stringFromValue :: Aeson.Value -> String
stringFromValue value = getObjectFromResult(Aeson.fromJSON value :: Aeson.Result String)

tagObject :: Aeson.Value -> Tags
tagObject value = Tags 
    { DrupalTaxonomy.id = stringFromValue(lookupInValue "tid" value)
    , name = stringFromValue(lookupInValue "name" value)
    , slug = stringFromValue(lookupInValue "name" value)
    , description = ""
    }

nothing value = value

tagsFromTagJson :: String -> [Tags]
tagsFromTagJson jsonString = map tagObject (DHMS.elems (convertValueToObject (lookupInValue "2" (getVocabulariesObject (parseOuterJson jsonString)))))
