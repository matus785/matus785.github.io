module Game.Towers exposing (..)

import Element exposing (..)
import Game.TwoD.Render as Render exposing (Renderable)
import Game.Resources as Resources exposing (Resources)

towerBodyLayer : Float
towerBodyLayer = -0.96

towerBaseLayer : Float
towerBaseLayer = -0.97

towerBaseSize : Float
towerBaseSize = 0.85

sellMultiplier : Float
sellMultiplier = 0.75

hitTimer : Float
hitTimer = 0.05

hitTimerLong : Float
hitTimerLong = 0.08

maxTowerLevel : Int
maxTowerLevel = 5

type Tower_type = 
    Minigun                 -- Bullet projectiles
    | Cannon                -- Cannonball projectiles
    | RocketLauncher Float  -- Missile projectiles (Float = size of Explosion in tiles)

type Upgrade_type = 
    Top
    | Bottom
    | NoPath

type Target = 
    First 
    | Strong
    | Weak
    | Close
    | Flying

type alias Tower = {
    class : Tower_type
    , targeting : Target
    , textureBody : String 
    , textureBase : String 
    , level : Int               -- upgrade level, 0 = tower is NOT placed yet
    , posXY : (Float, Float)
    , offsetY : Float           -- body offset on Y axis
    , rotation : Float      
    , size : Float
    , price : (Int, Int)        -- upgrade cost to current level (NoPath/Top price | Bottom price)
    , sellValue : Int
    , range : Float     
    , fireRate : Float          -- cooldown for firing projectiles in seconds
    , lastShot : Float          -- timer for firing projectiles in seconds
    -- Projectile Stats
    , projectileDamage : Int
    , projectileArmorIgnore : Int
    , projectileSpeed : Float
    , projectileLifetime : Float
    , projectilePierce : Int
    , projectileOffsetX : Float -- projectile spawn offset on Y axis of tower
    }

create_tower : String -> Float -> Tower
create_tower towertype mult = 
    let
        towerClass = 
            case towertype of
                "minigun" -> Minigun
                "cannon" -> Cannon
                "rocketlauncher" -> RocketLauncher 0
                _ -> Minigun

    in
    case towerClass of 
        Minigun -> { 
            class = Minigun 
            , textureBody = "/assets/towers/minigun.png"
            , textureBase = "/assets/towers/base-pointy.png"
            , offsetY = 0.35
            , size = 0.65
            , price = (round (100 * mult), 0)
            , range = 1.75
            , fireRate = 1.2
            , projectileDamage = 12
            , projectileArmorIgnore = 0
            , projectileSpeed = 0 
            , projectileLifetime = hitTimer
            , projectilePierce = 1
            , projectileOffsetX = 0.1
            , targeting = First
            , level = 0
            , posXY = (0, 0)
            , rotation = 0
            , lastShot = 0
            , sellValue = 0
            }
        Cannon -> { 
            class = Cannon
            , textureBody = "/assets/towers/cannon.png"
            , textureBase = "/assets/towers/base-squared.png"
            , offsetY = 0.2
            , size = 0.8
            , price = (round (150 * mult), 0)
            , range = 2.15
            , fireRate = 2
            , projectileDamage = 22
            , projectileArmorIgnore = 4 
            , projectileSpeed = 4
            , projectileLifetime = 0.8
            , projectilePierce = 2
            , projectileOffsetX = 0
            , targeting = First
            , level = 0
            , posXY = (0, 0)
            , rotation = 0
            , lastShot = 0
            , sellValue = 0
            }
        RocketLauncher _ -> { 
            class = RocketLauncher 1.15
            , textureBody = "/assets/towers/rocketlauncher.png"
            , textureBase = "/assets/towers/base-combined.png"
            , offsetY = 0.12
            , size = 0.6
            , price = (round (180 * mult), 0)
            , range = 2.75
            , fireRate = 2.2
            , projectileDamage = 18
            , projectileArmorIgnore = 2
            , projectileSpeed = 6
            , projectileLifetime = 0.5
            , projectilePierce = 5
            , projectileOffsetX = 0
            , targeting = First
            , level = 0
            , posXY = (0, 0)
            , rotation = 0
            , lastShot = 0
            , sellValue = 0
            }

