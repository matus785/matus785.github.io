module Game.Maps.Map5 exposing (..)

import Game.Calculations exposing (..)
import Game.Tiles exposing (..)
import Game.Enemies exposing (..)

mapWidth : Int
mapWidth = 14

mapHeight : Int
mapHeight = 14

startingCash : Int
startingCash = 480

waveList : List Wave
waveList = 
    [
        create_wave 1 200
        [
            create_enemy Scout 1 0
            , create_enemy Scout 0.3 0
            , create_enemy Scout 0.2 0
            , create_enemy Scout 0.1 0

            , create_enemy Scout 1 2
            , create_enemy Scout 0.3 2
            , create_enemy Scout 0.2 2
            , create_enemy Scout 0.1 2

            , create_enemy Soldier -1 4
        ]  
        , create_wave 2 300
        [
            create_enemy Soldier 0.2 0
            , create_enemy Soldier 0 0
            , create_enemy Soldier -0.2 0
            , create_enemy Soldier 0.1 0.1
            , create_enemy Soldier -0.1 0.1

            , create_enemy Scout 0 4

            , create_enemy Soldier 0.2 8
            , create_enemy Soldier 0 8
            , create_enemy Soldier -0.2 8
            , create_enemy Soldier 0.1 8.1
            , create_enemy Soldier -0.1 8.1

            , create_enemy Scout 0 12
        ]
        , create_wave 3 150
        [
            create_enemy Warrior -1 0
            , create_enemy Warrior -0.2 0
            , create_enemy Warrior 0 0
            , create_enemy Warrior 0.2 0
            , create_enemy Warrior 1 0
            , create_enemy Warrior -1 0.2
            , create_enemy Warrior -0.2 0.2
            , create_enemy Warrior 0 0.2
            , create_enemy Warrior 0.2 0.2
            , create_enemy Warrior 1 0.2

            , create_enemy Soldier -1 2
            , create_enemy Soldier -1 2.5

            , create_enemy Warrior -1 6
            , create_enemy Warrior -0.2 6
            , create_enemy Warrior 0 6
            , create_enemy Warrior 0.2 6
            , create_enemy Warrior 1 6
            , create_enemy Warrior -1 6.2
            , create_enemy Warrior -0.2 6.2
            , create_enemy Warrior 0 6.2
            , create_enemy Warrior 0.2 6.2
            , create_enemy Warrior 1 6.2

            , create_enemy Soldier 1 8
            , create_enemy Soldier 1 8.5
        ]

        , create_wave 4 250
        [
            create_enemy Soldier 0.2 0
            , create_enemy Soldier 0.1 0
            , create_enemy Soldier 0 0
            , create_enemy Soldier -0.1 0
            , create_enemy Soldier -0.2 0

            , create_enemy Scout -1 0.2
            , create_enemy Scout -1 0.4
            , create_enemy Scout -1 0.6
            , create_enemy Scout -1 0.8
            , create_enemy Scout -1 1
            , create_enemy Scout -1 1.2
            , create_enemy Scout -1 1.4
            , create_enemy Scout -1 1.6
            , create_enemy Scout -1 1.8

            , create_enemy Soldier 0.2 2
            , create_enemy Soldier 0.1 2
            , create_enemy Soldier 0 2
            , create_enemy Soldier -0.1 2
            , create_enemy Soldier -0.2 2

            , create_enemy Scout -1 2.2
            , create_enemy Scout -1 2.4
            , create_enemy Scout -1 2.6
            , create_enemy Scout -1 2.8
            , create_enemy Scout -1 3
            , create_enemy Scout -1 3.2
            , create_enemy Scout -1 3.4
            , create_enemy Scout -1 3.6
            , create_enemy Scout -1 3.8

            , create_enemy Soldier 0.2 4
            , create_enemy Soldier 0.1 4
            , create_enemy Soldier 0 4
            , create_enemy Soldier -0.1 4
            , create_enemy Soldier -0.2 4

            , create_enemy Veteran 0 8
        ]
        , create_wave 5 350
        [
            create_enemy Veteran 0 0

            , create_enemy Warrior -1 1
            , create_enemy Warrior -0.2 1
            , create_enemy Warrior 0.2 1
            , create_enemy Warrior 1 1

            , create_enemy Warrior -1 2
            , create_enemy Warrior -0.2 2
            , create_enemy Warrior 0.2 2
            , create_enemy Warrior 1 2

            , create_enemy Veteran 0 4

            , create_enemy Warrior -1 5
            , create_enemy Warrior -0.2 5
            , create_enemy Warrior 0.2 5
            , create_enemy Warrior 1 5

            , create_enemy Warrior -1 6
            , create_enemy Warrior -0.2 6
            , create_enemy Warrior 0.2 6
            , create_enemy Warrior 1 6

            , create_enemy Veteran -1 8

            , create_enemy Warrior -1 9
            , create_enemy Warrior -0.2 9
            , create_enemy Warrior 0.2 9
            , create_enemy Warrior 1 9

            , create_enemy Warrior -1 10
            , create_enemy Warrior -0.2 10
            , create_enemy Warrior 0.2 10
            , create_enemy Warrior 1 10

            , create_enemy Tank 0 16
        ]
        , create_wave 6 400
        [
            create_enemy Tank 0 0
            , create_enemy Tank 0 0.5

            , create_enemy Tank -1 8
            , create_enemy Tank -1 8.5

            , create_enemy Tank 1 16
            , create_enemy Tank 1 16.5

            , create_enemy HeavyTank 0 20
        ]

        , create_wave 7 450
        [
            create_enemy HeavyTank 0 0

            , create_enemy Veteran 0.2 1
            , create_enemy Veteran -0.2 1
            , create_enemy Veteran 0.2 2
            , create_enemy Veteran -0.2 2

            , create_enemy HeavyTank 0 8

            , create_enemy Veteran 0.2 9
            , create_enemy Veteran -0.2 9
            , create_enemy Veteran 0.2 10
            , create_enemy Veteran -0.2 10

            , create_enemy HeavyTank 0 16

            , create_enemy Veteran 0.2 17
            , create_enemy Veteran -0.2 17
            , create_enemy Veteran 0.2 18
            , create_enemy Veteran -0.2 18 

            , create_enemy HeavyTank -1 22
            , create_enemy HeavyTank 1 22
        ]

        , create_wave 8 450
        [
            create_enemy HeavyTank -1 0
            , create_enemy Tank 0 0
            , create_enemy HeavyTank 1 0

            , create_enemy Warrior 1 4
            , create_enemy Warrior -0.35 4
            , create_enemy Warrior -0.3 4
            , create_enemy Warrior -0.25 4
            , create_enemy Warrior -0.2 4
            , create_enemy Warrior -0.15 4
            , create_enemy Warrior -0.1 4
            , create_enemy Warrior 0.1 4
            , create_enemy Warrior 0.15 4
            , create_enemy Warrior 0.2 4
            , create_enemy Warrior 0.25 4
            , create_enemy Warrior 0.3 4
            , create_enemy Warrior 0.35 4
            , create_enemy Warrior -1 4

            , create_enemy HeavyTank -1 8
            , create_enemy Tank 0 8
            , create_enemy HeavyTank 1 8

            , create_enemy Warrior 1 12
            , create_enemy Warrior -0.35 12
            , create_enemy Warrior -0.3 12
            , create_enemy Warrior -0.25 12
            , create_enemy Warrior -0.2 12
            , create_enemy Warrior -0.15 12
            , create_enemy Warrior -0.1 12
            , create_enemy Warrior 0.1 12
            , create_enemy Warrior 0.15 12
            , create_enemy Warrior 0.2 12
            , create_enemy Warrior 0.25 12
            , create_enemy Warrior 0.3 12
            , create_enemy Warrior 0.35 12
            , create_enemy Warrior -1 12

            , create_enemy HeavyTank -1 16
            , create_enemy Tank 0 16
            , create_enemy HeavyTank 1 16

            , create_enemy Veteran -1 24
            , create_enemy Veteran 1 25
            , create_enemy Veteran 0 26
            , create_enemy Veteran 1 27
            , create_enemy Veteran -1 28
        ]

        , create_wave 9 0
        [
            create_enemy HeavyTank 0 0
            , create_enemy Tank 0 2

            , create_enemy Scout -1 2.5
            , create_enemy Scout -1 3
            , create_enemy Scout -1 3.5
            , create_enemy Scout 1 2.5
            , create_enemy Scout 1 3
            , create_enemy Scout 1 3.5

            , create_enemy HeavyTank 0 4
            , create_enemy Tank 0 6

            , create_enemy Soldier -1 6.5
            , create_enemy Soldier -1 7
            , create_enemy Soldier -1 7.5
            , create_enemy Soldier 1 6.5
            , create_enemy Soldier 1 7
            , create_enemy Soldier 1 7.5

            , create_enemy HeavyTank 0 8
            , create_enemy Tank 0 10

            , create_enemy Warrior -1 10.5
            , create_enemy Warrior -1 11
            , create_enemy Warrior -1 11.5
            , create_enemy Warrior 1 10.5
            , create_enemy Warrior 1 11
            , create_enemy Warrior 1 11.5

            , create_enemy HeavyTank 0 12
            , create_enemy Tank 0 14

            , create_enemy Veteran -1 14.5
            , create_enemy Veteran -1 15
            , create_enemy Veteran -1 15.5
            , create_enemy Veteran 1 14.5
            , create_enemy Veteran 1 15
            , create_enemy Veteran 1 15.5
            
            , create_enemy Tank -1 20
            , create_enemy Tank 1 20
            , create_enemy HeavyTank 0 21
            , create_enemy Tank -1 22
            , create_enemy Tank 1 22
        ]
    ]

