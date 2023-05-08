module Pages.Game exposing (..)

import Html exposing (..)
import Html.Events.Extra.Mouse as Mouse
import Browser.Events
import Array exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Cursor as Cursor

import Pages.Styles as Style exposing (..)
import SharedState exposing (SharedState, SharedStateUpdate(..))
import User exposing (User, save_level_score)
import Game.Playboard as Playboard exposing (..)
import Game.Level as Level exposing (..)
import Game.Tiles exposing (..)
import Game.Towers as Towers exposing (..)

minimumGameHeight : Int
minimumGameHeight = 650

initialMessageTime : Float
initialMessageTime = 5000

maxTargetingIndex : Int
maxTargetingIndex = 5


type alias HelperMessage = {
    message : String
    , timeLeft : Float
    }

type alias Model = { 
    level : Level
    , currentPlayer : User 
    , gameWH : (Int, Int)
    , currentObject : Object
    , currentAction : Action
    -- UI elements
    , currentMessage : Maybe HelperMessage
    , buttonHoverID : Int
    , showDescription : Bool
    , showTowerRange : Bool
    , showEnemyHealth : Bool 
    , exitLink : Maybe String
    }

type Msg = 
    ButtonOver Int
    | ChangeSpeed Int
    | SelectTower String
    | SelectAction Action
    | DisselectActivity
    | MouseMoved (Maybe (Float, Float))
    | MapClicked (Float, Float)
    | ToggleDescription
    | ToggleTowerRange
    | ToggleEnemyHealth
    | Tick Float
    | PauseLevel
    | ResumeLevel
    | SaveProgress
    | ChangeLink (Maybe String)

initModel : SharedState -> Maybe String -> Model
initModel state str =
    let 
        lvlNumber =
            case str of 
                Nothing -> 0
                Just num -> Maybe.withDefault 0 (String.toInt num)
        
        currentLevel = Level.create_level state.player.difficulty lvlNumber minimumGameHeight minimumGameHeight

        width = (get_col currentLevel.lvlMap) * currentLevel.lvlMap.tileSize
        height = (get_row currentLevel.lvlMap) * currentLevel.lvlMap.tileSize
    in 
    { 
        level = currentLevel
        , currentPlayer = state.player
        , gameWH = (width, height)
        , currentObject = NoObject
        , currentAction = NoAction
        , currentMessage = Nothing
        , buttonHoverID = 0
        , showDescription = True
        , showTowerRange = True
        , showEnemyHealth = True
        , exitLink = Nothing
    }

update : Msg -> Model -> (Model, Cmd Msg, SharedStateUpdate)
update msg model = 
    case msg of 
        ButtonOver id -> ({model | buttonHoverID = id}, Cmd.none, NoUpdate)

        ChangeSpeed n -> ({model | level = (change_speed model.level n)}, Cmd.none, NoUpdate)

        DisselectActivity -> 
            case model.currentAction of
                    NoAction -> ({model | currentObject = NoObject}, Cmd.none, NoUpdate)
                    Buy -> ({model | currentObject = NoObject, currentAction = NoAction}, Cmd.none, NoUpdate)
                    Upgrade _ -> update (SelectAction NoAction) model
                    _ -> ({model | currentAction = NoAction}, Cmd.none, NoUpdate)

        -- Game UI
        ToggleDescription -> ({model | showDescription = not model.showDescription}, Cmd.none, NoUpdate)
        ToggleTowerRange -> ({model | showTowerRange = not model.showTowerRange}, Cmd.none, NoUpdate)
        ToggleEnemyHealth -> ({model | showEnemyHealth = not model.showEnemyHealth}, Cmd.none, NoUpdate)

        SelectTower name -> 
            let
                newTower = create_tower name model.level.costMultiplier
            in
            ({model | currentObject = CurrentTower newTower False, currentAction = Buy}, Cmd.none, NoUpdate)

        MouseMoved pos -> 
            case pos of
                -- Mouse is on map
                Just p ->
                    let 
                        newpos = Playboard.map_coordinates model.level.lvlMap p
                    in
                    case model.currentObject of
                        -- Move tower preview
                        CurrentTower t preview -> 
                            if (newpos == t.posXY && preview) then (model, Cmd.none, NoUpdate)
                            else if (tower_is_placed model.level.lvlMap t) then (model, Cmd.none, NoUpdate)
                            else
                                let
                                    newtower = CurrentTower {t | posXY = newpos} True
                                in
                                ({model | currentObject = newtower}, Cmd.none, NoUpdate)

                        -- Dont move tower preview    
                        _ -> (model, Cmd.none, NoUpdate)

                -- Mouse is out of map
                Nothing ->  
                    case model.currentObject of
                        -- Stop showing preview tower
                        CurrentTower t preview -> 
                            if preview then ({model | currentObject = CurrentTower t False}, Cmd.none, NoUpdate)
                            else (model, Cmd.none, NoUpdate)
                        _ -> (model, Cmd.none, NoUpdate)

        MapClicked pos -> 
            let
                newpos = Playboard.map_coordinates model.level.lvlMap pos
            in 
            case model.currentObject of
                CurrentTower _ preview -> 
                    -- Buy new tower
                    if preview then update (SelectAction Buy) model
                    -- Select object on map
                    else ({model | currentObject = get_object model.level.lvlMap newpos, currentAction = NoAction} , Cmd.none, NoUpdate)

                -- Select object on map
                _ -> ({model | currentObject = get_object model.level.lvlMap newpos, currentAction = NoAction} , Cmd.none, NoUpdate)

        SelectAction act ->    
            -- Perform selected action
            if (act /= NoAction && act == model.currentAction) then 
                let
                    (newlevel, newobj, result) = perform_action act model.level model.currentObject
                    
                    (newAction, newMessage)  = 
                        case result of 
                            Nothing -> (NoAction, Nothing)
                            Just str -> (model.currentAction, Just (create_message str))

                    newID = 
                        case act of
                            Sell -> 0
                            Clear -> 0
                            Upgrade path ->     
                                case path of
                                    NoPath -> model.buttonHoverID
                                    _ -> 0
                            _ -> model.buttonHoverID
                in
                ({model | level = newlevel, currentObject = newobj, currentAction = newAction, currentMessage = newMessage, buttonHoverID = newID}, Cmd.none, NoUpdate) 

            -- Select new action
            else 
                case model.currentAction of
                    -- Undo upgrade
                    Upgrade _ ->
                        case model.currentObject of
                            CurrentTower t _ -> update (SelectAction act) {model | currentObject = get_object model.level.lvlMap t.posXY, currentAction = NoAction}
                            _ -> ({model | currentAction = act}, Cmd.none, NoUpdate) 

                    _ -> 
                        case act of      
                            -- Increase level of preview tower                      
                            Upgrade path -> 
                                case model.currentObject of 
                                    CurrentTower t preview -> 
                                        let
                                            newTower = increase_level t path model.level.costMultiplier
                                        in
                                        ({model | currentObject = CurrentTower newTower preview, currentAction = act}, Cmd.none, NoUpdate) 
                                    _ -> ({model | currentAction = act}, Cmd.none, NoUpdate) 

                            -- Change tower targeting
                            ChangeTargeting _ -> update (SelectAction act) {model | currentAction = act}

                            -- Select Action
                            _ -> ({model | currentAction = act}, Cmd.none, NoUpdate) 

        -- t = time in milisecond
        Tick t -> 
            let
                newLevel = tick_time model.level t
                newMessage = decrease_message_time model.currentMessage t
            in
            ({model | level = newLevel, currentMessage = newMessage}, Cmd.none, NoUpdate)

        PauseLevel -> ({model | level = pause_level model.level}, Cmd.none, NoUpdate)
        ResumeLevel -> ({model | level = unpause_level model.level}, Cmd.none, NoUpdate)
        ChangeLink link ->   ({model | exitLink = link}, Cmd.none, NoUpdate)

        SaveProgress -> 
            case model.level.lvlState of
                Won -> 
                    let
                        newUser = save_level_score model.currentPlayer model.level.lvlNumber model.level.lives model.level.currentTime
                    in
                    (model, Cmd.none, UpdateUser newUser)

                _ -> (model, Cmd.none, NoUpdate)

