module Game.Projectiles exposing (..)

import Game.TwoD.Render as Render exposing (Renderable)
import Game.Resources as Resources exposing (Resources)

import Game.Calculations exposing (..)

hitboxLayer : Float
hitboxLayer = 0.0001

explosionStageDuration : Float
explosionStageDuration = 0.04

-- layer interval = <0 , 1)

type Missile_type = 
    Regular         -- spawns Explosion projectile on contact with enemy (collision_2rectangles)
    | Explosive     -- explodes on contact OR when projectile lifespan reaches 0
    | Impactful     -- upon contact spawns explosion AND deals damage to hit enemy

type Projectile_type = 
    Bullet Float                    -- (Float = index of enemy, projectile target)
    | Cannonball
    | Missile Missile_type Float    -- (Float = size of Explosion in tiles)
    | Explosion Float Int           -- (Float = maximum size of Explosion | Int = stage of Explosion)

type alias Projectile = {
    class : Projectile_type
    , texture : String
    , layer : Float             -- unique layer value for rendering, also Projectile index  
    , posXY : (Float, Float)
    , rotation : Float
    , hitbox : (Float, Float)   -- width and length of Projectile hitbox, bigger value of hitbox is also the size of Projectile texture
    , speed : Float
    , lifespan : Float          -- when lifespan reaches 0 projectiles expire
    , damage : Int
    , armorIgnore : Int
    , pierce : Int              -- maximum amount of hit enemies
    }

-- create_explosion => creates Explosion projectile form Missile projectile
-- created explosion has stage set to 1
create_explosion : Projectile -> Maybe Projectile
create_explosion projectile = 
    case projectile.class of 
        Missile _ size -> 
            Just 
            {
                class = Explosion size 1 
                , posXY = projectile.posXY
                , texture = "/assets/projectiles/explosion-1.png"
                , hitbox = get_explosion_size 1 size
                , rotation = projectile.rotation
                , speed = 0
                , lifespan = explosionStageDuration
                , damage = projectile.damage
                , armorIgnore = projectile.armorIgnore
                , pierce = projectile.pierce
                , layer = projectile.layer
            }
        -- ERROR
        _ -> Nothing
    
get_explosion_size : Int -> Float -> (Float, Float)
get_explosion_size stage maxSize = 
    let
        newSize = 
            case stage of
                1 -> maxSize * 0.5
                2 -> maxSize * 0.75 
                3 -> maxSize
                4 -> maxSize * 0.8
                5 -> maxSize * 0.75
                _ -> maxSize
    in
    (newSize, newSize)

-- can_collide => returns TRUE if projectile can collide with enemy, otherwise FALSE
can_collide : Projectile -> Bool
can_collide projectile = 
    case projectile.class of
        Cannonball -> projectile.lifespan >= 0

        Missile _ _ -> projectile.lifespan >= 0

        Explosion _ stage -> 
            if (stage == 3) then True
            else False

        Bullet _ -> 
            if (projectile.lifespan <= 0) then True
            else False

-- reduce_health => reduces health of enemy 
reduce_health : Int -> Int -> Projectile -> Int
reduce_health health armor projectile = 
    let
        currentArmor = max 0 (armor - projectile.armorIgnore)

        currentDamage = max 0 (projectile.damage - currentArmor)
    in
    (health - currentDamage)

reduce_pierce : Projectile -> Maybe Projectile
reduce_pierce projectile = 
    let
        newPierce = projectile.pierce - 1
    in
    if (newPierce <= 0) then Nothing
    else Just {projectile | pierce = newPierce}

-- move_projectile => change position of projectile on map
-- return Nothing if projectile is out of map OR has 0 lifespan (Bullet remains even with lifespan <= 0)
move_projectile : Projectile -> (Int, Int) ->  Float -> Maybe Projectile
move_projectile projectile (row, col) dt = 
    let
        newLifespan = max 0 (projectile.lifespan - dt)

        canExplode = 
            case projectile.class of
                Missile t _ ->
                    case t of 
                        Explosive -> newLifespan <= 0
                        _ -> False

                _ -> False
    in
    case projectile.class of
        Bullet _ -> Just {projectile | lifespan = newLifespan}

        Explosion size stage -> 
            if (newLifespan <= 0) then
                let
                    newStage = stage + 1
                in
                if (newStage > 5) then Nothing
                else Just 
                    { projectile | 
                        lifespan = explosionStageDuration
                        , texture = "/assets/projectiles/explosion-" ++ (String.fromInt newStage) ++ ".png"
                        , hitbox = get_explosion_size newStage size
                        , class = Explosion size newStage
                    }

            else Just {projectile | lifespan = newLifespan}
        
        _ ->
            -- explode missile if expired
            if canExplode then create_explosion projectile
            -- despawn projectile
            else if (newLifespan <= 0) then Nothing
            -- move projectile
            else 
                let
                    movement = dt * projectile.speed

                    newX = Tuple.first projectile.posXY + (sin projectile.rotation) * movement
                    newY = Tuple.second projectile.posXY + (cos projectile.rotation) * movement
                in
                -- projectile out of map
                if (out_of_map (newX, newY) (row,col)) then Nothing
                -- new projectile position and lifespan
                else Just {projectile | posXY = (newX, newY), lifespan = newLifespan}

------------------------------------------------
-- Rendering
------------------------------------------------

render_all_projectiles : List Projectile -> Resources -> List Renderable
render_all_projectiles projectiles res =
    List.concat <| List.map (\o -> render_projectile o res) <| List.sortBy .layer projectiles

render_projectile : Projectile -> Resources -> List Renderable
render_projectile projectile res = 
    let
        newSize = max (Tuple.first projectile.hitbox) (Tuple.second projectile.hitbox)
    in
    [
        Render.spriteWithOptions 
        {
            position = (Tuple.first projectile.posXY, Tuple.second projectile.posXY, projectile.layer)
            , size = (newSize, newSize)
            , texture = Resources.getTexture projectile.texture res
            , rotation = negate (projectile.rotation)
            , pivot = (0.5, 0.5)
            , tiling = (1, 1)
        } 
        --, render_projectile_hitbox projectile res
    ]

render_projectile_hitbox : Projectile -> Resources -> Renderable
render_projectile_hitbox projectile res = 
    let
        newTexture = 
            case projectile.class of 
                Cannonball -> "/assets/ui/map/hitbox-circle.png"
                _ -> "/assets/ui/map/hitbox.png"
    in 
    Render.spriteWithOptions 
    {
        position = (Tuple.first projectile.posXY, Tuple.second projectile.posXY, projectile.layer + hitboxLayer)
        , size = projectile.hitbox
        , texture = Resources.getTexture newTexture res
        , rotation = negate (projectile.rotation)
        , pivot = (0.5, 0.5)
        , tiling = (1, 1)
    }
