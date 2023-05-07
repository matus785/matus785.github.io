module Game.Maps.Map7 exposing (..)

import Game.Calculations exposing (..)
import Game.Tiles exposing (..)
import Game.Enemies exposing (..)

mapWidth : Int
mapWidth = 12

mapHeight : Int
mapHeight = 12

startingCash : Int
startingCash = 750

waveList : List Wave
waveList = 
    [
        create_wave 1 350
        [
            create_enemy Scout -1 0

            , create_enemy Warrior -0.3 3
            , create_enemy Warrior -0.1 3
            , create_enemy Warrior 0.1 3
            , create_enemy Warrior 0.3 3

            , create_enemy Scout -1 5

            , create_enemy Warrior -0.3 8
            , create_enemy Warrior -0.1 8
            , create_enemy Warrior 0.1 8
            , create_enemy Warrior 0.3 8
        ] 
        , create_wave 2 50
        [
            create_enemy Tank 1 0

            , create_enemy Warrior -1 4
            , create_enemy Warrior -1 4.2
            , create_enemy Warrior -1 4.4

            , create_enemy Warrior -1 6
            , create_enemy Warrior -1 6.2
            , create_enemy Warrior -1 6.4

            , create_enemy Tank 0 10
        ]
        , create_wave 3 300
        [
            create_enemy Tank 0 0
            , create_enemy Tank 0 1

            , create_enemy Veteran -1 4.5
            , create_enemy Veteran 1 5.5
            , create_enemy Veteran -1 6.5

            , create_enemy Tank 0 10
            , create_enemy Tank 0 12.5
        ]
        , create_wave 4 150
        [
            create_enemy Veteran 0 0

            , create_enemy Soldier -1 1.5
            , create_enemy Soldier -0.2 1.5
            , create_enemy Soldier -0.1 1.5
            , create_enemy Soldier 0.1 1.5
            , create_enemy Soldier 0.2 1.5
            , create_enemy Soldier 1 1.5

            , create_enemy Veteran 0 3

            , create_enemy Warrior 1 4
            , create_enemy Warrior 1 4.5
            , create_enemy Warrior 1 5

            , create_enemy Warrior -1 4
            , create_enemy Warrior -1 4.5
            , create_enemy Warrior -1 5

            , create_enemy Veteran 0 6

            , create_enemy Soldier -1 7.5
            , create_enemy Soldier -0.2 7.5
            , create_enemy Soldier -0.1 7.5
            , create_enemy Soldier 0.1 7.5
            , create_enemy Soldier 0.2 7.5
            , create_enemy Soldier 1 7.5

            , create_enemy Veteran 0 9

            , create_enemy Warrior 1 10
            , create_enemy Warrior 1 10.5
            , create_enemy Warrior 1 11
            
            , create_enemy Warrior -1 10
            , create_enemy Warrior -1 10.5
            , create_enemy Warrior -1 11

            , create_enemy Veteran 0 12

            , create_enemy Soldier -1 4.5
            , create_enemy Soldier -0.2 4.5
            , create_enemy Soldier -0.1 4.5
            , create_enemy Soldier 0.1 4.5
            , create_enemy Soldier 0.2 4.5
            , create_enemy Soldier 1 4.5

            , create_enemy Veteran 0 15
        ]
        , create_wave 5 200
        [
            create_enemy Plane 1 0

            , create_enemy HeavyTank 0 2
            , create_enemy HeavyTank 0 3

            , create_enemy Veteran -1 6
            , create_enemy Veteran 1 6

            , create_enemy Plane 1 12
            
            , create_enemy HeavyTank 0 16
            , create_enemy HeavyTank 0 17

            , create_enemy Veteran -1 20
            , create_enemy Veteran 1 20
        ]
        , create_wave 6 450
        [
            create_enemy Plane 0 0

            , create_enemy Scout 1 0
            , create_enemy Scout 1 0.3
            , create_enemy Scout 1 0.6
            , create_enemy Scout 1 0.9
            , create_enemy Scout 1 1.2
            , create_enemy Scout 1 1.5
            , create_enemy Scout 1 1.8
            , create_enemy Scout 1 2.1
            , create_enemy Scout 1 2.4
            , create_enemy Scout 1 2.7
            , create_enemy Scout 1 3

            , create_enemy Plane 0 5

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

            , create_enemy Plane 0 10

            , create_enemy HeavyTank -0.2 12
            , create_enemy Tank 0 12
            , create_enemy HeavyTank 0.2 12
        ]
        , create_wave 7 400
        [
            create_enemy Tank 1 0
            , create_enemy Tank -1 0
            , create_enemy Tank 0.2 1
            , create_enemy Tank 0 1
            , create_enemy Tank -0.2 1

            , create_enemy Warrior 1 4
            , create_enemy Warrior 0.3 4
            , create_enemy Warrior 0.2 4
            , create_enemy Warrior 0.1 4
            , create_enemy Warrior 0 4
            , create_enemy Warrior -0.1 4
            , create_enemy Warrior -0.2 4
            , create_enemy Warrior -0.3 4
            , create_enemy Warrior -1 4

            , create_enemy Warrior 1 4.5
            , create_enemy Warrior 0.3 4.5
            , create_enemy Warrior 0.2 4.5
            , create_enemy Warrior 0.1 4.5
            , create_enemy Warrior 0 4.5
            , create_enemy Warrior -0.1 4.5
            , create_enemy Warrior -0.2 4.5
            , create_enemy Warrior -0.3 4.5
            , create_enemy Warrior -1 4.5

            , create_enemy Tank 1 8
            , create_enemy Tank -1 8
            , create_enemy Tank 0.2 9
            , create_enemy Tank 0 9
            , create_enemy Tank -0.2 9

            , create_enemy Warrior 1 12
            , create_enemy Warrior 0.3 12
            , create_enemy Warrior 0.2 12
            , create_enemy Warrior 0.1 12
            , create_enemy Warrior 0 12
            , create_enemy Warrior -0.1 12
            , create_enemy Warrior -0.2 12
            , create_enemy Warrior -0.3 12
            , create_enemy Warrior -1 12

            , create_enemy Warrior 1 12.5
            , create_enemy Warrior 0.3 12.5
            , create_enemy Warrior 0.2 12.5
            , create_enemy Warrior 0.1 12.5
            , create_enemy Warrior 0 12.5
            , create_enemy Warrior -0.1 12.5
            , create_enemy Warrior -0.2 12.5
            , create_enemy Warrior -0.3 12.5
            , create_enemy Warrior -1 12.5

            , create_enemy HeavyTank 1 16
            , create_enemy HeavyTank 0 16
            , create_enemy HeavyTank -1 16
        ]
        , create_wave 8 100
        [
            create_enemy Plane 0 0

            , create_enemy Veteran -1 1.2
            , create_enemy Veteran 0 1.4
            , create_enemy Veteran 1 1.6
            , create_enemy Veteran 0 1.8
            , create_enemy Veteran -1 2

            , create_enemy Veteran -1 2.2
            , create_enemy Veteran 0 2.4
            , create_enemy Veteran 1 2.6
            , create_enemy Veteran 0 2.8
            , create_enemy Veteran -1 3

            , create_enemy Veteran -1 3.2
            , create_enemy Veteran 0 3.4
            , create_enemy Veteran 1 3.6
            , create_enemy Veteran 0 3.8
            , create_enemy Veteran -1 4

            , create_enemy Plane 0 6

            , create_enemy Veteran -1 7.2
            , create_enemy Veteran 0 7.4
            , create_enemy Veteran 1 7.6
            , create_enemy Veteran 1 7.8
            , create_enemy Veteran -1 8

            , create_enemy Veteran -1 8.2
            , create_enemy Veteran 0 8.4
            , create_enemy Veteran 1 8.6
            , create_enemy Veteran 0 8.8
            , create_enemy Veteran -1 9

            , create_enemy Plane 1 15
            , create_enemy Plane 0 15
            , create_enemy Plane -1 15
        ]
        , create_wave 9 100
        [
            create_enemy HeavyTank -1 0
            , create_enemy Tank 1 0
            , create_enemy HeavyTank -1 1
            , create_enemy Tank 1 0.8

            , create_enemy Soldier -1 2
            , create_enemy Soldier -0.3 2
            , create_enemy Soldier -0.2 2
            , create_enemy Soldier -0.1 2
            , create_enemy Soldier 0.1 2
            , create_enemy Soldier 0.2 2
            , create_enemy Soldier 0.3 2
            , create_enemy Soldier 0.4 2

            , create_enemy Warrior -1 3
            , create_enemy Warrior -0.3 3
            , create_enemy Warrior -0.2 3
            , create_enemy Warrior -0.1 3
            , create_enemy Warrior 0.1 3
            , create_enemy Warrior 0.2 3
            , create_enemy Warrior 0.3 3
            , create_enemy Warrior 0.4 3

            , create_enemy HeavyTank 1 4
            , create_enemy Tank -1 4
            , create_enemy HeavyTank 1 5
            , create_enemy Tank -1 4.8

            , create_enemy Warrior -1 6
            , create_enemy Warrior -0.3 6
            , create_enemy Warrior -0.2 6
            , create_enemy Warrior -0.1 6
            , create_enemy Warrior 0.1 6
            , create_enemy Warrior 0.2 6
            , create_enemy Warrior 0.3 6
            , create_enemy Warrior 0.4 6

            , create_enemy Soldier -1 7
            , create_enemy Soldier -0.3 7
            , create_enemy Soldier -0.2 7
            , create_enemy Soldier -0.1 7
            , create_enemy Soldier 0.1 7
            , create_enemy Soldier 0.2 7
            , create_enemy Soldier 0.3 7
            , create_enemy Soldier 0.4 7

            , create_enemy HeavyTank 1 11
            , create_enemy Tank 0 11
            , create_enemy HeavyTank -1 11
            , create_enemy HeavyTank 1 12
            , create_enemy Tank 0 11.8
            , create_enemy HeavyTank -1 12
        ]
        , create_wave 10 0
        [
            create_enemy HeavyTank 1 0
            , create_enemy HeavyTank 0 0
            , create_enemy HeavyTank -1 0
            , create_enemy Tank -0.2 0.5
            , create_enemy Tank 0.2 0.5

            , create_enemy Plane -1 4
            , create_enemy Plane 1 4
            , create_enemy Plane -1 5
            , create_enemy Plane 1 5

            , create_enemy HeavyTank 1 8
            , create_enemy HeavyTank 0 8
            , create_enemy HeavyTank -1 8
            , create_enemy Tank -0.2 8.5
            , create_enemy Tank 0.2 8.5

            , create_enemy Scout -1 10
            , create_enemy Scout -1 10.1
            , create_enemy Scout -1 10.2
            , create_enemy Scout -1 10.3
            , create_enemy Scout -1 10.4
            , create_enemy Scout -1 10.5
            , create_enemy Scout -1 10.6
            , create_enemy Scout -1 10.7
            , create_enemy Scout -1 10.8
            , create_enemy Scout -1 10.9
            , create_enemy Scout -1 11
            
            , create_enemy Soldier -0.2 10
            , create_enemy Soldier -0.2 10.2
            , create_enemy Soldier -0.2 10.4
            , create_enemy Soldier -0.2 10.6
            , create_enemy Soldier -0.2 10.8
            , create_enemy Soldier -0.2 11

            , create_enemy Warrior 0.2 10
            , create_enemy Warrior 0.2 10.33
            , create_enemy Warrior 0.2 10.66
            , create_enemy Warrior 0.2 11

            , create_enemy Veteran 1 10
            , create_enemy Veteran 1 10.5
            , create_enemy Veteran 1 11

            , create_enemy Plane -1 15
            , create_enemy Plane 1 15
            , create_enemy Plane -1 16
            , create_enemy Plane 1 16

            , create_enemy HeavyTank 1 20
            , create_enemy HeavyTank 0 20
            , create_enemy HeavyTank -1 20
            , create_enemy Tank -0.2 20.5
            , create_enemy Tank 0.2 20.5
        ]
    ]

