module Pages.Guide exposing (..)

import Html exposing (..)
import Array exposing (..)
import Element exposing (..)
import Element.Font as Font
import Element.Border as Border
import Element.Background as Background
import Element.Events as Events
import Element.Cursor as Cursor

import Pages.Styles as Style exposing (..)
import SharedState exposing (SharedState, SharedStateUpdate(..))
import User exposing (difficulty_cost_multiplier, difficulty_enemy_multiplier)
import Game.Towers as Towers exposing (..)
import Game.Enemies as Enemies exposing (..)
import Game.Tiles exposing (..)

type Category = 
    Basics
    | Towers
    | Enemies
    | Tips

type alias Model = { 
    categoryIndex : Int
    , objectIndex : Int
    , allTowers : Array Tower
    , allEnemies : Array Enemy
    , buttonHoverID : Int
    }

type Msg = 
    ButtonOver Int
    | ChangeCategory Int
    | SelectObject Int
    | SelectLevel Int

tower_levels : Tower -> Float -> Array Tower
tower_levels tower mult = 
    let 
        (towerList, currentLevel) = 
            List.foldl 
                (\o (listT, lvl) ->     
                    let
                        previousTower = Array.get (lvl - 2) listT
                        newLvl = lvl + 1
                    in
                    case previousTower of
                        Nothing -> (Array.push o listT, newLvl)
                        Just t ->
                            let
                                nextLvl = 
                                    case t.level of
                                        5 -> 7
                                        _ -> t.level + 1

                                currentPath = get_upgrade_type {t | level = nextLvl}
                                newTower = increase_level t currentPath mult
                            in
                            (Array.push newTower listT, newLvl)
                ) 
                (Array.empty, 1) <| List.repeat 7 tower
    in
    towerList

init_towers : Float -> Array Tower
init_towers mult = 
    let
        towerMinigun = increase_level (create_tower "minigun" mult) NoPath mult
        towerCannon = increase_level (create_tower "cannon" mult) NoPath mult
        towerRocket = increase_level (create_tower "rocketlauncher" mult) NoPath mult
    in
    Array.append (tower_levels towerMinigun mult) <| Array.append (tower_levels towerCannon mult) (tower_levels towerRocket mult)

init_Enemies : Float -> Array Enemy
init_Enemies mult = 
    Array.fromList
    [
        place_enemy (Tuple.second <| create_enemy Scout 0 0) Array.empty Nothing 1 mult
        , place_enemy (Tuple.second <| create_enemy Soldier 0 0) Array.empty Nothing 1 mult
        , place_enemy (Tuple.second <| create_enemy Warrior 0 0) Array.empty Nothing 1 mult
        , place_enemy (Tuple.second <| create_enemy Veteran 0 0) Array.empty Nothing 1 mult
        , place_enemy (Tuple.second <| create_enemy Tank 0 0) Array.empty Nothing 1 mult
        , place_enemy (Tuple.second <| create_enemy HeavyTank 0 0) Array.empty Nothing 1 mult
        , place_enemy (Tuple.second <| create_enemy Plane 0 0) Array.empty Nothing 1 mult
        , place_enemy (Tuple.second <| create_enemy HeavyPlane 0 0) Array.empty Nothing 1 mult
    ]

initModel : SharedState -> Model
initModel state = {
    categoryIndex = 0
    , objectIndex = 0
    , allTowers = init_towers (difficulty_cost_multiplier state.player.difficulty)
    , allEnemies = init_Enemies (difficulty_enemy_multiplier state.player.difficulty)
    , buttonHoverID = 0
    }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of 
        ButtonOver id -> ({model | buttonHoverID = id}, Cmd.none)

        ChangeCategory index -> ({model | categoryIndex = index, objectIndex = 0}, Cmd.none)

        SelectObject index -> 
            case (index_to_category model.categoryIndex) of
                Enemies -> 
                    if (index == model.objectIndex) then ({model | objectIndex = 0}, Cmd.none)
                    else ({model | objectIndex = index}, Cmd.none)

                Towers ->
                    let
                        (indexMin, indexMax) = get_tower_index_range index
                    in
                    if (indexMin <= model.objectIndex && indexMax >= model.objectIndex) then ({model | objectIndex = 0}, Cmd.none)
                    else ({model | objectIndex = index}, Cmd.none)

                _ -> (model, Cmd.none)

        SelectLevel index -> 
            if (index /= model.objectIndex) then ({model | objectIndex = index}, Cmd.none)
            else (model, Cmd.none) 

category_to_str : Category -> String
category_to_str category = 
    case category of
        Basics -> "Basics"
        Towers -> "Towers"
        Enemies -> "Enemies"
        Tips -> "Tips"

index_to_category : Int -> Category
index_to_category index = 
    case index of
        0 -> Basics
        1 -> Towers
        2 -> Enemies
        3 -> Tips
        _ -> Basics

change_index : Int -> Int -> Int
change_index currentIndex difference = 
    let
        newIndex = currentIndex + difference
    in
    if (newIndex > 3) then 0
    else if (newIndex < 0) then 3
    else newIndex