get_tower_name : Tower -> String
get_tower_name tower = 
    case tower.class of
        Minigun -> "minigun"
        Cannon -> "cannon"
        RocketLauncher _ -> "rocketlauncher"

get_upgrade_type : Tower -> Upgrade_type
get_upgrade_type tower = 
    case tower.level of
        8 -> Top
        7 -> Bottom
        _ -> NoPath

get_tower_price : Tower -> Upgrade_type -> Int
get_tower_price tower path = 
    case path of
        NoPath -> Tuple.first tower.price
        Top -> Tuple.first tower.price 
        Bottom -> Tuple.second tower.price

get_targeting_name : Tower -> String
get_targeting_name tower = 
    case tower.targeting of
        First -> "FIRST"
        Strong -> "STRONG"
        Weak -> "WEAK"
        Close -> "CLOSE"
        Flying -> "FLYING"

-- get_tower_center -> returns spawn position of projectile, moved to LEFT or RIGHT from tower center by projectileOffsetX
get_tower_center : Tower -> (Float, Float )
get_tower_center tower = 
    let
        centerX = Tuple.first tower.posXY + 0.5
        centerY = Tuple.second tower.posXY + 0.5

        -- move center on X axis of tower
        offsetX = (sin (tower.rotation + pi / 2)) * tower.projectileOffsetX
        offsetY = (cos (tower.rotation + pi / 2)) * tower.projectileOffsetX
    in
    (centerX + offsetX, centerY + offsetY)

-- set_cooldown => reduces lastShot of tower by dt and changes texture of RocketLauncher 
set_cooldown : Tower -> Float -> Tower
set_cooldown tower dt = 
    let
        newTime = 
            if (tower.lastShot > 0) then tower.lastShot - dt
            else tower.lastShot

        newTexture = 
            case tower.class of
                RocketLauncher _ -> 
                    let
                        ready = newTime <= (tower.fireRate * 0.2)
                    in
                    case (get_upgrade_type tower) of
                        NoPath -> 
                            if (ready) then "/assets/towers/rocketlauncher.png"
                            else "/assets/towers/rocketlauncher-e.png"

                        Top ->
                            if (ready) then "/assets/towers/rocketlauncher-1.png"
                            else "/assets/towers/rocketlauncher-1e.png"

                        Bottom ->
                            if (ready) then "/assets/towers/rocketlauncher-2.png"
                            else if (tower.projectileOffsetX > 0) then "/assets/towers/rocketlauncher-2el.png"
                            else "/assets/towers/rocketlauncher-2er.png"
                    
                _ -> tower.textureBody
        
    in
    {tower | lastShot = newTime, textureBody = newTexture}

change_offset : Tower -> Tower
change_offset tower = 
    let
        newOffset = negate tower.projectileOffsetX   
    in
    {tower | projectileOffsetX = newOffset}

can_rotate : Tower -> Bool
can_rotate tower =
    case tower.class of
        -- Minigun cannot rotate if its projectile is on map
        Minigun -> 
            if (tower.fireRate - tower.lastShot <= tower.projectileLifetime) then False
            else True

        _ -> True