subscriptions : Sub Msg
subscriptions =
    Browser.Events.onAnimationFrameDelta (\time -> Tick time)

create_message : String -> HelperMessage
create_message str = 
    {message = str, timeLeft = initialMessageTime}

decrease_message_time : Maybe HelperMessage -> Float ->  Maybe HelperMessage
decrease_message_time message dt = 
    case message of 
        Just m -> 
            let
                newTime = m.timeLeft - dt
            in
            if (newTime <= 0) then Nothing
            else Just {m | timeLeft = newTime}

        _ -> Nothing

get_targeting_index : Tower -> Int
get_targeting_index tower = 
    case tower.targeting of
        First -> 1
        Strong -> 2
        Weak -> 3
        Close -> 4
        Towers.Flying -> 5

targeting_from_index : Int -> Target
targeting_from_index index =  
    case index of
        1 -> First
        2 -> Strong
        3 -> Weak
        4 -> Close
        5 -> Towers.Flying
        _ -> First

set_targeting_index : Int -> Int -> Int
set_targeting_index currentIndex difference = 
    let
        newIndex = currentIndex + difference
    in
    if (newIndex > maxTargetingIndex) then 1 
    else if (newIndex < 1) then maxTargetingIndex
    else newIndex

printPos : (Float, Float) -> String
printPos pos = 
    let
        strPos = Tuple.mapBoth String.fromFloat String.fromFloat pos
    in
    " x = " ++ Tuple.first strPos ++ "  y = " ++ Tuple.second strPos

------------------------------------------------
-- View
------------------------------------------------

hover_events : Int -> List (Element.Attribute Msg)
hover_events id = 
    [
        Events.onMouseEnter (ButtonOver id)
        , Events.onMouseLeave (ButtonOver 0)
    ]

description_text : Float -> String -> Element.Attribute Msg
description_text offset description = 
    Element.above 
    (
        Element.el
        (fonts.descriptionText ++ 
            [
                height (px 20)
                , moveRight (offset)
                , Font.size 16
                , Background.color colors.white
                , Border.color colors.black
                , Border.width 1
                , alpha 0.6
                , Events.onMouseEnter (ButtonOver 0)
            ]
        )
        (Element.text (" " ++ description ++ " "))
    )

pause_button : Model -> Int -> Element Msg
pause_button model id = 
    let
        buttonSource = ("/assets/ui/button_img_brown.svg", "/assets/ui/button_img_brownH.svg")

        buttonAttr = 
            ((hover_events id) ++ 
                [
                    moveUp 3
                    , Events.onClick PauseLevel
                    , Element.inFront
                    (
                        Element.image 
                        [
                            height (px 25)
                            , centerX
                            , centerY
                        ]
                        {src = "/assets/ui/icons/options.svg", description = "options"}
                    )
                ]
            )
    in
    Style.hover_button (35, 35) buttonSource (model.buttonHoverID == id) buttonAttr

resume_button : Model -> Int -> Element Msg
resume_button model id = 
    let
        buttonSource = ("/assets/ui/button_green.png", "/assets/ui/button_greenH.png")

        buttonAttr = 
            ( (hover_events id) ++
                [
                    Events.onClick ResumeLevel
                    , centerX
                    , Element.inFront
                    (
                        Element.el
                        ( fonts.buttonText ++ 
                            [
                                centerX
                                , centerY
                                , Font.size 20
                                , Font.semiBold
                            ]
                        )
                        (Element.text "RESUME")
                    )
                ]
            )
    in
    Style.hover_button (140, 55) buttonSource (model.buttonHoverID == id) buttonAttr

