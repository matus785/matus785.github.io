module Main exposing (Msg)

import Browser 
import Browser.Navigation as Nav
import Html exposing (..)
import Url exposing (..)
import Json.Encode as Enc
import Json.Decode as Dec
import Game.Resources as Resources exposing (..)

import User exposing (..)
import SharedState exposing (..)
import Route exposing (..)
import Pages.Game exposing (subscriptions)


main : Program Enc.Value Model Msg
main = Browser.application { 
    init = init
    , update = update 
    , view = view 
    , subscriptions = subscriptions
    , onUrlChange = UrlChanged 
    , onUrlRequest = LinkClicked
    }

type alias Model = { 
    navKey : Nav.Key
    , url : Url
    , appstate : AppState
    }

type AppState =
    NotReady
    | Ready SharedState Route
    | FailedToInit

type Msg = 
    UrlChanged Url
    | LinkClicked Browser.UrlRequest
    | LoadResources Resources.Msg
    | PageMsg Route.Msg


init : Enc.Value -> Url -> Nav.Key -> (Model, Cmd Msg)
init flags url key =
    let
        newModel = {navKey = key, url = url, appstate = NotReady}
    in 
    (load_state newModel flags)

load_state : Model -> Enc.Value -> (Model, Cmd Msg)
load_state model flags = 
    let 
        player = 
            case Dec.decodeValue User.decode_user flags of
                Ok user -> user
                Err _ -> User.noUser

        initState = {player = player, resources = Resources.init}

        initRoute = Route.parse_url initState model.url

    in 
    ({model | appstate = Ready initState initRoute}, Cmd.map LoadResources (Resources.loadTextures SharedState.gameResources))


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        LinkClicked urlRequest -> 
            case urlRequest of
                Browser.Internal url -> (model, Nav.pushUrl model.navKey (Url.toString url))
                Browser.External href -> (model, Nav.load href)
                    
        UrlChanged url ->
            case model.appstate of
                Ready state _ -> 
                    let 
                        newRoute = Route.parse_url state url
                    in
                    ({model | url = delete_fragment url, appstate = Ready state newRoute}, Cmd.none)

                -- ERROR  
                _ -> (model, Cmd.none)
        
        LoadResources m ->
            case model.appstate of
                Ready state route -> 
                    let 
                        newstate = SharedState.update state (UpdateResource m)
                    in 
                    ({model | appstate = Ready newstate route}, Cmd.none)

                -- ERROR  
                _ -> (model , Cmd.none)

        PageMsg m ->
            case model.appstate of
                Ready state route -> 
                    let 
                        (newRoute, cmd, stateUpdate) = Route.page_update m route
                        newstate = SharedState.update state stateUpdate
                    in 
                    case stateUpdate of
                        UpdateUser u -> ({model | appstate  = Ready newstate newRoute}, Cmd.batch [Cmd.map PageMsg cmd, SharedState.save_storage u])
                        _ -> ({model | appstate = Ready newstate newRoute}, Cmd.map PageMsg cmd)

                -- ERROR  
                _ -> (model , Cmd.none)
     

view : Model -> Browser.Document Msg
view model = 
    case model.appstate of

        Ready state route -> Route.page_view PageMsg state route

        NotReady -> {title = "Loading", body = [text "Loading"]}

        FailedToInit -> {title = "Failure", body = [text "ERROR: Application failed to inialize!"]}


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.appstate of
        Ready _ route ->
            case route of 
                Route.Game _ -> Sub.map PageMsg (Sub.map Route.GameMsg Pages.Game.subscriptions)
                _ -> Sub.none

        _ -> Sub.none