-- increase_level => increases level of tower, calculates upgrade price and sets lastShot (shooting cooldown) to 0
-- mult = price multiplier dependent on difficulty
-- Level 7 and 8 are special upgrade paths with different tower sprites (2 paths per tower class)
increase_level : Tower -> Upgrade_type -> Float -> Tower
increase_level tower path mult = 
    let
        newValue = tower.sellValue + round (toFloat (get_tower_price tower path) * sellMultiplier)
    in
    case path of
        NoPath -> 
            case tower.level of
                -- tower level 1
                0 -> {tower | level = 1, sellValue = newValue}

                -- tower level 2
                1 -> 
                    case tower.class of
                        Minigun ->
                            { tower | level = 2, sellValue = newValue, price = (round (50 * mult), 0), lastShot = 0
                                , range = 1.9
                                , fireRate = 1.05
                                , projectileDamage = 14
                            }
                        Cannon ->
                            { tower | level = 2, sellValue = newValue, price = (round (60 * mult), 0), lastShot = 0
                                , range = 2.3
                                , fireRate = 1.9
                                , projectileDamage = 24
                                , projectileArmorIgnore = 6
                                , projectileSpeed = 4.3
                                , projectileLifetime = 0.85
                                
                            }
                        RocketLauncher _ ->
                            { tower | level = 2, sellValue = newValue, price = (round (70 * mult), 0), lastShot = 0
                                , class = RocketLauncher 1.3
                                , range = 2.8
                                , fireRate = 2
                                , projectileDamage = 20
                                , projectileArmorIgnore = 3
                                , projectileSpeed = 6.5
                            }
                    
                -- tower level 3
                2 -> 
                    case tower.class of
                        Minigun ->
                            { tower | level = 3, sellValue = newValue, price = (round (60 * mult), 0), lastShot = 0
                                , range = 2
                                , fireRate = 0.9
                                , projectileDamage = 14
                                , projectileArmorIgnore = 1
                            }
                        Cannon ->
                            { tower | level = 3, sellValue = newValue, price = (round (75 * mult), 0), lastShot = 0
                                , range = 2.45
                                , fireRate = 1.8
                                , projectileDamage = 26
                                , projectileArmorIgnore = 8
                                , projectilePierce = 3
                                , projectileSpeed = 4.6
                                , projectileLifetime = 0.9
                            }
                        RocketLauncher _ ->
                            { tower | level = 3, sellValue = newValue, price = (round (80 * mult), 0), lastShot = 0
                                , class = RocketLauncher 1.4
                                , range = 2.85
                                , fireRate = 1.8
                                , projectileDamage = 22
                                , projectileArmorIgnore = 4
                                , projectilePierce = 6
                                , projectileSpeed = 7
                            }

                -- tower level 4
                3 -> 
                    case tower.class of
                        Minigun ->
                            { tower | level = 4, sellValue = newValue, price = (round (75 * mult), 0), lastShot = 0
                                , range = 2.1
                                , fireRate = 0.75
                                , projectileDamage = 16
                                , projectileArmorIgnore = 1
                            }
                        Cannon ->
                            { tower | level = 4, sellValue = newValue, price = (round (90 * mult), 0), lastShot = 0
                                , range = 2.6
                                , fireRate = 1.6
                                , projectileDamage = 32
                                , projectileArmorIgnore = 10
                                , projectilePierce = 3
                                , projectileSpeed = 5
                                , projectileLifetime = 0.95
                            }
                        RocketLauncher _ ->
                            { tower | level = 4, sellValue = newValue, price = (round (100 * mult), 0), lastShot = 0
                                , class = RocketLauncher 1.5
                                , range = 2.9
                                , fireRate = 1.7
                                , projectileDamage = 26
                                , projectileArmorIgnore = 5
                                , projectilePierce = 7
                                , projectileSpeed = 7.5
                            }

                -- tower level 5
                4 -> 
                    case tower.class of
                        Minigun ->
                            { tower | level = 5, sellValue = newValue, price = (round (100 * mult), 0), lastShot = 0
                                , range = 2.3
                                , fireRate = 0.6
                                , projectileDamage = 20
                                , projectileArmorIgnore = 2
                            }
                        Cannon ->
                            { tower | level = 5, sellValue = newValue, price = (round (115 * mult), 0), lastShot = 0
                                , range = 3.3
                                , fireRate = 1.4
                                , projectileDamage = 38
                                , projectileArmorIgnore = 12
                                , projectilePierce = 3
                                , projectileSpeed = 5.6
                                , projectileLifetime = 1
                            }
                        RocketLauncher _ ->
                            { tower | level = 5, sellValue = newValue, price = (round (120 * mult), 0), lastShot = 0
                                , class = RocketLauncher 1.6
                                , range = 3
                                , fireRate = 1.6
                                , projectileDamage = 32
                                , projectileArmorIgnore = 6
                                , projectilePierce = 8
                                , projectileSpeed = 8
                            }

                -- ERROR
                _ -> tower

        Top -> 
            case tower.class of 
                Minigun -> 
                    { tower | level = 8, sellValue = newValue, price = (round (220 * mult), round (200 * mult)), lastShot = 0
                        , textureBody = "/assets/towers/minigun-1.png"
                        , size = 0.8
                        , offsetY = 0.40
                        , projectileOffsetX = 0
                        , range = 4.5
                        , fireRate = 1.8
                        , projectileDamage = 120
                        , projectileArmorIgnore = 4
                        , projectileLifetime = hitTimerLong
                    }

                Cannon -> 
                    { tower | level = 8, sellValue = newValue, price = (round (240 * mult), round (220 * mult)), lastShot = 0
                        , textureBody = "/assets/towers/cannon-1.png"
                        , size = 0.95
                        , offsetY = 0.25
                        , range = 3.5
                        , fireRate = 1.4
                        , projectileDamage = 64
                        , projectileArmorIgnore = 20
                        , projectilePierce = 4
                        , projectileSpeed = 6
                        , projectileLifetime = 1
                    }

                RocketLauncher _ -> 
                    { tower | level = 8, sellValue = newValue, price = (round (280 * mult), round (300 * mult)), lastShot = 0
                        , class = RocketLauncher 2.2
                        , textureBody = "/assets/towers/rocketlauncher-1.png"
                        , size = 0.68
                        , offsetY = 0.18
                        , range = 3
                        , fireRate = 1.8
                        , projectileDamage = 60
                        , projectileArmorIgnore = 8
                        , projectilePierce = 10
                        , projectileSpeed = 8
                        , projectileLifetime = 0.4
                    }

        Bottom -> 
            case tower.class of 
                Minigun -> 
                    { tower | level = 7, sellValue = newValue, price = (round (220 * mult), round (200 * mult)), lastShot = 0
                        , textureBody = "/assets/towers/minigun-2.png"
                        , size = 0.75
                        , offsetY = 0.4
                        , projectileOffsetX = 0.1
                        , range = 2.5
                        , fireRate = 0.3
                        , projectileDamage = 22
                        , projectileArmorIgnore = 2
                    }

                Cannon -> 
                    { tower | level = 7, sellValue = newValue, price = (round (240 * mult), round (220 * mult)), lastShot = 0
                        , textureBody = "/assets/towers/cannon-2.png"
                        , size = 0.9
                        , offsetY = 0.28
                        , projectileOffsetX = 0.095
                        , range = 3
                        , fireRate = 0.5
                        , projectileDamage = 30
                        , projectileArmorIgnore = 16
                        , projectilePierce = 2
                        , projectileSpeed = 9
                        , projectileLifetime = 0.5
                    }

                RocketLauncher _ -> 
                    { tower | level = 7, sellValue = newValue, price = (round (280 * mult), round (300 * mult)), lastShot = 0
                        , class = RocketLauncher 1
                        , textureBody = "/assets/towers/rocketlauncher-2.png"
                        , size = 0.85
                        , offsetY = 0.35
                        , projectileOffsetX = 0.12
                        , range = 4
                        , fireRate = 1
                        , projectileDamage = 40
                        , projectileArmorIgnore = 12
                        , projectilePierce = 5
                        , projectileSpeed = 8
                        , projectileLifetime = 0.75
                    }

