module Pages.Settings exposing (..)

import Html exposing (..)
import Element exposing (..)
import Element.Font as Font
import Element.Border as Border
import Element.Events as Events
import Element.Input as Input
import Element.Cursor as Cursor

import Pages.Styles as Style exposing (..)
import SharedState exposing (SharedState, SharedStateUpdate(..))
import User exposing (..)

messageUnsaved : String
messageUnsaved = "* You have unsaved changes."

messageCurrent : String
messageCurrent = "* Player data are up-to-date."

type alias Model = { 
    currentPlayer : User
    , oldPlayer : User
    , currentMessage : String
    , buttonHoverID : Int
    }

initModel : SharedState -> Model
initModel state = {
    currentPlayer = state.player
    , oldPlayer = state.player
    , currentMessage = messageCurrent
    , buttonHoverID = 0
    }

type Msg = 
    ButtonOver Int
    | ChangeName String
    | ChangeLevel Float
    | ChangeDifficulty String
    | SaveUser

update : Msg -> Model -> (Model, Cmd Msg, SharedStateUpdate)
update msg model = 
    let
        player = model.currentPlayer
    in
    case msg of 
        ButtonOver id -> ({model | buttonHoverID = id}, Cmd.none, NoUpdate)

        ChangeName str -> 
            let
                newPlayer = {player | username = str}

                message = 
                    if (user_not_changed model.oldPlayer newPlayer) then messageCurrent
                    else messageUnsaved
            in
            ({model | currentPlayer = newPlayer, currentMessage = message}, Cmd.none, NoUpdate)

        ChangeLevel lvl -> 
            let
                newPlayer = set_level player (round lvl)

                message = 
                    if (user_not_changed model.oldPlayer newPlayer) then messageCurrent
                    else messageUnsaved
            in
            ({model | currentPlayer = newPlayer, currentMessage = message}, Cmd.none, NoUpdate)

        ChangeDifficulty str -> 
            let 
                diff = diff_from_str str
                newPlayer = {player | difficulty = diff}

                message = 
                    if (user_not_changed model.oldPlayer newPlayer) then messageCurrent
                    else messageUnsaved
            in
            ({model | currentPlayer = newPlayer, currentMessage = message}, Cmd.none, NoUpdate)

        SaveUser -> 
            let
                newPlayer = set_user_score model.oldPlayer player
            in
            ({model | currentPlayer = newPlayer, oldPlayer = newPlayer, currentMessage = messageCurrent}, Cmd.none, UpdateUser newPlayer)

------------------------------------------------
-- View
------------------------------------------------

hover_events : Int -> List (Element.Attribute Msg)
hover_events id = 
    [
        Events.onMouseEnter (ButtonOver id)
        , Events.onMouseLeave (ButtonOver 0)
    ]

label_text : List (Element.Attribute Msg)
label_text = 
    ( fonts.fancyTitle ++
        [
            centerY
            , paddingXY 40 0
            , Font.size 30
            , Font.alignLeft
            , Font.color colors.yellow
        ] 
    )

difficulty_button : String -> Model -> Int -> Element Msg
difficulty_button buttonLabel model id = 
    let
        selected = buttonLabel == (diff_to_str model.currentPlayer.difficulty)

        buttonSource =  
            if selected then ("/assets/ui/button_difficultyS.png", "/assets/ui/button_difficultyS.png")
            else ("/assets/ui/button_difficulty.png", "/assets/ui/button_difficultyH.png")

        buttonText = 
            Element.inFront
            (
                Element.el 
                ( 
                    fonts.buttonText  ++ 
                    [
                        centerX
                        , centerY
                        , Font.size 20
                        , if selected then Cursor.default
                        else Cursor.pointer
                        , if selected then Font.semiBold
                        else Font.medium
                    ]
                )
                (Element.text buttonLabel)
            )

        buttonAttr = 
            if selected then 
            ( (hover_events id) ++
                [
                    Cursor.default
                    , Element.onLeft
                    (
                        Element.image 
                        [
                            width (px 25) 
                            , height (px 25) 
                            , centerY
                            , moveLeft 5
                        ] 
                        { src = "/assets/ui/icons/arrow-r.svg", description = "arrow_r"}
                    )
                    , Element.onRight
                    (
                        Element.image 
                        [
                            width (px 25) 
                            , height (px 25) 
                            , centerY
                            , moveRight 5
                        ] 
                        { src = "/assets/ui/icons/arrow-l.svg", description = "arrow_l"}
                    )       
                ]
            )
            else Events.onClick (ChangeDifficulty buttonLabel) :: (hover_events id) 

    in
    Style.hover_button (120, 50) buttonSource (model.buttonHoverID == id) (buttonText :: buttonAttr)

save_button : Model -> Int -> Element Msg
save_button model id = 
    let
        buttonSource = ("/assets/ui/button_brown.png", "/assets/ui/button_brownH.png")

        buttonAttr = (hover_events id) ++ 
            [
                Events.onClick SaveUser
                , Element.inFront
                (
                    Element.el 
                    ( fonts.buttonText ++ 
                        [
                            centerX
                            , centerY
                            , Font.size 18
                            , Font.bold
                        ]
                    )
                    (Element.text "SAVE CHANGES")
                )
            ]
    in
    Style.hover_button (180, 50) buttonSource (model.buttonHoverID == id) buttonAttr

