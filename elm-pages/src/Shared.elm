module Shared exposing (..)

import Time exposing (Posix)
import Pages
import Pages.PagePath exposing (PagePath)
import Metadata exposing (Metadata)

type alias Model =
    { hovered : Maybe Datum
    , selection : Selection
    , dragging : Bool
    , hinted : Maybe Datum
    , startString : String
    , endString : String
    , btcS : String
    , width : Int
    , height : Int
    , showMobileMenu: Bool
    }

type Msg
    = SetScreenSize Int Int
    | Hold Data
    | Move Data
    | Drop Data
    | LeaveChart Data
    | LeaveContainer Data
      -- Chart 2
    | Hint (Maybe Datum)
    | ChangeStart Data String
    | ChangeEnd Data String
    | ChangeBtc String
    | ToggleMobileMenu
    | OnPageChange
      { path : PagePath Pages.PathKey
      , query : Maybe String
      , fragment : Maybe String
      , metadata : Metadata
      }



type alias Selection =
    { start : Maybe Datum
    , end : Maybe Datum
    }



---beware, start might be later than end!


type alias Data =
    List Datum


type alias Datum =
    { time : Posix
    , amount : Float
    }
