-- Types related to the final AST (adapted from Cheapskate.Types)

module CommonMark.Types where

import Data.Default
import Data.Sequence ( Seq )
import qualified Data.Map as M
-- import qualified Data.Map.Strict as M
import Data.Text ( Text )

-- | Root of the document's AST
data Doc = Doc Blocks
  deriving (Show)

-- | Block-level element
data Block = Hrule
           | Header !Int Inlines
           | CodeBlock !InfoString !Text
           | HtmlBlock !Text
           | Paragraph Inlines
           | Blockquote Blocks
           | List !Bool {- loose or tight -} !ListType Items
           deriving (Show)

type InfoString = Text

-- the Item type is for making list items more explicit in the AST
type Items = Seq Item

newtype Item = Item { blocks :: Blocks }
  deriving (Show)

type Blocks = Seq Block

data ListType = Bullet  !BulletType
              | Ordered !NumDelim !StartNum
              deriving (Show, Eq)

data BulletType = Hyphen
                | PlusSign
                | Asterisk
                deriving (Show, Eq)

data NumDelim = FullStop
              | RightParenthesis
              deriving (Show, Eq)

type StartNum = Int


-- | Inlines elements

data Inline = Escaped !Char
            | Entity !Text
            | CodeSpan !Text
            | Emph Inlines
            | Strong Inlines
            | Link  Inlines !Destination (Maybe Title)
            | Image Inlines !Destination (Maybe Title)
            | RawHTML !Text
            | HardBreak
            | SoftBreak
            | Textual !Text
            deriving (Show)

-- link- and image-related type synonyms
type Label       = Text
type Destination = Text
type Title       = Text

type Inlines = Seq Inline

-- | Map of link references
type RefMap = M.Map Label (Destination, Maybe Title)
