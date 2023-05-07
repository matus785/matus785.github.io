module Game.Maps.Map6 exposing (..)

import Game.Calculations exposing (..)
import Game.Tiles exposing (..)
import Game.Enemies exposing (..)

mapWidth : Int
mapWidth = 16

mapHeight : Int
mapHeight = 16

startingCash : Int
startingCash = 450

waveList : List Wave
waveList = 
    [
        create_wave 1 450
        [
            create_enemy Soldier -1 0
            , create_enemy Soldier -1 0.2

            , create_enemy Soldier -1 6
            , create_enemy Soldier -1 6.2

            , create_enemy Soldier 0 10
        ]  
        , create_wave 2 350
        [
            create_enemy Warrior -1 0
            , create_enemy Warrior -1 0.5

            , create_enemy Scout -1 3
            , create_enemy Scout -1 3.15
            , create_enemy Scout -1 3.3

            , create_enemy Warrior -1 6
            , create_enemy Warrior -1 6.5

            , create_enemy Scout 1 10.5
            , create_enemy Scout 1 10.65
            , create_enemy Scout 1 10.8

            , create_enemy Warrior -1 12
            , create_enemy Warrior -0.2 13.5
            , create_enemy Warrior 0 15
        ]  
        , create_wave 3 450
        [
            create_enemy Veteran -1 0

            , create_enemy Scout -1 1
            , create_enemy Scout 0 1.5
            , create_enemy Scout -1 2
            , create_enemy Scout 0 2.5
            , create_enemy Scout -1 3
            , create_enemy Scout 0 3.5
            , create_enemy Scout -1 4
            , create_enemy Scout 0 4.5
            , create_enemy Scout -1 5
            , create_enemy Scout 0 5.5

            , create_enemy Veteran 0 6

            , create_enemy Scout -1 7
            , create_enemy Scout 0 7.5
            , create_enemy Scout -1 8
            , create_enemy Scout 0 8.5
            , create_enemy Scout -1 9
            , create_enemy Scout 0 9.5
            , create_enemy Scout -1 10
            , create_enemy Scout 0 10.5
            , create_enemy Scout -1 11
            , create_enemy Scout 0 11.5

            , create_enemy Veteran 1 14
        ]  
        , create_wave 4 250
        [
            create_enemy Tank -1 0

            , create_enemy Veteran 1 4
            , create_enemy Veteran -1 4

            , create_enemy Tank -1 8

            , create_enemy Veteran 1 12
            , create_enemy Veteran -1 12

            , create_enemy Tank -1 14
        ]
        , create_wave 5 200
        [
            create_enemy Soldier -1 0
            , create_enemy Soldier -0.2 0
            , create_enemy Soldier 0.2 0
            , create_enemy Soldier 1 0

            , create_enemy Soldier -1 0.3
            , create_enemy Soldier -0.2 0.3
            , create_enemy Soldier 0.2 0.3
            , create_enemy Soldier 1 0.3

            , create_enemy Soldier -1 0.6
            , create_enemy Soldier -0.2 0.6
            , create_enemy Soldier 0.2 0.6
            , create_enemy Soldier 1 0.6

            , create_enemy Soldier -0.3 2
            , create_enemy Soldier 0 2
            , create_enemy Soldier 0.3 2

            , create_enemy Soldier -0.3 2.2
            , create_enemy Soldier 0 2.2
            , create_enemy Soldier 0.3 2.2

            , create_enemy Soldier -0.3 2.4
            , create_enemy Soldier 0 2.4
            , create_enemy Soldier 0.3 2.4

            , create_enemy Soldier 1 6
            , create_enemy Soldier 0 6
            , create_enemy Soldier -1 6
            , create_enemy Soldier 0.2 6.15
            , create_enemy Soldier -0.2 6.15
            , create_enemy Soldier 1 6.3
            , create_enemy Soldier 0 6.3
            , create_enemy Soldier -1 6.3

            , create_enemy Soldier 1 8
            , create_enemy Soldier 0 8
            , create_enemy Soldier -1 8
            , create_enemy Soldier 0.2 8.15
            , create_enemy Soldier -0.2 8.15
            , create_enemy Soldier 1 8.3
            , create_enemy Soldier 0 8.3
            , create_enemy Soldier -1 8.3
        ]
        , create_wave 6 450
        [
            create_enemy Tank 0 0

            , create_enemy Veteran 0 2
            , create_enemy Veteran 0 2.5
            , create_enemy Veteran 0 3

            , create_enemy Tank 0 5

            , create_enemy Veteran -1 7
            , create_enemy Veteran -1 7.5
            , create_enemy Veteran -1 8

            , create_enemy Tank 0 10

            , create_enemy Veteran 1 12
            , create_enemy Veteran 1 12.5
            , create_enemy Veteran 1 13

            , create_enemy HeavyTank -1 18
            , create_enemy HeavyTank 1 18
        ]
        , create_wave 7 150
        [
            create_enemy Tank 0 0
            , create_enemy Tank 0 1

            , create_enemy Warrior -1 3
            , create_enemy Warrior -0.3 3
            , create_enemy Warrior -0.2 3
            , create_enemy Warrior -0.1 3
            , create_enemy Warrior 0.1 3
            , create_enemy Warrior 0.2 3
            , create_enemy Warrior 0.3 3
            , create_enemy Warrior 1 3
            , create_enemy Warrior -1 4
            , create_enemy Warrior -0.3 4
            , create_enemy Warrior -0.2 4
            , create_enemy Warrior -0.1 4
            , create_enemy Warrior 0.1 4
            , create_enemy Warrior 0.2 4
            , create_enemy Warrior 0.3 4
            , create_enemy Warrior 1 4

            , create_enemy Tank -1 8
            , create_enemy Tank -1 9

            , create_enemy Warrior -1 11
            , create_enemy Warrior -0.3 11
            , create_enemy Warrior -0.2 11
            , create_enemy Warrior -0.1 11
            , create_enemy Warrior 0.1 11
            , create_enemy Warrior 0.2 11
            , create_enemy Warrior 0.3 11
            , create_enemy Warrior 1 11
            , create_enemy Warrior -1 12
            , create_enemy Warrior -0.3 12
            , create_enemy Warrior -0.2 12
            , create_enemy Warrior -0.1 12
            , create_enemy Warrior 0.1 12
            , create_enemy Warrior 0.2 12
            , create_enemy Warrior 0.3 12
            , create_enemy Warrior 1 12

            , create_enemy Tank 1 16
            , create_enemy Tank -1 17
            , create_enemy HeavyTank 1 18
            , create_enemy HeavyTank -1 20
        ]
        , create_wave 8 300
        [
            create_enemy Plane -1 0
            , create_enemy Plane 0 10
            , create_enemy Plane 1 20
        ]
        , create_wave 9 200
        [
            create_enemy Plane -1 0

            , create_enemy Warrior -0.3 1
            , create_enemy Warrior -0.2 1
            , create_enemy Warrior -0.1 1
            , create_enemy Warrior 0 1
            , create_enemy Warrior 0.1 1
            , create_enemy Warrior 0.2 1
            , create_enemy Warrior 0.3 1

            , create_enemy Tank 0 6
            , create_enemy Veteran -1 6
            , create_enemy Veteran -1 6.5
            , create_enemy Veteran 1 6
            , create_enemy Veteran 1 6.5

            , create_enemy Warrior -0.3 8
            , create_enemy Warrior -0.2 8
            , create_enemy Warrior -0.1 8
            , create_enemy Warrior 0 8
            , create_enemy Warrior 0.1 8
            , create_enemy Warrior 0.2 8
            , create_enemy Warrior 0.3 8

            , create_enemy Plane -1 12

            , create_enemy Warrior -0.3 13
            , create_enemy Warrior -0.2 13
            , create_enemy Warrior -0.1 13
            , create_enemy Warrior 0 13
            , create_enemy Warrior 0.1 13
            , create_enemy Warrior 0.2 13
            , create_enemy Warrior 0.3 13

            , create_enemy Tank 0 18
            , create_enemy Veteran -1 18
            , create_enemy Veteran -1 18.5
            , create_enemy Veteran 1 18
            , create_enemy Veteran 1 18.5

            , create_enemy Plane -1 20
            , create_enemy Plane 1 20
        ]
        , create_wave 10 0
        [
            create_enemy Plane 0 0

            , create_enemy Tank 0 2
            , create_enemy HeavyTank 0 3

            , create_enemy Plane -1 5

            , create_enemy Soldier -1 5.5
            , create_enemy Soldier 1 6
            , create_enemy Soldier -1 6.5
            , create_enemy Soldier 1 7
            , create_enemy Soldier -1 7.5
            , create_enemy Soldier 1 8
            , create_enemy Soldier -1 8.5
            , create_enemy Soldier 1 9
            , create_enemy Soldier -1 9.5

            , create_enemy Plane 1 10

            , create_enemy Scout -1 10.15
            , create_enemy Scout -1 10.3
            , create_enemy Scout -1 10.45
            , create_enemy Scout -1 10.6
            , create_enemy Scout -1 10.75
            , create_enemy Scout -1 10.9

            , create_enemy Warrior -1 11.2
            , create_enemy Warrior -0.2 11.2
            , create_enemy Warrior 0 11.2
            , create_enemy Warrior 0.2 11.2
            , create_enemy Warrior 1 11.2

            , create_enemy Veteran -1 11.7
            , create_enemy Veteran -0.2 11.7
            , create_enemy Veteran 0 11.7
            , create_enemy Veteran 0.2 11.7
            , create_enemy Veteran 1 11.7

            , create_enemy Scout 0 12
            , create_enemy Scout 0 12.3
            , create_enemy Scout 0 12.45
            , create_enemy Scout 0 12.6
            , create_enemy Scout 0 12.75
            , create_enemy Scout 0 12.9

            , create_enemy Scout 0 14
            , create_enemy Scout 0 14.3
            , create_enemy Scout 0 14.45
            , create_enemy Scout 0 14.6
            , create_enemy Scout 0 14.75
            , create_enemy Scout 0 14.9

            , create_enemy Plane 1 15

            , create_enemy Soldier -1 15.5
            , create_enemy Soldier 1 16
            , create_enemy Soldier -1 16.5
            , create_enemy Soldier 1 17
            , create_enemy Soldier -1 17.5
            , create_enemy Soldier 1 18
            , create_enemy Soldier -1 18.5
            , create_enemy Soldier 1 19
            , create_enemy Soldier -1 19.5

            , create_enemy Plane -1 20

            , create_enemy Tank -1 22
            , create_enemy Tank 1 22
            , create_enemy HeavyTank -1 22
            , create_enemy HeavyTank 1 22

            , create_enemy Plane 0 25
        ]




    ]