------------------------------------------------
-- Projectile Stats
------------------------------------------------

get_projectile_texture : Tower -> Upgrade_type -> String
get_projectile_texture tower upgradePath = 
    case tower.class of
        Minigun -> 
            case upgradePath of
                NoPath -> "/assets/projectiles/bullet.png"
                Top -> "/assets/projectiles/bullet-tall.png"
                Bottom -> "/assets/projectiles/bullet-wide.png"

        Cannon -> 
            case upgradePath of
                NoPath -> "/assets/projectiles/cannonball.png"
                Top -> "/assets/projectiles/cannonball-black.png"
                Bottom -> "/assets/projectiles/cannonball-white.png" 

        RocketLauncher _ -> 
             case upgradePath of
                NoPath -> "/assets/projectiles/missile.png"
                Top -> "/assets/projectiles/missile-big.png"
                Bottom -> "/assets/projectiles/missile.png"

get_projectile_hitbox : Tower -> Upgrade_type -> (Float, Float)
get_projectile_hitbox tower upgradePath = 
    case tower.class of
        Minigun -> 
            case upgradePath of
                NoPath -> (0.1, 0.35)
                Top -> (0.2, 0.55) 
                Bottom -> (0.28, 0.45)

        Cannon -> 
            case upgradePath of
                NoPath -> (0.25, 0.25)
                Top -> (0.28, 0.28)
                Bottom -> (0.19, 0.19)

        RocketLauncher _ -> 
             case upgradePath of
                NoPath -> (0.22, 0.52)
                Top -> (0.3, 0.56)
                Bottom -> (0.24, 0.54)

