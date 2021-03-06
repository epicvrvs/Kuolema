{-# LANGUAGE OverloadedStrings #-}

module Site
       ( site
       ) where

import Control.Applicative
import Control.Monad.Reader
import Data.IORef
import Text.Templating.Heist

import qualified Data.Text as T
import qualified Text.XmlHtml as X

import Snap.Extension.Heist
import Snap.Util.FileServe
import Snap.Types

import Application
import Configuration

testSplice :: Splice Application
testSplice = do
  reference <- asks counter
  value <- liftIO $ readIORef reference
  liftIO $ writeIORef reference (value + 1)
  return [X.TextNode $ T.pack $ show value]

index :: Application ()
index = ifTop $ heistLocal (bindSplices splices) $ render "index"
  where
    splices =
        [ ("test", testSplice)
        ]

site :: Application ()
site = route [ ("/", index)
             ]
       <|> fileServe staticPath
