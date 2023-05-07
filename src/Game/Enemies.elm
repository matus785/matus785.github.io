module Game.Enemies exposing (..)

import Array exposing (..) 
import Game.TwoD.Render as Render exposing (Renderable)
import Game.Resources as Resources exposing (Resources)
import Element exposing (..)

import Game.Calculations exposing (..)

healthbarLayer : Float
healthbarLayer = 0.0001

heathbarHeight : Float
heathbarHeight = 0.2

heathbarOffset : Float
heathbarOffset = 0.05

-- layer interval = <-0.95 , 0)

type Enemy_type = 
    Scout
    | Soldier 
    | Warrior
    | Veteran
    | Tank
    | HeavyTank
    | Plane
    | HeavyPlane

type Movement = 
    Ground
    | Flying

type alias Enemy = { 
    class : Enemy_type
    , movement : Movement   
    , texture : String 
    , layer : Float                             -- unique layer value for rendering, also enemy index
    , posXY : (Float, Float)   
    , offset : Float                            -- spawn offset <-0.4 , 0.4> 
    , rotation : Float          
    , hitbox : (Float, Float)                   -- width and length of Enemy hitbox, bigger value of hitbox is also the size of enemy texture
    , nextPoint : (Int, Maybe (Float, Float))   -- (index of next point | X and Y position of next point)
    , speed : Float
    , health : Int
    , healthMax : Float                         -- starting health (for showing health bar)
    , armor : Int
    , reward : Int
    , lives : Int
    , hitIndex : List Float                     -- list of projectile indexes, that already hit this enemy
    , healthbarDistance : Float                 -- distance of health bar from enemy on Y axis
    }

type alias Wave = { 
    waveNumber : Int 
    , currentTime : Float
    , reward : Int
    , enemies : List (Float, Enemy)
    }

-- create_enemy => returns Tuple with enemy spawn time and record values of enemy according to Enemy_type
-- spawnOffset = enemy spawn offset, applied to posXY in function place_enemy
create_enemy : Enemy_type -> Float -> Float -> (Float , Enemy)
create_enemy enemyType spawnOffset spawnTime = 
    let
        newOffset = clamp -0.4 0.4 spawnOffset


        
        enemy = 
            case enemyType of
                Scout -> { 
                    class = Scout
                    , movement = Ground
                    , texture = "/assets/enemies/scout.png"
                    , hitbox = (0.4, 0.3)
                    , speed = 3.6
                    , health = 20
                    , armor = 0
                    , reward = 8
                    , lives = 1
                    , layer = 0
                    , posXY = (0, 0)
                    , offset = newOffset
                    , rotation = 0
                    , nextPoint = (0, Nothing)
                    , healthMax = 0
                    , hitIndex = []
                    , healthbarDistance = 0
                    }

                Soldier -> { 
                    class = Soldier
                    , movement = Ground
                    , texture = "/assets/enemies/soldier.png"
                    , hitbox = (0.5, 0.28)
                    , speed = 2.4
                    , health = 50
                    , armor = 2
                    , reward = 10
                    , lives = 1
                    , layer = 0
                    , posXY = (0, 0)
                    , offset = newOffset
                    , rotation = 0
                    , nextPoint = (0, Nothing)
                    , healthMax = 0
                    , hitIndex = []
                    , healthbarDistance = 0
                    }

                Warrior -> { 
                    class = Warrior
                    , movement = Ground
                    , texture = "/assets/enemies/warrior.png"
                    , hitbox = (0.52, 0.34)
                    , health = 120
                    , armor = 6
                    , speed = 1.8
                    , reward = 14
                    , lives = 1
                    , layer = 0
                    , posXY = (0, 0)
                    , offset = newOffset
                    , rotation = 0
                    , nextPoint = (0, Nothing)
                    , healthMax = 0
                    , hitIndex = []
                    , healthbarDistance = 0
                    }

                Veteran -> { 
                    class = Veteran
                    , movement = Ground
                    , texture = "/assets/enemies/veteran.png"
                    , hitbox = (0.56, 0.36)
                    , health = 180
                    , armor = 10
                    , speed = 2.2
                    , reward = 20
                    , lives = 1
                    , layer = 0
                    , posXY = (0, 0)
                    , offset = newOffset
                    , rotation = 0
                    , nextPoint = (0, Nothing)
                    , healthMax = 0
                    , hitIndex = []
                    , healthbarDistance = 0
                    }
                    
                Tank -> { 
                    class = Tank
                    , movement = Ground
                    , texture = "/assets/enemies/tank-light.png"
                    , hitbox = (0.54, 0.8)
                    , health = 450
                    , armor = 26
                    , speed = 1.4
                    , reward = 30
                    , lives = 2
                    , layer = 0
                    , posXY = (0, 0)
                    , offset = newOffset
                    , rotation = 0
                    , nextPoint = (0, Nothing)
                    , healthMax = 0
                    , hitIndex = []
                    , healthbarDistance = 0
                    }

                HeavyTank -> { 
                    class = HeavyTank
                    , movement = Ground
                    , texture = "/assets/enemies/tank-heavy.png"
                    , hitbox = (0.54, 0.85)
                    , health = 600
                    , armor = 34
                    , speed = 1.2
                    , reward = 38
                    , lives = 2
                    , layer = 0
                    , posXY = (0, 0)
                    , offset = newOffset
                    , rotation = 0
                    , nextPoint = (0, Nothing)
                    , healthMax = 0
                    , hitIndex = []
                    , healthbarDistance = 0
                    }

                Plane -> { 
                    class = Plane
                    , movement = Flying
                    , texture = "/assets/enemies/plane-light.png"
                    , hitbox = (0.85, 0.68)
                    , health = 800
                    , armor = 12
                    , speed = 0.8
                    , reward = 42
                    , lives = 3
                    , layer = 0
                    , posXY = (0, 0)
                    , offset = newOffset
                    , rotation = 0
                    , nextPoint = (0, Nothing)
                    , healthMax = 0
                    , hitIndex = []
                    , healthbarDistance = 0
                    }

                HeavyPlane -> { 
                    class = HeavyPlane
                    , movement = Flying
                    , texture = "/assets/enemies/plane-heavy.png"
                    , hitbox = (0.95, 0.78)
                    , health = 1200
                    , armor = 18
                    , speed = 0.6
                    , reward = 50
                    , lives = 3
                    , layer = 0
                    , posXY = (0, 0)
                    , offset = newOffset
                    , rotation = 0
                    , nextPoint = (0, Nothing)
                    , healthMax = 0
                    , hitIndex = []
                    , healthbarDistance = 0
                    }
    in
    (spawnTime, enemy)