get_projectile_distance : Tower -> Upgrade_type -> Float
get_projectile_distance tower upgradePath =
    case tower.class of
        Minigun -> 
            case upgradePath of
                NoPath -> 0.74
                Top -> 1
                Bottom -> 0.9

        Cannon -> 
            case upgradePath of
                NoPath -> 0.68
                Top -> 0.85
                Bottom -> 0.8

        RocketLauncher _ -> 
             case upgradePath of
                NoPath -> 0.12
                Top -> 0.18
                Bottom -> 0.44

------------------------------------------------
-- Rendering
------------------------------------------------

render_all_towers : List Tower -> Resources -> List Renderable
render_all_towers towers res =
    List.map (\o -> render_base o res) towers 
    ++ List.map (\o -> render_body o res) towers

render_body : Tower -> Resources -> Renderable
render_body tower res =  
    Render.spriteWithOptions 
    {
        position = (Tuple.first tower.posXY + 0.5, Tuple.second tower.posXY + 0.5, towerBodyLayer)
        , size = (tower.size, tower.size)
        , texture = Resources.getTexture tower.textureBody res
        , rotation = negate (tower.rotation)
        , pivot = (0.5, 0.5 - (tower.offsetY))
        , tiling = (1, 1)
    }

render_base : Tower ->  Resources -> Renderable
render_base tower res =  
    Render.spriteWithOptions 
    {
        position = (Tuple.first tower.posXY + 0.5, Tuple.second tower.posXY + 0.5, towerBaseLayer)
        , size = (towerBaseSize, towerBaseSize)
        , texture = Resources.getTexture tower.textureBase res
        , rotation = 0
        , pivot = (0.5, 0.5)
        , tiling = (1, 1)
    }

preview_tower : Tower -> Int -> Int -> List (Element.Attribute msg) -> Element msg
preview_tower tower tileSize height listAttr =
    let
        bodyOffset = (toFloat tileSize) * (tower.offsetY)

        previewAttr = 
            -- tower preview on map (for buying tower) 
            if (List.isEmpty listAttr) then
                let
                    newX = (toFloat tileSize) * Tuple.first tower.posXY 
                    newY = (toFloat tileSize) * ((Tuple.second tower.posXY) - (toFloat height) + 1)
                in
                [
                    alpha 0.5
                    -- apply offset to tower body
                    , moveRight newX
                    , moveUp newY
                ]

            else [moveDown (bodyOffset * 0.4)]
    in
    -- tower base
    Element.image 
    ( listAttr ++ previewAttr ++
        [
            Element.height (px tileSize)
            , Element.width (px tileSize)
            , scale towerBaseSize
            -- tower body
            , Element.inFront 
            ( 
                Element.image 
                [
                    Element.height (px tileSize)
                    , Element.width (px tileSize)
                    , scale (tower.size / towerBaseSize)
                    , moveUp (bodyOffset * towerBaseSize)
                ]
                {src = tower.textureBody, description = "body-" ++ get_tower_name tower}
            )
        ] 
    )
    {src = tower.textureBase, description = "base-" ++ get_tower_name tower}

