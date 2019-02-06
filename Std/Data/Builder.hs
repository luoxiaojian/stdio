{-# LANGUAGE BangPatterns        #-}
{-# LANGUAGE CPP                 #-}
{-# LANGUAGE FlexibleContexts    #-}
{-# LANGUAGE FlexibleInstances   #-}
{-# LANGUAGE MagicHash           #-}
{-# LANGUAGE RankNTypes          #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE UnboxedTuples       #-}

{-|
Module      : Std.Data.Builder
Description : Efficient serialization/format.
Copyright   : (c) Winterland, 2017-2018
License     : BSD
Maintainer  : drkoster@qq.com
Stability   : experimental
Portability : non-portable

If you're users looking for functions turn data into 'Builder' s, check 'Std.Data.Binary' or
'Std.Data.Textual'. This module is intend to 'Builder' builders.

A 'Builder' records a buffer writing function, which can be 'mappend' in O(1) via composition.
In stdio a 'Builder' are designed to deal with different 'AllocateStrategy', it affects how
'Builder' react when writing across buffer boundaries:

  * When building a short strict 'Bytes' with 'buildBytes/buildByteswith',
    we do a 'DoubleBuffer'.

  * When building a large lazy @[Bytes]@ with 'buildBytesList/buildBytesListwith',
    we do an 'InsertChunk'.

  * When building and consuming are interlaced with 'buildAndRun/buildAndRunWith',
    we do an 'OneShotAction'.

Most of the time using combinators from this module to build 'Builder' s is enough,
but in case of rolling something shining from the ground, keep an eye on correct
'AllocateStrategy' handling.

-}

module Std.Data.Builder
  ( -- * Builder type
    Builder
  , append
   -- * Running builders
  , buildBytes
  , buildBytesWith
  , buildBytesList
  , buildBytesListWith
  , buildAndRun
  , buildAndRunWith
    -- * Basic buiders
  , bytes
  , ensureN
  , atMost
  , writeN
   -- * Pritimive builders
  , encodePrim
  , encodePrimLE
  , encodePrimBE
  -- * More builders
  , stringUTF8, charUTF8, string7, char7, string8, char8, text
  -- * Numeric builders
  -- ** Integral type formatting
  , IFormat(..)
  , defaultIFormat
  , Padding(..)
  , int
  , intWith
  , integer
  -- ** Fixded size hexidecimal formatting
  , hex, heX
  -- ** IEEE float formating
  , FFFormat(..)
  , double
  , doubleWith
  , float
  , floatWith
  , scientific
  , scientificWith
  ) where

import           Std.Data.Builder.Base
import           Std.Data.Builder.Numeric