airport : Maybe Point 
airport = Nothing

path : List Point
path = 
    [
        Point (11, 14) Down
        , Point (11, 11) Down
        , Point (12, 11) Right
        , Point (12, 4) Down
        , Point (11, 4) Left
        , Point (11, 2) Down
        , Point (4, 2) Left
        , Point (4, 7) Up
        , Point (7, 7) Right
        , Point (7, 11) Up
        , Point (3, 11) Left
        , Point (3, 14) Up
    ]

tileList : List ((Float, Float), Tile)
tileList = 
    [
        create_tile (0,0) (Lot Nothing) 0
        , create_tile (1,0) (Lot Nothing) 0
        , create_tile (2,0) (Lot (create_obstacle "rock-2" 0.75 0 (1, 1))) 0
        , create_tile (3,0) (Lot Nothing) 0
        , create_tile (4,0) (Lot Nothing) 0
        , create_tile (5,0) (Lot (create_obstacle "tree-star" 0.9 40 (0, 0))) 0
        , create_tile (6,0) (Lot (create_obstacle "tree-round" 0.65 70 (-1, 1))) 0
        , create_tile (7,0) (Lot Nothing) 0
        , create_tile (8,0) (Lot Nothing) 0
        , create_tile (9,0) (Lot (create_obstacle "bush" 0.8 190 (-1, -1))) 0
        , create_tile (10,0) (Lot Nothing) 0
        , create_tile (11,0) (Lot (create_obstacle "rock-6" 0.5 90 (1, -1))) 0
        , create_tile (12,0) (Lot (create_obstacle "tree-round" 0.75 30 (1, 1))) 0
        , create_tile (13,0) (Lot (create_obstacle "tree" 0.8 120 (0, 1))) 0
        , create_tile (0,1) (Lot Nothing) 0
        , create_tile (1,1) (Lot Nothing) 0
        , create_tile (2,1) (Lot Nothing) 0
        , create_tile (3,1) Road 12
        , create_tile (4,1) Road 2
        , create_tile (5,1) Road 2
        , create_tile (6,1) Road 2
        , create_tile (7,1) Road 2
        , create_tile (8,1) Road 2
        , create_tile (9,1) Road 2
        , create_tile (10,1) Road 2
        , create_tile (11,1) Road 13
        , create_tile (12,1) (Lot (create_obstacle "bush" 0.7 40 (-1, 1))) 0
        , create_tile (13,1) (Lot (create_obstacle "bush-many" 0.6 100 (0, -1))) 0
        , create_tile (0,2) (Lot Nothing) 0
        , create_tile (1,2) (Lot (create_obstacle "tree-round" 0.65 70 (-1, 1))) 0
        , create_tile (2,2) (Lot Nothing) 0
        , create_tile (3,2) Road 3
        , create_tile (4,2) Road 6
        , create_tile (5,2) Road 4
        , create_tile (6,2) Road 4
        , create_tile (7,2) Road 4
        , create_tile (8,2) Road 4
        , create_tile (9,2) Road 4
        , create_tile (10,2) Road 7
        , create_tile (11,2) Road 5
        , create_tile (12,2) (Lot Nothing) 0
        , create_tile (13,2) (Lot (create_obstacle "tree-star" 0.7 20 (-1, -1))) 0
        , create_tile (0,3) (Lot (create_obstacle "rock-6" 0.85 80 (1, -1))) 0
        , create_tile (1,3) (Lot (create_obstacle "tree-star" 0.65 180 (0, 1))) 0
        , create_tile (2,3) (Lot Nothing) 0
        , create_tile (3,3) Road 3
        , create_tile (4,3) Road 5
        , create_tile (5,3) (Lot (create_obstacle "bush-many" 0.9 180 (0, 0))) 0
        , create_tile (6,3) (Lot Nothing) 0
        , create_tile (7,3) (Lot (create_obstacle "tree" 0.8 130 (-1, -1))) 0
        , create_tile (8,3) (Lot Nothing) 0
        , create_tile (9,3) (Lot Nothing) 0
        , create_tile (10,3) Road 3
        , create_tile (11,3) Road 9
        , create_tile (12,3) Road 13
        , create_tile (13,3) (Lot Nothing) 0
        , create_tile (0,4) (Lot (create_obstacle "bush" 0.55 160 (1, -1))) 0
        , create_tile (1,4) (Lot Nothing) 0
        , create_tile (2,4) (Lot Nothing) 0
        , create_tile (3,4) Road 3
        , create_tile (4,4) Road 5
        , create_tile (5,4) (Lot (create_obstacle "rock-1" 0.65 60 (1, -1))) 0
        , create_tile (6,4) (Lot Nothing) 0
        , create_tile (7,4) (Lot Nothing) 0
        , create_tile (8,4) (Lot Nothing) 0
        , create_tile (9,4) (Lot Nothing) 0
        , create_tile (10,4) Road 10
        , create_tile (11,4) Road 7
        , create_tile (12,4) Road 5
        , create_tile (13,4) (Lot Nothing) 0
        , create_tile (0,5) (Lot Nothing) 0
        , create_tile (1,5) (Lot Nothing) 0
        , create_tile (2,5) (Lot Nothing) 0
        , create_tile (3,5) Road 3
        , create_tile (4,5) Road 5
        , create_tile (5,5) (Lot Nothing) 0
        , create_tile (6,5) (Lot Nothing) 0
        , create_tile (7,5) (Lot Nothing) 0
        , create_tile (8,5) (Lot Nothing) 0
        , create_tile (9,5) (Lot (create_obstacle "tree" 0.55 40 (-1, 1))) 0
        , create_tile (10,5) (Lot Nothing) 0
        , create_tile (11,5) Road 3
        , create_tile (12,5) Road 5
        , create_tile (13,5) (Lot Nothing) 0
        , create_tile (0,6) (Lot (create_obstacle "tree" 0.7 170 (1, -1))) 0
        , create_tile (1,6) (Lot Nothing) 0
        , create_tile (2,6) (Lot Nothing) 0
        , create_tile (3,6) Road 3
        , create_tile (4,6) Road 9
        , create_tile (5,6) Road 2
        , create_tile (6,6) Road 2
        , create_tile (7,6) Road 13
        , create_tile (8,6) (Lot Nothing) 0
        , create_tile (9,6) (Lot Nothing) 0
        , create_tile (10,6) (Lot Nothing) 0
        , create_tile (11,6) Road 3
        , create_tile (12,6) Road 5
        , create_tile (13,6) (Lot (create_obstacle "rock-4" 0.8 160 (-1, 1))) 0
        , create_tile (0,7) (Lot Nothing) 0
        , create_tile (1,7) (Lot Nothing) 0
        , create_tile (2,7) (Lot Nothing) 0
        , create_tile (3,7) Road 10
        , create_tile (4,7) Road 4
        , create_tile (5,7) Road 4
        , create_tile (6,7) Road 7
        , create_tile (7,7) Road 5
        , create_tile (8,7) (Lot (create_obstacle "tree-round" 0.85 0 (1, -1))) 0
        , create_tile (9,7) (Lot Nothing) 0
        , create_tile (10,7) (Lot Nothing) 0
        , create_tile (11,7) Road 3
        , create_tile (12,7) Road 5
        , create_tile (13,7) (Lot Nothing) 0
        , create_tile (0,8) (Lot Nothing) 0
        , create_tile (1,8) (Lot (create_obstacle "rock-4" 0.65 10 (1, 1))) 0
        , create_tile (2,8) (Lot Nothing) 0
        , create_tile (3,8) (Lot Nothing) 0
        , create_tile (4,8) (Lot Nothing) 0
        , create_tile (5,8) (Lot (create_obstacle "bush" 0.5 210 (0, -1))) 0
        , create_tile (6,8) Road 3
        , create_tile (7,8) Road 5
        , create_tile (8,8) (Lot Nothing) 0
        , create_tile (9,8) (Lot Nothing) 0
        , create_tile (10,8) (Lot (create_obstacle "rock-5" 0.65 280 (0, 1))) 0
        , create_tile (11,8) Road 3
        , create_tile (12,8) Road 5
        , create_tile (13,8) (Lot Nothing) 0
        , create_tile (0,9) (Lot (create_obstacle "bush-many" 0.7 150 (1, 0))) 0
        , create_tile (1,9) (Lot Nothing) 0
        , create_tile (2,9) (Lot Nothing) 0
        , create_tile (3,9) (Lot (create_obstacle "tree-star" 0.75 40 (1, 0))) 0
        , create_tile (4,9) (Lot (create_obstacle "tree" 0.9 200 (0, 0))) 0
        , create_tile (5,9) (Lot Nothing) 0
        , create_tile (6,9) Road 3
        , create_tile (7,9) Road 5
        , create_tile (8,9) (Lot Nothing) 0
        , create_tile (9,9) (Lot (create_obstacle "bush" 0.55 80 (1, 1))) 0
        , create_tile (10,9) (Lot (create_obstacle "tree-star" 0.85 60 (1, -1))) 0
        , create_tile (11,9) Road 3
        , create_tile (12,9) Road 5
        , create_tile (13,9) (Lot (create_obstacle "tree" 0.6 45 (-0.2, -1))) 0
        , create_tile (0,10) (Lot (create_obstacle "rock-2" 0.7 190 (1, 0))) 0
        , create_tile (1,10) (Lot (create_obstacle "tree-round" 0.9 180 (0, 0))) 0
        , create_tile (2,10) Road 12
        , create_tile (3,10) Road 2
        , create_tile (4,10) Road 2
        , create_tile (5,10) Road 2
        , create_tile (6,10) Road 8
        , create_tile (7,10) Road 5
        , create_tile (8,10) (Lot Nothing) 0
        , create_tile (9,10) (Lot (create_obstacle "rock-3" 0.75 0 (1, 1))) 0
        , create_tile (10,10) Road 12
        , create_tile (11,10) Road 8
        , create_tile (12,10) Road 5
        , create_tile (13,10) (Lot (create_obstacle "tree-round" 0.7 0 (-1, 0))) 0
        , create_tile (0,11) (Lot (create_obstacle "bush" 0.5 80 (1, -1))) 0
        , create_tile (1,11) (Lot Nothing) 0
        , create_tile (2,11) Road 3
        , create_tile (3,11) Road 6
        , create_tile (4,11) Road 4
        , create_tile (5,11) Road 4
        , create_tile (6,11) Road 4
        , create_tile (7,11) Road 11
        , create_tile (8,11) (Lot (create_obstacle "tree-round" 0.6 0 (-1, 1))) 0
        , create_tile (9,11) (Lot Nothing) 0
        , create_tile (10,11) Road 3
        , create_tile (11,11) Road 6
        , create_tile (12,11) Road 11
        , create_tile (13,11) (Lot (create_obstacle "rock-3" 0.7 45 (-1, -1))) 0
        , create_tile (0,12) (Lot Nothing) 0
        , create_tile (1,12) (Lot Nothing) 0
        , create_tile (2,12) Road 3
        , create_tile (3,12) Road 5
        , create_tile (4,12) (Lot Nothing) 0
        , create_tile (5,12) (Lot (create_obstacle "bush-many" 0.65 140 (1, 1))) 0
        , create_tile (6,12) (Lot (create_obstacle "tree-round" 0.9 10 (0, 0))) 0
        , create_tile (7,12) (Lot (create_obstacle "bush-many" 0.8 225 (1, -1))) 0
        , create_tile (8,12) (Lot (create_obstacle "bush" 0.7 50 (0, -1))) 0
        , create_tile (9,12) (Lot Nothing) 0
        , create_tile (10,12) Road 3
        , create_tile (11,12) Road 5
        , create_tile (12,12) (Lot (create_obstacle "tree" 0.9 70 (0, 0))) 0
        , create_tile (13,12) (Lot (create_obstacle "bush-many" 0.8 0 (-1, -1))) 0
        , create_tile (0,13) (Lot Nothing) 0
        , create_tile (1,13) (Lot (create_obstacle "rock-3" 0.85 120 (1, -1))) 0
        , create_tile (2,13) Road 3
        , create_tile (3,13) Road 5
        , create_tile (4,13) (Lot Nothing) 0
        , create_tile (5,13) (Lot Nothing) 0
        , create_tile (6,13) (Lot Nothing) 0
        , create_tile (7,13) (Lot (create_obstacle "tree-star" 0.7 30 (1, -1))) 0
        , create_tile (8,13) (Lot (create_obstacle "rock-1" 0.8 0 (0, -1))) 0
        , create_tile (9,13) (Lot (create_obstacle "tree" 0.65 0 (-1, 1))) 0
        , create_tile (10,13) Road 3
        , create_tile (11,13) Road 5
        , create_tile (12,13) (Lot Nothing) 0
        , create_tile (13,13) (Lot Nothing) 0
    ]