airport : Maybe Point 
airport = Just (Point (1.5, 16) Down)

path : List Point
path = 
    [
        Point (16, 14) Left
        , Point (13, 14) Left
        , Point (13, 12) Down
        , Point (9, 12) Left
        , Point (9, 10) Down
        , Point (7, 10) Left
        , Point (7, 8) Down
        , Point (3, 8) Left
        , Point (3, 2) Down
        , Point (11, 2) Right
        , Point (11, 4) Up
        , Point (13, 4) Right
        , Point (13, 6) Up
        , Point (16, 6) Right
    ]

tileList : List ((Float, Float), Tile)
tileList = 
    [
        create_tile (0,0) (Lot Nothing) 0
        , create_tile (1,0) (Lot (create_obstacle "rock-1" 0.75 30 (-1, 1))) 0
        , create_tile (2,0) (Lot (create_obstacle "bush" 0.85 60 (-1, 1))) 0
        , create_tile (3,0) (Lot (create_obstacle "tree-star" 0.65 140 (-1, 0))) 0
        , create_tile (4,0) (Lot Nothing) 0
        , create_tile (5,0) (Lot Nothing) 0
        , create_tile (6,0) (Lot (create_obstacle "tree" 0.7 40 (0, 1))) 0
        , create_tile (7,0) (Lot (create_obstacle "bush" 0.5 190 (-1, 1))) 0
        , create_tile (8,0) (Lot (create_obstacle "rock-5" 0.7 40 (1, -1))) 0
        , create_tile (9,0) (Lot (create_obstacle "tree" 0.8 210 (-1, 1))) 0
        , create_tile (10,0) (Lot (create_obstacle "tree-round" 0.75 10 (0, -1))) 0
        , create_tile (11,0) (Lot Nothing) 0
        , create_tile (12,0) (Lot Nothing) 0
        , create_tile (13,0) (Lot Nothing) 0
        , create_tile (14,0) (Lot (create_obstacle "tree-star" 0.85 130 (-1, 1))) 0
        , create_tile (15,0) (Lot Nothing) 0
        , create_tile (0,1) (Lot (create_obstacle "tree-star" 0.8 45 (-1, 1))) 0
        , create_tile (1,1) (Lot (create_obstacle "bush-many" 0.9 10 (0, 0))) 0
        , create_tile (2,1) Road 12
        , create_tile (3,1) Road 2
        , create_tile (4,1) Road 2
        , create_tile (5,1) Road 2
        , create_tile (6,1) Road 2
        , create_tile (7,1) Road 2
        , create_tile (8,1) Road 2
        , create_tile (9,1) Road 2
        , create_tile (10,1) Road 2
        , create_tile (11,1) Road 13
        , create_tile (12,1) (Lot (create_obstacle "bush-many" 0.9 90 (0, 0))) 0
        , create_tile (13,1) (Lot Nothing) 0
        , create_tile (14,1) (Lot Nothing) 0
        , create_tile (15,1) (Lot Nothing) 0
        , create_tile (0,2) (Lot (create_obstacle "tree-round" 0.6 0 (0, -1))) 0
        , create_tile (1,2) (Lot (create_obstacle "rock-6" 0.55 130 (-1, 0))) 0
        , create_tile (2,2) Road 3
        , create_tile (3,2) Road 6
        , create_tile (4,2) Road 4
        , create_tile (5,2) Road 4
        , create_tile (6,2) Road 4
        , create_tile (7,2) Road 4
        , create_tile (8,2) Road 4
        , create_tile (9,2) Road 4
        , create_tile (10,2) Road 7
        , create_tile (11,2) Road 5
        , create_tile (12,2) (Lot (create_obstacle "rock-4" 0.65 180 (1, 0))) 0
        , create_tile (13,2) (Lot Nothing) 0
        , create_tile (14,2) (Lot Nothing) 0
        , create_tile (15,2) (Lot (create_obstacle "tree" 0.8 70 (-1, 0))) 0
        , create_tile (0,3) (Lot (create_obstacle "tree-round" 0.85 0 (1, -1))) 0
        , create_tile (1,3) (Lot Nothing) 0
        , create_tile (2,3) Road 3
        , create_tile (3,3) Road 5
        , create_tile (4,3) (Lot Nothing) 0
        , create_tile (5,3) (Lot Nothing) 0
        , create_tile (6,3) (Lot Nothing) 0
        , create_tile (7,3) (Lot (create_obstacle "rock-3" 0.5 180 (1, -1))) 0
        , create_tile (8,3) (Lot (create_obstacle "bush-many" 0.75 0 (1, -1))) 0
        , create_tile (9,3) (Lot Nothing) 0
        , create_tile (10,3) Road 3
        , create_tile (11,3) Road 9
        , create_tile (12,3) Road 2
        , create_tile (13,3) Road 13
        , create_tile (14,3) (Lot (create_obstacle "rock-3" 0.9 10 (0, 0))) 0
        , create_tile (15,3) (Lot Nothing) 0
        , create_tile (0,4) (Lot (create_obstacle "tree" 0.7 50 (-1, -1))) 0
        , create_tile (1,4) (Lot Nothing) 0
        , create_tile (2,4) Road 3
        , create_tile (3,4) Road 5
        , create_tile (4,4) (Lot Nothing) 0
        , create_tile (5,4) (Lot (create_obstacle "rock-4" 0.75 240 (-1, 1))) 0
        , create_tile (6,4) (Lot Nothing) 0
        , create_tile (7,4) (Lot Nothing) 0
        , create_tile (8,4) (Lot Nothing) 0
        , create_tile (9,4) (Lot Nothing) 0
        , create_tile (10,4) Road 10
        , create_tile (11,4) Road 4
        , create_tile (12,4) Road 7
        , create_tile (13,4) Road 5
        , create_tile (14,4) (Lot (create_obstacle "tree-round" 0.65 60 (0, -1))) 0
        , create_tile (15,4) (Lot Nothing) 0
        , create_tile (0,5) (Lot Nothing) 0
        , create_tile (1,5) (Lot Nothing) 0
        , create_tile (2,5) Road 3
        , create_tile (3,5) Road 5
        , create_tile (4,5) (Lot (create_obstacle "tree-round" 0.6 90 (1, 1))) 0
        , create_tile (5,5) (Lot (create_obstacle "rock-6" 0.8 280 (0, 1))) 0
        , create_tile (6,5) (Lot Nothing) 0
        , create_tile (7,5) (Lot Nothing) 0
        , create_tile (8,5) (Lot Nothing) 0
        , create_tile (9,5) (Lot (create_obstacle "bush" 0.65 190 (-1, 0))) 0
        , create_tile (10,5) (Lot Nothing) 0
        , create_tile (11,5) (Lot Nothing) 0
        , create_tile (12,5) Road 3
        , create_tile (13,5) Road 9
        , create_tile (14,5) Road 2
        , create_tile (15,5) Road 2
        , create_tile (0,6) (Lot Nothing) 0
        , create_tile (1,6) (Lot Nothing) 0
        , create_tile (2,6) Road 3
        , create_tile (3,6) Road 5
        , create_tile (4,6) (Lot (create_obstacle "tree-star" 0.6 45 (-1, -1))) 0
        , create_tile (5,6) (Lot (create_obstacle "rock-2" 0.65 70 (-1, 1))) 0
        , create_tile (6,6) (Lot (create_obstacle "rock-1" 0.9 290 (0, 0))) 0
        , create_tile (7,6) (Lot Nothing) 0
        , create_tile (8,6) (Lot Nothing) 0
        , create_tile (9,6) (Lot Nothing) 0
        , create_tile (10,6) (Lot Nothing) 0
        , create_tile (11,6) (Lot Nothing) 0
        , create_tile (12,6) Road 10
        , create_tile (13,6) Road 4
        , create_tile (14,6) Road 4
        , create_tile (15,6) Road 4
        , create_tile (0,7) (Lot Nothing) 0
        , create_tile (1,7) (Lot Nothing) 0
        , create_tile (2,7) Road 3
        , create_tile (3,7) Road 9
        , create_tile (4,7) Road 2
        , create_tile (5,7) Road 2
        , create_tile (6,7) Road 2
        , create_tile (7,7) Road 13
        , create_tile (8,7) (Lot (create_obstacle "bush-many" 0.6 120 (1, -1))) 0
        , create_tile (9,7) (Lot (create_obstacle "tree-star" 0.75 50 (-1, -1))) 0
        , create_tile (10,7) (Lot Nothing) 0
        , create_tile (11,7) (Lot Nothing) 0
        , create_tile (12,7) (Lot Nothing) 0
        , create_tile (13,7) (Lot Nothing) 0
        , create_tile (14,7) (Lot Nothing) 0
        , create_tile (15,7) (Lot Nothing) 0
        , create_tile (0,8) (Lot (create_obstacle "rock-5" 0.85 70 (0, 1))) 0
        , create_tile (1,8) (Lot Nothing) 0
        , create_tile (2,8) Road 10
        , create_tile (3,8) Road 4
        , create_tile (4,8) Road 4
        , create_tile (5,8) Road 4
        , create_tile (6,8) Road 7
        , create_tile (7,8) Road 5
        , create_tile (8,8) (Lot (create_obstacle "rock-6" 0.5 270 (1, -1))) 0
        , create_tile (9,8) (Lot (create_obstacle "tree" 0.65 20 (0, 1))) 0
        , create_tile (10,8) (Lot (create_obstacle "bush" 0.9 140 (0, 0))) 0
        , create_tile (11,8) (Lot Nothing) 0
        , create_tile (12,8) (Lot Nothing) 0
        , create_tile (13,8) (Lot Nothing) 0
        , create_tile (14,8) (Lot Nothing) 0
        , create_tile (15,8) (Lot (create_obstacle "tree" 0.8 170 (-1, 1))) 0
        , create_tile (0,9) (Lot (create_obstacle "bush-many" 0.8 240 (1, -1))) 0
        , create_tile (1,9) (Lot (create_obstacle "tree-star" 0.6 10 (-1, 0))) 0
        , create_tile (2,9) (Lot Nothing) 0
        , create_tile (3,9) (Lot Nothing) 0
        , create_tile (4,9) (Lot Nothing) 0
        , create_tile (5,9) (Lot Nothing) 0
        , create_tile (6,9) Road 3
        , create_tile (7,9) Road 9
        , create_tile (8,9) Road 2
        , create_tile (9,9) Road 13
        , create_tile (10,9) (Lot Nothing) 0
        , create_tile (11,9) (Lot Nothing) 0
        , create_tile (12,9) (Lot (create_obstacle "tree-round" 0.85 0 (-1, 0))) 0
        , create_tile (13,9) (Lot Nothing) 0
        , create_tile (14,9) (Lot Nothing) 0
        , create_tile (15,9) (Lot (create_obstacle "tree" 0.5 40 (-1, 0))) 0
        , create_tile (0,10) (Lot (create_obstacle "bush" 0.7 260 (1, 0))) 0
        , create_tile (1,10) (Lot (create_obstacle "tree-round" 0.8 90 (-1, 0))) 0
        , create_tile (2,10) (Lot (create_obstacle "tree" 0.65 40 (-1, 1))) 0
        , create_tile (3,10) (Lot Nothing) 0
        , create_tile (4,10) (Lot Nothing) 0
        , create_tile (5,10) (Lot (create_obstacle "tree-star" 0.9 160 (0, 0))) 0
        , create_tile (6,10) Road 10
        , create_tile (7,10) Road 4
        , create_tile (8,10) Road 7
        , create_tile (9,10) Road 5
        , create_tile (10,10) (Lot Nothing) 0
        , create_tile (11,10) (Lot Nothing) 0
        , create_tile (12,10) (Lot Nothing) 0
        , create_tile (13,10) (Lot Nothing) 0
        , create_tile (14,10) (Lot (create_obstacle "rock-2" 0.8 230 (0, -1))) 0
        , create_tile (15,10) (Lot Nothing) 0
        , create_tile (0,11) (Lot Nothing) 0
        , create_tile (1,11) (Lot Nothing) 0
        , create_tile (2,11) (Lot (create_obstacle "bush-many" 0.75 70 (-1, 0))) 0
        , create_tile (3,11) (Lot (create_obstacle "tree" 0.9 135 (0, 0))) 0
        , create_tile (4,11) (Lot (create_obstacle "tree-round" 0.6 180 (0, -1))) 0
        , create_tile (5,11) (Lot Nothing) 0
        , create_tile (6,11) (Lot Nothing) 0
        , create_tile (7,11) (Lot Nothing) 0
        , create_tile (8,11) Road 3
        , create_tile (9,11) Road 9
        , create_tile (10,11) Road 2
        , create_tile (11,11) Road 2
        , create_tile (12,11) Road 2
        , create_tile (13,11) Road 13
        , create_tile (14,11) (Lot Nothing) 0
        , create_tile (15,11) (Lot Nothing) 0
        , create_tile (0,12) (Lot Nothing) 0
        , create_tile (1,12) (Lot (create_obstacle "rock-3" 0.9 320 (0, 0))) 0
        , create_tile (2,12) (Lot Nothing) 0
        , create_tile (3,12) (Lot (create_obstacle "bush" 0.7 60 (1, 0))) 0
        , create_tile (4,12) (Lot Nothing) 0
        , create_tile (5,12) (Lot (create_obstacle "bush-many" 0.8 20 (-1, 1))) 0
        , create_tile (6,12) (Lot Nothing) 0
        , create_tile (7,12) (Lot Nothing) 0
        , create_tile (8,12) Road 10
        , create_tile (9,12) Road 4
        , create_tile (10,12) Road 4
        , create_tile (11,12) Road 4
        , create_tile (12,12) Road 7
        , create_tile (13,12) Road 5
        , create_tile (14,12) (Lot Nothing) 0
        , create_tile (15,12) (Lot Nothing) 0
        , create_tile (0,13) (Lot Nothing) 0
        , create_tile (1,13) (Lot Nothing) 0
        , create_tile (2,13) (Lot (create_obstacle "bush" 0.6 50 (-1, -1))) 0
        , create_tile (3,13) (Lot (create_obstacle "tree" 0.5 130 (-1, 1))) 0
        , create_tile (4,13) (Lot (create_obstacle "tree-round" 0.9 260 (0, 0))) 0
        , create_tile (5,13) (Lot (create_obstacle "rock-1" 0.55 45 (1, 1))) 0
        , create_tile (6,13) (Lot (create_obstacle "tree" 0.7 150 (-1, -1))) 0
        , create_tile (7,13) (Lot Nothing) 0
        , create_tile (8,13) (Lot Nothing) 0
        , create_tile (9,13) (Lot Nothing) 0
        , create_tile (10,13) (Lot (create_obstacle "rock-4" 0.7 210 (0, 0))) 0
        , create_tile (11,13) (Lot (create_obstacle "tree" 0.75 130 (1, -1))) 0
        , create_tile (12,13) Road 3
        , create_tile (13,13) Road 9
        , create_tile (14,13) Road 2
        , create_tile (15,13) Road 2
        , create_tile (0,14) (Lot Nothing) 0
        , create_tile (1,14) (Lot (create_obstacle "tree-round" 0.8 20 (-1, 0))) 0
        , create_tile (2,14) (Lot (create_obstacle "bush-many" 0.9 80 (0, 0))) 0
        , create_tile (3,14) (Lot (create_obstacle "tree" 0.85 120 (1, 0))) 0
        , create_tile (4,14) (Lot (create_obstacle "bush" 0.6 230 (1, -1))) 0
        , create_tile (5,14) (Lot Nothing) 0
        , create_tile (6,14) (Lot (create_obstacle "tree-round" 0.7 0 (1, -1))) 0
        , create_tile (7,14) (Lot (create_obstacle "tree" 0.8 10 (0, -1))) 0
        , create_tile (8,14) (Lot (create_obstacle "tree-star" 0.65 70 (-1, 1))) 0
        , create_tile (9,14) (Lot (create_obstacle "tree-round" 0.9 180 (0, 0))) 0
        , create_tile (10,14) (Lot Nothing) 0
        , create_tile (11,14) (Lot Nothing) 0
        , create_tile (12,14) Road 10
        , create_tile (13,14) Road 4
        , create_tile (14,14) Road 4
        , create_tile (15,14) Road 4
        , create_tile (0,15) (Lot (create_obstacle "tree-star" 0.9 100 (0, 0))) 0
        , create_tile (1,15) Road 17
        , create_tile (2,15) (Lot (create_obstacle "rock-5" 0.7 60 (1, 0))) 0
        , create_tile (3,15) (Lot (create_obstacle "tree-star" 0.55 130 (-1, 1))) 0
        , create_tile (4,15) (Lot (create_obstacle "bush" 0.85 210 (-1, 0))) 0
        , create_tile (5,15) (Lot (create_obstacle "tree-round" 0.6 40 (-1, -1))) 0
        , create_tile (6,15) (Lot (create_obstacle "rock-3" 0.65 90 (-1, 1))) 0
        , create_tile (7,15) (Lot (create_obstacle "bush-many" 0.9 0 (0, 0))) 0
        , create_tile (8,15) (Lot (create_obstacle "tree" 0.6 190 (-1, -1))) 0
        , create_tile (9,15) (Lot Nothing) 0
        , create_tile (10,15) (Lot Nothing) 0
        , create_tile (11,15) (Lot Nothing) 0
        , create_tile (12,15) (Lot (create_obstacle "tree-star" 0.9 260 (0, 0))) 0
        , create_tile (13,15) (Lot Nothing) 0
        , create_tile (14,15) (Lot Nothing) 0
        , create_tile (15,15) (Lot Nothing) 0
    ]