view: Model -> Html Msg
view model = 
    let
        currentLevel = get_unlocked_level model.currentPlayer
    in
    Element.layout (Style.screen_background "/assets/ui/background-menu.svg" 0.5)
    (
        Style.menu_panel 
        (
            Element.column
            [
                width fill
                , height fill
                , paddingXY 42 44
                , spacing 15
            ]
            [
                -- top panel
                Element.row
                [
                    width fill
                    , height (px 72)
                    , paddingXY 5 0
                ]
                [
                    Style.panel_button_home (75, 60) (model.buttonHoverID == 1) (hover_events 1)
                    , Style.panel_button (150, 60, 5) "Levels" (model.buttonHoverID == 2) (hover_events 2)
                    , Style.panel_button (150, 60, 10) "Score" (model.buttonHoverID == 3) (hover_events 3) 
                    , Style.panel_button (150, 60, 15) "Guide" (model.buttonHoverID == 4) (hover_events 4) 
                    , Style.panel_button_inactive (150, 60, 20) "Settings"
                ]
                -- username input
                , Element.el
                [
                    width fill
                    , height (px 80)
                    , paddingXY 0 10
                ]
                (
                    Input.username
                    ( fonts.fancyText ++ 
                        [
                            width (px 260)
                            , height (px 40)
                            , focused [Border.glow colors.black 0]
                            , Cursor.text
                            , centerY
                            , Element.behindContent
                            (
                                Element.image
                                [ 
                                    width (px 300)
                                    , height (px 60)
                                    , centerX
                                    , centerY
                                    , moveUp 8
                                    , moveRight 5
                                    , Cursor.default
                                ]
                                {src = "/assets/ui/text_input.png", description = "text_input"}
                            )
                        ]
                    )
                    { 
                        label = 
                            Input.labelLeft 
                            (label_text ++
                                [
                                    paddingEach {top = 0, right = 80, bottom = 0, left = 40}
                                ]
                            )
                            (Element.text "Player name")
                            , onChange = \str -> ChangeName str
                            , placeholder = Just (Input.placeholder [] (Element.text "Enter Username"))
                            , text = model.currentPlayer.username
                    }
                )
                -- level unlocked slider
                , Element.row
                [
                    width fill
                    , height (px 80)
                    , paddingXY 0 10
                    , spacing 20
                ]
                [
                    Element.el label_text (Element.text "Levels unlocked")

                    , Input.slider
                    [
                        Element.width (px 265)
                        , height (px 40)
                        , Element.behindContent
                            (
                                Element.image
                                [ 
                                    width (px 300)
                                    , height (px 40)
                                    , centerX
                                    , centerY
                                    , moveRight 3
                                ]
                                {src = "/assets/ui/slider.png", description = "slider"}
                            )
                    ]
                    { 
                        label = 
                            Input.labelBelow
                                ( fonts.fancyText ++
                                    [
                                        centerX
                                        , Font.size 15
                                    ]
                                )
                                (Element.text ("Current level = " ++ String.fromInt currentLevel))

                        , onChange = \lvl -> ChangeLevel lvl
                        , min = 1
                        , max = toFloat User.maxMapNumber
                        , step = Just 1
                        , value = toFloat currentLevel
                        , thumb = 
                            Input.thumb 
                            [
                                Element.width (px 20)
                                , Element.width (px 20)
                                , moveUp 10
                                , focused [Border.glow colors.black 0]
                                , Element.inFront
                                (
                                    Element.image
                                    [ 
                                        width fill
                                        , height fill
                                    ]
                                    {src = "/assets/ui/slider_thumb.svg", description = "slider_thumb"}
                                )
                            ] 
                    }
                ]
                -- difficulty label
                , Element.el
                ( fonts.fancyTitle ++
                    [
                        width fill
                        , height (px 50)
                        , paddingXY 0 10
                        , moveDown 10
                        , Font.size 30
                        , Font.center
                        , Font.color colors.yellow
                    ]
                )
                (Element.text "Difficulty")  
                -- difficulty buttons
                , Element.row 
                [
                    width fill
                    , height (px 80)
                    , moveUp 10
                    , spaceEvenly
                    , paddingXY 100 0
                ]
                [
                    difficulty_button "Easy" model 5
                    , difficulty_button "Medium" model 6
                    , difficulty_button "Hard" model 7
                ]
                -- changes button and message
                , Element.row 
                [
                    width fill
                    , height (px 100) 
                    , spaceEvenly
                    , paddingXY 120 0
                    , Border.widthEach {bottom = 0, left = 0, right = 0, top = 2}
                ]
                [
                    save_button model 8
                    -- display message
                    , Element.el
                    ( fonts.regularText ++ 
                        [
                            centerY
                            , alignLeft
                            , Font.size 18
                            , moveLeft 30
                        ]
                    )
                    (Element.text model.currentMessage)        
                ]
            ]
        )
    )