create_wave : Int -> Int -> List (Float, Enemy) -> Wave
create_wave waveNumber money enemyList = 
    {
        waveNumber = waveNumber
        , currentTime = 0 
        , reward = money
        , enemies = enemyList
    }

get_enemy_name : Enemy -> String
get_enemy_name enemy = 
    case enemy.class of
        Scout -> "Scout"
        Soldier -> "Soldier"
        Warrior -> "Armored Soldier"
        Veteran -> "Veteran"
        Tank -> "Tank"
        HeavyTank-> "Armored Tank"
        Plane -> "Aircraft"
        HeavyPlane -> "Armored Aircraft"

enemy_can_spawn : (Float, Enemy) -> Float -> Bool
enemy_can_spawn enemy time =
    (Tuple.first enemy) <= time

enemy_in_range : Enemy -> (Float, Float) -> Float -> Bool
enemy_in_range enemy (x,y) range = 
    (distance_of_2points enemy.posXY (x,y)) <= range

enemy_can_be_hit : Enemy -> Float -> Bool
enemy_can_be_hit enemy index = 
    not (List.member index enemy.hitIndex)

-- set_healthbar_distance => calculates Y distance of healthbar from enemy
set_healthbar_distance : Enemy -> Enemy
set_healthbar_distance enemy = 
    let
        enemyWidth = Tuple.first enemy.hitbox
        enemyHeight = Tuple.second enemy.hitbox

        sinDistance = abs <| (sin enemy.rotation) * enemyWidth / 2
        cosDistance = abs <| (cos enemy.rotation) * enemyHeight / 2

        barDistanceY = 
            if (rot_is_dir enemy.rotation) then (max sinDistance cosDistance) + (heathbarHeight * 0.5)
            else (max sinDistance cosDistance) + (heathbarHeight * 0.75)
    in
    {enemy | healthbarDistance = barDistanceY}

------------------------------------------------
-- Targeting
------------------------------------------------

-- first_enemy => returns the first enemy from furthest_enemies function
-- prioritizes Flying or Ground enemies depending on Bool value of the first argument
first_enemy : Bool -> List Enemy -> Maybe Enemy
first_enemy flying enemies = 
    let
        flyingEnemies = furthest_enemies <| List.filter (\o -> o.movement == Flying) enemies
        groundEnemies = furthest_enemies <| List.filter (\o -> o.movement == Ground) enemies
    in
    if flying then List.head <| flyingEnemies ++ groundEnemies
    else List.head <| groundEnemies ++ flyingEnemies

