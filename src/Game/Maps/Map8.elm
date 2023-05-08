module Game.Maps.Map8 exposing (..)

import Game.Calculations exposing (..)
import Game.Tiles exposing (..)
import Game.Enemies exposing (..)

mapWidth : Int
mapWidth = 13

mapHeight : Int
mapHeight = 13

startingCash : Int
startingCash = 950

waveList : List Wave
waveList = 
    [
        create_wave 1 50
        [
            create_enemy Plane -1 0
        ]  
        , create_wave 2 250
        [
            create_enemy Warrior 1 0
            , create_enemy Warrior 1 3
            , create_enemy Warrior 1 6
            , create_enemy Warrior 1 9

            , create_enemy Tank -1 10

            , create_enemy Warrior 1 12
            , create_enemy Warrior 1 15
            , create_enemy Warrior 1 18
        ]  
        , create_wave 3 400
        [
            create_enemy Veteran -1 0
            , create_enemy Veteran -1 0.5

            , create_enemy Plane 0 4

            , create_enemy Veteran 0 14
            , create_enemy Veteran 0 14.5

            , create_enemy Plane -1 17

            , create_enemy Veteran 1 24
            , create_enemy Veteran 1 24.5

            , create_enemy Plane -1 28
        ]  
        , create_wave 4 350
        [
            create_enemy Tank 1 0

            , create_enemy Warrior -1 2
            , create_enemy Warrior -1 2.1

            , create_enemy Warrior 0 4
            , create_enemy Warrior 0 4.1

            , create_enemy Warrior -1 6
            , create_enemy Warrior -1 6.1

            , create_enemy Tank 0 8

            , create_enemy Warrior -1 10
            , create_enemy Warrior -1 10.1

            , create_enemy Warrior 1 12
            , create_enemy Warrior 1 12.1

            , create_enemy Warrior -1 14
            , create_enemy Warrior -1 14.1

            , create_enemy Tank -1 16

            , create_enemy Warrior 1 18
            , create_enemy Warrior 1 18.1

            , create_enemy Warrior 0 20
            , create_enemy Warrior 0 20.1

            , create_enemy Warrior 1 22
            , create_enemy Warrior 1 22.1

            , create_enemy HeavyTank -1 24
        ]  
        , create_wave 5 350
        [
            create_enemy HeavyTank -1 0

            , create_enemy Scout 1 1
            , create_enemy Scout 1 1.3
            , create_enemy Scout 1 1.6
            , create_enemy Scout 1 1.9
            , create_enemy Scout 1 2.2
            , create_enemy Scout 1 2.5
            , create_enemy Scout 1 2.8
            , create_enemy Scout 1 3.1
            , create_enemy Scout 1 3.4
            , create_enemy Scout 1 3.7
            , create_enemy Scout 1 4

            , create_enemy HeavyTank -1 4

            , create_enemy Scout 1 5
            , create_enemy Scout 1 5.3
            , create_enemy Scout 1 5.6
            , create_enemy Scout 1 5.9
            , create_enemy Scout 1 6.2
            , create_enemy Scout 1 6.5
            , create_enemy Scout 1 6.8
            , create_enemy Scout 1 7.1
            , create_enemy Scout 1 7.4
            , create_enemy Scout 1 7.7
            , create_enemy Scout 1 8

            , create_enemy HeavyTank -1 8

            , create_enemy Soldier 1 9
            , create_enemy Soldier 1 9.4
            , create_enemy Soldier 1 9.8
            , create_enemy Soldier 1 10.2
            , create_enemy Soldier 1 10.8
            , create_enemy Soldier 1 11.2
            , create_enemy Soldier 1 11.6
            , create_enemy Soldier 1 12

            , create_enemy Tank -1 16
            , create_enemy Tank 0 16
        ]  
        , create_wave 6 400
        [
            create_enemy HeavyPlane -1 0
            , create_enemy HeavyPlane 0 7
            , create_enemy HeavyPlane 1 14

            , create_enemy HeavyPlane -1 24
            , create_enemy HeavyPlane 0 24
            , create_enemy HeavyPlane 1 24
        ]  
        , create_wave 7 50
        [
            create_enemy Plane 1 0

            , create_enemy Warrior -1 2
            , create_enemy Warrior 0 2
            , create_enemy Warrior 1 2
            , create_enemy Warrior -1 2.2
            , create_enemy Warrior 0 2.2
            , create_enemy Warrior 1 2.2
            , create_enemy Warrior -1 2.4
            , create_enemy Warrior 0 2.4
            , create_enemy Warrior 1 2.4
            , create_enemy Warrior -1 2.6
            , create_enemy Warrior 0 2.6
            , create_enemy Warrior 1 2.6

            , create_enemy Tank -0.2 4
            , create_enemy Tank 0.2 4

            , create_enemy Plane 0 8

            , create_enemy Warrior -1 10
            , create_enemy Warrior 0 10
            , create_enemy Warrior 1 10
            , create_enemy Warrior -1 10.2
            , create_enemy Warrior 0 10.2
            , create_enemy Warrior 1 10.2
            , create_enemy Warrior -1 10.4
            , create_enemy Warrior 0 10.4
            , create_enemy Warrior 1 10.4
            , create_enemy Warrior -1 10.6
            , create_enemy Warrior 0 10.6
            , create_enemy Warrior 1 10.6

            , create_enemy Warrior -1 12
            , create_enemy Warrior 0 12
            , create_enemy Warrior 1 12
            , create_enemy Warrior -1 12.2
            , create_enemy Warrior 0 12.2
            , create_enemy Warrior 1 12.2
            , create_enemy Warrior -1 12.4
            , create_enemy Warrior 0 12.4
            , create_enemy Warrior 1 12.4
            , create_enemy Warrior -1 12.6
            , create_enemy Warrior 0 12.6
            , create_enemy Warrior 1 12.6

            , create_enemy Tank -0.2 14
            , create_enemy Tank 0.2 14

            , create_enemy HeavyPlane 1 22
            , create_enemy HeavyPlane 0 22
            , create_enemy HeavyPlane -1 22
            , create_enemy Plane 0.2 24
            , create_enemy Plane -0.2 24

        ]  
        , create_wave 8 50
        [
            create_enemy Veteran 0 0
            , create_enemy Veteran 0 1
            , create_enemy Veteran 0 2
            , create_enemy Veteran 0 3

            , create_enemy Tank -1 3.5
            , create_enemy Tank 1 3.5

            , create_enemy Veteran 0 4
            , create_enemy Veteran 0 5
            , create_enemy Veteran 0 6
            , create_enemy Veteran 0 7

            , create_enemy Tank -1 7.5
            , create_enemy Tank 1 7.5

            , create_enemy Veteran 0 8
            , create_enemy Veteran 0 9
            , create_enemy Veteran 0 10
            , create_enemy Veteran 0 11

            , create_enemy HeavyTank -1 11.5
            , create_enemy HeavyTank 1 11.5

            , create_enemy Veteran 0 12
            , create_enemy Veteran 0 13
            , create_enemy Veteran 0 14
            , create_enemy Veteran 0 15

            , create_enemy HeavyTank -1 15.5
            , create_enemy HeavyTank 1 15.5

            , create_enemy Veteran 0 16
            , create_enemy Veteran 0 17
            , create_enemy Veteran 0 18
            , create_enemy Veteran 0 19

            , create_enemy Plane -1 20
            , create_enemy Plane 1 20
        ]  
        , create_wave 9 50
        [

            create_enemy HeavyPlane -0.2 0
            , create_enemy HeavyPlane 0.2 0
            , create_enemy Plane -1 1
            , create_enemy Plane 0 1
            , create_enemy Plane 1 1

            , create_enemy Soldier -1 2
            , create_enemy Soldier -0.3 2
            , create_enemy Soldier -0.2 2
            , create_enemy Soldier -0.1 2
            , create_enemy Soldier 0.1 2
            , create_enemy Soldier 0.2 2
            , create_enemy Soldier 0.3 2
            , create_enemy Soldier 1 2

            , create_enemy Soldier -1 4
            , create_enemy Soldier -0.3 4
            , create_enemy Soldier -0.2 4
            , create_enemy Soldier -0.1 4
            , create_enemy Soldier 0.1 4
            , create_enemy Soldier 0.2 4
            , create_enemy Soldier 0.3 4
            , create_enemy Soldier 1 4

            , create_enemy Tank -1 6
            , create_enemy Tank 0 6
            , create_enemy Tank 1 6
            , create_enemy HeavyTank -0.2 7
            , create_enemy HeavyTank 0.2 7

            , create_enemy Warrior -1 8
            , create_enemy Warrior -0.3 8
            , create_enemy Warrior -0.2 8
            , create_enemy Warrior -0.1 8
            , create_enemy Warrior 0.1 8
            , create_enemy Warrior 0.2 8
            , create_enemy Warrior 0.3 8
            , create_enemy Warrior 1 8

            , create_enemy Warrior -1 10
            , create_enemy Warrior -0.3 10
            , create_enemy Warrior -0.2 10
            , create_enemy Warrior -0.1 10
            , create_enemy Warrior 0.1 10
            , create_enemy Warrior 0.2 10
            , create_enemy Warrior 0.3 10
            , create_enemy Warrior 1 10

            , create_enemy Plane -0.2 14
            , create_enemy Plane 0.2 14
            , create_enemy HeavyPlane -1 15
            , create_enemy HeavyPlane 0 15
            , create_enemy HeavyPlane 1 15
        ]  
        , create_wave 10 50
        [
            create_enemy HeavyPlane -1 0
            , create_enemy HeavyPlane 1 2
            , create_enemy HeavyPlane -1 4
            , create_enemy HeavyPlane 1 6
            , create_enemy HeavyPlane -1 8
            , create_enemy HeavyPlane 1 10
            , create_enemy HeavyPlane -1 12
            , create_enemy HeavyPlane 1 14
            , create_enemy HeavyPlane -1 16
            , create_enemy HeavyPlane 1 18
            , create_enemy HeavyPlane 0 18
            , create_enemy HeavyPlane -1 18
        ]  
        , create_wave 11 0
        [
            create_enemy Plane 0 0

            , create_enemy Tank 0 1
            , create_enemy Tank 0 2

            , create_enemy Scout -1 3.5
            , create_enemy Scout -0.3 3.5
            , create_enemy Scout -0.2 3.5
            , create_enemy Scout 0.2 3.5
            , create_enemy Scout 0.3 3.5
            , create_enemy Scout 1 3.5

            , create_enemy HeavyPlane 0 4

            , create_enemy Tank 0 5
            , create_enemy Veteran -1 5
            , create_enemy Veteran 1 5
            , create_enemy Veteran -1 6
            , create_enemy Veteran 1 6
            , create_enemy Tank 0 6

            , create_enemy Soldier -1 7.5
            , create_enemy Soldier -0.3 7.5
            , create_enemy Soldier -0.2 7.5
            , create_enemy Soldier 0.2 7.5
            , create_enemy Soldier 0.3 7.5
            , create_enemy Soldier 1 7.5

            , create_enemy Plane 0 8

            , create_enemy Tank 0 9
            , create_enemy Veteran -1 9
            , create_enemy Veteran 1 9
            , create_enemy Veteran -1 9.5
            , create_enemy Veteran 1 9.5
            , create_enemy Veteran -1 10
            , create_enemy Veteran 1 10
            , create_enemy HeavyTank 0 10

            , create_enemy Soldier -1 11.5
            , create_enemy Soldier -0.3 11.5
            , create_enemy Soldier -0.2 11.5
            , create_enemy Soldier 0.2 11.5
            , create_enemy Soldier 0.3 11.5
            , create_enemy Soldier 1 11.5

            , create_enemy HeavyPlane 0 12

            , create_enemy HeavyTank 0 13
            , create_enemy Veteran -1 13
            , create_enemy Veteran 1 13
            , create_enemy Veteran -1 13.5
            , create_enemy Veteran 1 13.5
            , create_enemy Veteran -1 14
            , create_enemy Veteran 1 14
            , create_enemy HeavyTank 0 14

            , create_enemy Warrior -1 15.5
            , create_enemy Warrior -0.3 15.5
            , create_enemy Warrior -0.2 15.5
            , create_enemy Warrior 0.2 15.5
            , create_enemy Warrior 0.3 15.5
            , create_enemy Warrior 1 15.5

            , create_enemy Plane 0 16

            , create_enemy Plane -1 18
            , create_enemy Plane 1 18
             , create_enemy Plane -1 19
            , create_enemy Plane 1 19

            , create_enemy HeavyPlane 0 20
        ]  
    ]

