{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Concurrent
import Control.Concurrent.MSemN
import Control.Lens
import Control.Monad

import Network.HTTP.Types

import Network.Wai
import Network.Wai.Handler.Warp

import System.IO

getSettings :: MSemN Int -> Settings
getSettings sem =
  defaultSettings & setPort 8080 & setOnOpen (const $ handleOpen sem) &
  setOnClose (const $ handleClose sem)

handleOpen :: MSemN Int -> IO Bool
handleOpen sem = do
  putChar '['
  handleConn sem 1
  pure True

handleClose :: MSemN Int -> IO ()
handleClose sem = do
  putChar ']'
  handleConn sem (-1)

handleConn :: MSemN Int -> Int -> IO ()
handleConn = signal

watchAvail :: MSemN Int -> IO ()
watchAvail sem = void $ forkIO $ forever $ do
  threadDelay 1000000
  peekAvail sem >>= print

main = do
  sem <- new 0
  let settings = getSettings sem
  hSetBuffering stdout NoBuffering
  putStrLn $ "Listening on port " ++ show (getPort settings)
  watchAvail sem
  runSettings settings $ \_ respond -> do
    threadDelay 1000
    respond $ responseLBS status200 [] "Hello World"