-- furthest_enemies => returns list of enemies furthest on map (enemies closest to the furthest nextPoint)
furthest_enemies : List Enemy -> List Enemy
furthest_enemies enemies = 
    let
        (sortedEnemies, maxPointIndex, minDisatnce) = 
            List.foldl 
                (\o (elist, max, min) -> 
                    let
                        currentPointIndex = Tuple.first o.nextPoint
                        nextPoint = Tuple.second o.nextPoint
                    in
                    case max of 
                        -- first maxPointIndex
                        Nothing -> 
                            let
                                newDistance = 
                                    case nextPoint of
                                        Just p -> Just (distance_of_2points o.posXY p)
                                        _ -> Nothing
                            in
                            (o :: elist, Just currentPointIndex, newDistance)

                        -- existing maxPointIndex
                        Just m -> 
                            -- next point index of enemy is smaller then maxPointIndex
                            if (m > currentPointIndex) then (elist, max, min)
                            -- next point index of enemy is bigger then maxPointIndex
                            else if (m < currentPointIndex) then 
                                let
                                    newDistance = 
                                        case nextPoint of
                                            Just p -> Just (distance_of_2points o.posXY p)
                                            _ -> Nothing
                                in
                                (List.singleton o, Just currentPointIndex, newDistance)
                            -- indexes are equal
                            else
                                let
                                    newDistance = 
                                        case nextPoint of
                                            Just p -> Just (distance_of_2points o.posXY p)
                                            _ -> Nothing

                                    ord = compare_distances min newDistance
                                in
                                -- comparing distances from next point
                                case ord of 
                                    EQ -> (o :: elist, max, min)
                                    LT -> (elist, max, min)
                                    GT -> (List.singleton o, Just currentPointIndex, newDistance)
                ) 
                ([], Nothing, Nothing) enemies
    in
    sortedEnemies

-- weakest_enemies => returns list of enemies with the lowest health
weakest_enemies : List Enemy -> List Enemy
weakest_enemies enemies = 
    let
        (foundEnemies, minHealth) = 
            List.foldl 
                (\o (elist, min) -> 
                    case min of 
                        -- first minHealth
                        Nothing -> (o :: elist, Just o.health)

                        -- existing minHealth
                        Just m -> 
                            -- enemy health is bigger then minHealth
                            if (m < o.health) then (elist, min)
                            -- health values are equal
                            else if (m == o.health) then (o :: elist, min) 
                            -- new minimum health
                            else (List.singleton o, Just o.health) 
                ) 
                ([], Nothing) enemies 
    in
    foundEnemies

-- strongest_enemies => returns list of enemies with the highest health
strongest_enemies : List Enemy -> List Enemy
strongest_enemies enemies = 
    let
        (foundEnemies, maxHealth) = 
            List.foldl 
                (\o (elist, max) -> 
                    case max of 
                        -- first maxHealth
                        Nothing -> (o :: elist, Just o.health)

                        -- existing maxHealth
                        Just m -> 
                            -- enemy health is lower then maxHealth
                            if (m > o.health) then (elist, max)
                            -- health values are equal
                            else if (m == o.health) then (o :: elist, max) 
                            -- new maximum health
                            else (List.singleton o, Just o.health) 
                ) 
                ([], Nothing) enemies
    in
    foundEnemies

-- closest_enemies => returns list of enemies with the smallest distance from point
-- point = X,Y position on map
closest_enemies : List Enemy -> (Float, Float) -> List Enemy
closest_enemies enemies point = 
    let
        (foundEnemies, minDisatnce) = 
            List.foldl 
                (\o (elist, min) -> 
                    let
                        dist = distance_of_2points o.posXY point
                    in
                    case min of 
                        -- first minDisatnce
                        Nothing -> (o :: elist, Just dist)

                        -- existing minDisatnce
                        Just m -> 
                            -- enemy distance from point is bigger then minDisatnce
                            if (m < dist) then (elist, min)
                            -- distances are equal
                            else if (m == dist) then (o :: elist, min) 
                            -- new minimum distance from point
                            else (List.singleton o, Just dist) 
                ) 
                ([], Nothing) enemies
    in
    foundEnemies

------------------------------------------------
-- Changing position on map
------------------------------------------------