get_tower_index_range : Int -> (Int, Int)
get_tower_index_range index = 
    (index, index + Towers.maxTowerLevel + 1)

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
                height (px 26)
                , paddingXY 0 2
                , moveRight (offset)
                , Font.size 18
                , Background.color colors.white
                , Border.color colors.black
                , Border.width 1
                , alpha 0.6
                , Events.onMouseEnter (ButtonOver 0)
            ]
        )
        (Element.text (" " ++ description ++ " "))
    )

arrow_button : Int -> Model -> Int -> Element Msg
arrow_button indexDifference model id = 
    let
        buttonSource = 
            if (indexDifference == 1) then ("/assets/ui/button_arrow-r.svg", "/assets/ui/button_arrow-rH.svg")
            else ("/assets/ui/button_arrow-l.svg", "/assets/ui/button_arrow-lH.svg"
            )

        buttonAttr = 
            ( (hover_events id) ++
                [
                    if (indexDifference == 1) then alignRight
                    else alignLeft
                    , Events.onClick (ChangeCategory <| change_index model.categoryIndex indexDifference)
                ]
            ) 
    in
    Style.hover_button (45, 45) buttonSource (model.buttonHoverID == id) buttonAttr

icon_text : (Int, Int) -> String -> String -> Bool -> List (Element Msg) -> List (Element.Attribute Msg) -> Element Msg
icon_text (w, h) iconSource iconLabel last textParagraph labelattr = 
    let
        imageSize = (h // 2) + (h // 6)
        minWidth = 
            if List.isEmpty textParagraph then (w // 5)
            else w
    in
    Element.row
    [
        width (px minWidth)
        , height (px h)
        , spacing 15
        , paddingXY 0 8
    ]
    [
        -- icon
        Element.image
        [
            height (px imageSize)
            , width (px imageSize)
            , alignLeft
            , centerY
        ]
        {src = "/assets/ui/" ++ iconSource, description = "icon-" ++ iconSource}
        -- label
        , Element.el
        [
            height (px (h - 10))
            , width (px (w // 5))
            , if last then  Border.width 0
                else Border.widthEach {bottom = 0, left = 0, right = 1, top = 0}
            , Border.color colors.black
        ]
        (
            Element.el
            ( fonts.fancyTitle ++ labelattr ++
                [
                    Font.size 24
                    , Font.alignLeft
                    , Font.extraBold
                    , centerY
                ]
            )
            (Element.text iconLabel)
        )
        -- value
        , Element.paragraph
        ( fonts.regularText ++ 
            [
                width fill
                , centerY
                , Font.size 16
                , Font.medium
            ]
        )
        textParagraph  
    ]

tip_text :  (Int, Int) -> Int -> List (Element Msg) -> Element Msg
tip_text (w, h) tipNumber textParagraph = 
    let
        imageSize = (h // 2) + (h // 6)
    in
    Element.row
    [
        width (px w)
        , height (px h)
        , spacing 5
        , paddingXY 0 4
    ]
    [
        -- tip icon
        Element.image
        [
            height (px imageSize)
            , width (px imageSize)
            , alignLeft
            , centerY
        ]
        {src = "/assets/ui/icons/lightbulb.svg", description = "icon-tip_" ++ String.fromInt tipNumber}
        -- tip number
        , Element.el
        [
            height (px (h - 10))
            , width (px 40)
            , Border.widthEach {bottom = 0, left = 0, right = 1, top = 0}
            , Border.color colors.black
        ]
        (
            Element.el
            ( fonts.fancyTitle ++
                [
                    Font.size 22
                    , Font.alignLeft
                    , Font.color colors.greenYellow
                    , Font.extraBold
                    , centerY
                ]
            )
            (Element.text ("#" ++ String.fromInt tipNumber))
        )
        -- tip text
        , Element.paragraph
        ( fonts.regularText ++ 
            [
                width fill
                , centerY
                , Font.size 15
                , Font.medium
            ]
        )
        textParagraph  
    ]

icon_text_description : (Int, Int) -> String -> (String, String, String) -> Bool -> Model -> Int -> Element Msg
icon_text_description (w, h) icon (label, value, description) last model id =
    let
        halfHeight = (h // 2) + 4
    in
    Element.row     
    [
        height (px h)
        , width (px w)
        , spacing 4
        , if last then Border.width 0
        else Border.widthEach {bottom = 0, left = 0, right = 1, top = 0}
    ]    
    [
        -- icon
        Element.image
        ( (hover_events id) ++
            [ 
                height (px (halfHeight + 8))
                , centerY
                , if (id == model.buttonHoverID) then description_text (toFloat halfHeight) description 
                else Element.above (Element.none)
            ]
        )
        {src = "/assets/ui/icons/" ++ icon, description = icon}

        -- label
        , Element.el
        ( fonts.regularTitle ++ 
            [
                height (px halfHeight)
                , Font.size (halfHeight)
                , centerY
                , paddingXY 2 0
            ]
        )
        (Element.text (label ++ " = "))

        -- text
        , Element.el
        ( fonts.numberText ++ 
            [
                height (px halfHeight)
                , width fill
                , Font.size (halfHeight)
                , Font.color colors.dimYellow
                , centerY
            ]
        )
        (Element.text (value))
    ]

tower_button : Int -> Model -> Int -> Element Msg
tower_button towerIndex model id = 
    let
        currentTower = Maybe.withDefault (create_tower "minigun" 1) <| Array.get (towerIndex - 1) model.allTowers 
        (indexMin, indexMax) = get_tower_index_range towerIndex

        selected = (indexMin <= model.objectIndex) && (indexMax >= model.objectIndex)

        buttonSource = 
            if selected then ("/assets/ui/button_img_brownS2.svg", "/assets/ui/button_img_brownSH2.svg")
            else ("/assets/ui/button_img_brown.svg", "/assets/ui/button_img_brownH.svg")

        towerImage = 
            Element.inFront (preview_tower currentTower 60 0 [centerX, centerY])
            
        buttonAttr = [Events.onClick (SelectObject towerIndex), towerImage, centerX] ++ (hover_events id)

    in
    Style.hover_button (80, 80) buttonSource (model.buttonHoverID == id) buttonAttr

enemy_button : Int -> Model -> Int -> Element Msg
enemy_button enemyIndex model id = 
    let
        currentEnemy = Maybe.withDefault (Tuple.second (create_enemy Scout 0 0)) <| Array.get (enemyIndex - 1) model.allEnemies 

        selected = model.objectIndex == enemyIndex

        buttonSource = 
            if selected then ("/assets/ui/button_img_brownS2.svg", "/assets/ui/button_img_brownSH2.svg")
            else ("/assets/ui/button_img_brown.svg", "/assets/ui/button_img_brownH.svg")

        enemyImage = 
            Element.inFront (preview_enemy currentEnemy 40 [centerX, centerY])
            
        buttonAttr = [Events.onClick (SelectObject enemyIndex), enemyImage] ++ (hover_events id)

    in
    Style.hover_button (60, 60) buttonSource (model.buttonHoverID == id) buttonAttr

level_button : Int -> Model -> Int -> Element Msg
level_button towerIndex model id = 
    let
        currentTower = Maybe.withDefault (create_tower "minigun" 1) <| Array.get (towerIndex - 1) model.allTowers 

        selected = model.objectIndex == towerIndex

        buttonSource = 
            if selected then ("/assets/ui/button_img_greenSH.svg", "/assets/ui/button_img_greenSH.svg")
            else ("/assets/ui/button_img_green.svg", "/assets/ui/button_img_greenH.svg")

        levelNumber = 
            Element.inFront 
            (
                Element.el
                [
                    centerX
                    , centerY
                    , Font.size 20
                    , Font.center
                    , if selected then Font.color colors.brown
                    else Font.color colors.black
                ]
                (Element.text (get_tower_level currentTower))
            )
            
        buttonAttr = 
            [
                if selected then Cursor.default
                else Cursor.pointer
                , levelNumber
                , centerY
                , Events.onClick (SelectLevel towerIndex)
            ] 
            ++ (hover_events id)

    in
    Style.hover_button (35, 35) buttonSource (model.buttonHoverID == id) buttonAttr

show_tile : (Int, Int) -> Tile -> List (Element.Attribute Msg) -> Element Msg
show_tile (w, h) tile attr = 
    Element.el
    ( attr ++
        [
            height (px h)
            , width (px w)
            , Border.color colors.black
            , Border.rounded 8
            , Border.width 3
            , clip
        ]
    )
    (preview_tile tile (w - 4))

show_enemy : (Int, Int) -> Enemy -> List (Element.Attribute Msg) -> Element Msg
show_enemy (w, h) enemy attr = 
    let
        newWidth = w // 2

        (roadIndex1, roadIndex2) = 
            case enemy.movement of
                Enemies.Flying -> (1, 1)
                Enemies.Ground -> (3, 5)

        leftRoad = Tuple.second <| create_tile (0, 0) Road roadIndex1 
        rightRoad = Tuple.second <| create_tile (0, 0) Road roadIndex2 

    in
    Element.row
    ( attr ++
        [
            height (px h)
            , width (px w)
            , Border.color colors.black
            , Border.rounded 8
            , Border.width 3
            , clip
            , Element.inFront (preview_enemy enemy (h - 10) [centerX, centerY])
        ]
    )
    [
        (preview_tile leftRoad (newWidth - 2))
        , (preview_tile rightRoad (newWidth - 2))
    ]

right_panel : Model -> Category -> Element Msg
right_panel model currentCategory = 
    Element.column 
    [
        width fill
        , height fill
        , centerX
        , scrollbarY
    ]
    (
        case currentCategory of
            Basics -> 
                -- game description
                [
                    Element.paragraph
                    ( fonts.fancyText ++ 
                        [
                            Font.size 15
                            , paddingEach {top = 0, right = 0, bottom = 0, left = 8}
                        ]
                    )
                    [
                        Element.el [Font.bold]
                        (Element.text ("Brutal Bulkwar"))
                        , Element.text (" is a Tower Defense game, where your goal is to protect the lives of civilians from hostile military. The game consists of ")
                        , Element.el [Font.bold]
                        (Element.text ("9"))
                        , Element.text (" levels, each with unique challenges and groups of enemies to overcome. The only way to stop incoming enemies is to build and upgrade ") 
                        , Element.el [Font.bold]
                        (Element.text ("Towers"))
                        , Element.text (" on a map. Every tower shoots projectiles over time, thereby injuring the invaders. After deafeating all enemies in a single level, you unlock a ")
                        , Element.el [Font.bold]
                        (Element.text ("New Level"))
                        , Element.text (" and your best score is saved on the ")
                        , Element.el [Font.bold]
                        (Element.text ("Scoreboard")) 
                        , Element.text (". The game ends after completing the final ninth level.")
                    ]
                ]

            Towers -> 
                -- tower buttons 
                [
                    Element.column 
                    [
                        width fill
                        , height fill
                        , spaceEvenly
                        , paddingXY 0 20
                    ]
                    [
                        tower_button 1 model 7
                        , tower_button 8 model 8
                        , tower_button 15 model 9
                    ]
                ]

            Enemies -> 
                -- enemy buttons
                [
                    Element.row
                    [
                        width fill
                        , height (px 100)
                        , spaceEvenly
                        , paddingEach {top = 20, right = 2, bottom = 0, left = 2}
                    ]
                    [
                        enemy_button 1 model 10
                        , enemy_button 2 model 11
                        , enemy_button 3 model 12
                    ]
                    , Element.row
                    [
                        width fill
                        , height (px 80)
                        , spaceEvenly
                        , paddingXY 2 0
                    ]
                    [
                        enemy_button 4 model 13
                        , enemy_button 5 model 14
                        , enemy_button 6 model 15
                    ]
                    , Element.row
                    [
                        width fill
                        , height (px 80)
                        , spaceEvenly
                        , paddingXY 38 0
                    ]
                    [
                        enemy_button 7 model 16
                        , enemy_button 8 model 17
                    ]

                ]

            Tips -> 
                -- tips description + advice
                [
                    Element.paragraph
                    ( fonts.fancyText ++ 
                        [
                            Font.size 15
                            , paddingEach {top = 0, right = 0, bottom = 0, left = 8}
                        ]
                    )
                    [
                        Element.text ("This page contains useful advice for beating the game and getting better score. If you still struggle completing levels while using these tips I suggest also reducing ")
                        , Element.el [Font.bold]
                        (Element.text ("Difficulty"))
                        , Element.text (".")
                    ]
                ]
    )

left_panel : Model -> Category -> Element Msg
left_panel model currentCategory = 
    Element.column 
    [
        width fill
        , height fill
        , paddingEach  {top = 10, right = 30, bottom = 5, left = 15}
        , case currentCategory of
            Basics -> spacing 14
            Towers -> spacing 2
            Enemies -> spacing 8
            Tips -> spacing 12
    ]
    (
        case currentCategory of
            Basics -> 
                [
                    -- lives explained
                    icon_text (420, 60) "icons/lives.svg" "Lives" False
                    [
                        (Element.text "When lives reach ")
                        , Element.el [Font.bold] 
                        (Element.text "0")
                        , (Element.text " you ")
                        , Element.el [Font.bold, Font.underline] 
                        (Element.text "Lose")
                        , (Element.text " the level")
                    ] [Font.color colors.greenYellow]
                    -- money explained
                    , icon_text (420, 60) "icons/money.svg" "Money" False
                    [
                        (Element.text "Used to ")
                        , Element.el [Font.bold, Font.underline] 
                        (Element.text "Buy")
                        , (Element.text " , ")
                        , Element.el [Font.bold, Font.underline] 
                        (Element.text "Upgrade")
                        , (Element.text " towers and ")
                        , Element.el [Font.bold, Font.underline] 
                        (Element.text "Clear")
                        , (Element.text " obstacles on map")
                    ] [Font.color colors.greenYellow]
                    -- waves explained
                    , icon_text (420, 60) "icons/waves.svg" "Waves" False
                    [
                        (Element.text "Defeating all enemies, therefore completing a wave rewards you with ")
                        , Element.el [Font.bold, Font.underline] 
                        (Element.text "Money")
                    ] [Font.color colors.greenYellow]
                    -- road end (flag) explained
                    , icon_text (420, 60) "map/road-flag.png" "Road\nEnd" False
                    [
                        (Element.text "This flag marks the destination of every enemy, enemies going beyond this point reduce ")
                        , Element.el [Font.bold, Font.underline] 
                        (Element.text "Lives")
                    ] [Font.color colors.greenYellow]
                    -- level speed label
                    , Element.el
                    ( fonts.regularTitle ++
                        [
                            width fill
                            , Font.size 24
                            , Font.extraBold
                            , Font.underline
                            , paddingEach {top = 10, right = 0, bottom = 0, left = 0}
                            , Border.color colors.brown
                            , Border.widthEach {top = 2, right = 0, bottom = 0, left = 0}
                        ]
                    )
                    (Element.text "Level Speed")
                    -- level speed icons and values
                    , Element.row
                    [
                        width fill
                        , height (px 40)
                        , spaceEvenly
                        , paddingEach {top = 10, right = 40, bottom = 0, left = 15}
                    ]
                    [
                        icon_text (200, 35) "icons/level_speed-0.svg" "0x" False [] [Font.color colors.greenYellow]
                        , icon_text (200, 35) "icons/level_speed-1.svg" "1x" False [] [Font.color colors.greenYellow]
                        , icon_text (200, 35) "icons/level_speed-2.svg" "2x" False [] [Font.color colors.greenYellow]
                        , icon_text (200, 35) "icons/level_speed-3.svg" "3x" True [] [Font.color colors.greenYellow]
                    ]
                ]

            Towers -> 
                let
                    currentTower = Array.get (model.objectIndex - 1) model.allTowers 
                    emptyTile = Tuple.second <| create_tile (0, 0) (Lot Nothing) 0 
                in
                case currentTower of
                    -- NO tower selected
                    Nothing ->
                        let
                            sellPercent = round <| Towers.sellMultiplier * 100
                        in
                        [
                            -- towers basic description
                            Element.paragraph
                            ( fonts.fancyText ++
                                [
                                    height (px 240)
                                    , width fill
                                    , paddingXY 0 5
                                    , Font.size 15
                                ]
                            )
                            [
                                Element.text ("Towers are your sole defense against incoming invaders. Each tower type has unique stats and projectile mechanics which provide advantages for damaging different types of enemies. You can upgrade any tower for a total of ")
                                , Element.el [Font.bold, Font.underline] 
                                (Element.text (String.fromInt Towers.maxTowerLevel))
                                , Element.text (" times. Upgrade cost increases with tower level. The final upgrade allows you to select one of 2 ")
                                , Element.el [Font.bold] 
                                (Element.text "Upgrade Paths")
                                , Element.text (". These upgrades provide vastly different stats and some even slightly change projectile mechanics of towers. Any tower upgrade is irreversible, therefore the only way to dispose of unwanted towers is to ")
                                , Element.el [Font.bold] 
                                (Element.text "Sell")
                                , Element.text (" them. Selling only returns ")
                                , Element.el [Font.bold] 
                                (Element.text (String.fromInt sellPercent ++ "%"))
                                , Element.text (" of money spent.")
                            ]
                            -- free plot showcase and explanation
                            ,  Element.row
                            [
                                width fill
                                , height (px 140)
                                , alignBottom
                                , paddingEach {top = 10, right = 5, bottom = 5, left = 5}
                            ]
                            [
                                Element.paragraph
                                ( fonts.regularText ++
                                    [
                                        height fill
                                        , width (px 300)
                                        , paddingXY 5 5
                                        , alignLeft
                                        , Font.size 15
                                    ]
                                )
                                [
                                    Element.text ("Towers can be placed anywhere on map with a free ")
                                    , Element.el [Font.bold] 
                                    (Element.text "Plot")
                                    , Element.text (" (see image). Some map tiles contain ")
                                    , Element.el [Font.bold] 
                                    (Element.text "Obstacles")
                                    , Element.text (" that can be cleared by selecting a tile and paying a certain amount of money. This cost depends on the ")
                                    , Element.el [Font.bold] 
                                    (Element.text "Type")
                                    , Element.text (" and ")
                                    , Element.el [Font.bold] 
                                    (Element.text "Size")
                                    , Element.text (" of selected obstacles.")
                                ]
                                , show_tile (100, 100) emptyTile [alignRight, centerY]
                            ]
                        ]

                    -- tower selected
                    Just t -> 
                        let
                            (towerName, towerDecription) = get_tower_description t

                            baseIndex = 
                                case t.class of
                                    Minigun -> 1
                                    Cannon -> 8
                                    RocketLauncher _ -> 15

                        in
                        [
                            Element.row
                            [
                                width fill
                                , height (px 150)
                                , paddingXY 5 10
                                , spacing 10
                            ]
                            [
                                -- tower image
                                show_tile (125, 125) emptyTile
                                [
                                    alignLeft
                                    , centerY
                                    , Element.inFront (preview_tower t 100 0 [centerX, centerY])
                                ]
                                , Element.column
                                [
                                    width fill
                                    , height fill
                                    , spacing 5
                                    , padding 5
                                ]
                                [
                                    -- tower name
                                    Element.el
                                    ( fonts.regularTitle ++ 
                                        [
                                            Font.size 22
                                            , Font.color colors.greenYellow
                                            , Font.alignLeft
                                            , padding 5
                                        ]
                                    )
                                    (Element.text towerName)
                                    -- tower description
                                    , Element.el
                                    ( fonts.regularText ++ 
                                        [
                                            width (px 260)
                                            , height (px 50)
                                            , Font.size 16
                                            , centerX
                                            , centerY
                                            , padding 5
                                            , Element.behindContent 
                                            (
                                                Element.el
                                                [
                                                    width fill
                                                    , height fill
                                                    , Background.color colors.white
                                                    , Border.width 2
                                                    , alpha 0.7
                                                ]
                                                (Element.none)
                                            )
                                        ]
                                    )
                                    (Element.paragraph [] [Element.text towerDecription])
                                    -- tower money cost
                                    , Element.row
                                    [
                                        width fill
                                        , height fill
                                        , spacing 10
                                        , paddingXY 30 0
                                    ]
                                    [
                                        Element.image
                                        [
                                            height (px 35)
                                            , width (px 35)
                                            , alignLeft
                                            , centerY
                                        ]
                                        {src = "/assets/ui/icons/money.svg", description = "icon-cost"}

                                        , Element.paragraph
                                        [
                                            Font.size 20
                                            , Font.alignLeft
                                            , centerY
                                        ]
                                        [
                                            Element.el
                                            ( fonts.regularTitle ++
                                                [
                                                    Font.color colors.black
                                                    , Font.extraBold
                                                    , centerY
                                                ]
                                            )
                                            (Element.text "Cost = ")
                                            , Element.el
                                            ( fonts.numberText ++
                                                [
                                                    Font.color colors.red
                                                    , centerY
                                                ]
                                            )
                                            (Element.text (String.fromInt (get_tower_price t <| get_upgrade_type t)))
                                        ]
                                    ]
                                ]
                            ]
                            -- tower level buttons
                            , Element.row
                            [
                                width fill
                                , height (px 50)
                                , spacing 12
                                , paddingEach {bottom = 5, left = 5, right = 5, top = 0}
                            ]
                            [
                                Element.el 
                                ( fonts.fancyTitle ++
                                    [
                                        width (px 75)
                                        , height fill
                                        , paddingEach {bottom = 0, left = 0, right = 0, top = 10}
                                        , Border.widthEach {bottom = 0, left = 0, right = 1, top = 0}
                                        , Font.size 22
                                        , Font.semiBold
                                        , Font.center 
                                        , Font.alignLeft
                                    ]
                                )
                                (Element.text "Levels")
                                , level_button baseIndex model 18
                                , level_button (baseIndex + 1) model 19
                                , level_button (baseIndex + 2) model 20
                                , level_button (baseIndex + 3) model 21
                                , level_button (baseIndex + 4) model 22
                                , level_button (baseIndex + 5) model 23
                                , level_button (baseIndex + 6) model 24
                            ]
                            -- tower stats
                            , Element.row
                            [
                                width fill
                                , height (px 50)
                                , paddingEach {top = 10, right = 10, bottom = 2, left = 10}
                                , spaceEvenly
                                , Border.widthEach {top = 3, right = 0, bottom = 0, left = 0}
                                , Border.color colors.dimBrown
                            ]
                            [
                                icon_text_description (180, 30) "damage.svg" ("Damage", String.fromInt t.projectileDamage, "damage to enemy per shot") False model 25 
                                , icon_text_description (210, 30) "armor_ignore.svg" ("Armor Ignore", String.fromInt t.projectileArmorIgnore, "armor bypass per shot") True model 26 
                            ]
                            , Element.row
                            [
                                width fill
                                , height (px 40)
                                , paddingEach {top = 2, right = 10, bottom = 2, left = 10}
                                , spaceEvenly
                            ]
                            [
                                icon_text_description (210, 30)  "attack_speed.svg" ("Fire-Rate", get_tower_fireRate t, "number of shots/projectiles per second") False model 27 
                                , icon_text_description (180, 30) "range.svg" ("Range", get_tower_range t, "range of tower (in tiles)") True model 28
                            ]
                            , Element.row
                            [
                                width fill
                                , height (px 40)
                                , paddingEach {top = 2, right = 10, bottom = 2, left = 10}
                                , spaceEvenly
                            ]
                            [
                                icon_text_description (210, 30)  "projectile_distance.svg" ("PR Distance", get_tower_projectileDistance t, "projectile travel distance (in tiles)") False model 29 
                                , icon_text_description (180, 30) "projectile_speed.svg" ("PR Speed", get_tower_projectileSpeed t, "projectile travel speed (tiles per second)") True model 30
                            ]
                            , Element.row
                            [
                                width fill
                                , height (px 40)
                                , paddingEach {top = 2, right = 10, bottom = 2, left = 10}
                                , spaceEvenly
                            ]
                            (
                                case t.class of
                                    RocketLauncher explosion_range ->
                                        [
                                            icon_text_description (210, 30)  "projectile_pierce.svg" ("Pierce", String.fromInt t.projectilePierce, "projectile pierce (max number of hit enemies)") False model 31
                                            , icon_text_description (180, 30) "explosion_range.svg" ("EX Range", String.fromFloat explosion_range, "range of missile explosion (in tiles)") True model 32
                                        ]

                                    _ ->
                                        [
                                            icon_text_description (210, 30)  "projectile_pierce.svg" ("Pierce", String.fromInt t.projectilePierce, "projectile pierce (max number of hit enemies)") True model 31 
                                        ]
                            )
                        ]

            Enemies -> 
                let
                    currentEnemy = Array.get (model.objectIndex - 1) model.allEnemies 
                    road_tile = Tuple.second <| create_tile (0, 0) Road 15 

                in
                case currentEnemy of
                    -- NO enemy selected
                    Nothing ->
                        [
                            -- enemy basic description
                            Element.paragraph
                            ( fonts.fancyText ++
                                [
                                    height (px 150)
                                    , width fill
                                    , paddingXY 0 5
                                    , Font.size 15
                                ]
                            )
                            [
                                Element.text ("Every enemy has the same objective of reaching the end of the road on map, therefore reducing your current ")
                                , Element.el [Font.bold] 
                                (Element.text "Lives")
                                , Element.text (". The amount of lives taken by enemies scales with their toughness. Enemies can also spawn with an ")
                                , Element.el [Font.bold] 
                                (Element.text "Offset")
                                , Element.text (", which determines their shift towards the ")
                                , Element.el [Font.bold] 
                                (Element.text "Left")
                                , Element.text (" or the ")
                                , Element.el [Font.bold] 
                                (Element.text "Right")
                                , Element.text (" side of the road. There are ")
                                , Element.el [Font.bold, Font.underline] 
                                (Element.text "2")
                                , Element.text (" types of enemies, depending on their movement:")

                            ]
                            , Element.row
                            [
                                height (px 145)
                                , width fill
                                , padding 5
                                , spacing 5
                            ]
                            [
                                Element.column
                                ( fonts.regularText ++
                                    [
                                        height fill
                                        , width (px 300)
                                        , alignLeft
                                        , Font.size 15
                                        , padding 5
                                        , spacing 10
                                    ]
                                )
                                [
                                    -- enemy type by movement
                                    Element.paragraph []
                                    [
                                        Element.el [Font.bold, Font.underline] 
                                        (Element.text "1. Ground Enemies")
                                        , Element.text (" - spawn directly on the road and move only along their current path towards the road end")
                                    ]
                                    , Element.paragraph []
                                    [
                                        Element.el [Font.bold, Font.underline] 
                                        (Element.text "2. Flying Enemies")
                                        , Element.text (" - spawn in the middle of a runway (see image) and move along the shortest flight path towards road end")
                                    ] 

                                ]
                                -- flying enemy spawn showcase
                                , Element.el
                                [
                                    height fill
                                    , width fill
                                    , alignRight

                                ]
                                (show_tile (100, 100) road_tile [centerX, alignTop])
                            ]
                            -- formula for damage received
                            , Element.row
                            [
                                height fill
                                , width fill
                                , paddingXY 10 0
                                , spacing 10
                            ]
                            [
                                Element.paragraph 
                                ( fonts.fancyText ++ 
                                    [
                                        height fill
                                        , Font.size 14
                                        , Font.alignLeft
                                    ]
                                )
                                [
                                   Element.text ("Whenever an enemy gets hit, the damage they receive is calculated in the following way:")
                                ] 
                                , Element.paragraph 
                                ( fonts.numberText ++ 
                                    [
                                        width (px 200)
                                        , height fill
                                        , Font.size 16
                                        , Font.center
                                        , Font.bold
                                        , paddingEach {top = 10 , right = 0, bottom = 0, left = 10}
                                        , Border.widthEach {top = 0, right = 0, bottom = 0, left = 1}
                                    ]
                                )
                                [
                                    Element.el [Font.color colors.red, paddingEach {top = 0, right = 0, bottom = 0, left = 25}]
                                    (Element.text ("TOWER DAMAGE"))
                                    , Element.el [paddingEach {top = 0, right = 25, bottom = 0, left = 0}]
                                    (Element.text " - ")
                                    , (Element.text "( ")
                                    , Element.el [Font.color colors.grey]
                                    (Element.text ("ENEMY ARMOR"))
                                    , (Element.text " - ")
                                    , Element.el [Font.color colors.orange, paddingEach {top = 0, right = 0, bottom = 0, left = 0}]
                                    (Element.text ("TOWER ARMOR IGNORE"))
                                    , (Element.text " )")
                                ] 
                            ]
                        ]

                    -- enemy selected
                    Just e -> 
                        [
                            Element.row
                            [
                                width fill
                                , height (px 100)
                                , paddingXY 20 5
                                , spacing 30
                                , Border.color colors.dimBrown
                                , Border.widthEach {top = 0, right = 0, bottom = 3, left = 0}
                            ]
                            [
                                show_enemy (160, 80) e [alignTop, alignLeft]
                                -- enemy name and type
                                , Element.column 
                                [
                                    width fill
                                    , height fill
                                    , spacing 10
                                    , paddingXY 0 5
                                ]
                                [
                                    Element.paragraph
                                    ( fonts.fancyTitle ++ 
                                        [
                                            width fill
                                            , Font.size 26
                                            , Font.alignLeft
                                            , Font.color colors.greenYellow
                                        ]
                                    )
                                    [(Element.text (get_enemy_name e))]
                                    , 
                                        case e.movement of
                                            Enemies.Ground -> icon_text (150, 30) "icons/enemy_ground.svg" "Ground" True [] [Font.color colors.black]
                                            Enemies.Flying -> icon_text (150, 30) "icons/enemy_flying.svg" "Flying" True [] [Font.color colors.black]
                                ]
                            ]
                            -- enemy stats
                            , Element.column 
                            [
                                width fill
                                , height fill
                                , paddingXY 50 10
                                , spacing 15
                            ]
                            [
                                icon_text_description (250, 40) "health.svg" ("Health", String.fromInt e.health, "enemy health") True model 33
                                , icon_text_description (250, 40) "armor.svg" ("Armor", String.fromInt e.armor, "enemy armor") True model 34
                                , icon_text_description (250, 40) "speed.svg" ("Speed", String.fromFloat e.speed, "enemy movment speed (tiles per second)") True model 35
                                , icon_text_description (250, 40) "lives.svg" ("Lives", String.fromInt e.lives, "lives taken by enemy") True model 36
                                , icon_text_description (250, 40) "money.svg" ("Reward", String.fromInt e.reward, "money earned after deafeating enemy") True model 37
                                
                            ]

                    
                        ]

            Tips -> 
                -- list of tips (6 total)
                [
                    tip_text (420, 55) 1
                    [
                        (Element.text "You shouldn't ")
                        , Element.el [Font.bold]
                        (Element.text "Clear Obstacles")
                        , (Element.text " on spots where you don't want to place towers")
                    ]
                    , tip_text (420, 55) 2
                    [
                        (Element.text "You can perform any action while the ")
                        , Element.el [Font.bold]
                        (Element.text "Level Speed")
                        , (Element.text " is set to ")
                        , Element.el [Font.bold, Font.underline]
                        (Element.text "0")
                    ]
                    , tip_text (420, 55) 3
                    [
                        (Element.text "Setting you target to ")
                        , Element.el [Font.bold] 
                        (Element.text "Strong")
                        , (Element.text " or ")
                        , Element.el [Font.bold] 
                        (Element.text "Close")
                        , (Element.text " makes it easier for certain towers to hit enemies")
                    ]
                    , tip_text (420, 55) 4
                    [
                        (Element.text "Towers with levels ")
                        , Element.el [Font.bold]
                        (Element.text "1")
                        , (Element.text " or ")
                        , Element.el [Font.bold]
                        (Element.text "MAX")
                        , (Element.text " have the best ")
                        , Element.el [Font.bold, Font.underline] 
                        (Element.text "Cost Efficiency")
                        , (Element.text " (damage per money spent)")
                    ]
                    , tip_text (420, 55) 5
                    [
                        Element.el [Font.bold]
                        (Element.text "Upgrading")
                        , (Element.text " any tower resets its firing cooldown, making it shoot instantly")
                    ]

                    , tip_text (420, 55) 6
                    [
                        Element.el [Font.bold]
                        (Element.text "Level Speed")
                        , (Element.text " influences timer for completing levels, therefore ")
                        , Element.el [Font.bold, Font.underline]
                        (Element.text "Higher")
                        , (Element.text " speed means ")
                        , Element.el [Font.bold, Font.underline]
                        (Element.text "Better")
                        , (Element.text " clear time")
                    ]
                ]
    )

view : Model -> Html Msg
view model = 
    let
        currentCategory = index_to_category model.categoryIndex 
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
                        , Style.panel_button_inactive (150, 60, 15) "Guide" 
                        , Style.panel_button (150, 60, 20) "Settings" (model.buttonHoverID == 4) (hover_events 4) 
                    ]
                    , Element.row
                    [
                        width fill
                        , height fill
                        , padding 15
                    ]
                    [
                        -- left panel
                        Element.el
                        [
                            width fill
                            , height fill
                            , alignLeft
                            , Element.behindContent
                            (
                                Element.image
                                [
                                    width (px 460)
                                    , centerX
                                    , centerY
                                    , moveUp 5
                                    , moveLeft 10
                                ]
                                {src = "/assets/ui/panel_info.svg", description = "panel_Info"}
                                
                            )
                        ]
                        (left_panel model currentCategory)
                        
                        -- right panel 
                        , Element.column
                        [
                            width (px 220)
                            , height fill
                            , alignRight
                            , paddingEach {top = 0, right = 0, bottom = 5, left = 10}
                            , spacing 10
                        ]
                        
                        [
                            Element.row
                            [
                                width fill
                                , height (px 65)
                                , centerX
                            ]
                            [
                                arrow_button -1 model 5
                                , Element.el
                                ( fonts.fancyTitle ++
                                    [
                                        Font.size 28
                                        , Font.extraBold
                                        , centerX
                                        , Font.glow colors.dimGreen 2 
                                        , Font.underline
                                    ]
                                )
                                (Element.text (category_to_str currentCategory))
                                , arrow_button 1 model 6
                            ]   
                            , right_panel model currentCategory
                        ]
                    ]
                ]
            )
        )