exit_button : (Int, Int) -> String -> String -> Model -> Int -> Element Msg
exit_button (w, h) link label model id = 
     let
        buttonSource = ("/assets/ui/button_green.png", "/assets/ui/button_greenH.png")

        buttonAttr = 
            ( (hover_events id) ++
                [
                    Events.onClick (ChangeLink (Just link))
                    , centerX
                    , Element.inFront
                    (
                        Element.el
                        ( fonts.buttonText ++ 
                            [
                                centerX
                                , centerY
                                , Font.size 20
                                , Font.semiBold
                            ]
                        )
                        (Element.text label)
                    )
                ]
            )
    in
    Style.hover_button (w, h) buttonSource (model.buttonHoverID == id) buttonAttr

confirm_button : Bool -> Model -> Int -> Element Msg
confirm_button check model id = 
    let
        buttonSource = ("/assets/ui/button_img_square.svg", "/assets/ui/button_img_squareH.svg")

        iconName = 
            if check then "/assets/ui/icons/check.svg"
            else "/assets/ui/icons/cross.svg"

        buttonAttr = 
            ( (hover_events id) ++
                [
                    centerX
                    , if check then moveLeft 0
                    else Events.onClick (ChangeLink Nothing)
                    , Element.inFront
                    (
                        Element.image 
                        [
                            height (px 35)
                            , centerX
                            , centerY
                        ]
                        {src = iconName, description = "options"}
                    )
                ]
            )

    in
    if check then Style.link_button (65, 65) (Maybe.withDefault "" model.exitLink) buttonSource (model.buttonHoverID == id) [centerX] buttonAttr 
    else Style.hover_button (65, 65) buttonSource (model.buttonHoverID == id) buttonAttr 

disselect_button : Model -> Int -> Element Msg
disselect_button model id = 
    let
        buttonSource = ("/assets/ui/button_img_round.svg", "/assets/ui/button_img_roundH.svg")

        buttonAttr = 
            ( (hover_events id) ++
                [
                    alignRight
                    , Events.onClick (DisselectActivity)
                    , Element.inFront
                    (
                        Element.image 
                        [
                            height (px 15)
                            , centerX
                            , centerY
                        ]
                        {src = "/assets/ui/icons/cross.svg", description = "options"}
                    )
                ]
            )

    in
    Style.hover_button (30, 30) buttonSource (model.buttonHoverID == id) buttonAttr 

targeting_button : Int -> Int -> Model -> Int -> Element Msg
targeting_button currentIndex indexDifference model id = 
    let
        buttonSource = 
            if (indexDifference == 1) then ("/assets/ui/button_arrow-r.svg", "/assets/ui/button_arrow-rH.svg")
            else ("/assets/ui/button_arrow-l.svg", "/assets/ui/button_arrow-lH.svg"
            )

        buttonAttr = 
            ( (hover_events id) ++
                [
                    centerX
                    , Events.onClick (SelectAction <| ChangeTargeting <| targeting_from_index <| set_targeting_index currentIndex indexDifference)
                ]
            ) 

    in
    Style.hover_button (30, 30) buttonSource (model.buttonHoverID == id) buttonAttr

link_pause_screen : (Int, Int) -> String -> String -> Model -> Int -> Element Msg
link_pause_screen (w, h) link label model id = 
    let
        buttonSource = ("/assets/ui/button_green.png", "/assets/ui/button_greenH.png")

        buttonAttr = 
            ( (hover_events id) ++
                [
                    Events.onClick SaveProgress
                    , Element.inFront
                    (
                        Element.el
                        ( fonts.buttonText ++ 
                            [
                                centerX
                                , centerY
                                , Font.size 20
                                , Font.semiBold
                            ]
                        )
                        (Element.text label)
                    )
                ]
            )

    in
    Style.link_button (w, h) link buttonSource (model.buttonHoverID == id) [centerX] buttonAttr 

toggle_button : String -> Model -> Int -> Element Msg
toggle_button icon model id =
    let 
        (selected, toggleEvent, descriptionText) = 
            case icon of 
                "info" -> (model.showDescription, Events.onClick (ToggleDescription), "show this text")
                "HPbar" -> (model.showEnemyHealth, Events.onClick (ToggleEnemyHealth), "show enemy health")
                "sight" -> (model.showTowerRange, Events.onClick (ToggleTowerRange), "show tower range")
                _ -> (False, Events.onClick (ToggleDescription), "")
                
        iconName = 
            if selected then "/assets/ui/icons/" ++ icon ++ "-S.svg"
            else "/assets/ui/icons/" ++ icon ++ ".svg"

        buttonSource = 
            if (selected) then ("/assets/ui/button_img_brownS.svg", "/assets/ui/button_img_brownSH.svg")
            else ("/assets/ui/button_img_brown.svg", "/assets/ui/button_img_brownH.svg")

        buttonIcon = 
            Element.inFront
            (
                Element.image 
                [
                    height (px 20)
                    , centerX
                    , centerY
                ]
                {src = iconName, description = "icon-" ++ icon}
            )

        buttonAttr = 
            if (model.showDescription && id == model.buttonHoverID) then (description_text 15 descriptionText) :: (hover_events id) ++ [centerX, toggleEvent, buttonIcon]
            else (hover_events id) ++ [centerX, toggleEvent, buttonIcon]
           
    in
    Style.hover_button (30, 30) buttonSource (model.buttonHoverID == id) buttonAttr