-- place_enemy => returns enemy with applied offset to position, changed health depending on difficulty multipier and adjusted layer
place_enemy : Enemy -> Array Point -> Maybe Point -> Float -> Float -> Enemy
place_enemy enemy path airport newLayer mult = 
    let
        newHealth = round ((toFloat enemy.health) * mult)
    in
    case enemy.movement of 
        Flying ->
            let
                currentIndex = (Array.length path) - 1

                point = Maybe.withDefault emptyPoint airport

                -- rotation based on spawn point
                newRotation = dir_to_rot point.direction
                sinValue = sin newRotation
                cosValue = cos newRotation

                -- enemy position with offset
                newX = (Tuple.first point.posXY) + ((abs cosValue) * enemy.offset)                       
                newY = (Tuple.second point.posXY) + ((abs sinValue) * enemy.offset)        

                -- X,Y of next point
                nextX = newX + sinValue
                nextY = newY + cosValue  
            in 
            set_healthbar_distance
                {enemy 
                    | rotation = newRotation
                    , posXY = (newX, newY), nextPoint = (currentIndex, Just (nextX, nextY))
                    , layer = newLayer
                    , health = newHealth
                    , healthMax = toFloat newHealth
                }

        Ground -> 
            let
                point = Maybe.withDefault emptyPoint <| Array.get 0 path

                -- enemy offset based on spawn point direction
                offsetMult = 
                    case point.direction of
                        Up -> 1
                        Down -> -1
                        Left -> 1
                        Right -> -1
                        
                newX =  
                    -- UP or DOWN => add enemy.offset to X
                    if (point.direction == Up || point.direction== Down) then (Tuple.first point.posXY) + enemy.offset * offsetMult
                    else Tuple.first point.posXY
              
                newY  =  
                    -- LEFT or RIGHT => add enemy.offset to Y
                    if (point.direction == Left || point.direction == Right) then (Tuple.second point.posXY) + enemy.offset * offsetMult
                    else Tuple.second point.posXY                 
            in
            set_healthbar_distance
                {enemy 
                    | rotation = dir_to_rot point.direction
                    , posXY = (newX, newY), nextPoint = (1, Nothing)
                    , layer = newLayer
                    , health = newHealth
                    , healthMax = toFloat newHealth
                }

-- move_enemy => move or rotate enemy on map
-- diff = time difference
move_enemy : Enemy -> Array Point -> Float -> Enemy
move_enemy enemy path diff =
    let
        index = Tuple.first enemy.nextPoint
        point = Tuple.second enemy.nextPoint
        currentX = Tuple.first enemy.posXY
        currentY = Tuple.second enemy.posXY
    in
    case point of
        -- rotate enemy
        Nothing -> 
            case enemy.movement of
                Flying ->
                    let
                        newPoint = Array.get index path
                        lastPoint = Maybe.withDefault emptyPoint <| Array.get ((Array.length path) - 1) path

                        newRotation =  
                            case newPoint of
                                Nothing -> dir_to_rot lastPoint.direction
                                Just p -> rotation_of_2points enemy.posXY p.posXY

                        newX =  
                            case newPoint of 
                                -- exit map
                                Nothing -> 
                                    if (lastPoint.direction == Right) then currentX + 1
                                    else if (lastPoint.direction == Left) then currentX - 1
                                    else currentX
                                -- set next point
                                Just p -> Tuple.first p.posXY
                                    
                        newY =  
                            case newPoint of 
                                -- exit map
                                Nothing -> 
                                    if (lastPoint.direction == Up) then currentY + 1
                                    else if (lastPoint.direction == Down) then currentY - 1
                                    else currentY
                                -- set next point
                                Just p -> Tuple.second p.posXY                    
                    in
                    set_healthbar_distance {enemy | rotation = newRotation, nextPoint = (index + 1, Just (newX, newY))}

                Ground -> 
                    let
                        newIndex = index + 1
                        newPoint = Array.get index path

                        newDirection =  
                            case newPoint of
                                Nothing -> rot_to_dir enemy.rotation
                                Just p -> p.direction

                        -- offset multiplier based on the direction of point following the next point 
                        offsetMult =    
                            let
                                nextDirection = 
                                    case (Array.get newIndex path) of
                                        Nothing -> newDirection
                                        Just p -> p.direction
                            in
                            case nextDirection of
                                Up -> 1
                                Down -> -1
                                Right -> -1
                                Left -> 1

                        newX =  
                            case newPoint of 
                                -- exit map
                                Nothing -> 
                                    if (newDirection == Right || newDirection == Left) then currentX + 1
                                    else currentX
                                -- set next point
                                Just p ->                            
                                    if (newDirection == Up || newDirection == Down) then currentX
                                    else Tuple.first p.posXY + (enemy.offset * offsetMult)
                                        
                        newY =  
                            case newPoint of 
                                -- exit map
                                Nothing -> 
                                    if (newDirection == Up || newDirection == Down) then currentY + 1
                                    else currentY
                                -- set next point
                                Just p -> 
                                    if (newDirection == Right || newDirection == Left) then currentY
                                    else Tuple.second p.posXY + (enemy.offset * offsetMult)                 
                    in
                    set_healthbar_distance {enemy | rotation = dir_to_rot newDirection, nextPoint = (newIndex, Just (newX, newY))}

        -- change enemy position
        Just p -> 
            let
                distanceX = abs (Tuple.first p - currentX)
                distanceY = abs (Tuple.second p - currentY)

                movement = diff * enemy.speed
            in
            -- enemy located at next point
            if (distanceX <= movement && distanceY <= movement) then move_enemy {enemy | posXY = p, nextPoint = (index, Nothing)} path 0
            -- enemy NOT located at next point
            else {enemy | posXY = (currentX + movement * (sin enemy.rotation), currentY + movement * (cos enemy.rotation))}

