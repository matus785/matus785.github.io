module Route exposing (..)

import Browser 
import Html exposing (..)
import Url exposing (Url)
import Url.Parser as UrlParser exposing ((</>))

import SharedState exposing (SharedState, SharedStateUpdate(..))

-- Pages
import Pages.Home as Home exposing (..)
import Pages.Info as Info exposing (..)
import Pages.LevelPreview as LevelPreview exposing (..)
import Pages.ScoreBoard as ScoreBoard exposing (..)
import Pages.Guide as Guide exposing (..)
import Pages.Settings as Settings exposing (..)
import Pages.Game as Game exposing (..)
import User exposing (get_unlocked_level)


type Route = 
    Home Home.Model
    | Info Info.Model
    | Level LevelPreview.Model
    | Score ScoreBoard.Model
    | Guide Guide.Model
    | Settings Settings.Model
    | Game Game.Model
    | NotFound

type Msg = 
    HomeMsg Home.Msg
    | InfoMsg Info.Msg
    | LevelMsg LevelPreview.Msg
    | ScoreMsg ScoreBoard.Msg
    | GuideMsg Guide.Msg
    | SettingsMsg Settings.Msg
    | GameMsg Game.Msg

delete_fragment : Url -> Url
delete_fragment url = 
    {url | fragment = Nothing}

myParser : SharedState -> UrlParser.Parser (Route -> a) a 
myParser state =
    UrlParser.oneOf
    [ 
        UrlParser.map Home <| UrlParser.map Home.initModel <| UrlParser.top
        , UrlParser.map Home <| UrlParser.map Home.initModel <| UrlParser.s "home"
        , UrlParser.map Info <| UrlParser.map Info.initModel <| UrlParser.s "info"
        , UrlParser.map Level <| UrlParser.map (LevelPreview.initModel state) <| UrlParser.s "levels"
        , UrlParser.map Score <| UrlParser.map (ScoreBoard.initModel state) <| UrlParser.s "score"
        , UrlParser.map Guide <| UrlParser.map (Guide.initModel state) <| UrlParser.s "guide" 
        , UrlParser.map Settings <| UrlParser.map (Settings.initModel state) <| UrlParser.s "settings"
        , UrlParser.map Game <| UrlParser.map (Game.initModel state) <| UrlParser.s "game" </> UrlParser.fragment identity
    ]

-- parse_url => parses Url to Route (see myParser) depending on url path and fragment
-- if url == ".../game#0" or selected level is NOT unlocked then level was not initialized properly (page NotFound)
parse_url : SharedState -> Url -> Route
parse_url state url =
    let 
        newRoute = url |> UrlParser.parse (myParser state) |> Maybe.withDefault NotFound 
    in
    case newRoute of 
        Game model -> 
            if (model.level.lvlNumber == 0 || (get_unlocked_level state.player) < model.level.lvlNumber) then NotFound
            else newRoute

        _ -> newRoute

page_view : (Msg -> msg) -> SharedState -> Route -> Browser.Document msg
page_view mapper state route =
    let
        pageTitle =
            case route of
                Home _ -> "Home"

                Info _ -> "Info"

                Level _ -> "Levels"

                Score _ -> "Score"

                Guide _ -> "Guide"

                Settings _ -> "Settings"

                Game _ -> "Game"

                NotFound -> "404 (Not Found)"
  
        pageBody = map_view state route            
    in
    {title = "Elm TD game - " ++ pageTitle, body = [pageBody |> Html.map mapper]}

-- map_view => calls view function (depending on Route type) to produce Html Msg
map_view : SharedState -> Route -> Html Msg
map_view state route =
    case route of
        Home model -> Home.view model |> Html.map HomeMsg

        Info model -> Info.view model |> Html.map InfoMsg

        Level model -> LevelPreview.view state model |> Html.map LevelMsg

        Score model -> ScoreBoard.view model |> Html.map ScoreMsg

        Guide model -> Guide.view model |> Html.map GuideMsg 

        Settings model -> Settings.view model |> Html.map SettingsMsg

        Game model -> Game.view state model |> Html.map GameMsg

        NotFound -> h1 [] [text "ERROR 404 - Page not found"]
    
-- page_update => calls update function (depending on Route type) to update current route model
page_update : Msg -> Route -> (Route, Cmd Msg, SharedStateUpdate)
page_update pageMsg route = 
    let
        errorUpdate = (route, Cmd.none, NoUpdate)
    in
    case pageMsg of
        HomeMsg msg -> 
            case route of
                Home model -> 
                    let
                        (newmodel, newCmd) = Home.update msg model
                        newroute = Home newmodel
                    in
                    (newroute, Cmd.map HomeMsg newCmd, NoUpdate)

                -- ERROR
                _ -> errorUpdate

        InfoMsg msg ->
            case route of
                Info model -> 
                    let
                        (newmodel, newCmd) = Info.update msg model
                        newroute = Info newmodel
                    in
                    (newroute, Cmd.map InfoMsg newCmd, NoUpdate)

                -- ERROR
                _ -> errorUpdate

        LevelMsg msg -> 
            case route of
                Level model -> 
                    let
                        (newmodel, newCmd) = LevelPreview.update msg model
                        newroute = Level newmodel
                    in
                    (newroute, Cmd.map LevelMsg newCmd, NoUpdate)

                -- ERROR
                _ -> errorUpdate

        ScoreMsg msg -> 
            case route of
                Score model -> 
                    let
                        (newmodel, newCmd) = ScoreBoard.update msg model
                        newroute = Score newmodel
                    in
                    (newroute, Cmd.map ScoreMsg newCmd, NoUpdate)

                -- ERROR
                _ -> errorUpdate

        GuideMsg msg ->
            case route of
                Guide model -> 
                    let
                        (newmodel, newCmd) = Guide.update msg model
                        newroute = Guide newmodel
                    in
                    (newroute, Cmd.map GuideMsg newCmd, NoUpdate)

                -- ERROR
                _ -> errorUpdate

        SettingsMsg msg -> 
            case route of
                Settings model -> 
                    let
                        (newmodel, newCmd, stateupdate) = Settings.update msg model
                        newroute = Settings newmodel
                    in
                    (newroute, Cmd.map SettingsMsg newCmd, stateupdate)

                -- ERROR
                _ -> errorUpdate 
        
        GameMsg msg -> 
            case route of
                Game model -> 
                    let
                        (newmodel, newCmd, stateupdate) = Game.update msg model
                        newroute = Game newmodel
                    in
                    (newroute, Cmd.map GameMsg newCmd, stateupdate)

                -- ERROR
                _ -> errorUpdate