preview_tower_range : Tower -> Int -> Int -> Element msg
preview_tower_range tower tileSize height  = 
    let
        x = Tuple.first tower.posXY     
        y = Tuple.second tower.posXY - (toFloat height) + 1
    in
    Element.image 
    [
        Element.height (px tileSize)
        , Element.width (px tileSize)
        , scale (tower.range * 2)
        , moveUp ((toFloat tileSize) * y) 
        , moveRight ((toFloat tileSize) * x)
        , alpha 0.25
    ]
    {src = "/assets/ui/map/range_circle.svg", description = "range-" ++ get_tower_name tower}

------------------------------------------------
-- User Interface
------------------------------------------------

get_tower_description : Tower -> (String, String)
get_tower_description tower = 
    let
        path = get_upgrade_type tower

        fancyName = 
            case tower.class of
                Minigun -> 
                    case path of
                        NoPath -> "Minigun"
                        Top -> "Flak Gun"
                        Bottom -> "Machine Gun"

                Cannon -> 
                    case path of
                        NoPath -> "Cannon"
                        Top -> "Artillery"
                        Bottom -> "Autocannon"

                RocketLauncher _ -> 
                    case path of
                        NoPath -> "Rocket Launcher"
                        Top -> "Heavy Mortar"
                        Bottom -> "Missile Battery"

        description =
            case tower.class of
                Minigun -> 
                    case path of
                        NoPath -> "Never misses, but it cannot hit more than one enemy."
                        Top -> "High damage and range, but slow fire-rate."
                        Bottom -> "Fast fire-rate, but short range and low damage." 

                Cannon -> 
                    case path of
                        NoPath -> "Capable of hitting multiple enemies in a straight line."
                        Top -> "Better pierce and damage, but slow projectile speed."
                        Bottom -> "High fire-rate and projectile speed, but less pierce."
                        
                RocketLauncher _ -> 
                    case path of
                        NoPath -> "Its projectiles explode on contact and hit multiple nearby enemies."
                        Top -> "Its projectiles explode when they hit an enemy or when they expire."
                        Bottom -> "Its projectiles explode and damage a single enemy on contact."
    in
    (fancyName, description)

get_tower_projectileSpeed : Tower -> String
get_tower_projectileSpeed tower = 
    case tower.class of
        Minigun -> " ✘ "
        _ -> String.left 3 <| String.fromFloat tower.projectileSpeed

get_tower_fireRate : Tower -> String
get_tower_fireRate tower = 
    let
        shotsPerSecond = 1 / tower.fireRate
    in
    String.left 4 <| String.fromFloat shotsPerSecond

get_tower_range : Tower -> String
get_tower_range tower = 
    let
        actualRange = tower.range - 0.4999
    in
    String.left 4 <| String.fromFloat actualRange

get_tower_projectileDistance : Tower -> String 
get_tower_projectileDistance tower = 
    case tower.class of
        Minigun -> " ✘ "
        _ -> String.left 4 <| String.fromFloat (tower.projectileLifetime * tower.projectileSpeed)

get_tower_level : Tower -> String
get_tower_level tower = 
    case get_upgrade_type tower of 
        NoPath -> 
            case tower.level of 
                1 -> "Ⅰ"
                2 -> "Ⅱ"
                3 -> "Ⅲ"
                4 -> "Ⅳ"
                5 -> "Ⅴ"
                _ -> ""
        Top -> "★"
        Bottom -> "✦"