------------------------------------------------
-- Rendering
------------------------------------------------

render_all_enemies : List Enemy -> Bool -> Resources -> List Renderable
render_all_enemies enemies showHPbar res =
    List.concat <| List.map (\o -> render_enemy o res showHPbar) <| List.sortBy .layer enemies

render_enemy : Enemy ->  Resources -> Bool -> List Renderable
render_enemy enemy res showHPbar = 
    let
        enemySize = max (Tuple.first enemy.hitbox) (Tuple.second enemy.hitbox)
    in
    Render.spriteWithOptions 
    {
        position = (Tuple.first enemy.posXY, Tuple.second enemy.posXY, enemy.layer)
        , size = (enemySize, enemySize)
        , texture = Resources.getTexture enemy.texture res
        , rotation = negate (enemy.rotation)
        , pivot = (0.5, 0.5)
        , tiling = (1, 1)
    } :: 
    if showHPbar then (render_enemy_health enemy res enemySize) 
    else []
    --if showHPbar then (render_enemy_hitbox enemy res) :: (render_enemy_health enemy res enemySize) 
    --else [(render_enemy_hitbox enemy res)]
    
render_enemy_hitbox : Enemy -> Resources -> Renderable
render_enemy_hitbox enemy res = 
    Render.spriteWithOptions 
    {
        position = (Tuple.first enemy.posXY, Tuple.second enemy.posXY, enemy.layer + healthbarLayer)
        , size = enemy.hitbox
        , texture = Resources.getTexture "/assets/ui/map/hitbox.png" res
        , rotation = negate (enemy.rotation)
        , pivot = (0.5, 0.5)
        , tiling = (1, 1)
    }

render_enemy_health : Enemy -> Resources -> Float -> List Renderable 
render_enemy_health enemy res barWidth = 
    let
        missingHealth = 1 - ((toFloat enemy.health) / enemy.healthMax)

        redBarWidth = barWidth * missingHealth
        redBarOffset = (barWidth / 2) - (redBarWidth / 2)

        greenBar = 
            Render.spriteWithOptions 
            {
                position = (Tuple.first enemy.posXY, Tuple.second enemy.posXY + enemy.healthbarDistance + heathbarOffset, enemy.layer + healthbarLayer)
                , size = (barWidth, heathbarHeight)
                , texture = Resources.getTexture "/assets/ui/map/healthbar-green.png" res
                , rotation = 0
                , pivot = (0.5, 0.5)
                , tiling = (1, 1)
            }

        redBar = 
            Render.spriteWithOptions 
            {
                position = (Tuple.first enemy.posXY + redBarOffset, Tuple.second enemy.posXY + enemy.healthbarDistance + heathbarOffset, enemy.layer + (healthbarLayer * 2))
                , size = (redBarWidth, heathbarHeight)
                , texture = Resources.getTexture "/assets/ui/map/healthbar-red.png" res
                , rotation = 0
                , pivot = (0.5, 0.5)
                , tiling = (1, 1)
            }
    in
    [greenBar, redBar]

preview_enemy : Enemy -> Int -> List (Element.Attribute msg) -> Element msg
preview_enemy enemy tileSize  listAttr =
    Element.image 
    ( listAttr ++ 
        [
            Element.height (px tileSize)
            , Element.width (px tileSize)
        ]
    )
    {src = enemy.texture, description = "enemy_preview"}