speed_button : Int -> Model -> Int -> Element Msg
speed_button speed model id =
    let
        selected = speed == model.level.speed

        iconName = 
            if selected then  "/assets/ui/icons/level_speed-" ++ String.fromInt speed ++ "S.svg"
            else "/assets/ui/icons/level_speed-" ++ String.fromInt speed ++ ".svg"

        buttonSource = 
            if selected then ("/assets/ui/button_img_roundS.svg", "/assets/ui/button_img_roundS.svg") 
            else ("/assets/ui/button_img_round.svg", "/assets/ui/button_img_roundH.svg") 

        buttonIcon = 
            Element.inFront
            (
                Element.image 
                [
                    if (speed == 3) then width (px 27)
                    else width (px 21)
                    , centerX
                    , centerY
                    , if (speed == 1 || speed == 3) then moveRight 2
                    else moveRight 0
                ]
                {src = iconName, description = "speed-" ++  String.fromInt speed}
            )

        buttonAttr = 
            if selected then [Cursor.default, buttonIcon] ++ (hover_events id) 
            else [Events.onClick (ChangeSpeed speed), buttonIcon] ++ (hover_events id) 
    in
    Style.hover_button (45, 45) buttonSource (model.buttonHoverID == id) buttonAttr

icon_label_description : (Int, Int) -> String -> (String, String) -> Model -> Int -> List (Element.Attribute Msg) -> Element Msg
icon_label_description (w, h) icon (label, description) model id listAttr =
    let
        halfHeight = (h // 2) + 6
    in
    Element.row     
    [
        height (px h)
        , width (px w)
        , spacingXY (w // 20) 0
    ]    
    [
        -- icon
        Element.image
        ( (hover_events id) ++
            [ 
                height (px halfHeight)
                , centerY
                -- description
                , if (model.showDescription && id == model.buttonHoverID) then description_text (toFloat halfHeight) description 
                else Element.above (Element.none)
            ]
        )
        {src = "/assets/ui/icons/" ++ icon, description = icon}
        -- label
        , Element.el
        ( fonts.numberText ++ listAttr ++ 
            [
                height (px halfHeight)
                , width (fill)
                , Font.size halfHeight
                , centerY
            ]
        )
        (Element.text (label))
    ]

tower_image : String -> Model -> Int -> Element Msg
tower_image towerName model id = 
    let
        name = String.toLower towerName

        selected = 
            case model.currentObject of 
                CurrentTower t _ ->  
                    if ((get_tower_name t) == name && not (tower_is_placed model.level.lvlMap t)) then True
                    else False
                _ -> False

        buttonSource = 
            if selected then ("/assets/ui/button_img_greenS.svg", "/assets/ui/button_img_greenSH.svg")
            else ("/assets/ui/button_img_green.svg", "/assets/ui/button_img_greenH.svg")

        towerImage = 
            Element.inFront
            (
                Element.image 
                [
                    width (px 50)
                    , height (px 50)
                    , centerX
                    , centerY
                ]
                {src = "/assets/towers/" ++ name ++ ".png", description = "tower"}
            ) 

        buttonAttr = 
            if selected then [Events.onClick DisselectActivity, towerImage] ++ (hover_events id)
            else [Events.onClick (SelectTower name), towerImage] ++ (hover_events id)

    in
    Style.hover_button (80, 80) buttonSource (model.buttonHoverID == id) buttonAttr

action_button : (Int, Int) -> Action -> Model -> Int -> Element Msg
action_button (w, h) action model id = 
    let
        (icon, description, upgradeText) =
            case action of 
                Sell -> ("sell", "sell tower", "")

                Upgrade path -> 
                    case path of
                        NoPath -> ("upgrade", "upgrade tower", "")
                        Top -> ("upgrade", "upgrade path 1", "★")
                        Bottom -> ("upgrade", "upgrade path 2", "✦")

                Clear -> ("break", "break obstacle", "")

                _ -> ("", "", "")

        selected = action == model.currentAction

        iconName = 
            if selected then "/assets/ui/icons/" ++ icon ++ "-S.svg"
            else "/assets/ui/icons/" ++ icon ++ ".svg"

        buttonSource = 
            if selected then ("/assets/ui/button_img_brownS.svg", "/assets/ui/button_img_brownSH.svg")
            else ("/assets/ui/button_img_brown.svg", "/assets/ui/button_img_brownH.svg")
        
        buttonAttr =   
            ( (hover_events id) ++ 
                [
                    Events.onClick (SelectAction action)
                    , centerX

                    , if (model.showDescription && id == model.buttonHoverID) then description_text (toFloat h / 2) description        
                    else Element.above (Element.none)

                    , Element.inFront
                    (    
                        Element.image 
                        [
                            width (px (w - 15))
                            , centerX
                            , centerY     
                        ]
                        {src = iconName, description = "icon-" ++ icon}
                    )

                    , Element.inFront
                    (
                        Element.el
                        [
                            alignRight
                            , alignBottom
                            , Font.size 22
                            , if (selected) then Font.color colors.black
                            else Font.color colors.darkGreen
                            , moveLeft 2
                            , moveUp 1
                        ]
                        (Element.text (upgradeText))
                    )   
                ]
            )

    in
    Style.hover_button (w, h) buttonSource (model.buttonHoverID == id) buttonAttr

show_object : Int -> Model -> Element Msg
show_object panelHeight model = 
    let
        borderWidth = 3
        imageHeight = 75 + (borderWidth * 2)
    in
    Element.el
    [
        height (px panelHeight)
        , width (fill)
        , padding 5
        , spacingXY 0 10
        , Border.color colors.darkGrey
        , Border.widthEach {bottom = 2, left = 0, right = 0, top = 2}
    ]
    (
        case model.currentObject of
            -- NO object
            NoObject -> Element.none

            -- tower selected
            CurrentTower t _ -> 
                let
                    (towerName, _ ) = get_tower_description t
                    placed = tower_is_placed model.level.lvlMap t

                    towerLevel = 
                        if placed then get_tower_level t
                        else ""

                    showTargeting = 
                        case model.currentAction of
                            Buy -> False
                            Sell -> False
                            Upgrade _ -> False 
                            _ -> placed                

                    labelBorder = 
                        [
                            Border.widthEach {bottom = 0, left = 0, right = 1, top = 0}
                            , Border.color colors.darkGrey
                        ]

                    pathUpgrades = 
                        [
                            action_button (40, 40) (Upgrade Top) model 21
                            , action_button (40, 40) (Upgrade Bottom) model 22
                        ]

                    oneUpgrade = [action_button (40, 40) (Upgrade NoPath) model 20]
                in
                Element.column
                [
                    height fill
                    , width fill
                ]
                [
                    Element.row
                    [
                        height (px (imageHeight + 10))
                        , width fill
                        , paddingXY 15 5
                        , spacing 10 
                    ]
                    [
                        -- tower image
                        Element.el
                        [
                            height (px imageHeight)
                            , width (px imageHeight)
                            , Background.color colors.lightGrey
                            , Border.color colors.black
                            , Border.rounded 5
                            , Border.width borderWidth
                            -- tower level
                            , Element.inFront
                            (
                                Element.el
                                [
                                    alignBottom
                                    , alignRight
                                    , Font.size 20
                                    , Font.color colors.darkGreen
                                    , moveLeft 3
                                    , moveUp 1
                                ]
                                (Element.text towerLevel)
                            )
                        ]
                        (preview_tower t (imageHeight - 19) 0 [centerX, centerY])
                        -- tower name
                        , Element.column
                        [
                            height fill
                            , width fill
                            , spacingXY 0 5
                        ]
                        [
                            Element.row
                            [
                                height (px 35)
                                , width fill
                            ]
                            [
                                Element.el
                                (
                                    fonts.fancyText ++
                                    [ 
                                        width (px 120)
                                        , Font.size 20
                                        , Font.alignLeft 
                                        , Font.semiBold
                                    ]
                                )
                                (Element.text towerName)
                                , disselect_button model 23
                            ]
                            -- targeting buttons
                            , if (showTargeting) then 
                                Element.row
                                [
                                    height fill
                                    , width fill
                                    , spacing 5 
                                    , paddingEach {top = 0, right = 15, bottom = 0, left = 0}
                                ]
                                [                             
                                    targeting_button (get_targeting_index t) -1 model 24
                                    , Element.image
                                    [
                                        width (px 135)
                                        , height (px 35)
                                        , centerX
                                        , Element.inFront
                                        (
                                            Element.row
                                            [
                                                width fill
                                                , height fill
                                                , spacing 5 
                                                , paddingXY 10 0
                                            ]
                                            [
                                                Element.image
                                                ( (hover_events 25) ++ 
                                                    [
                                                        width (px 25)
                                                        , height (px 25)
                                                        , if (model.buttonHoverID == 25 && model.showDescription) then description_text 10 "targeting priority"
                                                        else Element.above (Element.none)
                                                    ]
                                                )

                                                {src = "/assets/ui/icons/target.svg", description = "targeting_icon"}
                                                , Element.el
                                                (
                                                    fonts.regularText ++
                                                    [ 
                                                        width (px 110)
                                                        , height (px 15)
                                                        , centerY
                                                        , Font.size 18
                                                        , Font.alignLeft 
                                                        , Font.semiBold
                                                    ]
                                                )
                                                (Element.text (get_targeting_name t))
                                            ]
                                        )                                 
                                    ]
                                    {src = "/assets/ui/text_field.png", description = "targeting"}
                                    , targeting_button (get_targeting_index t) 1 model 26
                                ]
                            -- money values for UPGRADE, BUY or SELL actions
                            else 
                                let
                                    (fontColor, moneyDescription) = 
                                        case model.currentAction of 
                                            Sell -> ([Font.color colors.green], "sell value")
                                            _ -> ([Font.color colors.red], "cost")

                                    moneyValue = 
                                        case model.currentAction of 
                                            Sell -> String.fromInt t.sellValue
                                            _ -> String.fromInt (get_tower_price t (get_upgrade_type t))
                                in
                                Element.el
                                ([
                                    height fill
                                    , width fill
                                    , paddingXY 20 5
                                ])
                                (icon_label_description (160, 30) "money.svg" (moneyValue, moneyDescription) model 27 fontColor)
                        ]
                    ]
                    , Element.row
                    [
                        height fill
                        , width fill
                        , paddingXY 10 2
                    ]
                    [
                        -- tower stats
                        Element.column 
                        [
                            height fill
                            , width (px 240)
                            , spacing 5
                        ]
                        [
                            Element.row
                            [
                                height (px 30)
                                , width fill
                                , spacing 10
                            ]
                            [
                                icon_label_description (90, 30) "damage.svg" (String.fromInt t.projectileDamage, "damage per shot") model 28 labelBorder 
                                , icon_label_description (75, 30) "armor_ignore.svg" (String.fromInt t.projectileArmorIgnore, "armor ignore") model 29 []
                            ]
                            , Element.row
                            [
                                height (px 30)
                                , width fill
                                , spacing 10
                            ]
                            ( icon_label_description (90, 30) "attack_speed.svg" (get_tower_fireRate t, "shots per second") model 30 labelBorder :: 
                                case t.class of
                                    RocketLauncher explosion_range ->            
                                        [
                                            icon_label_description (75, 30) "range.svg" (get_tower_range t, "range (in tiles)") model 31 labelBorder
                                            , icon_label_description (50, 30) "explosion_range.svg" (String.fromFloat explosion_range, "range of explosion") model 32 []
                                        ]
                                    _ -> List.singleton (icon_label_description (75, 30) "range.svg" (get_tower_range t, "range (in tiles)") model 31 [])
                            )
                            , Element.row
                            [
                                height (px 30)
                                , width fill
                                , spacing 10
                            ]
                            [
                                icon_label_description (90, 30) "projectile_distance.svg" (get_tower_projectileDistance t, "travel distance of shots") model 33 labelBorder
                                , icon_label_description (75, 30) "projectile_speed.svg" (get_tower_projectileSpeed t, "travel speed of shots ") model 34 labelBorder
                                , icon_label_description (50, 30) "projectile_pierce.svg" (String.fromInt t.projectilePierce, "number of hit enemies per shot") model 35 []
                            ]
                        ]
                        -- action buttons
                        , if placed then Element.column 
                        [
                            height fill
                            , width fill
                            , spaceEvenly
                            , paddingXY 0 5
                            , moveRight 12
                        ]
                        [
                            Element.row
                            [
                                width (px 95)
                                , height (px 40)
                                , spacing 15
                            ]
                            (
                                -- upgrade buttons
                                case model.currentAction of
                                    Upgrade path -> 
                                        case path of 
                                            NoPath -> oneUpgrade
                                            _ -> pathUpgrades
                                            
                                    _ -> 
                                        if (t.level < Towers.maxTowerLevel) then oneUpgrade
                                        else if (t.level == Towers.maxTowerLevel) then pathUpgrades
                                        else []

                            )
                            -- sell button
                            , action_button (40, 40) Sell model 36
                        ]
                        else Element.none
                    ]
                ]
            
            -- tile selected
            CurrentTile t ->
                let
                    showObstacle = has_obstacle t

                    buildText = 
                        case t.class of
                            Lot _ -> 
                                if (showObstacle) then "Can't build tower"
                                else "Can build tower"
                            Road -> "Can't build tower"
                in 
                Element.column
                [
                    height fill
                    , width fill
                ]
                [
                    Element.row
                    [
                        height (px (imageHeight + 10))
                        , width fill
                        , paddingXY 15 0
                        , spacing 10
                    ]
                    [
                        -- tile image
                        Element.el
                        [
                            height (px imageHeight)
                            , width (px imageHeight)
                            , Border.color colors.black
                            , Border.rounded 5
                            , Border.width borderWidth
                            , centerX
                            , centerY
                            , clip
                        ]
                        (preview_tile t 76)
                        , Element.column
                        [
                            height fill
                            , width fill
                            , spacing 5
                        ]
                        [
                            -- tile name
                            Element.row
                            [
                                height (px 35)
                                , width fill
                            ]
                            [
                                Element.el
                                (
                                    fonts.fancyText ++
                                    [ 
                                        width (px 120)
                                        , Font.size 20
                                        , Font.alignLeft 
                                        , Font.semiBold
                                    ]
                                )
                                (Element.text (get_tile_name t))
                                , disselect_button model 37
                            ]
                            -- obstacle clear cost
                            , case model.currentAction of
                                Clear ->   
                                    Element.el
                                    ([
                                        height fill
                                        , width fill
                                        , paddingXY 20 5
                                    ])
                                    (icon_label_description (160, 30) "money.svg" (String.fromInt (get_tile_clear_cost t) ,"cost") model 38 [Font.color colors.red]) 
                                _ -> Element.none   
                        ]
                    ]
                    , Element.row 
                    [
                        height fill
                        , width fill
                        , paddingXY 15 10
                    ]
                    [
                        -- tile buildable text
                        Element.el
                        ( fonts.regularText ++ 
                            [
                                height fill
                                , width (px 180)
                                , alignLeft
                                , paddingXY 15 20
                                , Font.size 18
                                , Font.alignLeft
                            ]
                        )
                        (Element.text buildText)
                        -- clear obstacle button
                        , Element.column 
                        [
                            height (px 50)
                            , width (px 80)
                            , centerX
                            , centerY
                        ]
                        (
                            if showObstacle then [action_button (45, 45) Clear model 39]
                            else []
                        ) 
                    ]
                ]
    )

pause_screen : Model -> Element Msg
pause_screen model = 
    case model.level.lvlState of
        NotComplete -> Element.none
        _ -> 
            let
                screenTitle = 
                    ( fonts.regularTitle ++ 
                        [
                            Font.size 35
                            , centerX
                            , paddingEach {top = 10, right = 0, bottom = 20, left = 0}
                        ]
                    )

                panel = 
                    case model.level.lvlState of
                        NotComplete -> []

                        Paused -> 
                            [
                                Element.el (Font.color colors.dimYellow :: screenTitle) (Element.text "Level Paused")
                                , resume_button model 1
                                , exit_button (200, 55) ("game#" ++ String.fromInt model.level.lvlNumber) "RETRY LEVEL" model 2
                                , exit_button (200, 55) "levels" "BACK TO MENU" model 3
                            ]

                        Won -> 
                            let
                                lastLevel = model.level.lvlNumber == User.maxMapNumber

                                nextButton = 
                                    if lastLevel then Element.none
                                    else link_pause_screen (200, 55) ("game#" ++ String.fromInt (model.level.lvlNumber + 1)) "NEXT LEVEL" model 1
                            in                 
                            (
                                (
                                    if lastLevel then
                                        -- last level text
                                        [
                                            -- title and fireworks images
                                            Element.el 
                                            ( screenTitle ++ 
                                                [
                                                    Font.color colors.lightGreen
                                                    , moveRight 4
                                                    , Element.onLeft
                                                    (
                                                        Element.image
                                                        [
                                                            width (px 32)
                                                            , moveDown 8
                                                            , moveLeft 2
                                                        ]
                                                        {src = "/assets/ui/icons/fireworks.svg", description = "fireworks-left"}
                                                    )
                                                    , Element.onRight
                                                    (
                                                        Element.image
                                                        [
                                                            width (px 32)
                                                            , moveDown 8
                                                            , moveRight 2
                                                        ]
                                                        {src = "/assets/ui/icons/fireworks.svg", description = "fireworks-left"}
                                                    )

                                                ] 
                                            ) 
                                            (Element.text "Congratulations!")
                                            -- final level beaten text
                                            , Element.el 
                                            ( fonts.regularTitle ++ 
                                                [
                                                    Font.size 25
                                                    , Font.color colors.dimYellow
                                                    , centerX
                                                    , paddingEach {top = 0, right = 0, bottom = 10, left = 0}
                                                ]
                                            )
                                            (Element.text "You Beat The Final Level.")
                                        ]

                                    else [Element.el (Font.color colors.lightGreen :: screenTitle) (Element.text "Level Complete")] 
                                ) ++ 
                                -- level complete buttons
                                [
                                    nextButton
                                    , link_pause_screen (200, 55) "levels" "BACK TO MENU" model 2
                                    , link_pause_screen (140, 55) "home" "EXIT" model 3
                                ]
                            )

                        Lost -> 
                            [
                                Element.el (Font.color colors.darkRed :: screenTitle) (Element.text "Game Over")
                                , link_pause_screen (200, 55) ("game#" ++ String.fromInt model.level.lvlNumber) "RETRY LEVEL"  model 1
                                , link_pause_screen (200, 55) "levels" "BACK TO MENU" model 2
                                , link_pause_screen (140, 55) "home" "EXIT" model 3
                            ]
            in
            Element.el
            [
                height fill
                , width (px (Tuple.first model.gameWH + 410))
                , centerX
                -- panel background with alpha
                , Element.behindContent
                (
                    Element.el 
                    [
                        height fill
                        , width fill
                        , Background.color colors.lightGrey
                        , alpha 0.5 
                    ]
                    (Element.none)
                )
            ]
            -- pause panel
            (
                Element.image
                [
                    height (px 420)
                    , centerX
                    , centerY
                    , Element.inFront
                    (
                        Element.column 
                        [
                            height fill
                            , width fill
                            , paddingXY 0 40
                            , spacing 25
                        ]
                        panel
                    )
                ]
                {src = "/assets/ui/panel_pause.svg", description = "panel_pause"}
            )

confirm_screen : Model -> Element Msg
confirm_screen model = 
    let
        title = 
            [
                Element.paragraph 
                ( fonts.fancyTitle ++ 
                    [
                        width fill
                        , Font.size 30
                        , Font.color colors.black
                    ]
                )
                [
                    Element.text "Current Level Progress Will Be"
                    , Element.el 
                    [
                        Font.extraBold
                        , Font.color colors.darkRed
                    ]
                    (Element.text " LOST")
                    , Element.text "!!!"
                ]
                , Element.paragraph 
                ( fonts.fancyTitle ++ 
                    [
                        width fill
                        , Font.size 26
                        , Font.color colors.black
                    ]
                )
                [
                    Element.text "Do you Still Want To "
                    , Element.el 
                    [
                        Font.extraBold
                        , Font.underline
                    ]
                    (Element.text "EXIT")
                    , Element.text " Level?"
                ]
            ]
            
    in
    Element.el
    [
        height fill
        , width (px (Tuple.first model.gameWH + 410))
        , centerX
        -- panel background with alpha
        , Element.behindContent
        (
            Element.el 
            [
                height fill
                , width fill
                , Background.color colors.lightGrey
                , alpha 0.5 
            ]
            (Element.none)
        )
    ]
    (
        -- confirm panel
        Element.image
        [
            height (px 320)
            , centerX
            , centerY
            , Element.inFront
            (
                Element.column 
                [
                    height fill
                    , width fill
                    , paddingXY 100 30
                    , spacing 25
                ]
                ( title ++ 
                    [
                        Element.row
                        [
                            width fill
                            , height fill
                            , spacing 100
                            , moveUp 25
                        ]
                        -- confirm or cancel buttons
                        [
                            confirm_button True model 4
                            , confirm_button False model 5
                        ]
                    ]
                )
            )
        ]
        {src = "/assets/ui/panel_confirm.svg", description = "panel_pause"}
    )

view: SharedState -> Model -> Html Msg
view state model = 
    let
        borderSize = 3

        newHeight = (Tuple.second model.gameWH) + 5
        newWidth = (Tuple.first model.gameWH)  + 5

        wavesText = String.fromInt (get_wave_number model.level) ++ "/" ++ String.fromInt (Array.length model.level.waves) ++ " (" ++ String.fromInt (get_unbeaten_enemy_count model.level) ++ " left)"
    
    in
    Element.layout (Style.screen_background "/assets/ui/background-game.svg" 0.5)
    (
        Element.row
        [
            height (fill |> maximum minimumGameHeight |> minimum minimumGameHeight)
            , width fill
            , alignTop
            , moveDown 20
            -- pause or confirm screen
            , Element.inFront
            (
                case model.exitLink of 
                    Nothing -> pause_screen model
                    Just l -> confirm_screen model
            )
        ]
        [
            -- map view
            Element.el
            [
                height (px minimumGameHeight)
                , width (px newWidth)
                , centerX
                , Background.color colors.dimBrown
            ]
            (Element.el
            [
                height (px newHeight)
                , width (fill)
                , centerY
                , Border.color colors.black 
                , Border.width borderSize
                , clip

                -- tower preview on map
                , case model.currentObject of
                    CurrentTower t show -> 
                        if show then Element.inFront (preview_tower t model.level.lvlMap.tileSize (get_row model.level.lvlMap) [])
                        else Element.inFront (Element.none)

                    _ -> Element.inFront (Element.none)

                -- tower range preview on map
                , case model.currentObject of
                    CurrentTower t show -> 
                        if (model.showTowerRange && (show || tower_is_placed model.level.lvlMap t)) then 
                            Element.inFront (preview_tower_range t model.level.lvlMap.tileSize (get_row model.level.lvlMap))
                        else Element.inFront (Element.none)

                    _ -> Element.inFront (Element.none) 

                -- screen for mouse input
                , Element.inFront
                (
                    Element.el
                    [
                        height fill
                        , width fill
                        , Element.htmlAttribute (Mouse.onEnter (\event -> MouseMoved (Just event.offsetPos)))
                        , Element.htmlAttribute (Mouse.onOut (\_ -> MouseMoved Nothing))
                        , Element.htmlAttribute (Mouse.onMove (\event -> MouseMoved (Just event.offsetPos)))
                        , Element.htmlAttribute (Mouse.onClick (\event -> MapClicked (event.offsetPos)))
                    ]
                    (Element.text "")
                )
            ]
            (Element.html (draw_board model.level.lvlMap state.resources model.showEnemyHealth)))

            -- left panel
            , Element.image
            [
                height (px minimumGameHeight)
                , centerX
                , Element.inFront
                (
                    Element.column
                    [
                        height fill
                        , width fill
                        , padding 20
                        , spacing 5
                    ]
                    [
                        -- level number
                        Element.row
                        [
                            width fill
                            , height (px 45)
                            , spaceEvenly
                            , paddingXY 90 0
                            , Border.color colors.darkGrey
                            , Border.widthEach {bottom = 2, left = 0, right = 0, top = 0}
                        ]
                        [
                            Element.el
                            (
                                fonts.fancyTitle ++
                                [ 
                                    width (px 120)
                                    , Font.size 30
                                    , Font.alignLeft 
                                    , Font.color colors.darkGreen
                                ]
                            )
                            (Element.text ("Level " ++ String.fromInt model.level.lvlNumber))
                            , pause_button model 6
                        ]
                        -- level info
                        , Element.row 
                        [
                            width fill
                            , height (px 155)
                            , moveDown 5
                            , spaceEvenly
                            , paddingXY 5 0
                            , Border.color colors.black
                            , Border.widthEach {bottom = 2, left = 0, right = 0, top = 0} 
                        ]
                        [
                            Element.column
                            [
                                width (px 270)
                                , height fill
                                , spacing 5
                                , paddingXY 5 0
                            ]
                            [
                                -- speed buttons
                                Element.row
                                [
                                    width fill
                                    , height (px 60)
                                    , spaceEvenly
                                    , paddingXY 5 0
                                    , Border.color colors.darkGrey
                                    , Border.widthEach {bottom = 1, left = 0, right = 0, top = 0}
                                ]
                                [
                                    speed_button 0 model 7
                                    , speed_button 1 model 8
                                    , speed_button 2 model 9
                                    , speed_button 3 model 10
                                ]
                                -- level lives, money and waves values
                                , Element.row
                                [
                                    width fill
                                    , height (px 40)
                                    , spacing 20
                                    , paddingXY 10 0
                                ]
                                [
                                    icon_label_description (70, 38) "lives.svg" (String.fromInt model.level.lives, "lives left") model 11 [Font.glow colors.white 1.5]
                                    , icon_label_description (150, 38) "money.svg" (String.fromInt model.level.money, "money left") model 12 [Font.glow colors.white 1.5]
                                ]
                                , Element.el
                                [
                                    width (px 200)
                                    , height (px 40)
                                    , centerX
                                ]
                                (icon_label_description (200, 38) "waves.svg" (wavesText, "current wave/total waves (enemies left)") model 13 [Font.glow colors.white 1.5])
                            ]
                            -- UI buttons panel
                            , Element.column
                            [
                                width (px 80)
                                , height fill
                                , spaceEvenly 
                                , paddingEach {top = 17, right = 0, bottom = 22, left = 0}
                                , Element.behindContent
                                (
                                    Element.image
                                    [
                                        width (px 65)
                                        , moveUp 5
                                        , centerX
                                        , centerY
                                    ]
                                    {src = "/assets/ui/panel_UIbuttons.svg", description = "panel_UIbuttons"}
                                )
                            ]
                            -- toggle buttons
                            [
                                toggle_button "info" model 14
                                , toggle_button "sight" model 15
                                , toggle_button "HPbar" model 16
                            ]
                        ]
                        -- tower panel
                        , Element.row
                        [
                            width fill
                            , height (px 40)
                            , spacingXY 20 0
                        ]
                        [
                            Element.el
                            (
                                fonts.regularTitle ++
                                [ 
                                    centerX
                                    , centerY
                                    , Font.size 25
                                    , Font.color colors.dimOrange
                                ]
                            )
                            (Element.text ("Towers"))
                        ]
                        -- tower selection buttons
                        , Element.image
                        [
                            width fill
                            , moveUp 5
                            , Element.inFront
                            (
                                Element.row
                                [
                                    width fill
                                    , height (px 104)
                                    , spaceEvenly
                                    , paddingXY 40 0
                                ]
                                [
                                    tower_image "Minigun" model 17
                                    , tower_image "Cannon" model 18
                                    , tower_image "RocketLauncher" model 19
                                ]
                            )
                        ]
                        {src = "/assets/ui/panel_objects.svg" , description = "object_panel"}
                        
                        -- object preview
                        , case model.currentObject of
                            NoObject -> Element.none
                            _ -> show_object 205 model

                        -- display helper message
                        , case model.currentMessage of
                            Nothing -> Element.none
                            Just m -> 
                                let
                                    a = (1000 - ((initialMessageTime - m.timeLeft) * 0.15)) / 1000
                                in
                                Element.el
                                ( fonts.regularText ++ 
                                    [
                                        width fill
                                        , centerX
                                        , alignBottom
                                        , Font.size 18
                                        , Font.color colors.darkRed
                                        , Font.center
                                        , moveUp 10
                                        , alpha a
                                    ]
                                )
                                (Element.text m.message)
                    ]
                )
            ]
            {src ="/assets/ui/panel_game.svg" , description = "game_panel"}
        ]
    )
