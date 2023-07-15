{-
  Copyright (c) Meta Platforms, Inc. and affiliates.
  All rights reserved.

  This source code is licensed under the BSD-style license found in the
  LICENSE file in the root directory of this source tree.
-}

module Thrift.Server.Types
  ( ServerOptions(..)
  , defaultOptions
  , ServerException(..)
  , FactoryFunction
  , ModifyFunction
  ) where

import Control.Exception hiding (handle)
import Data.Text (Text)
import Foreign.Ptr

-- -----------------------------------------------------------------------------
-- Factory function

-- | C function to generate a Processor to use in Thrift
-- The IO () is a lie, but the specific type doesn't really matter as everything
-- lives on the C++ side of the world.
type FactoryFunction = FunPtr (IO ())

-- -----------------------------------------------------------------------------
-- Modify function

-- | C function to modify the ThriftServer after it has been created,
-- but before we start serving requests.
type ModifyFunction = FunPtr (Ptr ThriftServer -> IO ())

data ThriftServer

-- -----------------------------------------------------------------------------
-- Options

data ServerOptions = ServerOptions
  { desiredPort :: Maybe Int
  , numWorkerThreads :: Maybe Int
      -- ^ number of requests that can be executed simultaneously.
      -- Defaults to the number of CPU cores.
  , customFactoryFn :: Maybe FactoryFunction
      -- ^ whether a custom factory should be used
  , customModifyFn :: Maybe ModifyFunction
  }

-- | Takes the `onewayFunctions'` from your thrift Service instance
defaultOptions :: ServerOptions
defaultOptions = ServerOptions
  { desiredPort = Nothing
  , numWorkerThreads = Nothing
  , customFactoryFn = Nothing
  , customModifyFn = Nothing
  }

-- -----------------------------------------------------------------------------
-- Exceptions

newtype ServerException = ServerException Text
  deriving (Show, Eq)
instance Exception ServerException
