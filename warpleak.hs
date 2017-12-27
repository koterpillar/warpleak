{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Concurrent

import Network.HTTP.Types

import Network.Wai
import Network.Wai.Handler.Warp

main = run 8080 $ \_ respond -> do
  threadDelay 100
  respond $ responseLBS status200 [] "Hello World"