airport : Maybe Point 
airport = Just (Point (5.5, 12) Down)

path : List Point
path = 
    [
        Point (12, 11) Left
        , Point (9, 11) Left
        , Point (9, 10) Down
        , Point (4, 10) Left
        , Point (4, 11) Up
        , Point (1, 11) Left
        , Point (1, 6) Down
        , Point (7, 6) Right
        , Point (7, 4) Down
        , Point (1, 4) Left
        , Point (1, 1) Down
        , Point (12, 1) Right
    ]

tileList : List ((Float, Float), Tile)
tileList = 
    [
        create_tile (0,0) Road 12
        , create_tile (1,0) Road 2
        , create_tile (2,0) Road 2
        , create_tile (3,0) Road 2
        , create_tile (4,0) Road 2
        , create_tile (5,0) Road 2
        , create_tile (6,0) Road 2
        , create_tile (7,0) Road 2
        , create_tile (8,0) Road 2
        , create_tile (9,0) Road 2
        , create_tile (10,0) Road 2
        , create_tile (11,0) Road 2
        , create_tile (0,1) Road 3
        , create_tile (1,1) Road 6
        , create_tile (2,1) Road 4
        , create_tile (3,1) Road 4
        , create_tile (4,1) Road 4
        , create_tile (5,1) Road 4
        , create_tile (6,1) Road 4
        , create_tile (7,1) Road 4
        , create_tile (8,1) Road 4
        , create_tile (9,1) Road 4
        , create_tile (10,1) Road 4
        , create_tile (11,1) Road 4
        , create_tile (0,2) Road 3
        , create_tile (1,2) Road 5
        , create_tile (2,2) (Lot Nothing) 0
        , create_tile (3,2) (Lot Nothing) 0
        , create_tile (4,2) (Lot (create_obstacle "tree-round" 0.85 0 (1, -1))) 0
        , create_tile (5,2) (Lot Nothing) 0
        , create_tile (6,2) (Lot (create_obstacle "rock-3" 0.75 140 (1, 1))) 0
        , create_tile (7,2) (Lot (create_obstacle "tree-star" 0.6 60 (-1, 0))) 0
        , create_tile (8,2) (Lot Nothing) 0
        , create_tile (9,2) (Lot Nothing) 0
        , create_tile (10,2) (Lot Nothing) 0
        , create_tile (11,2) (Lot Nothing) 0
        , create_tile (0,3) Road 3
        , create_tile (1,3) Road 9
        , create_tile (2,3) Road 2
        , create_tile (3,3) Road 2
        , create_tile (4,3) Road 2
        , create_tile (5,3) Road 2
        , create_tile (6,3) Road 2
        , create_tile (7,3) Road 13
        , create_tile (8,3) (Lot Nothing) 0
        , create_tile (9,3) (Lot (create_obstacle "bush-many" 0.8 110 (0, -1))) 0
        , create_tile (10,3) (Lot Nothing) 0
        , create_tile (11,3) (Lot Nothing) 0
        , create_tile (0,4) Road 10
        , create_tile (1,4) Road 4
        , create_tile (2,4) Road 4
        , create_tile (3,4) Road 4
        , create_tile (4,4) Road 4
        , create_tile (5,4) Road 4
        , create_tile (6,4) Road 7
        , create_tile (7,4) Road 5
        , create_tile (8,4) (Lot Nothing) 0
        , create_tile (9,4) (Lot Nothing) 0
        , create_tile (10,4) (Lot Nothing) 0
        , create_tile (11,4) (Lot (create_obstacle "bush" 0.6 20 (-1, 1))) 0
        , create_tile (0,5) Road 12
        , create_tile (1,5) Road 2
        , create_tile (2,5) Road 2
        , create_tile (3,5) Road 2
        , create_tile (4,5) Road 2
        , create_tile (5,5) Road 2
        , create_tile (6,5) Road 8
        , create_tile (7,5) Road 5
        , create_tile (8,5) (Lot Nothing) 0
        , create_tile (9,5) (Lot Nothing) 0
        , create_tile (10,5) (Lot (create_obstacle "tree-star" 0.9 45 (0, 0))) 0
        , create_tile (11,5) (Lot (create_obstacle "rock-4" 0.5 90 (-0.15, 0))) 0
        , create_tile (0,6) Road 3
        , create_tile (1,6) Road 6
        , create_tile (2,6) Road 4
        , create_tile (3,6) Road 4
        , create_tile (4,6) Road 4
        , create_tile (5,6) Road 4
        , create_tile (6,6) Road 4
        , create_tile (7,6) Road 11
        , create_tile (8,6) (Lot Nothing) 0
        , create_tile (9,6) (Lot (create_obstacle "tree" 0.7 30 (1, -1))) 0
        , create_tile (10,6) (Lot (create_obstacle "tree-round" 0.8 200 (0, 1))) 0
        , create_tile (11,6) (Lot (create_obstacle "bush-many" 0.65 120 (-1, -1))) 0
        , create_tile (0,7) Road 3
        , create_tile (1,7) Road 5
        , create_tile (2,7) (Lot (create_obstacle "tree" 0.65 40 (-1, 1))) 0
        , create_tile (3,7) (Lot (create_obstacle "bush-many" 0.55 50 (0, 1))) 0
        , create_tile (4,7) (Lot Nothing) 0
        , create_tile (5,7) (Lot Nothing) 0
        , create_tile (6,7) (Lot Nothing) 0
        , create_tile (7,7) (Lot (create_obstacle "tree-round" 0.55 100 (1, -1))) 0
        , create_tile (8,7) (Lot Nothing) 0
        , create_tile (9,7) (Lot Nothing) 0
        , create_tile (10,7) (Lot (create_obstacle "bush" 0.55 20 (1, 0))) 0
        , create_tile (11,7) (Lot Nothing) 0
        , create_tile (0,8) Road 3
        , create_tile (1,8) Road 5
        , create_tile (2,8) (Lot Nothing) 0
        , create_tile (3,8) (Lot Nothing) 0
        , create_tile (4,8) (Lot (create_obstacle "rock-1" 0.8 270 (1, 1))) 0
        , create_tile (5,8) (Lot (create_obstacle "tree" 0.7 160 (0, -1))) 0
        , create_tile (6,8) (Lot Nothing) 0
        , create_tile (7,8) (Lot Nothing) 0
        , create_tile (8,8) (Lot (create_obstacle "tree-star" 0.5 60 (-1, 1))) 0
        , create_tile (9,8) (Lot Nothing) 0
        , create_tile (10,8) (Lot (create_obstacle "rock-6" 0.85 180 (1, -1))) 0
        , create_tile (11,8) (Lot (create_obstacle "tree" 0.6 45 (-1, 0))) 0
        , create_tile (0,9) Road 3
        , create_tile (1,9) Road 5
        , create_tile (2,9) (Lot (create_obstacle "bush" 0.7 0 (-1, 1))) 0
        , create_tile (3,9) Road 12
        , create_tile (4,9) Road 2
        , create_tile (5,9) Road 2
        , create_tile (6,9) Road 2
        , create_tile (7,9) Road 2
        , create_tile (8,9) Road 2
        , create_tile (9,9) Road 13
        , create_tile (10,9) (Lot Nothing) 0
        , create_tile (11,9) (Lot (create_obstacle "tree-star" 0.85 170 (1, -1))) 0
        , create_tile (0,10) Road 3
        , create_tile (1,10) Road 9
        , create_tile (2,10) Road 2
        , create_tile (3,10) Road 8
        , create_tile (4,10) Road 6
        , create_tile (5,10) Road 4
        , create_tile (6,10) Road 4
        , create_tile (7,10) Road 4
        , create_tile (8,10) Road 7
        , create_tile (9,10) Road 9
        , create_tile (10,10) Road 2
        , create_tile (11,10) Road 2
        , create_tile (0,11) Road 10
        , create_tile (1,11) Road 4
        , create_tile (2,11) Road 4
        , create_tile (3,11) Road 4
        , create_tile (4,11) Road 11
        , create_tile (5,11) Road 17
        , create_tile (6,11) (Lot Nothing) 0
        , create_tile (7,11) (Lot (create_obstacle "rock-5" 0.8 10 (1, -1))) 0
        , create_tile (8,11) Road 10
        , create_tile (9,11) Road 4
        , create_tile (10,11) Road 4
        , create_tile (11,11) Road 4
    ]
