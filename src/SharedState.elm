module SharedState exposing (..)

import Game.Resources as Resources exposing (Resources)

import User exposing (User)
import Ports exposing (..)


type alias SharedState = { 
    player : User
    , resources : Resources
    }

type SharedStateUpdate = 
    NoUpdate
    | UpdateUser User
    | UpdateResource Resources.Msg

update : SharedState -> SharedStateUpdate -> SharedState
update sharedState sharedStateUpdate =
    case sharedStateUpdate of
        UpdateUser u -> {sharedState | player = u} 

        UpdateResource resourceMsg -> {sharedState | resources = Resources.update resourceMsg sharedState.resources} 

        NoUpdate -> sharedState  

save_storage : User -> Cmd msg
save_storage player = 
    setStorage (User.encode_user player)

gameResources : List String
gameResources = 
    [
        -- Tiles
        "/assets/tiles/tile-0.png"
        , "/assets/tiles/tile-1.png"
        , "/assets/tiles/tile-2.png"
        , "/assets/tiles/tile-3.png"
        , "/assets/tiles/tile-4.png"
        , "/assets/tiles/tile-5.png"
        , "/assets/tiles/tile-6.png"
        , "/assets/tiles/tile-7.png"
        , "/assets/tiles/tile-8.png"
        , "/assets/tiles/tile-9.png"
        , "/assets/tiles/tile-10.png"
        , "/assets/tiles/tile-11.png"
        , "/assets/tiles/tile-12.png"
        , "/assets/tiles/tile-13.png"
        , "/assets/tiles/tile-14.png"
        , "/assets/tiles/tile-15.png"
        , "/assets/tiles/tile-16.png"
        , "/assets/tiles/tile-17.png"
        , "/assets/tiles/tile-18.png"
        -- Objects
        , "/assets/objects/bush.png"
        , "/assets/objects/bush-many.png"
        , "/assets/objects/tree.png"
        , "/assets/objects/tree-round.png"
        , "/assets/objects/tree-star.png"
        , "/assets/objects/rock-1.png"
        , "/assets/objects/rock-2.png"
        , "/assets/objects/rock-3.png"
        , "/assets/objects/rock-4.png"
        , "/assets/objects/rock-5.png"
        , "/assets/objects/rock-6.png"
        -- Towers
        , "/assets/towers/base-combined.png"
        , "/assets/towers/base-pointy.png"
        , "/assets/towers/base-squared.png"
        , "/assets/towers/cannon.png"
        , "/assets/towers/cannon-1.png"
        , "/assets/towers/cannon-2.png"
        , "/assets/towers/minigun.png"
        , "/assets/towers/minigun-1.png"
        , "/assets/towers/minigun-2.png"
        , "/assets/towers/rocketlauncher.png"
        , "/assets/towers/rocketlauncher-e.png"
        , "/assets/towers/rocketlauncher-1.png"
        , "/assets/towers/rocketlauncher-1e.png"
        , "/assets/towers/rocketlauncher-2.png"
        , "/assets/towers/rocketlauncher-2el.png"
        , "/assets/towers/rocketlauncher-2er.png"
        -- Enemies
        , "/assets/enemies/scout.png"
        , "/assets/enemies/soldier.png"
        , "/assets/enemies/warrior.png"
        , "/assets/enemies/veteran.png"
        , "/assets/enemies/tank-light.png"
        , "/assets/enemies/tank-heavy.png"
        , "/assets/enemies/plane-light.png"
        , "/assets/enemies/plane-heavy.png"
        -- Projectiles
        , "/assets/projectiles/bullet.png"
        , "/assets/projectiles/bullet-tall.png"
        , "/assets/projectiles/bullet-wide.png"
        , "/assets/projectiles/cannonball.png"
        , "/assets/projectiles/cannonball-black.png"
        , "/assets/projectiles/cannonball-white.png" 
        , "/assets/projectiles/missile.png"
        , "/assets/projectiles/missile-big.png"
        , "/assets/projectiles/explosion-1.png"
        , "/assets/projectiles/explosion-2.png"
        , "/assets/projectiles/explosion-3.png"
        , "/assets/projectiles/explosion-4.png"
        , "/assets/projectiles/explosion-5.png"
        -- Map UI
        , "/assets/ui/map/hitbox.png"
        , "/assets/ui/map/hitbox-circle.png"
        , "/assets/ui/map/healthbar-green.png"
        , "/assets/ui/map/healthbar-red.png"
        , "/assets/ui/map/road-flag.png"
    ]