airport : Maybe Point 
airport = Just (Point (0, 7.5) Right)

path : List Point
path = 
    [
        Point (0, 10) Right
        , Point (8, 10) Right
        , Point (8, 6) Down
        , Point (4, 6) Left
        , Point (4, 2) Down
        , Point (13, 2) Right
    ]

tileList : List ((Float, Float), Tile)
tileList = 
    [
        create_tile (0,0) (Lot Nothing) 0
        , create_tile (1,0) (Lot Nothing) 0
        , create_tile (2,0) (Lot Nothing) 0
        , create_tile (3,0) (Lot (create_obstacle "rock-4" 0.75 20 (1, 1))) 0
        , create_tile (4,0) (Lot (create_obstacle "bush" 0.65 60 (-1, 0))) 0
        , create_tile (5,0) (Lot Nothing) 0
        , create_tile (6,0) (Lot Nothing) 0
        , create_tile (7,0) (Lot Nothing) 0
        , create_tile (8,0) (Lot (create_obstacle "tree-star" 0.9 140 (0, 1))) 0
        , create_tile (9,0) (Lot Nothing) 0
        , create_tile (10,0) (Lot Nothing) 0
        , create_tile (11,0) (Lot Nothing) 0
        , create_tile (12,0) (Lot Nothing) 0
        , create_tile (0,1) (Lot Nothing) 0
        , create_tile (1,1) (Lot (create_obstacle "bush-many" 0.85 30 (1, 1))) 0
        , create_tile (2,1) (Lot Nothing) 0
        , create_tile (3,1) Road 12
        , create_tile (4,1) Road 2
        , create_tile (5,1) Road 2
        , create_tile (6,1) Road 2
        , create_tile (7,1) Road 2
        , create_tile (8,1) Road 2
        , create_tile (9,1) Road 2
        , create_tile (10,1) Road 2
        , create_tile (11,1) Road 2
        , create_tile (12,1) Road 2
        , create_tile (0,2) (Lot Nothing) 0
        , create_tile (1,2) (Lot Nothing) 0
        , create_tile (2,2) (Lot Nothing) 0
        , create_tile (3,2) Road 3
        , create_tile (4,2) Road 6
        , create_tile (5,2) Road 4
        , create_tile (6,2) Road 4
        , create_tile (7,2) Road 4
        , create_tile (8,2) Road 4
        , create_tile (9,2) Road 4
        , create_tile (10,2) Road 4
        , create_tile (11,2) Road 4
        , create_tile (12,2) Road 4
        , create_tile (0,3) (Lot Nothing) 0
        , create_tile (1,3) (Lot (create_obstacle "tree-round" 0.55 0 (1, -1))) 0
        , create_tile (2,3) (Lot (create_obstacle "tree" 0.75 120 (0, 1))) 0
        , create_tile (3,3) Road 3
        , create_tile (4,3) Road 5
        , create_tile (5,3) (Lot (create_obstacle "rock-3" 0.6 1220 (1, 0))) 0
        , create_tile (6,3) (Lot (create_obstacle "tree" 0.8 0 (0, -1))) 0
        , create_tile (7,3) (Lot Nothing) 0
        , create_tile (8,3) (Lot Nothing) 0
        , create_tile (9,3) (Lot Nothing) 0
        , create_tile (10,3) (Lot Nothing) 0
        , create_tile (11,3) (Lot (create_obstacle "tree-round" 0.75 270 (-1, 1))) 0
        , create_tile (12,3) (Lot Nothing) 0
        , create_tile (0,4) (Lot (create_obstacle "tree" 0.55 70 (-1, 1))) 0
        , create_tile (1,4) (Lot (create_obstacle "rock-2" 0.8 10 (1, -1))) 0
        , create_tile (2,4) (Lot (create_obstacle "tree-star" 0.65 170 (1, 0))) 0
        , create_tile (3,4) Road 3
        , create_tile (4,4) Road 5
        , create_tile (5,4) (Lot (create_obstacle "tree-round" 0.75 0 (-1, -1))) 0
        , create_tile (6,4) (Lot Nothing) 0
        , create_tile (7,4) (Lot Nothing) 0
        , create_tile (8,4) (Lot Nothing) 0
        , create_tile (9,4) (Lot (create_obstacle "rock-1" 0.6 30 (-1, 1))) 0
        , create_tile (10,4) (Lot (create_obstacle "bush-many" 0.9 140 (1, 1))) 0
        , create_tile (11,4) (Lot Nothing) 0
        , create_tile (12,4) (Lot Nothing) 0
        , create_tile (0,5) (Lot (create_obstacle "tree-round" 0.9 90 (1, 1))) 0
        , create_tile (1,5) (Lot Nothing) 0
        , create_tile (2,5) (Lot (create_obstacle "bush" 0.55 50 (-1, -1))) 0
        , create_tile (3,5) Road 3
        , create_tile (4,5) Road 9
        , create_tile (5,5) Road 2
        , create_tile (6,5) Road 2
        , create_tile (7,5) Road 2
        , create_tile (8,5) Road 13
        , create_tile (9,5) (Lot Nothing) 0
        , create_tile (10,5) (Lot Nothing) 0
        , create_tile (11,5) (Lot Nothing) 0
        , create_tile (12,5) (Lot (create_obstacle "bush" 0.9 100 (-1, 1))) 0
        , create_tile (0,6) (Lot Nothing) 0
        , create_tile (1,6) (Lot Nothing) 0
        , create_tile (2,6) (Lot (create_obstacle "tree" 0.7 70 (0, 1))) 0
        , create_tile (3,6) Road 10
        , create_tile (4,6) Road 4
        , create_tile (5,6) Road 4
        , create_tile (6,6) Road 4
        , create_tile (7,6) Road 7
        , create_tile (8,6) Road 5
        , create_tile (9,6) (Lot Nothing) 0
        , create_tile (10,6) (Lot (create_obstacle "tree" 0.55 170 (-1, 1))) 0
        , create_tile (11,6) (Lot Nothing) 0
        , create_tile (12,6) (Lot (create_obstacle "tree-star" 0.6 0 (1, 1))) 0
        , create_tile (0,7) Road 18
        , create_tile (1,7) (Lot Nothing) 0
        , create_tile (2,7) (Lot Nothing) 0
        , create_tile (3,7) (Lot Nothing) 0
        , create_tile (4,7) (Lot (create_obstacle "tree-star" 0.85 240 (0, -1))) 0
        , create_tile (5,7) (Lot Nothing) 0
        , create_tile (6,7) (Lot (create_obstacle "rock-6" 0.75 45 (1, -1))) 0
        , create_tile (7,7) Road 3
        , create_tile (8,7) Road 5
        , create_tile (9,7) (Lot (create_obstacle "tree-star" 0.85 120 (1, 0))) 0
        , create_tile (10,7) (Lot (create_obstacle "bush" 0.6 10 (0, -1))) 0
        , create_tile (11,7) (Lot Nothing) 0
        , create_tile (12,7) (Lot Nothing) 0
        , create_tile (0,8) (Lot Nothing) 0
        , create_tile (1,8) (Lot (create_obstacle "bush-many" 0.8 40 (-1, 1))) 0
        , create_tile (2,8) (Lot Nothing) 0
        , create_tile (3,8) (Lot (create_obstacle "rock-5" 0.5 80 (1, -1))) 0
        , create_tile (4,8) (Lot Nothing) 0
        , create_tile (5,8) (Lot (create_obstacle "tree-round" 0.7 180 (-1, 1))) 0
        , create_tile (6,8) (Lot (create_obstacle "tree-star" 0.65 150 (-1, -1))) 0
        , create_tile (7,8) Road 3
        , create_tile (8,8) Road 5
        , create_tile (9,8) (Lot Nothing) 0
        , create_tile (10,8) (Lot (create_obstacle "rock-2" 0.8 60 (0, -1))) 0
        , create_tile (11,8) (Lot (create_obstacle "tree" 0.9 110 (1, 0))) 0
        , create_tile (12,8) (Lot Nothing) 0
        , create_tile (0,9) Road 2
        , create_tile (1,9) Road 2
        , create_tile (2,9) Road 2
        , create_tile (3,9) Road 2
        , create_tile (4,9) Road 2
        , create_tile (5,9) Road 2
        , create_tile (6,9) Road 2
        , create_tile (7,9) Road 8
        , create_tile (8,9) Road 5
        , create_tile (9,9) (Lot (create_obstacle "bush-many" 0.75 230 (1, -1))) 0
        , create_tile (10,9) (Lot (create_obstacle "tree-round" 0.8 160 (0, 0))) 0
        , create_tile (11,9) (Lot (create_obstacle "rock-4" 0.55 70 (0, 1))) 0
        , create_tile (12,9) (Lot Nothing) 0
        , create_tile (0,10) Road 4
        , create_tile (1,10) Road 4
        , create_tile (2,10) Road 4
        , create_tile (3,10) Road 4
        , create_tile (4,10) Road 4
        , create_tile (5,10) Road 4
        , create_tile (6,10) Road 4
        , create_tile (7,10) Road 4
        , create_tile (8,10) Road 11
        , create_tile (9,10) (Lot (create_obstacle "rock-3" 0.65 90 (-1, 0))) 0
        , create_tile (10,10) (Lot Nothing) 0
        , create_tile (11,10) (Lot (create_obstacle "tree-star" 0.8 200 (1, 0))) 0
        , create_tile (12,10) (Lot (create_obstacle "bush" 0.7 140 (0, -1))) 0
        , create_tile (0,11) (Lot (create_obstacle "bush" 0.85 40 (1, -1))) 0
        , create_tile (1,11) (Lot Nothing) 0
        , create_tile (2,11) (Lot Nothing) 0
        , create_tile (3,11) (Lot Nothing) 0
        , create_tile (4,11) (Lot (create_obstacle "tree" 0.65 0 (-1, -1))) 0
        , create_tile (5,11) (Lot Nothing) 0
        , create_tile (6,11) (Lot (create_obstacle "bush" 0.75 30 (0, -1))) 0
        , create_tile (7,11) (Lot (create_obstacle "rock-1" 0.85 220 (-1, -1))) 0
        , create_tile (8,11) (Lot (create_obstacle "tree-round" 0.7 0 (1, 0))) 0
        , create_tile (9,11) (Lot (create_obstacle "tree-star" 0.5 190 (1, -1))) 0
        , create_tile (10,11) (Lot (create_obstacle "bush-many" 0.9 50 (0, 1))) 0
        , create_tile (11,11) (Lot (create_obstacle "tree" 0.6 135 (1, -1))) 0
        , create_tile (12,11) (Lot Nothing) 0
        , create_tile (0,12) (Lot Nothing) 0
        , create_tile (1,12) (Lot Nothing) 0
        , create_tile (2,12) (Lot Nothing) 0
        , create_tile (3,12) (Lot (create_obstacle "rock-3" 0.75 160 (0, -1))) 0
        , create_tile (4,12) (Lot (create_obstacle "bush-many" 0.6 0 (1, -1))) 0
        , create_tile (5,12) (Lot (create_obstacle "bush-many" 0.7 20 (0, 0))) 0
        , create_tile (6,12) (Lot (create_obstacle "tree-round" 0.85 140 (1, -1))) 0
        , create_tile (7,12) (Lot (create_obstacle "tree-star" 0.65 80 (1, -1))) 0
        , create_tile (8,12) (Lot Nothing) 0
        , create_tile (9,12) (Lot (create_obstacle "tree" 0.8 270 (1, -1))) 0
        , create_tile (10,12) (Lot (create_obstacle "bush" 0.6 90 (0, 0))) 0
        , create_tile (11,12) (Lot (create_obstacle "tree-round" 0.85 160 (1, -1))) 0
        , create_tile (12,12) (Lot (create_obstacle "rock-2" 0.7 10 (0, -1))) 0
    ]
